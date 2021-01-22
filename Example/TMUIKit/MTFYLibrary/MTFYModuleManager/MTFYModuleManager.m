//
//  MTFYModuleManager.m
//  Matafy
//
//  Created by Tiaotiao on 2019/5/20.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYModuleManager.h"
#import <objc/runtime.h>

#import "MTFYMoudleBase.h"
#import "MTFYModuleInfo.h"
#import "MTFYMultiProtocolInfo.h"

#define MTFYM_SEMAPHORE_LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#define MTFYM_SEMAPHORE_UNLOCK(lock) dispatch_semaphore_signal(lock);


@interface MTFYModuleManager ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, MTFYModuleInfo *> *MTFYModuleDic;

/**
 protocol和对于实现Class名称
 key protocol的名字
 value Class名称
 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *MTFYProtocolDic;

/**
 protocol和对于实现Class
 一个protocol可能会有多个实现的Class
 key MTFYMultiProtocolInfo组合的名字
 value Class的实例
 */
@property (nonatomic, strong) NSMapTable<MTFYMultiProtocolInfo *, id<MTFYModuleMultiProtocol>> *MTFYMultiProtocolImplDic;
/// a lock to keep the access to `MTFYMultiProtocolImplDic` thread-safe
@property (nonatomic, strong, nonnull) dispatch_semaphore_t weakLock;


