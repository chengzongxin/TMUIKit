//
//  MTFYMBaseProtocolPool.h
//  Matafy
//
//  Created by Tiaotiao on 2019/5/20.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 可以由多个impl去实现
 类似于通知
 */
@protocol MTFYModuleMultiProtocol <NSObject>

@optional
// null

@end


/**
 只能由单个impl去实现
 */
@protocol MTFYModuleSingleProtocol <NSObject>

@optional

@end


/**
 主模块事件api
 */
@protocol MTFYMBaseEventProtocol <MTFYModuleMultiProtocol>

@optional
// null

@end


/**
 通知api
 */
@protocol MTFYMBaseNoticeProtocol <MTFYModuleMultiProtocol>

@optional
// null

@end


/**
 module需要外部提供的api
 */
@protocol MTFYMBaseFetchProtocol <MTFYModuleSingleProtocol>

@optional

/**
 是否是单例
 
 @return YES/NO
 */
+ (BOOL)singleton;


/**
 如果是单例，实现该函数作为单例入口
 
 @return 单例
 */
+ (id)shareInstance;

@end


/**
 module提供出来的api
 在module内部实现
 */
@protocol MTFYMBaseProvideProtocol <MTFYModuleSingleProtocol>

@optional
// null

@end

