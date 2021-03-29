//
//  TMUIBadgeProtocol.h
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/29.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// TODO: molice 等废弃 tmui_badgeCenterOffset 系列接口后再删除
#import "TMUICore.h"

NS_ASSUME_NONNULL_BEGIN

@class TMUILabel;

@protocol TMUIBadgeProtocol <NSObject>

#pragma mark - Badge

/// 用数字设置未读数，0表示不显示未读数
@property(nonatomic, assign) NSUInteger tmui_badgeInteger;

/// 用字符串设置未读数，nil 表示不显示未读数
@property(nonatomic, copy, nullable) NSString *tmui_badgeString;

@property(nonatomic, strong, nullable) UIColor *tmui_badgeBackgroundColor;
@property(nonatomic, strong, nullable) UIColor *tmui_badgeTextColor;
@property(nonatomic, strong, nullable) UIFont *tmui_badgeFont;

/// 未读数字与圆圈之间的 padding，会影响最终 badge 的大小。当只有一位数字时，会取宽/高中最大的值作为最终的宽高，以保证整个 badge 是正圆。
@property(nonatomic, assign) UIEdgeInsets tmui_badgeContentEdgeInsets;

/// 默认 badge 的布局处于 view 右上角（x = view.width, y = -badge height），通过这个属性可以调整 badge 相对于默认原点的偏移，x 正值表示向右，y 正值表示向下。
/// 特别地，对于普通的 UITabBarItem 和 UIBarButtonItem，badge 布局相对于内部的 imageView 而不是按钮本身，如果该 item 使用了 customView 则相对于按钮本身。
@property(nonatomic, assign) CGPoint tmui_badgeOffset;

/// 横屏下使用，其他同 @c tmui_badgeOffset 。
@property(nonatomic, assign) CGPoint tmui_badgeOffsetLandscape;

/// 在这两个属性被删除之前，如果不主动设置 @c tmui_badgeOffset 和 @c tmui_badgeOffsetLandscape ，则依然使用旧的逻辑，一旦设置过两个新属性，则旧属性会失效。
@property(nonatomic, assign) CGPoint tmui_badgeCenterOffset DEPRECATED_MSG_ATTRIBUTE("TMUIBadge 不再以中心为布局参考点，请改为使用 tmui_badgeOffset");
@property(nonatomic, assign) CGPoint tmui_badgeCenterOffsetLandscape DEPRECATED_MSG_ATTRIBUTE("TMUIBadge 不再以中心为布局参考点，请改为使用 tmui_badgeOffsetLandscape");

@property(nonatomic, strong, readonly, nullable) TMUILabel *tmui_badgeLabel;


#pragma mark - UpdatesIndicator

/// 控制红点的显隐
@property(nonatomic, assign) BOOL tmui_shouldShowUpdatesIndicator;
@property(nonatomic, strong, nullable) UIColor *tmui_updatesIndicatorColor;
@property(nonatomic, assign) CGSize tmui_updatesIndicatorSize;

/// 默认红点的布局处于 view 右上角（x = view.width, y = -badge height），通过这个属性可以调整红点相对于默认原点的偏移，x 正值表示向右，y 正值表示向下。
/// 特别地，对于普通的 UITabBarItem 和 UIBarButtonItem，红点相对于内部的 imageView 布局而不是按钮本身，如果该 item 使用了 customView 则相对于按钮本身。
@property(nonatomic, assign) CGPoint tmui_updatesIndicatorOffset;

/// 横屏下使用，其他同 @c tmui_updatesIndicatorOffset 。
@property(nonatomic, assign) CGPoint tmui_updatesIndicatorOffsetLandscape;

/// 在这两个属性被删除之前，如果不主动设置 @c tmui_updatesIndicatorOffset 和 @c tmui_updatesIndicatorOffsetLandscape ，则依然使用旧的逻辑，一旦设置过两个新属性，则旧属性会失效。
@property(nonatomic, assign) CGPoint tmui_updatesIndicatorCenterOffset DEPRECATED_MSG_ATTRIBUTE("TMUIBadge 不再以中心为布局参考点，请改为使用 tmui_updatesIndicatorOffset");
@property(nonatomic, assign) CGPoint tmui_updatesIndicatorCenterOffsetLandscape DEPRECATED_MSG_ATTRIBUTE("TMUIBadge 不再以中心为布局参考点，请改为使用 tmui_updatesIndicatorOffsetLandscape");

@property(nonatomic, strong, readonly, nullable) UIView *tmui_updatesIndicatorView;

@end


NS_ASSUME_NONNULL_END
