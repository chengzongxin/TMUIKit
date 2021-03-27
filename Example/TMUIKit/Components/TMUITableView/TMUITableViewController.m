//
//  TMUITableViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/18.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUITableViewController.h"
#import "TMUITableViewController1.h"
#import "TMUITableViewController2.h"
#import "TMUITableViewController3.h"
#import "TMUITableViewController4.h"
#import "TMUITableViewController5.h"
#import "TMUITableViewController6.h"
#import "TMUITableViewController7.h"

@interface TMUITableViewController ()

@end


@implementation TMUITableViewController

- (void)push:(Class)vcClass{
    UIViewController *vc = [[vcClass alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    GroupTV(
            Section(
                    Row.str(@"TMUITableViewController1").fnt(18).detailStr(@"通过 insets 系列属性调整间距").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TMUITableViewController1.class];
                        }),
                    Row.str(@"TMUITableViewController2").fnt(18).detailStr(@"通过 block 调整分隔线位置").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TMUITableViewController2.class];
                        }),
                    Row.str(@"TMUITableViewController3").fnt(18).detailStr(@"通过修改配置表 accessoryType 样式").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TMUITableViewController3.class];
                        }),
                    Row.str(@"TMUITableViewController4").fnt(18).detailStr(@"TMUITableViewHeaderFooterView").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TMUITableViewController4.class];
                        }),
                    Row.str(@"TMUITableViewController5").fnt(18).detailStr(@"Inset Group 自适应高度").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TMUITableViewController5.class];
                        }),
                    Row.str(@"TMUITableViewController6").fnt(18).detailStr(@"缓存行高").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TMUITableViewController6.class];
                        }),
                    Row.str(@"TMUITableViewController7").fnt(18).detailStr(@"自定义cell 缓存行高 autolayout布局").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TMUITableViewController7.class];
                        }),
                    ).title(@"TableView Components")
            ).embedIn(self.view);
}

@end
