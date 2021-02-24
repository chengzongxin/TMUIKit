//
//  UIViewTMUIViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/20.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UIViewTMUIViewController.h"
#import <Masonry.h>

@interface UIViewTMUIViewController ()

@end

@implementation UIViewTMUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self demo1];
}

- (void)demo1{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColor.tmui_randomColor;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(-100);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    
    NSMutableArray *titles = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [titles addObject:@(i).stringValue];
    }
    // 圆角
    [self addSegmentedWithTop:520 labelText:@"设置圆角" titles:titles click:^(NSInteger index) {
        [view tmui_cornerDirect:index radius:20];
    }];
    // 阴影
    [self addSegmentedWithTop:570 labelText:@"设置阴影" titles:titles click:^(NSInteger index) {
        [view tmui_shadowColor:UIColor.tmui_randomColor opacity:1.0 offsetSize:CGSizeMake(index, index) corner:index*1.0];
    }];
    // 渐变
    [self addSegmentedWithTop:620 labelText:@"设置渐变" titles:titles click:^(NSInteger index) {
        [view tmui_gradientWithColors:@[UIColor.tmui_randomColor,UIColor.tmui_randomColor] gradientType:index];
    }];
    // 边框
    [self addSegmentedWithTop:670 labelText:@"设置边框" titles:titles click:^(NSInteger index) {
        [view tmui_border:UIColor.tmui_randomColor width:index type:index];
    }];
}


@end
