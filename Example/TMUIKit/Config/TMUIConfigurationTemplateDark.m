//
//  TMUIConfigurationTemplateDark.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/4/8.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUIConfigurationTemplateDark.h"

@implementation TMUIConfigurationTemplateDark

#pragma mark - <TMUIConfigurationTemplateProtocol>

- (void)applyConfigurationTemplate {
    [super applyConfigurationTemplate];
    
    TMUICMI.keyboardAppearance = UIKeyboardAppearanceDark;
    
    TMUICMI.navBarBackgroundImage = nil;
    TMUICMI.navBarStyle = UIBarStyleBlack;
    
    TMUICMI.tabBarBackgroundImage = nil;
    TMUICMI.tabBarStyle = UIBarStyleBlack;
    
    TMUICMI.toolBarStyle = UIBarStyleBlack;
}

// TMUI 2.3.0 版本里，配置表新增这个方法，返回 YES 表示在 App 启动时要自动应用这份配置表。仅当你的 App 里存在多份配置表时，才需要把除默认配置表之外的其他配置表的返回值改为 NO。
- (BOOL)shouldApplyTemplateAutomatically {
    [TMUIThemeManagerCenter.defaultThemeManager addThemeIdentifier:self.themeName theme:self];
    
    NSString *selectedThemeIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:TDSelectedThemeIdentifier];
    BOOL result = [selectedThemeIdentifier isEqualToString:self.themeName];
    if (result) {
        TMUIThemeManagerCenter.defaultThemeManager.currentTheme = self;
    }
    return result;
}

#pragma mark - <TDThemeProtocol>

- (UIColor *)themeBackgroundColor {
    return UIColorBlack;
}

- (UIColor *)themeBackgroundColorLighten {
    return UIColorMake(28, 28, 30);
}

- (UIColor *)themeBackgroundColorHighlighted {
    return UIColorMake(48, 49, 51);
}

- (UIColor *)themeTintColor {
    return UIColorTheme0;
}

- (UIColor *)themeTitleTextColor {
    return UIColorDarkGray1;
}

- (UIColor *)themeMainTextColor {
    return UIColorDarkGray3;
}

- (UIColor *)themeDescriptionTextColor {
    return UIColorDarkGray6;
}

- (UIColor *)themePlaceholderColor {
    return UIColorDarkGray8;
}

- (UIColor *)themeCodeColor {
    return self.themeTintColor;
}

- (UIColor *)themeSeparatorColor {
    return UIColorMake(46, 50, 54);
}

- (NSString *)themeName {
    return TDThemeIdentifierDark;
}
@end
