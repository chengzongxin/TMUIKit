//
//  MTFYBaseTool.m
//  Matafy
//
//  Created by Tiaotiao on 2019/4/3.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYBaseTool.h"

@implementation MTFYBaseTool

+ (BOOL)mtfy_checkIsAppStore {
    // 先用宏定义
    return APPSTORE;
}

+ (UIViewController *)mtfy_fetchCurrentVC
{
    UIViewController *vc = nil;
    
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
        vc = nextResponder;
    } else {
        vc = window.rootViewController;
    }
    
    if ([vc isKindOfClass:[UITabBarController class]]) {
        vc = [(UITabBarController *)vc selectedViewController];
    }
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = [(UINavigationController *)vc visibleViewController];
    }
    
    return vc;
}


+ (void)mtfy_makeCallTelephone:(NSString *)phoneNum
{
    if (!phoneNum) {
        return;
    }
    
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@", phoneNum];
    NSURL *url = [NSURL URLWithString:str];
    
    UIApplication *application = [UIApplication sharedApplication];
    if (@available(iOS 10.0, *)) {
        [application openURL:url options:@{} completionHandler:^(BOOL success) {
            //NSLog(@"OpenSuccess=%d",success);
        }];
    } else {
        BOOL success = [application openURL:url];
        NSLog(@"IOS9 call phone open %@: %d", url, success);
    }
}

+ (UIView *)statusBar {
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
        if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
            UIView *localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
            if ([localStatusBar respondsToSelector:@selector(statusBar)]) {
                return  [localStatusBar performSelector:@selector(statusBar)];
            }
        }
        return nil;
    } else {
        return  [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    }
}

@end
