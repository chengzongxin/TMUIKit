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
    
    [self demo2];
}

- (void)demo1{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColor.tmui_randomColor;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(200);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    
    NSMutableArray *titles = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [titles addObject:@(i).stringValue];
    }
    // 圆角
    [self addSegmentedWithTop:320 labelText:@"设置圆角" titles:titles click:^(NSInteger index) {
        [view tmui_cornerRadius:(index+1)*5];
    }];
    // 阴影
    [self addSegmentedWithTop:370 labelText:@"设置阴影" titles:titles click:^(NSInteger index) {
        [view tmui_shadowColor:UIColor.tmui_randomColor opacity:1.0 offsetSize:CGSizeMake(index, index) corner:index*1.0];
    }];
    // 渐变
    /*
     TMUIGradientTypeLeftToRight,
     TMUIGradientTypeTopLeftToBottomRight,
     TMUIGradientTypeTopToBottom,
     TMUIGradientTypeTopRightToBottomLeft,
     TMUIGradientTypeBottomRightToTopLeft,
     TMUIGradientTypeBottomLeftToTopRight,
     */
    [self addSegmentedWithTop:420 labelText:@"设置渐变" titles:@[@"左-右",@"左上-右下",@"上-下",@"右上-左下"] click:^(NSInteger index) {
        TMUIGradientType type = TMUIGradientTypeLeftToRight;
        switch (index) {
            case 0:
                type = TMUIGradientTypeLeftToRight;
                break;
            case 1:
                type = TMUIGradientTypeTopLeftToBottomRight;
                break;
            case 2:
                type = TMUIGradientTypeTopToBottom;
                break;
            case 3:
                type = TMUIGradientTypeTopRightToBottomLeft;
                break;
        }
        [view tmui_gradientWithColors:@[UIColor.tmui_randomColor,UIColor.tmui_randomColor] gradientType:type];
    }];
    // 边框
    /*
     UIRectEdgeNone   = 0,
     UIRectEdgeTop    = 1 << 0,
     UIRectEdgeLeft   = 1 << 1,
     UIRectEdgeBottom = 1 << 2,
     UIRectEdgeRight  = 1 << 3,
     UIRectEdgeAll    = UIRectEdgeTop | UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight
     */
    [self addSegmentedWithTop:470 labelText:@"设置边框" titles:@[@"全部",@"左",@"右",@"上",@"下"] click:^(NSInteger index) {
        UIRectEdge type = UIRectEdgeNone;
        switch (index) {
            case 0:
                type = UIRectEdgeAll;
                break;
            case 1:
                type = UIRectEdgeLeft;
                break;
            case 2:
                type = UIRectEdgeRight;
                break;
            case 3:
                type = UIRectEdgeTop;
                break;
            case 4:
                type = UIRectEdgeBottom;
                break;
        }
        [view tmui_border:UIColor.tmui_randomColor width:10 type:type];
    }];
}

- (void)demo2{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColor.tmui_randomColor;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(600);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    
    NSMutableArray *titles = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [titles addObject:@(i).stringValue];
    }
    // 圆角
    [self addSegmentedWithTop:750 labelText:@"设置半圆角" titles:titles click:^(NSInteger index) {
        [view tmui_cornerDirect:index radius:50];
        view.layer.shadowPath = [view.layer.mask path];
        [view tmui_shadowColor:UIColor.tmui_randomColor opacity:1 offsetSize:CGSizeMake(10, 10) corner:50];
    }];
}



@end
