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
    
    Label.str(self.demoInstructions).styles(h1).addTo(self.view).makeCons(^{
        make.top.left.constants(NavigationContentTop+20,20);
    });
    
    
    TMUILabel *label = [[TMUILabel alloc] init];
    [self.view addSubview:label];
    label.text = @"label1：可长按复制";
    label.backgroundColor = UIColor.grayColor;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@50);
        make.top.mas_equalTo(@200);
        make.width.mas_equalTo(@300);
        make.height.mas_equalTo(@100);
    }];
    
    // set
    label.canPerformCopyAction = YES;
    label.didCopyBlock = ^(TMUILabel * _Nonnull label, NSString * _Nonnull stringCopied) {
        NSLog(@"%@",stringCopied);
    };
    
    
    TMUILabel *label1 = [TMUILabel new];
    label1.text = @"label2：可设置contentEdgeInsets";
    label1.backgroundColor = UIColor.grayColor;
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@50);
        make.top.mas_equalTo(@350);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(@100);
    }];
    
    
    [self addSliderWithTop:500 labelText:@"↑ (上缩进)" slide:^(float padding) {
        label1.contentEdgeInsets = UIEdgeInsetsSetTop(label1.contentEdgeInsets, padding);
    }];
    
    [self addSliderWithTop:550 labelText:@"← (左缩进)" slide:^(float padding) {
        label1.contentEdgeInsets = UIEdgeInsetsSetLeft(label1.contentEdgeInsets, padding);
    }];
    
    [self addSliderWithTop:600 labelText:@"↓ (下缩进)" slide:^(float padding) {
        label1.contentEdgeInsets = UIEdgeInsetsSetBottom(label1.contentEdgeInsets, padding);
    }];
    
    [self addSliderWithTop:650 labelText:@"→ (右缩进)" slide:^(float padding) {
        label1.contentEdgeInsets = UIEdgeInsetsSetRight(label1.contentEdgeInsets, padding);
    }];
}


@end
