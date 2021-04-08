//
//  TDThemeManager.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/29.
//  Copyright © 2021 chengzongxin. All rights reserved.
//


#import "TDThemeManager.h"

@interface TDThemeManager ()

@property(nonatomic, strong) UIColor *td_backgroundColor;
@property(nonatomic, strong) UIColor *td_backgroundColorLighten;
@property(nonatomic, strong) UIColor *td_backgroundColorHighlighted;
@property(nonatomic, strong) UIColor *td_tintColor;
@property(nonatomic, strong) UIColor *td_titleTextColor;
@property(nonatomic, strong) UIColor *td_mainTextColor;
@property(nonatomic, strong) UIColor *td_descriptionTextColor;
@property(nonatomic, strong) UIColor *td_placeholderColor;
@property(nonatomic, strong) UIColor *td_codeColor;
@property(nonatomic, strong) UIColor *td_separatorColor;
@property(nonatomic, strong) UIColor *td_gridItemTintColor;

@property(nonatomic, strong) UIImage *td_searchBarTextFieldBackgroundImage;
@property(nonatomic, strong) UIImage *td_searchBarBackgroundImage;

@property(nonatomic, strong) UIVisualEffect *td_standardBlueEffect;

@property(class, nonatomic, strong, readonly) TDThemeManager *sharedInstance;
@end

@implementation TDThemeManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static TDThemeManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}
    
- (instancetype)init {
    if (self = [super init]) {
        self.td_backgroundColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<TDThemeProtocol> *theme) {
            return theme.themeBackgroundColor;
        }];
        self.td_backgroundColorLighten = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<TDThemeProtocol> * _Nullable theme) {
            return theme.themeBackgroundColorLighten;
        }];
        self.td_backgroundColorHighlighted = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<TDThemeProtocol> *theme) {
            return theme.themeBackgroundColorHighlighted;
        }];
        self.td_tintColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<TDThemeProtocol> *theme) {
            return theme.themeTintColor;
        }];
        self.td_titleTextColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<TDThemeProtocol> *theme) {
            return theme.themeTitleTextColor;
        }];
        self.td_mainTextColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<TDThemeProtocol> *theme) {
            return theme.themeMainTextColor;
        }];
        self.td_descriptionTextColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<TDThemeProtocol> *theme) {
            return theme.themeDescriptionTextColor;
        }];
        self.td_placeholderColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<TDThemeProtocol> *theme) {
            return theme.themePlaceholderColor;
        }];
        self.td_codeColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<TDThemeProtocol> *theme) {
            return theme.themeCodeColor;
        }];
        self.td_separatorColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<TDThemeProtocol> *theme) {
            return theme.themeSeparatorColor;
        }];
        self.td_gridItemTintColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<TDThemeProtocol> * _Nullable theme) {
            return theme.themeGridItemTintColor;
        }];

//        self.td_searchBarTextFieldBackgroundImage = [UIImage tmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject<TDThemeProtocol> * _Nullable theme) {
//            return [UISearchBar tmui_generateTextFieldBackgroundImageWithColor:theme.themeBackgroundColorHighlighted];
//        }];
//        self.td_searchBarBackgroundImage = [UIImage tmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject<TDThemeProtocol> * _Nullable theme) {
//            return [UISearchBar tmui_generateBackgroundImageWithColor:theme.themeBackgroundColor borderColor:nil];
//        }];
//
//        self.td_standardBlueEffect = [UIVisualEffect tmui_effectWithThemeProvider:^UIVisualEffect * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<TDThemeProtocol> * _Nullable theme) {
//            return [UIBlurEffect effectWithStyle:[identifier isEqualToString:TDThemeIdentifierDark] ? UIBlurEffectStyleDark : UIBlurEffectStyleLight];
//        }];
    }
    return self;
}

+ (NSObject<TDThemeProtocol> *)currentTheme {
    return TMUIThemeManagerCenter.defaultThemeManager.currentTheme;
}

@end

@implementation UIColor (TDTheme)

+ (instancetype)td_sharedInstance {
    static dispatch_once_t onceToken;
    static UIColor *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (UIColor *)td_backgroundColor {
    return TDThemeManager.sharedInstance.td_backgroundColor;
}

+ (UIColor *)td_backgroundColorLighten {
    return TDThemeManager.sharedInstance.td_backgroundColorLighten;
}

+ (UIColor *)td_backgroundColorHighlighted {
    return TDThemeManager.sharedInstance.td_backgroundColorHighlighted;
}

+ (UIColor *)td_tintColor {
    return TDThemeManager.sharedInstance.td_tintColor;
}

+ (UIColor *)td_titleTextColor {
    return TDThemeManager.sharedInstance.td_titleTextColor;
}

+ (UIColor *)td_mainTextColor {
    return TDThemeManager.sharedInstance.td_mainTextColor;
}

+ (UIColor *)td_descriptionTextColor {
    return TDThemeManager.sharedInstance.td_descriptionTextColor;
}

+ (UIColor *)td_placeholderColor {
    return TDThemeManager.sharedInstance.td_placeholderColor;
}

+ (UIColor *)td_codeColor {
    return TDThemeManager.sharedInstance.td_codeColor;
}

+ (UIColor *)td_separatorColor {
    return TDThemeManager.sharedInstance.td_separatorColor;
}

+ (UIColor *)td_gridItemTintColor {
    return TDThemeManager.sharedInstance.td_gridItemTintColor;
}

@end

@implementation UIImage (TDTheme)

+ (UIImage *)td_searchBarTextFieldBackgroundImage {
    return TDThemeManager.sharedInstance.td_searchBarTextFieldBackgroundImage;
}

+ (UIImage *)td_searchBarBackgroundImage {
    return TDThemeManager.sharedInstance.td_searchBarBackgroundImage;
}

@end

@implementation UIVisualEffect (TDTheme)

+ (UIVisualEffect *)td_standardBlurEffect {
    return TDThemeManager.sharedInstance.td_standardBlueEffect;
}

@end
