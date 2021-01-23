//
//  TMTextViewViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/23.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMTextViewViewController.h"

@interface TMTextViewViewController ()

@end

@implementation TMTextViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TMTextView *textView = [[TMTextView alloc] init];
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@100);
        make.top.mas_equalTo(@100);
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@100);
    }];
}


@end
