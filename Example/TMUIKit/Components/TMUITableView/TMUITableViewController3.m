//
//  TMUITableViewController3.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/18.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUITableViewController3.h"
#import <TMUITableViewCell.h>

@interface TMUITableViewController3 ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, copy) NSArray<NSString *> *dataSource;
@end

@implementation TMUITableViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = @[@"UITableViewCellAccessoryNone",
                        @"UITableViewCellAccessoryDisclosureIndicator",
                        @"UITableViewCellAccessoryDetailDisclosureButton",
                        @"UITableViewCellAccessoryCheckmark",
                        @"UITableViewCellAccessoryDetailButton"];
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    TMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TMUITableViewCell alloc] initForTableView:tableView withReuseIdentifier:identifier];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.accessoryType = (UITableViewCellAccessoryType)indexPath.row;
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    Log(indexPath);
//    [TMUITips showWithText:[NSString stringWithFormat:@"点击了第 %@ 行的按钮", @(indexPath.row)] inView:self.view hideAfterDelay:1.2];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.tmui_randomColor;
    }
    return _tableView;
}

@end
