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
#import "TMPopoverViewController.h"
#import "ChainStyleConfigViewController.h"
#import "TMUIBadgeViewController.h"
#import "TMUICoreViewController6.h"
#import "TDThemeViewController.h"
#import "TDModalPresentationViewController.h"

@interface TMComponentsViewController ()

@end

@implementation TMComponentsViewController

- (void)push:(Class)vcClass{
    UIViewController *vc = [[vcClass alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GroupTV(
            Section(
                    Row.str(@"TMUITheme").fnt(18).detailStr(@"主题管理").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TDThemeViewController.class];
                        }),
                    Row.str(@"TMUIModalPresentationViewController").fnt(18).detailStr(@"各种自定义弹窗").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TDModalPresentationViewController.class];
                        }),
                    Row.str(@"TMUITableView").fnt(18).detailStr(@"多样式UITableView").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TMUITableViewController.class];
                        }),
                    Row.str(@"TMUIBadge").fnt(18).detailStr(@"一行代码添加badge").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TMUIBadgeViewController.class];
                        }),
                    Row.str(@"TMUIMultipleDelegates").fnt(18).detailStr(@"让对象支持多个delegate、支持自定义的delegate").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TMUICoreViewController6.class];
                        }),
                    Row.str(@"TMPageViewController").fnt(18).detailStr(@"简单代理实现滑动吸顶header，动态tab子VC").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TMPageRootViewController.class];
                        }),
                    ).title(@"TMUI Components"),
            Section(
                    Row.str(@"TMContentAlert").fnt(18).detailStr(@"TMContentAlert").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TMUIAlertViewController.class];
                        }),
                    Row.str(@"TMPopoverView").fnt(18).detailStr(@"弹窗popover view").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TMPopoverViewController.class];
                        }),
                    ).title(@"TMUI Alert"),
            Section(
                    Row.str(@"ChainUI").fnt(18).detailStr(@"链式UI功能Demo").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:ChainUIViewController.class];
                        }),
                    Row.str(@"ChainUI").fnt(18).detailStr(@"链式UI常用方法").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:ChainUIViewController1.class];
                        }),
                    Row.str(@"ChainUI").fnt(18).detailStr(@"链式Style全局配置").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:ChainStyleConfigViewController.class];
                        }),
                    ).title(@"TMUI ChainUI"),
            
            ).embedIn(self.view);
}

@end
