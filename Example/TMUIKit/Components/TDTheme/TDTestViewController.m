//
//  TDTestViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/5/13.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TDTestViewController.h"
#import "TMUIFloatLayoutView.h"

@interface TDTestButton : UIButton

@end

@interface TDTestViewController ()

@end

@implementation TDTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TMUIFloatLayoutView *floatView = [[TMUIFloatLayoutView alloc] init];
    floatView.itemMargins = UIEdgeInsetsMake(10, 10, 5, 10);
    for (int i = 0; i < 5; i++) {
        TDTestButton *btn = [TDTestButton buttonWithType:UIButtonTypeSystem];
        btn.backgroundColor = UIColor.tmui_randomColor;
        btn.frame = CGRectSetSize(btn.frame, CGSizeMake(150, 44));
        [btn setTitle:@(i).stringValue forState:UIControlStateNormal];
        [floatView addSubview:btn];
    }
    [self.view addSubview:floatView];
    UIEdgeInsets paddings = UIEdgeInsetsMake(24, 24 + self.view.tmui_safeAreaInsets.left, 24 + self.view.tmui_safeAreaInsets.bottom, 24 + self.view.tmui_safeAreaInsets.right);
    floatView.frame = CGRectMake(paddings.left, paddings.top + NavigationContentTop, CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(paddings), TMUIViewSelfSizingHeight);
}


@end


@implementation TDTestButton

- (CGSize)sizeThatFits:(CGSize)size{
    return self.frame.size;
}


@end
