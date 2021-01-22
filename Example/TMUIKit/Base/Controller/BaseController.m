//
//  BaseController.m
//  MyApp
//
//  Created by Jason on 2018/5/28.
//  Copyright © 2018年 Jason. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()

@end

@implementation BaseController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 非主页控制器添加返回按钮    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    // 分类统一处理
    [self cancellWebImageMemory];
}


@end
