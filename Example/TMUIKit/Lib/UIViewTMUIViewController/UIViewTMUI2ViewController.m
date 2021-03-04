//
//  UIViewTMUI2ViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/2/24.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UIViewTMUI2ViewController.h"

@interface UIViewTMUI2ViewController ()

@end

@implementation UIViewTMUI2ViewController

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
    
    NSArray *titles = @[@"none",@"点击",@"双击",@"长按"];
    // 圆角
    [self addSegmentedWithTop:520 labelText:@"手势类型" titles:titles click:^(NSInteger index) {
        
        for (UIGestureRecognizer *ges in view.gestureRecognizers) {
            [view removeGestureRecognizer:ges];
        }
        switch (index) {
            case 1:{
                [view tmui_addSingerTapWithBlock:^{
                    [TMToast toast:titles[index]];
                }];
            }
                break;
            case 2:{
                [view tmui_addDoubleTapWithBlock:^{
                    [TMToast toast:titles[index]];
                }];
            }
                break;
            case 3:{
                [view tmui_addLongPressGestureWithMinimumPressDuration:0.5 stateBegin:^{
                    [TMToast toast:titles[index]];
                } stateEnd:^{
                    
                }];
            }
                break;
                
            default:
                break;
        }
        
    }];
    
}


@end
