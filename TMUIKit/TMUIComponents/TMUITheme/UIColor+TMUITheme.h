//
//  UIColor+TMUITheme.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/4/8.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class TMUIThemeManager;

@interface UIColor (TMUITheme)

/**
 生成一个动态的 color 对象，每次使用该颜色时都会动态根据当前的 TMUIThemeManager 主题返回对应的颜色。
 @param provider 当 color 被使用时，这个 provider 会被调用，返回对应当前主题的 color 值。请不要在这个 block 里做耗时操作。
 @return 当前主题下的实际色值，由 provider 返回
 */
+ (UIColor *)tmui_colorWithThemeProvider:(UIColor *(^)(__kindof TMUIThemeManager *manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme))provider;

/**
 生成一个动态的 color 对象，每次使用该颜色时都会动态根据当前的 TMUIThemeManager name 和主题返回对应的颜色。
 @param name themeManager 的 name，用于区分不同维度的主题管理器
 @param provider 当 color 被使用时，这个 provider 会被调用，返回对应当前主题的 color 值。请不要在这个 block 里做耗时操作。
 @return 当前主题下的实际色值，由 provider 返回
*/
+ (UIColor *)tmui_colorWithThemeManagerName:(__kindof NSObject<NSCopying> *)name provider:(UIColor *(^)(__kindof TMUIThemeManager *manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme))provider;

@end

NS_ASSUME_NONNULL_END
