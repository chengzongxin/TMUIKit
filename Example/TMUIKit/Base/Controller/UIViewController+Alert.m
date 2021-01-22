//
//  UIViewController+Alert.m
//  Matafy
//
//  Created by Jason on 2018/11/23.
//  Copyright © 2018 com.upintech. All rights reserved.
//

#import "UIViewController+Alert.h"

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
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:kLStr(@"common_alert_sure") style:UIAlertActionStyleDefault handler:sure];
    
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
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:kLStr(@"common_alert_sure") style:UIAlertActionStyleDefault handler:sure];
    
    UIAlertAction *revoke = [UIAlertAction actionWithTitle:kLStr(@"common_alert_cancel") style:UIAlertActionStyleCancel handler:cancel];
    
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
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLStr(@"common_alert_cancel") style:UIAlertActionStyleCancel handler:nil];
    
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
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLStr(@"common_alert_cancel") style:UIAlertActionStyleCancel handler:nil];
    
    [alertSheet addAction:actionOne];
    [alertSheet addAction:actionTwo];
    [alertSheet addAction:cancelAction];
    
    [self presentViewController:alertSheet animated:YES completion:nil];
}

@end
