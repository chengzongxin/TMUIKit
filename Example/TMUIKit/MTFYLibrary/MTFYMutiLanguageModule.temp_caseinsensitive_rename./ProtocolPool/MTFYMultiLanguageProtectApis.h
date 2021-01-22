//
//  MTFYMultiLanguageProtectApis.h
//  Matafy
//
//  Created by Tiaotiao on 2019/6/18.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 模块内部需要存储的数据
 非文件数据，文件数据目录请调用<<+ (NSString *)moduleRootPath:(NSString *)moduleKey>>获取
 */
@protocol MTFYMultiLanguageCacheProtocol <MTFYMCacheModelProtocol>

@optional


@end


/**
 模块内部相互调用的接口
 主模块直接调用子模块的可以不用放到这里，
 这里主要放子模块之间相互调用的接口
 */
@protocol MTFYMultiLanguageProviceProtectProtocol <MTFYMBaseProvideProtocol>

@optional

@end
