//
//  UIViewController+TCategory.m
//  TBasicLib
//
//  Created by kevin.huang on 14-6-11.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import "UIViewController+TCategory.h"
#import <objc/runtime.h>

@implementation UIViewController (TCategory)

- (BOOL)navBarHidden {
    BOOL hidden = [objc_getAssociatedObject(self, _cmd) boolValue];
    return hidden;
}

- (void)setNavBarHidden:(BOOL)navBarHidden {
    objc_setAssociatedObject(self, @selector(navBarHidden), @(navBarHidden), OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - api

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)previousViewController {
    NSArray* viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1) {
        NSUInteger controllerIndex = [viewControllers indexOfObject:self];
        if (controllerIndex != NSNotFound && controllerIndex > 0) {
            return [viewControllers objectAtIndex:controllerIndex-1];
        }
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)nextViewController {
    NSArray* viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1) {
        NSUInteger controllerIndex = [viewControllers indexOfObject:self];
        if (controllerIndex != NSNotFound && controllerIndex+1 < viewControllers.count) {
            return [viewControllers objectAtIndex:controllerIndex+1];
        }
    }
    return nil;
}


#pragma mark - api

- (void)navBackAction:(id)sender {
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 

- (void)t_presentViewController:(UIViewController *)viewControllerToPresent
                      animated:(BOOL)flag
                    completion:(void (^)(void))completion {
    
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
    
    UIViewController *rootVc;
    if ([currentWindow rootViewController].presentedViewController) {
        rootVc = [currentWindow rootViewController].presentedViewController;
    } else {
        rootVc = [currentWindow rootViewController];
    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewControllerToPresent];
    
    [rootVc presentViewController:nav animated:flag completion:completion];
}


@end
