//
//  MTFYMultiProtocolInfo.m
//  Matafy
//
//  Created by Tiaotiao on 2019/5/20.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYMultiProtocolInfo.h"
#import <objc/runtime.h>


@implementation MTFYMultiProtocolInfo

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

- (instancetype)initWithMultiProtocol:(Protocol *)protocol
                            multiimpl:(id<MTFYModuleMultiProtocol>)multiImpl;
{
    self = [super init];
    if (self) {
        NSString *protocolImplStr = [self.class checkMutliProtocol:protocol impl:multiImpl];
        if (protocolImplStr) {
            NSArray<NSString *> *nameArr = [protocolImplStr componentsSeparatedByString:@"_"];
            self.protocolName = nameArr[0];
            self.implName = nameArr[1];
            self.protocolMethodList = [self fetchAllMethodFromProtocol:protocol];
        }
    }
    return self;
}

#pragma mark - Public

+ (NSString *)checkMutliProtocol:(Protocol *)protocol impl:(id<MTFYModuleMultiProtocol>)mutliImpl
{
    NSString *protocolStr = NSStringFromProtocol(protocol);
    NSString *implStr = NSStringFromClass(((NSObject *)mutliImpl).class);
    BOOL isMuitlProtocol = protocol_conformsToProtocol(protocol, NSProtocolFromString(@"MTFYModuleMultiProtocol"));
    
    NSAssert(isMuitlProtocol, @"Protocol:%@没有继承MTFYModuleMultiProtocol", protocolStr);
    BOOL isImplHasProtocol = [(NSObject *)mutliImpl conformsToProtocol:protocol];
    NSAssert(isImplHasProtocol, @"mutliImpl:%@没有实现protocol:%@", implStr, protocolStr);
    
    if (isMuitlProtocol && isImplHasProtocol) {
        return [NSString stringWithFormat:@"%@_%@", protocolStr, implStr];
    } else {
        return nil;
    }
}

- (BOOL)isEqualNameStr:(NSString *)nameStr
{
    NSArray<NSString *> *nameArr = [nameStr componentsSeparatedByString:@"_"];
    if (nameArr.count < 2) {
        return NO;
    }
    
    return [self.protocolName isEqualToString:nameArr[0]] && [self.implName isEqualToString:nameArr[1]];
}

#pragma mark - Event Respone

#pragma mark - Delegate

#pragma mark - Private

- (NSArray<NSString *> *)fetchAllMethodFromProtocol:(Protocol *)protocol
{
    NSMutableArray<NSString *> *methodArr = [NSMutableArray array];
    
    [methodArr addObjectsFromArray:[self fetchMethodFromProtocol:protocol isRequiredMethod:YES isInstanceMethod:YES]];
    [methodArr addObjectsFromArray:[self fetchMethodFromProtocol:protocol isRequiredMethod:YES isInstanceMethod:NO]];
    [methodArr addObjectsFromArray:[self fetchMethodFromProtocol:protocol isRequiredMethod:NO isInstanceMethod:YES]];
    [methodArr addObjectsFromArray:[self fetchMethodFromProtocol:protocol isRequiredMethod:NO isInstanceMethod:NO]];
    
    return methodArr;
}

- (NSArray<NSString *> *)fetchMethodFromProtocol:(Protocol *)protocol isRequiredMethod:(BOOL)isRequiredMethod isInstanceMethod:(BOOL)isInstanceMethod
{
    NSMutableArray<NSString *> *methodArr = [NSMutableArray array];
    unsigned int methodCount = 0;
    struct objc_method_description *methodList = protocol_copyMethodDescriptionList(protocol, isRequiredMethod, isInstanceMethod, &methodCount);
    if (methodList) {
        for (int i = 0; i < methodCount; i++) {
            struct objc_method_description method = methodList[i];
            [methodArr addObject:NSStringFromSelector(method.name)];
        }
        free(methodList);
        methodList = 0;
    }
    
    
    return methodArr;
}

#pragma mark - Getters and Setters

#pragma mark - Supperclass

#pragma mark - NSObject

- (BOOL)isEqual:(MTFYMultiProtocolInfo *)object
{
    return [self.protocolName isEqualToString:object.protocolName] && [self.implName isEqualToString:object.implName];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@_%@", self.protocolName, self.implName];
}

@end
