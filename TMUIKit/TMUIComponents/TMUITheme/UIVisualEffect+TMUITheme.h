//
//  UIVisualEffect+TMUITheme.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/4/8.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class TMUIThemeManager;

@protocol TMUIDynamicEffectProtocol <NSObject>

@required

/// 获取当前 UIVisualEffect 的实际 effect（返回的 effect 必定不是 dynamic image）
@property(nonatomic, strong, readonly) __kindof UIVisualEffect *tmui_rawEffect;

/// 标志当前 UIVisualEffect 对象是否为动态 effect（由 [UIVisualEffect tmui_effectWithThemeProvider:] 创建的 effect
@property(nonatomic, assign, readonly) BOOL tmui_isDynamicEffect;

@end

@interface UIVisualEffect (TMUITheme) <TMUIDynamicEffectProtocol>

/**
 生成一个动态的 UIVisualEffect 对象，每次使用该对象时都会动态根据当前的 TMUIThemeManager 主题返回对应的 effect。
 @param provider 当 UIVisualEffect 被使用时，这个 provider 会被调用，返回对应当前主题的 effect 值。请不要在这个 block 里做耗时操作。
 @return 一个动态的 UIVisualEffect 对象，被使用时才会返回实际的 effect 效果
 */
+ (UIVisualEffect *)tmui_effectWithThemeProvider:(UIVisualEffect *(^)(__kindof TMUIThemeManager *manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme))provider;

/**
 生成一个动态的 UIVisualEffect 对象，每次使用该对象时都会动态根据当前的 TMUIThemeManager  name 和主题返回对应的 effect。
 @param name themeManager 的 name，用于区分不同维度的主题管理器
 @param provider 当 UIVisualEffect 被使用时，这个 provider 会被调用，返回对应当前主题的 effect 值。请不要在这个 block 里做耗时操作。
 @return 一个动态的 UIVisualEffect 对象，被使用时才会返回实际的 effect 效果
*/
+ (UIVisualEffect *)tmui_effectWithThemeManagerName:(__kindof NSObject<NSCopying> *)name provider:(UIVisualEffect *(^)(__kindof TMUIThemeManager *manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme))provider;
@end

NS_ASSUME_NONNULL_END
