//
//  UIBarItem+TMUIBadge.h
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/29.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMUIBadgeProtocol.h"
NS_ASSUME_NONNULL_BEGIN

/**
 *  用于在 UIBarButtonItem（通常用于 UINavigationBar 和 UIToolbar）和 UITabBarItem 上显示未读红点或者未读数，对设置的时机没有要求。
 *  提供的属性请查看 @c TMUIBadgeProtocol ，属性的默认值在 TMUIConfigurationTemplate 配置表里设置，如果不使用配置表，则所有属性的默认值均为 0 或 nil。
 *
 *  @note 系统对 UIBarButtonItem 和 UITabBarItem 在横竖屏下均会有不同的布局，当你使用本控件时建议分别检查横竖屏下的表现是否正确。
 */
@interface UIBarItem (TMUIBadge) <TMUIBadgeProtocol>

@end

NS_ASSUME_NONNULL_END
