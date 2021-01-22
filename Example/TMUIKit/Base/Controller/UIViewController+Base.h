//
//  UIViewController+Base.h
//  NewStart
//
//  Created by  ZhuHong on 2017/12/27.
//  Copyright © 2017年 CoderHG. All rights reserved.
//

/**
 基控制器的公共处理
 这个分类放到这里的原因是, 这个分类只可能在这个地方用到, 所以放在这里也是很不错的
 */

#import <UIKit/UIKit.h>

@interface UIViewController (Base)

/**
 白色返回按钮
 */
- (void)addWhiteBackButton;

- (void)addBackButtonWithIcon:(NSString *_Nonnull)icon;

/**
 定义返回按钮样式
 */
- (UIBarButtonItem *_Nullable)itemWithTarget:(id _Nullable )target action:(SEL _Nullable )action image:(NSString *_Nullable)imageSTR highImage:(NSString *_Nullable)highImage;

/**
 当内存吃紧的时候,取消当前下载/清除内存总所有的图片
 */
- (void)cancellWebImageMemory;

/** 通过故事版名称创建InitialVC */
+ (instancetype _Nullable )storyboardInitialWithName:(NSString *_Nullable)sbName;

/** 通过故事版名称创建以当前class命名的Identifier VC */
+ (instancetype _Nullable )storyboardWithName:(NSString *_Nullable)sbName;

/**
 pop方法
 */
- (void)popLastViewControllerWithAnimation;


/**
 设置标题-样式靠近左边

 @param title 标题
 */
- (void)setleftTitle:(NSString *_Nullable)title;

/**
 隐藏导航栏
 
 @param hidden hidden
 */
//- (void)navigationBarHidden:(BOOL)hidden;


/**
 隐藏导航栏下划线
 
 @param hidden hidden
 */
//- (void)navigationBarShadowImageHidden:(BOOL)hidden;


/**
 判断是否有token,弹出LoginVC

 @return 返回是否显示了LoginVC
 */
- (BOOL)showLoginVC;
- (BOOL)showLoginVC:(void (^_Nullable)(void))callback;

/**
 隐藏/显示状态栏

 @param show 是否显示
 */
- (void)statusBarShow:(BOOL)show;

/**
 获取tabbarController

 @return 返回MainTabBarController
 */
- (UITabBarController *_Nullable)mainTabBarController;

// 获取当前屏幕显示的viewcontroller
@property (nonatomic, strong ,readonly) UIViewController * _Nullable currentVC;

// 获取当前屏幕显示的viewcontroller
- (UIViewController *_Nullable)getCurrentVC;


// Toast 提示
- (void)toast:(NSString *_Nullable)toastString;

- (void)showSnapShot:(UIImage *_Nullable)snapShotImage;

// 允许/禁止滑动
- (void)interactivePopDisable:(BOOL)disable;

@end
