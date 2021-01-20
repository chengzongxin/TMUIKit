//
//  TMButtonViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/20.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMButtonViewController.h"

@interface TMButtonViewController ()

@end

@implementation TMButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    TMButton *btn = [[TMButton alloc] initWithFrame:CGRectMake(100, 100, 100, 300)];
    btn.backgroundColor = UIColor.orangeColor;
    [self.view addSubview: btn];
    
}


@end
