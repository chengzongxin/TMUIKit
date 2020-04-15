//
//  ComponentDemoTableVC.m
//  TMUIKitDemo
//
//  Created by nigel.ning on 2020/4/15.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "ComponentDemoTableVC.h"

@interface ComponentDemoTableVC ()
@property (nonatomic, strong)NSArray<NSString*> *dataSource;
@end

@implementation ComponentDemoTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
}

- (void)initDataSource {
    self.dataSource = @[
        NSStringFromClass([TMContentAlert class]),
    ];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"测试组件：%@", self.dataSource[indexPath.item]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *name = self.dataSource[indexPath.item];
    NSString *testVcClassStr = [NSString stringWithFormat:@"TestFor%@", name];
    Class cls = NSClassFromString(testVcClassStr);
    if (cls) {
        UIViewController *vc = [[[cls class] alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        NSLog(@"未发现测试vc for 组件： %@", name);
    }
}

@end
