//
//  UIView+TMUITheme.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/4/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TMUIThemeManager;

@interface UIView (TMUITheme)

/**
 注册当前 view 里需要在主题变化时被重新设置的 property，当主题变化时，会通过 tmui_themeDidChangeByManager:identifier:theme: 来重新调用一次 self.xxx = xxx，以达到刷新界面的目的。
 @param getters 属性的 getter， 内部会根据命名规则自动转换得到 setter，再通过 performSelector 的形式调用 getter 和 setter
 */
- (void)tmui_registerThemeColorProperties:(NSArray<NSString *> *)getters;

/**
 注销通过 tmui_registerThemeColorProperties: 注册的 property
 @param getters 属性的 getter， 内部会根据命名规则自动转换得到 setter，再通过 performSelector 的形式调用 getter 和 setter
 */
- (void)tmui_unregisterThemeColorProperties:(NSArray<NSString *> *)getters;

/**
 当主题变化时这个方法会被调用，通过 registerThemeColorProperties: 方法注册的属性也会在这里被更新（所以记得要调用 super）。registerThemeColorProperties: 无法满足的需求可以重写这个方法自行实现。
 @param manager 当前的主题管理对象
 @param identifier 当前主题的标志，可自行修改参数类型为目标类型
 @param theme 当前主题对象，可自行修改参数类型为目标类型
 */
- (void)tmui_themeDidChangeByManager:(nullable TMUIThemeManager *)manager identifier:(nullable __kindof NSObject<NSCopying> *)identifier theme:(nullable __kindof NSObject *)theme NS_REQUIRES_SUPER;

@property(nonatomic, copy, nullable) void (^tmui_themeDidChangeBlock)(void);

@end

NS_ASSUME_NONNULL_END
