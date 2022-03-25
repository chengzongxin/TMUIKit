//
//  TDOneFoldLabelViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2022/3/25.
//  Copyright © 2022 chengzongxin. All rights reserved.
//

#import "TDOneFoldLabelViewController.h"

@interface TDOneFoldLabelViewController ()

@end

@implementation TDOneFoldLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TMUIFoldLabel *label = [[TMUIFoldLabel alloc] init];
    label.attributedText = [[NSAttributedString alloc] initWithString:[self contentStr] attributes:@{NSFontAttributeName:UIFont(12)}];
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NavigationContentTop + 20);
        make.left.right.mas_equalTo(0);
    }];
}


- (NSString *)contentStr {
    NSString *str = @"最新入驻的三家公司，在样式上logo外围增加一个圈，同时五家装修公司都增加new最新入驻的三家公司，在样式上logo外围增加一个圈，同时五家装修公司都增加new最新入驻的三家公司，在样式上logo外围增加一个圈，同时五家装修公司都增加new";
    return str;
}



@end
