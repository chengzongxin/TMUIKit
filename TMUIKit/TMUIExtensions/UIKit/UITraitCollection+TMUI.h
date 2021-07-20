//
//  UITraitCollection+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/4/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITraitCollection (TMUI)

/**
 添加一个系统的深色、浅色外观发即将生变化前的监听，可用于需要在外观即将发生改变之前更新状态，例如 QMUIThemeManager 利用其来自动切换主题
 @note 如果在 info.plist 中指定 User Interface Style 值将无法监听。
 */
+ (void)tmui_addUserInterfaceStyleWillChangeObserver:(id)observer selector:(SEL)aSelector API_AVAILABLE(ios(13.0));

@end

NS_ASSUME_NONNULL_END
