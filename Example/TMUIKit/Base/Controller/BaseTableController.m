//
//  BaseTableController.m
//  MyApp
//
//  Created by Jason on 2018/5/28.
//  Copyright © 2018年 Jason. All rights reserved.
//

#import "BaseTableController.h"
#import "UIViewController+Base.h"

@interface BaseTableController ()

@end

@implementation BaseTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 非主页控制器添加返回按钮
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // 分类统一处理
    [self cancellWebImageMemory];
}

@end
