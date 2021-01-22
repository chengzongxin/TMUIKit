//
//  MTFYModuleProtocol.h
//  Matafy
//
//  Created by Tiaotiao on 2019/5/20.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTFYMBaseProtocolPool.h"
#import "MTFYModuleConstant.h"


@protocol MTFYMCacheModelProtocol <NSObject>

/**
 读取某个模块缓存文本信息
 
 @param moduleKey 模块的关键字
 @return 缓存对象
 */
+ (id<MTFYMCacheModelProtocol>)readCacheInfo:(NSString *)moduleKey;

/**
 模块存储文本信息的路径
 
 @param moduleKey 模块的关键字
 @return 路径
 */
+ (NSString *)saveCacheInfoKey:(NSString *)moduleKey;


/**
 存储模块的文本信息
 
 @param moduleKey 模块的关键字
 */
- (void)saveCacheInfo:(NSString *)moduleKey;

/**
 Documents/module/xxxx/
 
 @return 模块的跟路径
 */
+ (NSString *)moduleRootPath:(NSString *)moduleKey;

@end


@protocol MTFYModuleBaseProtocol <NSObject>

/**
 模块的关键字，信息存储的文件夹、日志log
 
 @return 关键字
 */
+ (NSString *)moduleKey;

@optional

/**
 如果不实现，默认 MTFYMModuleLevelNormal
 
 @return 模块等级
 */
- (MTFYModuleLevel)moduleLevel;

/**
 模块内部使用的 缓存存储model
 
 @return 缓存存储model
 */
- (id<MTFYMCacheModelProtocol>)cacheModel;


@end

