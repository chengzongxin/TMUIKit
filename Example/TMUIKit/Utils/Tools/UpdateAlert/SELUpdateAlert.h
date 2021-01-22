//
//  SELUpdateAlert.h
//  SelUpdateAlert
//
//  Created by zhuku on 2018/2/7.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickAction)(BOOL conform);

@interface SELUpdateAlert : UIView

/**
 添加版本更新提示
 
 @param title 版本号
 @param description 版本更新内容（数组）
 
 descriptions 格式如 @[@"1.xxxxxx",@"2.xxxxxx"]
 */
+ (void)showUpdateAlertWithVersion:(NSString *)title Descriptions:(NSArray *)description;

/**
 添加版本更新提示
 
 @param title 版本号
 @param description 版本更新内容（字符串）
 
 description 格式如 @"1.xxxxxx\n2.xxxxxx"
 */
+ (void)showUpdateAlertWithVersion:(NSString *)title Description:(NSString *)description;

+ (void)showUpdateAlertWithVersion:(NSString *)title
                       description:(NSString *)description
                          onAction:(ClickAction)clickAction;

@property (nonatomic, copy) ClickAction clickAction;

@end
