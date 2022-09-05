//
//  UINavigationItem+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/1/19.
//

#import "UINavigationItem+TMUI.h"
#import "UIView+TMUI.h"

@implementation UINavigationItem (TMUI)

- (UINavigationBar *)tmui_navigationBar {
    // UINavigationItem 内部有个方法可以获取 navigationBar
    if ([self respondsToSelector:@selector(navigationBar)]) {
        return [self performSelector:@selector(navigationBar)];
    }
    return nil;
}

- (UINavigationController *)tmui_navigationController {
    UINavigationBar *navigationBar = self.tmui_navigationBar;
    UINavigationController *navigationController = (UINavigationController *)navigationBar.superview.tmui_viewController;
    if ([navigationController isKindOfClass:UINavigationController.class]) {
        return navigationController;
    }
    return nil;
}

- (UIViewController *)tmui_viewController {
    UINavigationBar *navigationBar = self.tmui_navigationBar;
    UINavigationController *navigationController = self.tmui_navigationController;
    
    if (!navigationBar || !navigationController) return nil;
    
    NSInteger index = [navigationBar.items indexOfObject:self];
    if (index != NSNotFound && index < navigationController.viewControllers.count) {
        UIViewController *viewController = navigationController.viewControllers[index];
        return viewController;
    }
    return nil;
}

- (UINavigationItem *)tmui_previousItem {
    NSArray<UINavigationItem *> *items = self.tmui_navigationBar.items;
    if (!items.count) return nil;
    NSInteger index = [items indexOfObject:self];
    if (index != NSNotFound && index > 0) return items[index - 1];
    return nil;
}

- (UINavigationItem *)tmui_nextItem {
    NSArray<UINavigationItem *> *items = self.tmui_navigationBar.items;
    if (!items.count) return nil;
    NSInteger index = [items indexOfObject:self];
    if (index != NSNotFound && index < items.count - 1) return items[index + 1];
    return nil;
}
@end
