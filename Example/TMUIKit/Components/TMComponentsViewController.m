//
//  TMComponentsViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/19.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMComponentsViewController.h"

@interface TMComponentsViewController ()

@end

@implementation TMComponentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [TMToast toast:@"123123"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [TMToast toastScore:123 content:@"333"];
}

@end
