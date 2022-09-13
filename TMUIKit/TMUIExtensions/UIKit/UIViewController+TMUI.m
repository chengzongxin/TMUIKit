//
//  UIViewController+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/20.
//

#import "UIViewController+TMUI.h"
#import <objc/runtime.h>
#import <TMUICore/TMUICore.h>


@implementation UIViewController (TMUI)

- (BOOL)tmui_navBarHidden {
    BOOL hidden = [objc_getAssociatedObject(self, _cmd) boolValue];
    return hidden;
}

- (void)setTmui_navBarHidden:(BOOL)navBarHidden {
    objc_setAssociatedObject(self, @selector(tmui_navBarHidden), @(navBarHidden), OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - api

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)tmui_previousViewController {
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
- (UIViewController*)tmui_nextViewController {
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

- (void)tmui_navBackAction:(id)sender {
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark -  获取当前最顶层的ViewController
- (UIViewController *)tmui_topViewController {
    return TMUIHelper.topViewController;
}

+ (UIViewController *)tmui_topViewController{
    return TMUIHelper.topViewController;
}
+ (UIViewController *)tmui_topViewControllerForPresent{
    return TMUIHelper.topViewControllerForPresent;
}

@end



@implementation UIViewController (TMUI_Alert)


- (void)tmui_showAlertWithTitle:(NSString *)title
                        message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
               buttonIndexBlock:(void (^)(NSInteger))block
              otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSInteger index = 0;
    if (cancelButtonTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (block) {
                block(index);
            }
        }];
        [alertController addAction:cancelAction];
        index ++;
    }
    
    if (otherButtonTitles)
    {
        va_list args;//定义一个指向个数可变的参数列表指针
        va_start(args, otherButtonTitles);//得到第一个可变参数地址
        for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString *))
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:arg style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (block) {
                    block(index);
                }
            }];
            [alertController addAction:action];
            index ++;
        }
        va_end(args);//置空指针
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)tmui_showAlertWithTitle:(NSString *)title message:(NSString *)message block:(void (^)(NSInteger))block buttons:(NSString *)buttonTitle, ...{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    NSInteger index = 0;
    va_list args;//定义一个指向个数可变的参数列表指针
    va_start(args, buttonTitle);//得到第一个可变参数地址
    for (NSString *arg = buttonTitle; arg != nil; arg = va_arg(args, NSString *)) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:arg style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            block(index);
        }];
        [alert addAction:action];
        index ++;
    }
    va_end(args);//置空指针
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tmui_showSheetWithTitle:(NSString *)title message:(NSString *)message block:(void (^)(NSInteger))block buttons:(NSString *)buttonTitle, ...{
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    NSInteger index = 0;
    va_list args;//定义一个指向个数可变的参数列表指针
    va_start(args, buttonTitle);//得到第一个可变参数地址
    for (NSString *arg = buttonTitle; arg != nil; arg = va_arg(args, NSString *)) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:arg style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            block(index);
        }];
        [alertSheet addAction:action];
        index ++;
    }
    va_end(args);//置空指针
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertSheet addAction:cancelAction];
    
    [self presentViewController:alertSheet animated:YES completion:nil];
}

@end
