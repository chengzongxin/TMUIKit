//
//  TMUIMenuVIewController.m
//  TMUIKit_Example
//
//  Created by 熊熙 on 2022/4/25.
//  Copyright © 2022 chengzongxin. All rights reserved.
//

#import "TMUIMenuViewController.h"
#import "TMUIMenuView.h"

@interface TMUIMenuViewController ()<TMUIMenuViewDelegate>

@end

@implementation TMUIMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(50, 50, 30, 30);
    [btn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnDown
{
    //@[@"item_school.png", @"item_battle.png", @"item_list.png", @"item_chat.png", @"item_share.png"]
    TMUIMenuView *menu = [[TMUIMenuView alloc] initWithTitleArray:@[@"附近学校", @"联赛流程", @"其他联赛", @"校内群聊", @"邀请好友"] imageArray:@[@"item_school.png", @"item_battle.png", @"item_list.png", @"item_chat.png", @"item_share.png"] origin:CGPointMake(50, 80) width:125 rowHeight:22 Direct:TMUILeftTriangle];
    menu.delegate = self;
    [self.view addSubview:menu];
}


- (void)MenuItemDidSelected:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
