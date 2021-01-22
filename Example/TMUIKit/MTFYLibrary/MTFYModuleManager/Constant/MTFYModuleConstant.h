//
//  MTFYModuleConstant.h
//  Matafy
//
//  Created by Tiaotiao on 2019/5/20.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 第一初始化函数
#define MTFY_DESIGNATED_INITIALIZER NS_DESIGNATED_INITIALIZER
/// 禁言某个方法
#define MTFY_UNAVAILABLE_INSTEAD(comment) __attribute__((unavailable(comment)))
/// 过期提醒
#define MTFYDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)


/**
 模块的响应优先级
 
 - MTFYMModuleLevelLow: 低
 - MTFYMModuleLevelNormal: 中
 - MTFYMModuleLevelHigh: 高
 */
typedef NS_ENUM(NSInteger, MTFYModuleLevel)
{
    MTFYMModuleLevelLow,
    MTFYMModuleLevelNormal,
    MTFYMModuleLevelHigh,
};


@interface MTFYModuleConstant : NSObject

@end


