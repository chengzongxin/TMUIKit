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
    // 注意这里的段落必须用NSLineBreakByWordWrapping，否则不会计算换行
    NSParagraphStyle *style = [NSMutableParagraphStyle tmui_paragraphStyleWithLineSpacing:10 lineBreakMode:NSLineBreakByWordWrapping];
    
    TMUIFoldLabel *label0 = [[TMUIFoldLabel alloc] init];
    label0.numberOfLines = 0;
    label0.attributedText = [[NSAttributedString alloc] initWithString:[self contentStr] attributes:@{NSFontAttributeName:UIFont(12),NSParagraphStyleAttributeName:style}];
    [self.view addSubview:label0];
    
    TMUIFoldLabel *label1 = [[TMUIFoldLabel alloc] init];
    label1.numberOfLines = 1;
    label1.attributedText = [[NSAttributedString alloc] initWithString:[self contentStr] attributes:@{NSFontAttributeName:UIFont(18),NSParagraphStyleAttributeName:style}];
    [self.view addSubview:label1];
    
    TMUIFoldLabel *label2 = [[TMUIFoldLabel alloc] init];
    label2.numberOfLines = 2;
    label2.attributedText = [[NSAttributedString alloc] initWithString:[self contentStr] attributes:@{NSFontAttributeName:UIFont(16),NSParagraphStyleAttributeName:style}];
    [self.view addSubview:label2];
    
    TMUIFoldLabel *label3 = [[TMUIFoldLabel alloc] init];
    label3.numberOfLines = 3;
    label3.attributedText = [[NSAttributedString alloc] initWithString:[self contentStr] attributes:@{NSFontAttributeName:UIFont(14),NSParagraphStyleAttributeName:style}];
    [self.view addSubview:label3];
    
    TMUIFoldLabel *label4 = [[TMUIFoldLabel alloc] init];
    label4.numberOfLines = 4;
    label4.attributedText = [[NSAttributedString alloc] initWithString:[self contentStr] attributes:@{NSFontAttributeName:UIFont(12),NSParagraphStyleAttributeName:style}];
    [self.view addSubview:label4];
    
    [label0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NavigationContentTop + 20);
        make.left.right.mas_equalTo(0);
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label0.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
    }];
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
    }];
    
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label3.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
    }];
}


- (NSString *)contentStr {
    NSString *str = @"最新入驻的三家公司，在样式上logo外围增加一个圈，同时五家装修公司都增加new最新入驻的三家公司，在样式上logo外围增加一个圈，同时五家装修公司都增加new最新入驻的三家公司，在样式上logo外围增加一个圈，同时五家装修公司都增加new";
    return str;
}



@end
