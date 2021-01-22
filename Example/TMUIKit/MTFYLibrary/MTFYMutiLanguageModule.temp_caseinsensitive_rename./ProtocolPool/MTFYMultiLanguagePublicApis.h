//
//  MTFYMultiLanguagePublicApis.h
//  Matafy
//
//  Created by Tiaotiao on 2019/6/17.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYMBaseProtocolPool.h"
#import "MTFYMultiLanguageConstant.h"


// 对外的宏
#define kMTFYMultiLanguageModule ((id<MTFYMultiLanguageProvideProtocol>)[kMTFYModuleManager moduleFromModuleName:MTFYMultiLanguageModuleName])

#define kLStr(key) [kMTFYMultiLanguageModule modMultiStringFromKey:key]


/**
 模块对外的接口
 如果不是主模块提供出来的api，请注明使用那个子模块提供的，在主模块里面使用addProviceApiInstance提供中转
 */

@protocol MTFYMultiLanguageProvideProtocol <MTFYMBaseProvideProtocol>

@optional

/**
 是否支持当前系统的语言
 */
@property (nonatomic, assign, readonly) BOOL isSupportCurSystemLanguage;

- (MTFYMultiLanguageType)modCurLanguageType;
- (NSString *)modCurLanguageSourcePathName;

- (void)modMultiLanguageChange:(MTFYMultiLanguageType)type;

/**
 String key 转到对应语言字符串
 
 @param key String key
 @return 对应语言字符串
 */
- (NSString *)modMultiStringFromKey:(NSString *)key;

@end


/**
 外部提供的协议
 一般采用@required
 模块内部需要工程提供的一些方法，参数等
 不方便使用参数形式注入，使用此方法
 */
@protocol MTFYMultiLanguageFetchProtocol <MTFYMBaseFetchProtocol>

@required


@end


/**
 事件触发的协议，一般情况下不需要配置实现类
 通常是模块内部去实现的，由其他模块去触发
 */
@protocol MTFYMultiLanguageEventProtocol <MTFYMBaseEventProtocol>

@optional

@end


/**
 通知类的协议(代理)
 可以同时通知到多个类
 */
@protocol MTFYMultiLanguageNoticeProtocol <MTFYMBaseNoticeProtocol>

@optional


@end

