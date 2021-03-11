//
//  TMAppDelegate.m
//  TMUIKit
//
//  Created by chengzongxin on 01/19/2021.
//  Copyright (c) 2021 chengzongxin. All rights reserved.
//

#import "TMAppDelegate.h"


NSString *const h1 = @"h1";
NSString *const h2 = @"h2";
NSString *const body = @"body";

@interface TMAppDelegate ()

@property (nonatomic, strong) CUIStyle *h1;
@property (nonatomic, strong) CUIStyle *h2;
@property (nonatomic, strong) CUIStyle *body;
//@property (nonatomic, strong) CUIStyle *img_icon;
//@property (nonatomic, strong) CUIStyle *img_small;
//@property (nonatomic, strong) CUIStyle *img_big;

@end

@implementation TMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    _h1 = Style(h1).fnt(@16).color(Color(@"black")).lineGap(10).multiline;
    _h2 = Style(h2).fnt(@12).color(Color(@"black")).lineGap(10).multiline;
    _body = Style(body).fnt(12).color(Color(@"gray")).lineGap(15).multiline;
    
#if DEBUG
    // iOS
    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
    // tvOS
    //[[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/tvOSInjection.bundle"] load];
    // macOS
    //[[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/macOSInjection.bundle"] load];
#endif
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
