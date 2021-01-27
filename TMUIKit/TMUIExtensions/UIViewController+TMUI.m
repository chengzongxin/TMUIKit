//
//  UIViewController+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/20.
//

#import "UIViewController+TMUI.h"
#import <objc/runtime.h>
@implementation UIViewController (TMUI)

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


#pragma mark -  获取当前最顶层的ViewController
+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    result = [self topVC:result];
    while(result.presentedViewController) {
        result = [self topVC:result.presentedViewController];
    }
    return result;
}

+ (UIViewController*)topVC:(UIViewController*)VC {
    if([VC isKindOfClass:[UINavigationController class]]) {
        return [self topVC:[(UINavigationController*)VC topViewController]];
    }
    if([VC isKindOfClass:[UITabBarController class]]) {
        return [self topVC:[(UITabBarController*)VC selectedViewController]];
    }
    return VC;
}
@end



@implementation UIViewController (Alert)
/**
 弹出UIAlertController
 
 @param title   标题
 @param message 消息
 @param sure    点击确定按钮
 */
- (void)showAlertSureWithTitle:(NSString *)title message:(NSString *)message sure:(void (^) (UIAlertAction *action))sure;
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:sure];
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}



/**
 弹出UIAlerController
 
 @param title   标题
 @param message 消息
 @param sure    点击确定
 @param cancel  点击取消
 */
- (void)showAlertSureAndCancelWithTitle:(NSString *)title message:(NSString *)message sure:(void (^) (UIAlertAction *action))sure cancel:(void (^) (UIAlertAction *action))cancel
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:sure];
    
    UIAlertAction *revoke = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancel];
    
    [alert addAction:action];
    [alert addAction:revoke];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 弹出UIAlertController
 
 @param actionOneTitle 标题
 @param handlerOne     点击标题的事件
 */
- (void)showSheetOneaction:(NSString *)actionOneTitle handlerOne:(void(^)(UIAlertAction *action))handlerOne
{
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:actionOneTitle style:UIAlertActionStyleDefault handler:handlerOne];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertSheet addAction:actionOne];
    [alertSheet addAction:cancelAction];
    
    [self presentViewController:alertSheet animated:YES completion:nil];
}


/**
 弹出UIAlerController
 
 @param actionOneTitle 第一标题
 @param actionTwoTitle 第二个标题
 @param handlerOne     第一个标题点击事件
 @param handlerTwo     第二个标题点击事件
 */
- (void)showSheetTwoaction:(NSString *)actionOneTitle actionTwo:(NSString *)actionTwoTitle handlerOne:(void(^)(UIAlertAction *action))handlerOne handlerTwo:(void (^) (UIAlertAction *action))handlerTwo
{
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:actionOneTitle style:UIAlertActionStyleDefault handler:handlerOne];
    
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:actionTwoTitle style:UIAlertActionStyleDefault handler:handlerTwo];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertSheet addAction:actionOne];
    [alertSheet addAction:actionTwo];
    [alertSheet addAction:cancelAction];
    
    [self presentViewController:alertSheet animated:YES completion:nil];
}

@end