/**
 时间消耗记录
 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *timeConsumeDic;

@end


@implementation MTFYModuleManager

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

- (void)dealloc
{
    [self.context removeObserver:self forKeyPath:@"moduleConfigPlistName" context:nil];
}

+ (instancetype)sharedManager
{
    static id sharedManager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedManager = [[MTFYModuleManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.context = [[MTFYMContext alloc] init];
        [self registerLocolModules];
        
        self.timeConsumeDic = [NSMutableDictionary dictionary];
        
        [self.context addObserver:self forKeyPath:@"moduleConfigPlistName" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)registerLocolModules
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:self.context.moduleConfigPlistName ofType:@"plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        return;
    }
    
    NSArray<NSDictionary *> *moduleArr = [[NSArray alloc] initWithContentsOfFile:plistPath];
    for (NSInteger i=0; i<moduleArr.count; ++i) {
        NSDictionary *obj = moduleArr[i];
        NSString *moduleName = obj[@"moduleClass"];
        NSString *fetchProtocolName = obj[@"fetchProtocol"];
        NSString *fetchProtocolImplName = obj[@"fetchProtocolImpl"];
        MTFYModuleInfo *moduleInfo = [self registerModuleWithModuleName:moduleName];
        if (moduleInfo && fetchProtocolName.length > 0 && fetchProtocolImplName.length > 0) {
            Protocol *fetchProtocol = NSProtocolFromString(fetchProtocolName);
            Class impl = NSClassFromString(fetchProtocolImplName);
            NSAssert(fetchProtocol, @"Protocol:%@不存在", fetchProtocolName);
            NSAssert(impl, @"Class:%@不存在", fetchProtocolImplName);
            [self registerProtocol:fetchProtocol implClass:impl];
            moduleInfo.fetchProtocol = [self createSingleProtocolImpl:fetchProtocol];
        }
    }
}

- (void)registerDynamicModule:(NSString *)moduleName
                fetchProtocol:(Protocol *)fetchProtocol
            fetchProtocolImpl:(Class)fetchImpl
{
    MTFYModuleInfo *moduleInfo = [self registerModuleWithModuleName:moduleName];
    if (moduleInfo) {
        [self registerProtocol:fetchProtocol implClass:fetchImpl];
        moduleInfo.fetchProtocol = [self createSingleProtocolImpl:fetchProtocol];
#pragma GCC diagnostic ignored "-Wundeclared-selector"
        [moduleInfo.moduleInstance performSelector:@selector(modSetup)];
        [moduleInfo.moduleInstance performSelector:@selector(modInit)];
    }
}

- (void)unregisterDynamicModule:(NSString *)moduleName
                  fetchProtocol:(Protocol *)fetchProtocol
{
    [self.MTFYModuleDic removeObjectForKey:moduleName];
    if (fetchProtocol) {
        NSString *protocolStr = NSStringFromProtocol(fetchProtocol);
        [self.MTFYProtocolDic removeObjectForKey:protocolStr];
    }
}

- (MTFYModuleInfo *)registerModuleWithModuleName:(NSString *)moduleName
{
    MTFYModuleInfo *moduleInfo = [[MTFYModuleInfo alloc] initWithModuleName:moduleName];
    if (moduleInfo.moduleInstance) {
        [self.MTFYModuleDic setObject:moduleInfo forKey:moduleName];
    } else {
        NSAssert(NO, @"registerModule:%@不存在", moduleName);
        return nil;
    }
    
    return moduleInfo;
}

- (void)registerProtocol:(Protocol *)protocol implClass:(Class)impl
{
    NSParameterAssert(protocol);
    NSParameterAssert(impl);
    NSString *protocolStr = NSStringFromProtocol(protocol);
    NSString *className = NSStringFromClass(impl);
    
    self.MTFYProtocolDic[protocolStr] = className;
}

- (id<MTFYModuleSingleProtocol>)createSingleProtocolImpl:(Protocol *)protocol
{
    NSString *protocolStr = NSStringFromProtocol(protocol);
    BOOL isSingleProtocol = protocol_conformsToProtocol(protocol, @protocol(MTFYModuleSingleProtocol));
    if (!isSingleProtocol) {
        NSAssert(isSingleProtocol, @"Protocol:%@不是singleProtocol", protocolStr);
        return nil;
    }
    
    NSString *implClassName = self.MTFYProtocolDic[protocolStr];
    Class implClass = NSClassFromString(implClassName);
    if (!implClass) {
        NSAssert(implClass, @"Class:%@不存在", implClassName);
        return nil;
    }
    
    if ([[implClass class] respondsToSelector:@selector(singleton)]) {
        if ([[implClass class] singleton]) {
            if ([[implClass class] respondsToSelector:@selector(shareInstance)]) {
                return [[implClass class] shareInstance];
            } else {
                NSAssert(NO, @"Class:没有找到单例%@的实现方法shareInstance", implClassName);
            }
        }
    }
    
    return [[implClass alloc] init];
}


#pragma mark - Public

- (MTFYModuleInfo *)moduleInfoFromName:(NSString *)moduleName
{
    MTFYModuleInfo *moduleInfo = self.MTFYModuleDic[moduleName];
    if (!moduleInfo || !moduleInfo.moduleInstance) {
        NSAssert(NO, @"模块:<%@>没有注册，请在Plist里面添加或者调用registerDynamicModule去注册", moduleName);
    }
    return moduleInfo;
}

- (id<MTFYModuleBaseProtocol>)moduleFromModuleName:(NSString *)moduleName
{
    MTFYModuleInfo *moduleInfo = [self moduleInfoFromName:moduleName];
    return moduleInfo.moduleInstance;
}

- (id<MTFYModuleSingleProtocol>)fetchProtocolFromModuleName:(NSString *)moduleName
{
    MTFYModuleInfo *moduleInfo = [self moduleInfoFromName:moduleName];
    return moduleInfo.fetchProtocol;
}

- (id<MTFYMCacheModelProtocol>)cacheModelFromModuleName:(NSString *)moduleName
{
    MTFYModuleInfo *moduleInfo = [self moduleInfoFromName:moduleName];
    id<MTFYModuleBaseProtocol> moduleInstance = moduleInfo.moduleInstance;
    
    id<MTFYMCacheModelProtocol> cacheModel = nil;
    if ([moduleInstance respondsToSelector:@selector(cacheModel)]) {
        cacheModel = [moduleInstance cacheModel];
    } else {
        NSAssert(NO, @"模块:%@没有提供cacheModel方法", moduleName);
    }
    
    return cacheModel;
}

- (void)saveCacheInfoWithModuleName:(NSString *)moduleName
{
    MTFYModuleInfo *moduleInfo = [self moduleInfoFromName:moduleName];
    id<MTFYModuleBaseProtocol> moduleInstance = moduleInfo.moduleInstance;
    
    id<MTFYMCacheModelProtocol> cacheModel = nil;
    if ([moduleInstance respondsToSelector:@selector(cacheModel)]) {
        cacheModel = [moduleInstance cacheModel];
    } else {
        NSAssert(NO, @"模块:%@没有提供cacheModel方法", moduleName);
    }
    
    NSString *moduleKey = nil;
    if ([moduleInstance.class respondsToSelector:@selector(moduleKey)]) {
        moduleKey = [moduleInstance.class moduleKey];
    } else {
        NSAssert(NO, @"模块:%@没有提供moduleKey方法", moduleName);
    }
    
    [cacheModel saveCacheInfo:moduleKey];
}

- (NSString *)moduleKeyFromModuleName:(NSString *)moduleName
{
    MTFYModuleInfo *moduleInfo = [self moduleInfoFromName:moduleName];
    id<MTFYModuleBaseProtocol> moduleInstance = moduleInfo.moduleInstance;
    
    NSString *moduleKey = nil;
    if ([moduleInstance.class respondsToSelector:@selector(moduleKey)]) {
        moduleKey = [moduleInstance.class moduleKey];
    } else {
        NSAssert(NO, @"模块:%@没有提供moduleKey方法", moduleName);
    }
    
    return moduleKey;
}

- (id)moduleName:(NSString *)moduleName callApi:(SEL)apiSel
{
    return [self moduleName:moduleName callApi:apiSel object:nil object:nil];
}

- (id)moduleName:(NSString *)moduleName callApi:(SEL)apiSel object:(id)object
{
    return [self moduleName:moduleName callApi:apiSel object:object object:nil];
}

- (id)moduleName:(NSString *)moduleName callApi:(SEL)apiSel object:(id)object1 object:(id)object2
{
    //CGFloat startTime = CACurrentMediaTime();
    MTFYModuleInfo *moduleInfo = [self moduleInfoFromName:moduleName];
    id<MTFYModuleBaseProtocol> moduleInstance = moduleInfo.moduleInstance;
    
    id<NSObject> target = [(MTFYMoudleBase *)moduleInstance findForwardingTarget:apiSel];
    
    if (!target) {
        NSAssert(NO, @"[%@:%@]没有找到target", moduleName,  NSStringFromSelector(apiSel));
        return nil;
    }
    
    NSMethodSignature *signature = [target.class instanceMethodSignatureForSelector:apiSel];
    NSInteger parNumber = signature.numberOfArguments - 2;
    const char *returnType = [signature methodReturnType];
    if (parNumber > 2) {
        NSAssert(NO, @"最多只支持两个参数，请先使用[kMTFYModuleManager moduleInfoFromName:@\"%@\"]获取到Module，再直接调用:%@", moduleName,  NSStringFromSelector(apiSel));
        return nil;
    }
    
    if (strcmp(returnType, @encode(id)) != 0
        && strcmp(returnType, @encode(void)) != 0) {
        NSAssert(NO, @"不支持的返回值，请先使用[kMTFYModuleManager moduleInfoFromName:@\"%@\"]获取到Module，再直接调用<%@>", moduleName, NSStringFromSelector(apiSel));
        return nil;
    }
    
    id returnResult = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (strcmp(returnType, @encode(void)) != 0) {
        returnResult = [target performSelector:apiSel withObject:object1 withObject:object2];
    } else {
        [target performSelector:apiSel withObject:object1 withObject:object2];
    }
#pragma clang diagnostic pop
    //[self logTimeConsumingInfo:NSStringFromClass(target.class) apiName:NSStringFromSelector(apiSel) time:(CACurrentMediaTime() - startTime) * 1000];
    
    return returnResult;
}

- (id)targer:(id<NSObject>)target performSelector:(SEL)apiSel withObject:(id)object1 withObject:(id)object2
{
    double startTime = CACurrentMediaTime();
    NSMethodSignature *signature = [target.class instanceMethodSignatureForSelector:apiSel];
    NSInteger parNumber = signature.numberOfArguments - 2;
    const char *returnType = [signature methodReturnType];
    if (parNumber > 2) {
        NSAssert(NO, @"最多只支持两个参数，%@调用%@", NSStringFromClass(target.class),  NSStringFromSelector(apiSel));
        return nil;
    }
    
    if (strcmp(returnType, @encode(id)) != 0
        && strcmp(returnType, @encode(void)) != 0) {
        NSAssert(NO, @"不支持的返回值，%@调用%@", NSStringFromClass(target.class), NSStringFromSelector(apiSel));
        return nil;
    }
    
    id returnResult = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (strcmp(returnType, @encode(void)) != 0) {
        returnResult = [target performSelector:apiSel withObject:object1 withObject:object2];
    } else {
        [target performSelector:apiSel withObject:object1 withObject:object2];
    }
#pragma clang diagnostic pop
    
    [self logTimeConsumingInfo:NSStringFromClass(target.class) apiName:NSStringFromSelector(apiSel) time:(CACurrentMediaTime() - startTime) * 1000];
    
    return returnResult;
}

- (id)tiggerMultiProtocolSel:(SEL)multiSel
{
    return [self tiggerMultiProtocolSel:multiSel withObject:nil withObject:nil];
}

- (id)tiggerMultiProtocolSel:(SEL)multiSel withObject:(id)object
{
    return [self tiggerMultiProtocolSel:multiSel withObject:object withObject:nil];
}

- (id)tiggerMultiProtocolSel:(SEL)multiSel withObject:(id)object1 withObject:(id)objdec2
{
    __block id returnVaule = nil;
    NSArray<MTFYModuleInfo *> *allLoadedSortModules = [self allLoadedSortedModules];
    // 首先响应模块的事件
    for (NSInteger i=0; i<allLoadedSortModules.count; ++i) {
        MTFYModuleInfo *obj = allLoadedSortModules[i];
        if ([obj.moduleInstance respondsToSelector:multiSel]) {
            // 统计运行时间
            returnVaule = [self targer:obj.moduleInstance performSelector:multiSel withObject:object1 withObject:objdec2];
        }
    }
    
    // 其次响应multiProtocol的实现类
    MTFYM_SEMAPHORE_LOCK(self.weakLock);
    NSArray<MTFYMultiProtocolInfo *> *keyArr = self.MTFYMultiProtocolImplDic.keyEnumerator.allObjects;
    NSArray<id<MTFYModuleMultiProtocol>> *objectArr = self.MTFYMultiProtocolImplDic.objectEnumerator.allObjects;
    MTFYM_SEMAPHORE_UNLOCK(self.weakLock);
    
    for (int i=0; i<keyArr.count; ++i) {
        MTFYMultiProtocolInfo *key = keyArr[i];
        if (i < objectArr.count) {
            id<MTFYModuleMultiProtocol> obj = objectArr[i];
            
            BOOL isProtocolMethod = [key.protocolMethodList containsObject:NSStringFromSelector(multiSel)];
            BOOL isRespond = [obj respondsToSelector:multiSel];
            if (isProtocolMethod && isRespond) {
                returnVaule = [self targer:obj performSelector:multiSel withObject:object1 withObject:objdec2];
            }
        }
    }
    
    return returnVaule;
}

- (NSArray<MTFYModuleInfo*> *)allLoadedSortedModules
{
    NSMutableArray<MTFYModuleInfo *> *allLoadedModules = [NSMutableArray arrayWithArray:self.MTFYModuleDic.allValues];
    [allLoadedModules sortUsingComparator:^NSComparisonResult(MTFYModuleInfo * _Nonnull obj1, MTFYModuleInfo *  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    return allLoadedModules;
}

- (void)addMultiProtocol:(Protocol *)protocol impl:(id<MTFYModuleMultiProtocol>)multiImpl
{
    NSString *keyStr = [MTFYMultiProtocolInfo checkMutliProtocol:protocol impl:multiImpl];
    
    if (keyStr) {
        MTFYMultiProtocolInfo *protocolInfo = [[MTFYMultiProtocolInfo alloc] initWithMultiProtocol:protocol multiimpl:multiImpl];
        MTFYM_SEMAPHORE_LOCK(self.weakLock);
        if (![self.MTFYMultiProtocolImplDic.keyEnumerator.allObjects containsObject:protocolInfo]) {
            [self.MTFYMultiProtocolImplDic setObject:multiImpl forKey:protocolInfo];
        }
        MTFYM_SEMAPHORE_UNLOCK(self.weakLock);
    }
}

- (void)removeMultiProtocol:(Protocol *)protocol impl:(id<MTFYModuleMultiProtocol>)multiImpl
{
    NSString *keyStr = [MTFYMultiProtocolInfo checkMutliProtocol:protocol impl:multiImpl];
    
    if (keyStr) {
        __block MTFYMultiProtocolInfo *findProtocolInfo = nil;
        MTFYM_SEMAPHORE_LOCK(self.weakLock);
        NSArray<MTFYMultiProtocolInfo *> *allObjects = self.MTFYMultiProtocolImplDic.keyEnumerator.allObjects;
        MTFYM_SEMAPHORE_UNLOCK(self.weakLock);
        for (NSInteger i=0; i<allObjects.count; ++i) {
            MTFYMultiProtocolInfo *obj = allObjects[i];
            if ([obj isEqualNameStr:keyStr]) {
                findProtocolInfo = obj;
                break;
            }
        }
        
        MTFYM_SEMAPHORE_LOCK(self.weakLock);
        [self.MTFYMultiProtocolImplDic removeObjectForKey:findProtocolInfo];
        MTFYM_SEMAPHORE_UNLOCK(self.weakLock);
    }
}

- (NSArray<id<MTFYModuleMultiProtocol>> *)fetchAllMutliImpls
{
    NSMutableArray<id<MTFYModuleMultiProtocol>> *allMutliImpls = [NSMutableArray array];
    MTFYM_SEMAPHORE_LOCK(self.weakLock);
    NSArray<id<MTFYModuleMultiProtocol>> *multiImpls = [[self.MTFYMultiProtocolImplDic objectEnumerator] allObjects];
    MTFYM_SEMAPHORE_UNLOCK(self.weakLock);
    for (NSInteger i=0; i<multiImpls.count; ++i) {
        id<MTFYModuleMultiProtocol> item = multiImpls[i];
        if (![allMutliImpls containsObject:item]) {
            [allMutliImpls addObject:item];
        }
    }
    
    return allMutliImpls;
}

#pragma mark - Event Respone

#pragma mark - Delegate

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context
{
    if ([keyPath isEqualToString:@"moduleConfigPlistName"]) {
        NSString *plistNew = change[@"new"];
        NSString *plistOld = change[@"old"];
        if ([plistOld isEqualToString:@"MTFYModuleConfig"]
            && ![plistOld isEqualToString:plistNew]) {
            [self registerLocolModules];
        }
    }
}

#pragma mark - Private

// 如果时间超过500ms 就实时打印，如果没有超过就打印下被调用了，详细信息等1分钟之后再打印详细的
- (void)logTimeConsumingInfo:(NSString *)className apiName:(NSString *)apiName time:(double)timeInMS
{

}

#pragma mark - Getters and Setters

- (NSMutableDictionary *)MTFYModuleDic
{
    if (!_MTFYModuleDic) {
        _MTFYModuleDic = [NSMutableDictionary dictionary];
    }
    return _MTFYModuleDic;
}

- (NSMutableDictionary *)MTFYProtocolDic
{
    if (!_MTFYProtocolDic) {
        _MTFYProtocolDic = [NSMutableDictionary dictionary];
    }
    return _MTFYProtocolDic;
}

- (NSMapTable<MTFYMultiProtocolInfo *, id<MTFYModuleMultiProtocol>> *)MTFYMultiProtocolImplDic
{
    if (!_MTFYMultiProtocolImplDic) {
        _MTFYMultiProtocolImplDic = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableWeakMemory capacity:16];
    }
    return _MTFYMultiProtocolImplDic;
}

- (dispatch_semaphore_t)weakLock
{
    if (!_weakLock) {
        _weakLock = dispatch_semaphore_create(1);
    }
    
    return _weakLock;
}

#pragma mark - Supperclass

#pragma mark - NSObject


@end
