//
//  TDCommonUI.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/29.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TDCommonUI.h"



NSString *const TDSelectedThemeIdentifier = @"selectedThemeIdentifier";
NSString *const TDThemeIdentifierDefault = @"Default";
NSString *const TDThemeIdentifierGrapefruit = @"Grapefruit";
NSString *const TDThemeIdentifierGrass = @"Grass";
NSString *const TDThemeIdentifierPinkRose = @"Pink Rose";
NSString *const TDThemeIdentifierDark = @"Dark";

const CGFloat TDButtonSpacingHeight = 72;

@implementation TDCommonUI

//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        // 统一设置所有 TMUISearchController 搜索状态下的 statusBarStyle
//        OverrideImplementation([TMUISearchController class], @selector(initWithContentsViewController:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
//            return ^TMUISearchController *(TMUISearchController *selfObject, UIViewController *firstArgv) {
//                
//                // call super
//                TMUISearchController *(*originSelectorIMP)(id, SEL, UIViewController *);
//                originSelectorIMP = (TMUISearchController * (*)(id, SEL, UIViewController *))originalIMPProvider();
//                TMUISearchController *result = originSelectorIMP(selfObject, originCMD, firstArgv);
//                
//                result.TMUI_preferredStatusBarStyleBlock = ^UIStatusBarStyle{
//                    if ([TMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier isEqual:TDThemeIdentifierDark]) {
//                        return UIStatusBarStyleLightContent;
//                    }
//                    return TMUIStatusBarStyleDarkContent;
//                };
//                return result;
//            };
//        });
//    });
//}

+ (void)renderGlobalAppearances {
//    [TDUIHelper customMoreOperationAppearance];
//    [TDUIHelper customAlertControllerAppearance];
//    [TDUIHelper customDialogViewControllerAppearance];
//    [TDUIHelper customImagePickerAppearance];
//    [TDUIHelper customEmotionViewAppearance];
//    [TDUIHelper customPopupAppearance];
    
    UISearchBar *searchBar = [UISearchBar appearance];
    searchBar.searchTextPositionAdjustment = UIOffsetMake(4, 0);
    
    TMUILabel *label = [TMUILabel appearance];
    label.highlightedBackgroundColor = TableViewCellSelectedBackgroundColor;
}

@end

@implementation TDCommonUI (ThemeColor)

static NSArray<UIColor *> *themeColors = nil;
+ (UIColor *)randomThemeColor {
    if (!themeColors) {
        themeColors = @[UIColorTheme0,
                        UIColorTheme1,
                        UIColorTheme2,
                        UIColorTheme3,
                        UIColorTheme4,
                        UIColorTheme5,
                        UIColorTheme6,
                        UIColorTheme7,
                        UIColorTheme8,
                        UIColorTheme9,
                        UIColorTheme10];
    }
    return themeColors[arc4random() % themeColors.count];
}

@end

@implementation TDCommonUI (Layer)

+ (CALayer *)generateSeparatorLayer {
    CALayer *layer = [CALayer layer];
    [layer tmui_removeDefaultAnimations];
    layer.backgroundColor = UIColorSeparator.CGColor;
    return layer;
}


@end
