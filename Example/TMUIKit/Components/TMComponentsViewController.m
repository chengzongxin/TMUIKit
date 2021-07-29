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

#define THEME_CELL fnt(18).subtitleStyle.cellHeightAuto.color(UIColor.td_mainTextColor).detailColor(UIColor.td_descriptionTextColor)

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
                    Row.str(@"TMUITheme").detailStr(@"主题管理").THEME_CELL.onClick(^{
                            [self push:TDThemeViewController.class];
                        }),
                    Row.str(@"TMUIModalPresentationViewController").detailStr(@"各种自定义弹窗").THEME_CELL.onClick(^{
                            [self push:TDModalPresentationViewController.class];
                        }),
                    Row.str(@"TMUITableView").detailStr(@"多样式UITableView").THEME_CELL.onClick(^{
                            [self push:TMUITableViewController.class];
                        }),
                    Row.str(@"TMUIBadge").detailStr(@"一行代码添加badge").THEME_CELL.onClick(^{
                            [self push:TMUIBadgeViewController.class];
                        }),
                    Row.str(@"TMUIMultipleDelegates").detailStr(@"让对象支持多个delegate、支持自定义的delegate").THEME_CELL.onClick(^{
                            [self push:TMUICoreViewController6.class];
                        }),
                    Row.str(@"TMPageViewController").detailStr(@"简单代理实现滑动吸顶header，动态tab子VC").THEME_CELL.onClick(^{
                            [self push:TMPageRootViewController.class];
                        }),
                    ).title(@"TMUI Components"),
            Section(
                    Row.str(@"TMContentAlert").detailStr(@"TMContentAlert").THEME_CELL.onClick(^{
                            [self push:TMUIAlertViewController.class];
                        }),
                    Row.str(@"TMPopoverView").detailStr(@"弹窗popover view").THEME_CELL.onClick(^{
                            [self push:TMPopoverViewController.class];
                        }),
                    ).title(@"TMUI Alert"),
            Section(
                    Row.str(@"ChainUI").detailStr(@"链式UI功能Demo").THEME_CELL.onClick(^{
                            [self push:ChainUIViewController.class];
                        }),
                    Row.str(@"ChainUI").detailStr(@"链式UI常用方法").THEME_CELL.onClick(^{
                            [self push:ChainUIViewController1.class];
                        }),
                    Row.str(@"ChainUI").detailStr(@"链式Style全局配置").THEME_CELL.onClick(^{
                            [self push:ChainStyleConfigViewController.class];
                        }),
                    ).title(@"TMUI ChainUI"),
            
            ).embedIn(self.view);
}

@end
