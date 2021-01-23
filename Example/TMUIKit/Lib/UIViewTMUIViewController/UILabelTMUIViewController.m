//
//  UILabelTMUIViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/23.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UILabelTMUIViewController.h"

@interface UILabelTMUIViewController ()

@end

@implementation UILabelTMUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] tmui_initWithFont:UIFont(20) textColor:UIColor.orangeColor];
    [self.view addSubview:label];
    label.numberOfLines = 0;
    label.text = @"春眠不觉晓，\n处处闻啼鸟，\n夜来风雨声，\n花落知多少。";
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@100);
        make.top.mas_equalTo(@100);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(@200);
    }];
    
    
    UILabel *tips = [[UILabel alloc] tmui_initWithFont:UIFont(20) textColor:UIColor.greenColor];
    [self.view addSubview:tips];
    tips.numberOfLines = 0;
    tips.text = @"可点击富文本 '春眠' '啼鸟' '风雨声' '花落知多少'\n";
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@100);
        make.top.mas_equalTo(@500);
        make.width.mas_equalTo(@300);
        make.height.mas_equalTo(@300);
    }];
    
    
    // 行间距
    [label tmui_addAttributesText:10];
    // 指定富文本
    [label tmui_addAttributesText:@"春眠不觉晓" color:UIColor.systemPinkColor font:UIFont(30)];
    [label tmui_addAttributesText:@"处处闻啼鸟" color:UIColor.greenColor font:UIFont(20)];
    [label tmui_addAttributesText:@"夜来风雨声" color:UIColor.systemPurpleColor font:UIFont(25)];
    [label tmui_addAttributesText:@"花落知多少" color:UIColor.systemPurpleColor font:UIFont(25)];
    // 垂直偏移
    [label tmui_addAttributesLineOffset:0];
    // 加横线
    [label tmui_addAttributesLineSingle];
    // 设置可交互文字
    [label tmui_clickAttrTextWithStrings:@[@"春眠",@"啼鸟",@"风雨声",@"花落知多少"] clickAction:^(NSString * _Nonnull string, NSRange range, NSInteger index) {
        NSLog(@"%@",string);
        [self showAlertSureWithTitle:string message:[NSString stringWithFormat:@"你点击了%@",string] sure:^(UIAlertAction * _Nonnull action) {
            NSLog(@"%@",action);
        }];
    }];
    
    
}

@end
