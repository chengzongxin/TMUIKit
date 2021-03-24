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
#import "ChainUIViewController1.h"
#import "TMUITableViewController.h"
#import "TMUIAlertViewController.h"

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
                    
                    Row.str(@"TMUITableView").fnt(18).detailStr(@"多样式UITableView").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TMUITableViewController.class];
                        }),
                    ).title(@"TMUI Components"),
            Section(
                    Row.str(@"TMContentAlert").fnt(18).detailStr(@"TMContentAlert").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TMUIAlertViewController.class];
                        }),
                    ).title(@"TMUI Alert"),
            Section(
                    Row.str(@"ChainUI").fnt(18).detailStr(@"链式UI功能Demo").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:ChainUIViewController.class];
                        }),
                    Row.str(@"ChainUI").fnt(18).detailStr(@"链式UI常用方法").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:ChainUIViewController1.class];
                        }),
                    ).title(@"TMUI ChainUI"),
            
            ).embedIn(self.view);
}

@end
