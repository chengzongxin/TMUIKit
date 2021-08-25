//
//  TMAppDelegate.m
//  TMUIKit
//
//  Created by chengzongxin on 01/19/2021.
//  Copyright (c) 2021 chengzongxin. All rights reserved.
//

#import "TMAppDelegate.h"
#import "TMUIExampleConfiguration.h"
#import "TDThemeManager.h"
#import "TMUIConfigurationTemplate.h"
#import "TMUIConfigurationTemplateGrapefruit.h"
#import "TMUIConfigurationTemplateGrass.h"
#import "TMUIConfigurationTemplatePinkRose.h"
#import "TMUIConfigurationTemplateDark.h"


@interface TMAppDelegate ()<UITextFieldDelegate,UIScrollViewDelegate>


@end

@implementation TMAppDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    Log(self);
    Log(scrollView.contentOffset);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    Log(self);
    Log(string);
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self initTheme];
    id t2 = [[TMUIExampleConfiguration alloc] init];
    id t1 = TMUIExampleConfiguration.sharedInstance;
    Log(t1);
    Log(t2);
    
    return YES;
}

- (void)initTheme{
    
    // 1. 先注册主题监听，在回调里将主题持久化存储，避免启动过程中主题发生变化时读取到错误的值
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThemeDidChangeNotification:) name:TMUIThemeDidChangeNotification object:nil];
    
    // 2. 然后设置主题的生成器
    TMUIThemeManagerCenter.defaultThemeManager.themeGenerator = ^__kindof NSObject * _Nonnull(NSString * _Nonnull identifier) {
        if ([identifier isEqualToString:TDThemeIdentifierDefault]) return TMUIConfigurationTemplate.new;
        if ([identifier isEqualToString:TDThemeIdentifierGrapefruit]) return TMUIConfigurationTemplateGrapefruit.new;
        if ([identifier isEqualToString:TDThemeIdentifierGrass]) return TMUIConfigurationTemplateGrass.new;
        if ([identifier isEqualToString:TDThemeIdentifierPinkRose]) return TMUIConfigurationTemplatePinkRose.new;
        if ([identifier isEqualToString:TDThemeIdentifierDark]) return TMUIConfigurationTemplateDark.new;
        return nil;
    };
    
    // 3. 再针对 iOS 13 开启自动响应系统的 Dark Mode 切换
    // 如果不需要这个功能，则不需要这一段代码
    if (@available(iOS 13.0, *)) {
        if (TMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier) {// 做这个 if(currentThemeIdentifier) 的保护只是为了避免 TD 里的配置表没启动时，没人为 currentTheme/currentThemeIdentifier 赋值，导致后续的逻辑会 crash，业务项目里理论上不会有这种情况出现，所以可以省略这个 if，直接写下面的代码就行了
            
            TMUIThemeManagerCenter.defaultThemeManager.identifierForTrait = ^__kindof NSObject<NSCopying> * _Nonnull(UITraitCollection * _Nonnull trait) {
                // 1. 如果当前系统切换到 Dark Mode，则返回 App 在 Dark Mode 下的主题
                if (trait.userInterfaceStyle == UIUserInterfaceStyleDark) {
                    return TDThemeIdentifierDark;
                }
                
                // 2. 如果没有命中1，说明此时系统是 Light，则返回 App 在 Light 下的主题即可，这里不直接返回 Default，而是先做一些复杂判断，是因为 TMUI Demo 非深色模式的主题有好几个，而我们希望不管之前选择的是 Default、Grapefruit 还是 PinkRose，只要从 Dark 切换为非 Dark，都强制改为 Default。
                
                // 换句话说，如果业务项目只有 Light/Dark 两套主题，则按下方被注释掉的代码一样直接返回 Light 下的主题即可。
//                return TDThemeIdentifierDefault;
                
                if ([TMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier isEqual:TDThemeIdentifierDark]) {
                    return TDThemeIdentifierDefault;
                }
                return TMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier;
            };
            TMUIThemeManagerCenter.defaultThemeManager.respondsSystemStyleAutomatically = YES;
        }
    }
    
}

- (void)handleThemeDidChangeNotification:(NSNotification *)notification {
    
    TMUIThemeManager *manager = notification.object;
    if (![manager.name isEqual:TMUIThemeManagerNameDefault]) return;
    
    [[NSUserDefaults standardUserDefaults] setObject:manager.currentThemeIdentifier forKey:TDSelectedThemeIdentifier];
    
    [TDThemeManager.currentTheme applyConfigurationTemplate];
    
    // 主题发生变化，在这里更新全局 UI 控件的 appearance
//    [TDCommonUI renderGlobalAppearances];
    
    // 更新表情 icon 的颜色
//    [TDUIHelper updateEmotionImages];
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
