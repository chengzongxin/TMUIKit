//
//  UITabBarItem+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBarItem (TMUI)
/**
 *  双击 tabBarItem 时的回调，默认为 nil。
 *  @arg tabBarItem 被双击的 UITabBarItem
 *  @arg index      被双击的 UITabBarItem 的序号
 */
@property(nonatomic, copy, nullable) void (^tmui_doubleTapBlock)(UITabBarItem *tabBarItem, NSInteger index);

/**
 * 获取一个UITabBarItem内显示图标的UIImageView，如果找不到则返回nil
 */
- (nullable UIImageView *)tmui_imageView;
+ (nullable UIImageView *)tmui_imageViewInTabBarButton:(nullable UIView *)tabBarButton;
@end

NS_ASSUME_NONNULL_END
