//
//  TMViewController.m
//  TMUIKit
//
//  Created by chengzongxin on 01/19/2021.
//  Copyright (c) 2021 chengzongxin. All rights reserved.
//

#import "TMViewController.h"
#import <TMUIKit.h>
@interface TMViewController ()

@end

@implementation TMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    TMButton *button = [[TMButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    button.backgroundColor = UIColor.orangeColor;
    [self.view addSubview:button];
    
    [button log];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
@end
