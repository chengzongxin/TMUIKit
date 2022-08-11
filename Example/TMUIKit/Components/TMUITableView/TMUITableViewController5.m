//
//  TMUITableViewController5.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/18.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUITableViewController5.h"

@interface TMUITableViewController5 ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray<NSString *> *texts;
@end

@implementation TMUITableViewController5

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.texts = @[
        @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。",
        @"UIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。",
        @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。\nUIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。\n高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。"
    ];
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem tmui_itemWithImage:UIImageMake(@"icon_nav_about") target:self action:@selector(handleDebugItemEvent)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem tmui_itemWithTitle:@"切换间距" target:self action:@selector(handleDebugItemEvent)];
    
    [self.view addSubview:self.tableView];
}


#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    TMUIDynamicHeightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TMUIDynamicHeightTableViewCell alloc] initForTableView:tableView withReuseIdentifier:identifier];
    }
    [cell renderWithNameText:[NSString stringWithFormat:@"%@ - %@", @(indexPath.section), @(indexPath.row)] contentText:self.texts[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Section Header %@", @(section)];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Section Footer %@", @(section)];
}


- (void)handleDebugItemEvent {
    self.tableView.tmui_insetGroupedCornerRadius += 5;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:TMUITableViewStyleInsetGrouped];
        _tableView.tmui_insetGroupedCornerRadius = 12;
        _tableView.tmui_insetGroupedHorizontalInset = 20;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorHexString(@"EEEEEE");
    }
    return _tableView;
}


@end
