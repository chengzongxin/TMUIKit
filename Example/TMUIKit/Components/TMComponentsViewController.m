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
#import "TDThemeGlobalConfig.h"

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
            SECTION_CREATE(
                           ROW_CREATE(@"TMUIButton",
                                      @"设置图片、文字位置、图文间距",
                                      @"TMUIButtonViewController"),
                           ROW_CREATE(@"TMUILabel",
                                      @"控制label内容的padding、设置是否需要长按复制的功能",
                                      @"TMUILabelViewController"),
                           ROW_CREATE(@"TMUITextField",
                                      @"自定义 placeholderColor、支持限制输入的文字的长度、超过时回调、设置TextField内容Inset、clearButton位置偏移",
                                      @"TMUITextFieldViewController"),
                           ROW_CREATE(@"TMUITextView",
                                      @"支持 placeholder 并支持更改 placeholderColor；若使用了富文本文字，则 placeholder 的样式也会跟随文字的样式（除了 placeholder 颜色）、支持在文字发生变化时计算内容高度并通知 delegate、支持限制输入框最大高度，一般配合第 2 点使用、支持限制输入的文本的最大长度，默认不限制、修正系统 UITextView 在输入时自然换行的时候，contentOffset 的滚动位置没有考虑textContainerInset.bottom",
                                      @"TMUITextViewViewController"),
                           ROW_CREATE(@"TMUISlider",
                                      @"修改背后导轨的高度、修改圆点的大小、修改圆点的阴影样式",
                                      @"TMUISliderViewController"),
                           ROW_CREATE(@"TMUISegmentedControl",
                                      @"修改背后导轨的高度、修改圆点的大小、修改圆点的阴影样式",
                                      @"TMUISegmentedControlViewController"),
                           ).title(@"TMUI Widget"),
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
