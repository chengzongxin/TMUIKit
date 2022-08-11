//
//  TMFoundationViewController.m
//  TMUIKit_Example
//
//  Created by cl w on 2021/2/1.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMFoundationViewController.h"
#import "TDAllSystemFontViewController.h"
@interface TMFoundationViewController ()

@end

@implementation TMFoundationViewController
{
    NSArray *_datas;
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GroupTV(
            SECTION_CREATE(
                           ROW_CREATE(@"Font 字体",
                                      @"针对在类型里添加属性的相关便捷宏定义",
                                      @"TDAllSystemFontViewController"),
                           ).THEME_TITLE(@"TMUI Foundataion"),
            ).embedIn(self.view);
}


@end
