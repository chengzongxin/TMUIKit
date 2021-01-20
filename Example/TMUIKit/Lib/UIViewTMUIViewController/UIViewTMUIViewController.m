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
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 222, 100)];
    view.backgroundColor = UIColor.orangeColor;
    [view tmui_addSingerTapWithBlock:^{
        NSLog(@"click view");
    }];
    
    [self.view addSubview:view];
    
    NSLog(@"%d",view.tmui_visible);
    NSLog(@"%@",view.tmui_viewController);
//    NSLog(@"%d",self.view.tmui_isControllerRootView);
    
    
//    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    view2.backgroundColor = UIColor.redColor;
//    [self.view addSubview:view2];
//    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.left.right.top.bottom.equalTo(self.view).inset(100);
//        make.edges.mas_equalTo(UIEdgeInsetsMake(100, 100, 100, 100));
//    }];
}


@end
