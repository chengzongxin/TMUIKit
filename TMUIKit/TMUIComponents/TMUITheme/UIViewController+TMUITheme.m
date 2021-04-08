//
//  UIViewController+TMUITheme.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/4/8.
//


#import "UIViewController+TMUITheme.h"
//#import "TMUIModalPresentationViewController.h"

@implementation UIViewController (TMUITheme)

- (void)tmui_themeDidChangeByManager:(TMUIThemeManager *)manager identifier:(__kindof NSObject<NSCopying> *)identifier theme:(__kindof NSObject *)theme {
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull childViewController, NSUInteger idx, BOOL * _Nonnull stop) {
        [childViewController tmui_themeDidChangeByManager:manager identifier:identifier theme:theme];
    }];
    if (self.presentedViewController && self.presentedViewController.presentingViewController == self) {
        [self.presentedViewController tmui_themeDidChangeByManager:manager identifier:identifier theme:theme];
    }
    
}

@end

//@implementation TMUIModalPresentationViewController (TMUITheme)
//
//- (void)tmui_themeDidChangeByManager:(TMUIThemeManager *)manager identifier:(__kindof NSObject<NSCopying> *)identifier theme:(__kindof NSObject *)theme {
//    [super tmui_themeDidChangeByManager:manager identifier:identifier theme:theme];
//    if (self.contentViewController) {
//        [self.contentViewController tmui_themeDidChangeByManager:manager identifier:identifier theme:theme];
//    }
//}
//
//@end
