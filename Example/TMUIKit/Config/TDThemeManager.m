//
//  TDThemeManager.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/29.
//  Copyright © 2021 chengzongxin. All rights reserved.
//


#import "TDThemeManager.h"

@interface TDThemeManager ()

@property(nonatomic, strong) UIColor *qd_backgroundColor;
@property(nonatomic, strong) UIColor *qd_backgroundColorLighten;
@property(nonatomic, strong) UIColor *qd_backgroundColorHighlighted;
@property(nonatomic, strong) UIColor *qd_tintColor;
@property(nonatomic, strong) UIColor *qd_titleTextColor;
@property(nonatomic, strong) UIColor *qd_mainTextColor;
@property(nonatomic, strong) UIColor *qd_descriptionTextColor;
@property(nonatomic, strong) UIColor *qd_placeholderColor;
@property(nonatomic, strong) UIColor *qd_codeColor;
@property(nonatomic, strong) UIColor *qd_separatorColor;
@property(nonatomic, strong) UIColor *qd_gridItemTintColor;

@property(nonatomic, strong) UIImage *qd_searchBarTextFieldBackgroundImage;
@property(nonatomic, strong) UIImage *qd_searchBarBackgroundImage;

@property(nonatomic, strong) UIVisualEffect *qd_standardBlueEffect;

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
        self.qd_backgroundColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<TDThemeProtocol> *theme) {
            return theme.themeBackgroundColor;
        }];
        self.qd_backgroundColorLighten = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<TDThemeProtocol> * _Nullable theme) {
            return theme.themeBackgroundColorLighten;
        }];
        self.qd_backgroundColorHighlighted = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<TDThemeProtocol> *theme) {
            return theme.themeBackgroundColorHighlighted;
        }];
        self.qd_tintColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<TDThemeProtocol> *theme) {
            return theme.themeTintColor;
        }];
        self.qd_titleTextColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<TDThemeProtocol> *theme) {
            return theme.themeTitleTextColor;
        }];
        self.qd_mainTextColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<TDThemeProtocol> *theme) {
            return theme.themeMainTextColor;
        }];
        self.qd_descriptionTextColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<TDThemeProtocol> *theme) {
            return theme.themeDescriptionTextColor;
        }];
        self.qd_placeholderColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<TDThemeProtocol> *theme) {
            return theme.themePlaceholderColor;
        }];
        self.qd_codeColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<TDThemeProtocol> *theme) {
            return theme.themeCodeColor;
        }];
        self.qd_separatorColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<TDThemeProtocol> *theme) {
            return theme.themeSeparatorColor;
        }];
        self.qd_gridItemTintColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<TDThemeProtocol> * _Nullable theme) {
            return theme.themeGridItemTintColor;
        }];

//        self.qd_searchBarTextFieldBackgroundImage = [UIImage tmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject<TDThemeProtocol> * _Nullable theme) {
//            return [UISearchBar tmui_generateTextFieldBackgroundImageWithColor:theme.themeBackgroundColorHighlighted];
//        }];
//        self.qd_searchBarBackgroundImage = [UIImage tmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject<TDThemeProtocol> * _Nullable theme) {
//            return [UISearchBar tmui_generateBackgroundImageWithColor:theme.themeBackgroundColor borderColor:nil];
//        }];
//
//        self.qd_standardBlueEffect = [UIVisualEffect tmui_effectWithThemeProvider:^UIVisualEffect * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<TDThemeProtocol> * _Nullable theme) {
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

+ (instancetype)qd_sharedInstance {
    static dispatch_once_t onceToken;
    static UIColor *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (UIColor *)qd_backgroundColor {
    return TDThemeManager.sharedInstance.qd_backgroundColor;
}

+ (UIColor *)qd_backgroundColorLighten {
    return TDThemeManager.sharedInstance.qd_backgroundColorLighten;
}

+ (UIColor *)qd_backgroundColorHighlighted {
    return TDThemeManager.sharedInstance.qd_backgroundColorHighlighted;
}

+ (UIColor *)qd_tintColor {
    return TDThemeManager.sharedInstance.qd_tintColor;
}

+ (UIColor *)qd_titleTextColor {
    return TDThemeManager.sharedInstance.qd_titleTextColor;
}

+ (UIColor *)qd_mainTextColor {
    return TDThemeManager.sharedInstance.qd_mainTextColor;
}

+ (UIColor *)qd_descriptionTextColor {
    return TDThemeManager.sharedInstance.qd_descriptionTextColor;
}

+ (UIColor *)qd_placeholderColor {
    return TDThemeManager.sharedInstance.qd_placeholderColor;
}

+ (UIColor *)qd_codeColor {
    return TDThemeManager.sharedInstance.qd_codeColor;
}

+ (UIColor *)qd_separatorColor {
    return TDThemeManager.sharedInstance.qd_separatorColor;
}

+ (UIColor *)qd_gridItemTintColor {
    return TDThemeManager.sharedInstance.qd_gridItemTintColor;
}

@end

@implementation UIImage (TDTheme)

+ (UIImage *)qd_searchBarTextFieldBackgroundImage {
    return TDThemeManager.sharedInstance.qd_searchBarTextFieldBackgroundImage;
}

+ (UIImage *)qd_searchBarBackgroundImage {
    return TDThemeManager.sharedInstance.qd_searchBarBackgroundImage;
}

@end

@implementation UIVisualEffect (TDTheme)

+ (UIVisualEffect *)qd_standardBlurEffect {
    return TDThemeManager.sharedInstance.qd_standardBlueEffect;
}

@end
