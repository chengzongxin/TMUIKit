//
//  TMButtonViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/20.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUIButtonViewController.h"

@interface TMUIButtonViewController ()

@property (nonatomic, strong) TMUIButton *btn;

@end

@implementation TMUIButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    TMUIButton *btn = [[TMUIButton alloc] initWithFrame:CGRectMake(100, 100, 220, 300)];
    btn.backgroundColor = UIColor.orangeColor;
    [self.view addSubview: btn];
    [btn setImage:[UIImage imageNamed:@"icon_moreOperation_shareWeibo"] forState:UIControlStateNormal];
    [btn setTitle:@"ssss" forState:UIControlStateNormal];
    _btn = btn;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSInteger type = _btn.imagePosition;
    CGFloat interval = _btn.spacingBetweenImageAndTitle;
    type ++;
    if (type > 3) {
        type = 0;
    }
    interval += 10;
    if (interval > 100) {
        interval = 0;
    }
    _btn.imagePosition = type;
    _btn.spacingBetweenImageAndTitle = interval;
}


@end
