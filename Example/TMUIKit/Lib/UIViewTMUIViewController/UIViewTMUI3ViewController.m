//
//  UIViewTMUI3ViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/2/24.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UIViewTMUI3ViewController.h"

@interface UIViewTMUI3ViewController ()

@end

@implementation UIViewTMUI3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    NSArray *titles1 = @[@"none",@"渐显",@"渐隐",@"逐渐放大",@"逐渐放大"] ;
    // 圆角
    
    [self addSegmentedWithTop:520 labelText:@"动画:" titles:titles1 click:^(NSInteger index) {
        [view tmui_animateWithDuration:2 animationType:index completion:^(BOOL finished) {
            NSLog(@"animate finish");
            view.transform = CGAffineTransformIdentity;
            view.alpha = 1;
        }];
    }];
    
    NSArray *titles2 = @[@"从顶部出现",@"从顶部移除",@"从底部出现",@"从底部移除"] ;
    // 圆角
    
    [self addSegmentedWithTop:570 labelText:@"动画:" titles:titles2 click:^(NSInteger index) {
        [view tmui_animateWithDuration:2 animationType:index+5 completion:^(BOOL finished) {
            NSLog(@"animate finish");
            view.transform = CGAffineTransformIdentity;
            view.alpha = 1;
        }];
    }];
}

@end
