//
//  TMUITableViewController1.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/18.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUITableViewController1.h"
#import <TMUIComponents/TMUITableView.h>
#import <TMUIComponents/TMUITableViewCell.h>
#import <TMUIComponents/TMUITableViewHeaderFooterView.h>

@interface TMUITableViewController1 ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@end


@implementation TMUITableViewController1

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"普通 cell";
    } else if (section == 1) {
        return @"使用 imageEdgeInsets";
    } else if (section == 2) {
        return @"使用 textLabelEdgeInsets";
    } else if (section == 3) {
        return @"使用 detailTextLabelEdgeInsets";
    } else if (section == 4) {
        return @"使用 accessoryEdgeInsets";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.imageView.image = [UIImage tmui_imageWithShape:TMUIImageShapeOval size:CGSizeMake(16, 16) tintColor:[UIColor tmui_randomColor]];
        cell.textLabel.text = NSStringFromClass([TMUITableViewCell class]);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // reset
    cell.imageEdgeInsets = UIEdgeInsetsZero;
    cell.textLabelEdgeInsets = UIEdgeInsetsZero;
    cell.detailTextLabelEdgeInsets = UIEdgeInsetsZero;
    cell.accessoryEdgeInsets = UIEdgeInsetsZero;
    
    if (indexPath.section == 0) {
        cell.detailTextLabel.text = nil;
    } else if (indexPath.section == 1) {
        cell.detailTextLabel.text = @"imageEdgeInsets";
        cell.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    } else if (indexPath.section == 2) {
        cell.detailTextLabel.text = @"textLabelEdgeInsets";
        cell.textLabelEdgeInsets = UIEdgeInsetsMake(-6, 30, 0, 0);
    } else if (indexPath.section == 3) {
        cell.detailTextLabel.text = @"detailTextLabelEdgeInsets";
        cell.detailTextLabelEdgeInsets = UIEdgeInsetsMake(6, 30, 0, 0);
    } else if (indexPath.section == 4) {
        cell.detailTextLabel.text = @"accessoryEdgeInsets, accessoryEdgeInsets, accessoryEdgeInsets, accessoryEdgeInsets, accessoryEdgeInsets, accessoryEdgeInsets";
        cell.accessoryEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 32);
    }
//    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44 + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
