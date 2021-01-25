//
//  TMLabelViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/23.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUILabelViewController.h"

@interface TMUILabelViewController ()

@end

@implementation TMUILabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    TMUILabel *label = [[TMUILabel alloc] init];
    [self.view addSubview:label];
    label.text = @"可长按复制";
    label.backgroundColor = UIColor.tmui_randomColor;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@100);
        make.top.mas_equalTo(@100);
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@100);
    }];
    
    // set
    label.canPerformCopyAction = YES;
    label.didCopyBlock = ^(TMUILabel * _Nonnull label, NSString * _Nonnull stringCopied) {
        NSLog(@"%@",stringCopied);
    };
    
    
    TMUILabel *label1 = [TMUILabel new];
    label1.text = @"可设置contentinsets";
    label1.backgroundColor = UIColor.tmui_randomColor;
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@100);
        make.top.mas_equalTo(@300);
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@100);
    }];
    
    // set
    label1.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 50, 0);
}


@end
