//
//  UIView+TMUIBadge.h
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/29.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMUIBadgeProtocol.h"
NS_ASSUME_NONNULL_BEGIN

extern const CGPoint TMUIBadgeInvalidateOffset;
/**
 用于在任意 UIView 上显示未读红点或者未读数，提供的属性请查看 @c TMUIBadgeProtocol ，属性的默认值在 TMUIConfigurationTemplate 配置表里设置，如果不使用配置表，则所有属性的默认值均为 0 或 nil。
 
 @note 使用该组件会强制设置 view.clipsToBounds = NO 以避免布局到 view 外部的红点/未读数看不到。
 */
@interface UIView (TMUIBadge) <TMUIBadgeProtocol>

@end

NS_ASSUME_NONNULL_END
