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

@property (nonatomic, strong) TMUIMenuViewConfig *config;

@end

@implementation TMUIMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(300, 100, 30, 30);
    [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnDown:(UIButton *)button
{
    //@[@"item_school.png", @"item_battle.png", @"item_list.png", @"item_chat.png", @"item_share.png"]
//    TMUIMenuView *menu = [[TMUIMenuView alloc] initWithTitleArray:@[@"附近学校", @"联赛流程", @"其他联赛", @"校内群聊", @"邀请好友"] imageArray:@[@"item_school.png", @"item_battle.png", @"item_list.png", @"item_chat.png", @"item_share.png"] origin:CGPointMake(50, 120) width:125 rowHeight:22 Direct:TMUILeftTriangle];
//    menu.delegate = self;
    
    NSArray *titles =  @[@"附近学校",@"邀请好友",@"校内群聊",];
    
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    CGRect frame = [button convertRect:self.navigationController.view.bounds toView:nil];
    
    
    NSMutableArray *menuItems = [NSMutableArray arrayWithCapacity:0];
    
    TMUIMenuItemModel *nearbyItem = [[TMUIMenuItemModel alloc] init];
    nearbyItem.title = @"附近学校";
    nearbyItem.imageName = @"item_school.png";
    nearbyItem.onTapItemCallback = ^(id  _Nonnull sender, NSInteger index) {
        NSString *title = [titles tmui_safeObjectAtIndex:index];
        NSLog(@"点击index:%ld title:%@",(long)index,title);
    };
    
    TMUIMenuItemModel *inviteItem = [[TMUIMenuItemModel alloc] init];
    inviteItem.title = @"邀请好友";
    inviteItem.imageName = @"item_share.png";
    inviteItem.onTapItemCallback = ^(id  _Nonnull sender, NSInteger index) {
        NSString *title = [titles tmui_safeObjectAtIndex:index];
        NSLog(@"点击index:%ld title:%@",(long)index,title);
    };
    
    TMUIMenuItemModel *chatItem = [[TMUIMenuItemModel alloc] init];
    chatItem.title = @"校内群聊";
    chatItem.imageName = @"item_school.png";
    chatItem.onTapItemCallback = ^(id  _Nonnull sender, NSInteger index) {
        NSString *title = [titles tmui_safeObjectAtIndex:index];
        NSLog(@"点击index:%ld title:%@",(long)index,title);
    };
    
    [menuItems addObject:nearbyItem];
    [menuItems addObject:inviteItem];
    [menuItems addObject:chatItem];
    
    
    self.config.menuOrigin = CGPointMake(frame.origin.x, frame.origin.y+20);
    
    TMUIMenuView *menu1 = [[TMUIMenuView alloc] initWithMenuItems:menuItems MenuConfig:self.config];
    
    //[self.view addSubview:menu1];
    
    
    [TMUIMenuView popupMenuOnView:self.view fromView:button WithItems:menuItems];
    
    
}

- (TMUIMenuViewConfig *)config {
    if(!_config) {
        _config = [[TMUIMenuViewConfig alloc] init];
        _config.menuWidth = 125;
        _config.rowHeight = 22;
        _config.triDirect = TMUIRightTriangle;
    }
    return _config;
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
