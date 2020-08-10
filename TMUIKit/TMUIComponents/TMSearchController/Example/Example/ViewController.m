//
//  ViewController.m
//  Example
//
//  Created by nigel.ning on 2020/4/14.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "ViewController.h"
#import "ListVc.h"
#import "SearchBarUIDemoVc.h"
#import "NormalVc.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCell"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"searchBar UI 样式";
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = @"自定义searchController交互效果";
        cell.detailTextLabel.text = @"带导航的tableviewHeader一般用法";
    }else if (indexPath.row == 2) {
        cell.textLabel.text = @"自定义searchController交互效果";
        cell.detailTextLabel.text = @"带导航的普通vc自定义位置用法";
    }else if (indexPath.row == 3) {
        cell.textLabel.text = @"自定义searchController交互效果";
        cell.detailTextLabel.text = @"无导航的普通vc自定义位置用法";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        SearchBarUIDemoVc *vc = [[SearchBarUIDemoVc alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1) {
        ListVc *vc = [[ListVc alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2) {
        NormalVc *vc = [[NormalVc alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3) {
        NormalVc *vc = [[NormalVc alloc] init];
        vc.navBarShouldHide = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
