//
//  UIViewController+TMUITheme.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/4/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TMUIThemeManager;

@interface UIViewController (TMUITheme)

/**
 当主题变化时这个方法会被调用
 @param manager 当前的主题管理对象
 @param identifier 当前主题的标志，可自行修改参数类型为目标类型
 @param theme 当前主题对象，可自行修改参数类型为目标类型
 */
- (void)tmui_themeDidChangeByManager:(TMUIThemeManager *)manager identifier:(__kindof NSObject<NSCopying> *)identifier theme:(__kindof NSObject *)theme NS_REQUIRES_SUPER;
@end


NS_ASSUME_NONNULL_END
