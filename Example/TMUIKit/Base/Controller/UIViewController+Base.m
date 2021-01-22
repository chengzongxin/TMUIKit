//
//  UIViewController+Base.m
//  NewStart
//
//  Created by  ZhuHong on 2017/12/27.
//  Copyright © 2017年 CoderHG. All rights reserved.
//

#import "UIViewController+Base.h"
#import "SDWebImageManager.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@implementation UIViewController (Base)

/**
 非主页控制器添加返回按钮
 */
- (void)addBackButton {
    //无需再每个控制器 添加返回按钮
    //self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(popLastViewControllerWithAnimation) image:@"ico_back" highImage:@"ico_back"];
}

- (void)addWhiteBackButton {
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(popLastViewControllerWithAnimation) image:@"投诉单 back" highImage:@"投诉单 back"];
}

- (void)addBackButtonWithIcon:(NSString *)icon{
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(popLastViewControllerWithAnimation) image:icon highImage:nil];
}

/**
 定义返回按钮样式
 */
- (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)imageSTR highImage:(NSString *)highImage {
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageSTR]];
    
    CGRect imageFrame = imageView.frame;
    UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageFrame.size.width*2.0, 38.0)];
    imageFrame.origin.y = (backView.frame.size.height - imageFrame.size.height)*0.5;
    imageView.frame = imageFrame;
    
    [backView addSubview:imageView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = backView.bounds;
    
    [backView addSubview:btn];
    
    return [[UIBarButtonItem alloc] initWithCustomView:backView];
}

- (void)popLastViewControllerWithAnimation {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/** 通过故事版名称创建InitialVC */
+ (instancetype)storyboardInitialWithName:(NSString *)sbName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sbName bundle:nil];
    return [storyboard instantiateInitialViewController];
}

/** 通过故事版名称创建以当前class命名的Identifier VC */
+ (instancetype)storyboardWithName:(NSString *)sbName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sbName bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}


/**
 当内存吃紧的时候,取消当前下载/清除内存总所有的图片
 */
- (void)cancellWebImageMemory {
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    // 1.取消下载
    [mgr cancelAll];
    
    // 2.清除内存中的所有图片
    [mgr.imageCache clearWithCacheType:SDImageCacheTypeMemory completion:nil];
}


/**
 设置标题
 */
- (void)setleftTitle:(NSString *)title{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 230, 44)];
    titleLabel.text = title;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    titleLabel.textColor = [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1/1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
}


/**
 隐藏导航栏

 @param hidden hidden
 */
//- (void)navigationBarHidden:(BOOL)hidden{
//    UIView *_UIBarBackground = self.navigationController.navigationBar.subviews.firstObject;
//    [_UIBarBackground.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        obj.hidden = hidden;
//    }];
//}


/**
  隐藏导航栏下划线

 @param hidden hidden
 */
//- (void)navigationBarShadowImageHidden:(BOOL)hidden{
//    [self.navigationController.navigationBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        if ([obj isKindOfClass:NSClassFromString(@"_UIBarBackground")]||[obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
//            
//            [obj setClipsToBounds:hidden];
//        }
//    }];
//}


- (BOOL)showLoginVC{
    if ([User sharedInstance].token == nil) {
        [[LoginManager sharedInstance] login:^(NSInteger result) {
            
        }];
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)showLoginVC:(void (^)(void))callback{
    if ([User sharedInstance].token == nil) {
        [[LoginManager sharedInstance] login:^(NSInteger result) {
            callback();
        }];
        return YES;
    }else{
        return NO;
    }
}

// 隐藏/显示状态栏
- (void)statusBarShow:(BOOL)show{
    //    UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];  //或者
    UIView *statusBar = [MTFYBaseTool statusBar];
    statusBar.alpha = show; // 显示
}

// 获取tabbarController
- (UITabBarController *)mainTabBarController
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *tabbarController = window.rootViewController;
    if ([tabbarController isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)tabbarController;
    }
    return nil;
}


#pragma mark - 当前屏幕显示的viewcontroller
-(UIViewController *)currentVC{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *controller = [self getCurrentVCFrom:rootViewController];
    return controller;
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

// 递归查找VC
- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
//    if ([rootVC presentedViewController]) {
//        // 视图是被presented出来的
//
//        rootVC = [rootVC presentedViewController];
//    }
    
    while ([rootVC presentedViewController]) {
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

- (void)toast:(NSString *)toastString{
    
    [self.view hideAllToasts];
    
    if ([toastString containsString:@"Error Domain"]) {
        [self.view makeToast:kLStr(@"network_not_force") duration:3.0 position:CSToastPositionCenter];
    }else{
        [self.view makeToast:toastString duration:3.0 position:CSToastPositionCenter];
    }
}


/* 显示截图 */
- (void)showSnapShot:(UIImage *)snapShotImage{
    UIScrollView *  storeScrollView = [UIScrollView new];
    storeScrollView.contentSize = UIScreen.mainScreen.bounds.size;
    storeScrollView.frame = UIScreen.mainScreen.bounds;
    storeScrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:storeScrollView];
    
    UIImageView *storeImage = [[UIImageView alloc] initWithImage:snapShotImage];
//    storeImage.image = snapShotImage;
    [storeScrollView addSubview:storeImage];
//    storeImage.frame = (CGRect){CGPointZero,snapShotImage.size};
    
    UIButton *delete = [UIButton button];
    delete.frame = CGRectMake(0, 0, 100, 40);
    delete.center = storeScrollView.center;
    [delete setOkaTitle:@"delete"];
    delete.backgroundColor = UIColor.orangeColor;
    [delete addTarget:self action:@selector(deleteScrollView:)];
    [storeScrollView addSubview:delete];
}

- (void)deleteScrollView:(UIButton *)button{
    UIView *scroll = button.superview;
    [scroll removeFromSuperview];
    scroll = nil;
}

- (void)interactivePopDisable:(BOOL)disable{
    self.fd_interactivePopDisabled = disable;
}

@end
