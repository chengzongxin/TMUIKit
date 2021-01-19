//
//  TMUIKitViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/19.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUIKitViewController.h"
#import <TMUIKit.h>
#import <Masonry.h>

@interface TMUIKitViewController ()

@end

@implementation TMUIKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    TMButton *button = [[TMButton alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    button.backgroundColor = UIColor.orangeColor;
    [self.view addSubview:button];
    
    [button log123];
    
    TMButton *button2 = [[TMButton alloc] init];
    button2.backgroundColor = UIColor.orangeColor;
    [self.view addSubview:button2];
    
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@100);
        make.top.equalTo(button.mas_bottom).inset(100);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
