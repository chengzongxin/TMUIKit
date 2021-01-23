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
    
    UIView *cornerView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
    cornerView.backgroundColor = UIColor.orangeColor;
    [cornerView tmui_addSingerTapWithBlock:^{
        NSLog(@"click view");
    }];
    
    [self.view addSubview:cornerView];
    
    NSLog(@"%d",cornerView.tmui_visible);
    NSLog(@"%@",cornerView.tmui_viewController);
    
    
    [self addSegmentedWithLabelText:@"设置圆角:" titles:@[@"none",@"TopLeft",@"TopRight",@"BottomLeft",@"BottomRight",@"LeftRight"] click:^(NSInteger index) {
        [cornerView tmui_cornerDirect:index radius:20];
    }];
}

- (void)shadowGradientViewTest{
    
    UIView *shadowGradientView = [[UIView alloc] initWithFrame:CGRectMake(100, 300, 200, 100)];
    [self.view addSubview:shadowGradientView];
    
    shadowGradientView.backgroundColor = UIColor.orangeColor;
    shadowGradientView.layer.cornerRadius = 10;
    
    [shadowGradientView tmui_shadowColor:UIColor.grayColor opacity:0.5 offsetSize:CGSizeMake(10, 10) corner:5];
    
    [shadowGradientView tmui_gradientLeftToRightWithStartColor:UIColor.redColor endColor:UIColor.greenColor];
    
    UIView *shadowGradientView1 = [[UIView alloc] initWithFrame:CGRectMake(100, 500, 200, 100)];
    
    
    [self.view addSubview:shadowGradientView1];
    shadowGradientView1.layer.cornerRadius = 10;
    
    shadowGradientView1.backgroundColor = UIColor.orangeColor;
    
    [shadowGradientView1 tmui_shadowColor:UIColor.grayColor opacity:0.5 offsetSize:CGSizeMake(10, 10) corner:5];
    
    [shadowGradientView1 tmui_gradientUpToDownWithStartColorToDown:UIColor.redColor endColor:UIColor.greenColor];
    
}


@end
