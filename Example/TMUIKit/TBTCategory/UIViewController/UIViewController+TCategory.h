//
//  UIViewController+TCategory.h
//  TBasicLib
//
//  Created by kevin.huang on 14-6-11.
//  Copyright (c) 2014年 binxun. All rights reserved.
//  添加返回上一个viewcontroller等一些方法

#import <UIKit/UIKit.h>

@interface UIViewController (TCategory)

// 控制导航栏显示或隐藏
@property (nonatomic, assign) BOOL navBarHidden;

// 导航控制器中上一个viewcontroller
- (UIViewController*)previousViewController;
// 导航控制器中下一个viewcontroller
- (UIViewController*)nextViewController;

#pragma mark - 

// 导航栏返回按钮方法
-(void)navBackAction:(id)sender;

@end
