//
//  TMComponentsViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/19.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMComponentsViewController.h"
#import "TMPageRootViewController.h"
#import "ChainUIViewController.h"


@interface TMComponentsViewController ()

@end

@implementation TMComponentsViewController

- (void)push:(Class)vcClass{
    UIViewController *vc = [[vcClass alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GroupTV(
            Section(
                    Row.str(@"TMPageViewController").fnt(18).detailStr(@"简单代理实现滑动吸顶header，动态tab子VC").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TMPageRootViewController.class];
                        }),
                    Row.str(@"ChainUI").fnt(18).detailStr(@"链式UI").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:ChainUIViewController.class];
                        }),
                    ).title(@"TMUI Components")
            ).embedIn(self.view);
}

@end
