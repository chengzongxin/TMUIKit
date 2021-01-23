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
    
    [self cornerViewTest];
    
    [self shadowGradientViewTest];
}

- (void)cornerViewTest{
    
    UIView *cornerView = [[UIView alloc] init];
    cornerView.backgroundColor = UIColor.orangeColor;
    [cornerView tmui_addSingerTapWithBlock:^{
        NSLog(@"click view");
    }];
    
    [self.view addSubview:cornerView];
    [cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(200, 100));
    }];
    
    NSLog(@"%d",cornerView.tmui_visible);
    NSLog(@"%@",cornerView.tmui_viewController);
    
    
    [self addSegmentedWithLabelText:@"设置圆角:" titles:@[@"none",@"TopLeft",@"TopRight",@"BottomLeft",@"BottomRight",@"LeftRight"] click:^(NSInteger index) {
        [cornerView tmui_cornerDirect:index radius:20];
    }];
        
    [self addSegmentedWithLabelText:@"动画:" titles:@[@"none",@"渐显",@"渐隐",@"逐渐放大",@"逐渐放大",@"从顶部出现",@"从顶部移除",@"从底部出现",@"从底部移除"] click:^(NSInteger index) {
        [cornerView tmui_animateWithDuration:2 animationType:index completion:^(BOOL finished) {
            NSLog(@"animate finish");
        }];
    }];
}

- (void)shadowGradientViewTest{
    
    UIView *shadowGradientView = [[UIView alloc] init];
    [self.view addSubview:shadowGradientView];
    [shadowGradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(300);
        make.size.mas_equalTo(CGSizeMake(200, 100));
    }];
    shadowGradientView.backgroundColor = UIColor.orangeColor;
    shadowGradientView.layer.cornerRadius = 10;
    
    [shadowGradientView tmui_shadowColor:UIColor.grayColor opacity:0.5 offsetSize:CGSizeMake(10, 10) corner:5];
    
    [shadowGradientView tmui_gradientLeftToRightWithStartColor:UIColor.redColor endColor:UIColor.greenColor];
    
    UIView *shadowGradientView1 = [[UIView alloc] init];
    [self.view addSubview:shadowGradientView1];
    [shadowGradientView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(500);
        make.size.mas_equalTo(CGSizeMake(200, 100));
    }];
    shadowGradientView1.layer.cornerRadius = 10;
    
    shadowGradientView1.backgroundColor = UIColor.orangeColor;
    
    [shadowGradientView1 tmui_shadowColor:UIColor.grayColor opacity:0.5 offsetSize:CGSizeMake(10, 10) corner:5];
    
    [shadowGradientView1 tmui_gradientUpToDownWithStartColorToDown:UIColor.redColor endColor:UIColor.greenColor];
    
}


@end
