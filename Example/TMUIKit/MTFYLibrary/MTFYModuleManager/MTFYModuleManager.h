//
//  MTFYModuleManager.h
//  Matafy
//
//  Created by Tiaotiao on 2019/5/20.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTFYMContext.h"
#import "MTFYMBaseProtocolPool.h"
#import "MTFYModuleProtocol.h"

#define kMTFYModuleManager [MTFYModuleManager sharedManager]

@interface MTFYModuleManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) MTFYMContext *context;

/**
 动态注册模块
 当模块不是存在于整个App运行周期，使用前注册，使用完成后移除
 
 @param moduleName 模块名称
 @param fetchProtocol 需要外部提供的api协议
 @param fetchImpl 实现类
 */
- (void)registerDynamicModule:(NSString *)moduleName
                fetchProtocol:(Protocol *)fetchProtocol
            fetchProtocolImpl:(Class)fetchImpl;

/**
 移除动态注册的模块
 模块不在使用时调用
 
 @param moduleName 模块名称
 @param fetchProtocol 协议
 */
- (void)unregisterDynamicModule:(NSString *)moduleName
                  fetchProtocol:(Protocol *)fetchProtocol;

/**
 从模块名称获取到模块主类
 
 @param moduleName 模块名称
 @return 模块主类
 */
- (id<MTFYModuleBaseProtocol>)moduleFromModuleName:(NSString *)moduleName;

/**
 获取某个模块需要工程提供api的协议实现类
 MTFYModuleManager自己管理
 
 @param moduleName 模块名称
 @return 提供api的类
 */
- (id<MTFYMBaseFetchProtocol>)fetchProtocolFromModuleName:(NSString *)moduleName;

/**
 获取某个模块的缓存模块
 cache由具体的模块自己管理
 
 @param moduleName 模块名称
 @return 缓存模块
 */
- (id<MTFYMCacheModelProtocol>)cacheModelFromModuleName:(NSString *)moduleName;

/**
 根据module名称存储缓存
 
 @param moduleName 模块名称
 */
- (void)saveCacheInfoWithModuleName:(NSString *)moduleName;

/**
 module调用public Api方法
 如果返回值不是object或者参数不是object，直接moduleFromModuleName获取到module后，直接调用
 
 @param moduleName 调用的模块
 @param apiSel public api方法
 @return 返回值
 */
- (id)moduleName:(NSString *)moduleName callApi:(SEL)apiSel;
- (id)moduleName:(NSString *)moduleName callApi:(SEL)apiSel object:(id)object;
- (id)moduleName:(NSString *)moduleName callApi:(SEL)apiSel object:(id)object1 object:(id)object2;

/**
 获取模块的关键字
 log、cache等
 
 @param moduleName 名称名称
 @return 关键字
 */
- (NSString *)moduleKeyFromModuleName:(NSString *)moduleName;


/**
 主动监听某个模块的事件和通知协议
 这里不会multiImpl retain，当multiImpl被释放，监听也会自动解除
 
 @param protocol 某个模块的协议
 @param multiImpl 监听的类，一般是self
 */
- (void)addMultiProtocol:(Protocol *)protocol impl:(id<MTFYModuleMultiProtocol>)multiImpl;

/**
 当multiImpl还在生命周期，主动解除对协议的监听
 一般用在监听一次就不在监听的情况
 
 @param protocol 某个模块的协议
 @param multiImpl 监听的类，一般是self
 */
- (void)removeMultiProtocol:(Protocol *)protocol impl:(id<MTFYModuleMultiProtocol>)multiImpl;

/**
 触发模块自定义的multiProtocol的某个方法
 
 @param multiSel 事件
 */
- (id)tiggerMultiProtocolSel:(SEL)multiSel;
- (id)tiggerMultiProtocolSel:(SEL)multiSel withObject:(id)object;
- (id)tiggerMultiProtocolSel:(SEL)multiSel withObject:(id)object1 withObject:(id)objdec2;


@end

