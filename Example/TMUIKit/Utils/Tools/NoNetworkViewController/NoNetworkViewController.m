//
//  NoNetworkViewController.m
//  ShareBite
//
//  Created by William Falcon on 1/15/15.
//  Copyright (c) 2015 HACStudios. All rights reserved.
//


#import "NoNetworkViewController.h"
#import "Reachability.h"
#import "NoNetworkManager.h"
#import <objc/runtime.h>

@interface NoNetworkViewController()
@property (assign) BOOL originalNavigationBarState;
@end

@implementation NoNetworkViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *bar = self.navigationController.navigationBar;
    
    [bar setBackgroundColor:[UIColor whiteColor]];
    
    [bar setShadowImage:[[UIImage alloc] init]];
    
    bar.translucent = false;
    // 设置背景颜色
    [bar setBarTintColor:[UIColor whiteColor]];
    // 设置全局导航栏
    [bar setTintColor:[UIColor blackColor]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
//    [self blurBackground];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //hide nav bar
//    self.originalNavigationBarState = self.navigationController.navigationBar.hidden;
//    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //show nav bar
//    self.navigationController.navigationBar.hidden = self.originalNavigationBarState;
}

#pragma mark - UI Utils
- (void)blurBackground {
    self.view.backgroundColor = [UIColor clearColor];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:effect];
    blurView.frame = self.view.bounds;
    [self.view insertSubview:blurView atIndex:0];
}


- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tap:(id)sender {
    NSLog(@"tap nonetview");
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:kLStr(@"network_verifying")];
    [SVProgressHUD dismissWithDelay:3.0];
    
    // 调用 handleNetworkChange
    NoNetworkManager *shareInstance = [NoNetworkManager sharedInstance];
    SEL selector = NSSelectorFromString(@"handleNetworkChange:");
//    IMP imp = [shareInstance methodForSelector:selector];
//    CGRect (*func)(id, SEL, id) = (void *)imp;
//    func(shareInstance, selector, nil);
    [shareInstance performSelector:selector withObject:nil];
}

@end






