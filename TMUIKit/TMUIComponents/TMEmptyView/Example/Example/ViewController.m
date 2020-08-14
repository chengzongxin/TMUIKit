//
//  ViewController.m
//  Example
//
//  Created by nigel.ning on 2020/4/14.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "ViewController.h"
#import "TestItem.h"
#import "FullPageVc.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray<NSArray<TestItem *> *> *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"空态视图样式展示";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"To全屏" style:UIBarButtonItemStylePlain target:self action:@selector(toFullPageVc)];
    
    NSMutableArray *items0 = [NSMutableArray array];
    NSMutableArray *items1 = [NSMutableArray array];
    for (NSInteger i = 0; i <= TMEmptyContentTypeVideoDetailErr; ++i) {
        [items0 addObject:({
            TestItem *item = [TestItem itemWithType:i];
            item;
        })];
        [items1 addObject:({
            TestItem *item = [TestItem itemWithType:i];
            item;
        })];
    }
    self.dataSource = @[
        items0,
        items1
    ];
}

- (void)toFullPageVc {
    FullPageVc *vc = [[FullPageVc alloc] init];
    vc.dataSource = self.dataSource;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCell"];
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row].title;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"在view上显示";
    }
    return @"在tableview上显示";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        @TMUI_weakify(self);
        [TMEmptyView showEmptyInView:self.view safeMargin:UIEdgeInsetsZero contentType:self.dataSource[indexPath.section][indexPath.row].type clickBlock:^{
            @TMUI_strongify(self);
            [self.view.tmui_emptyView remove];
        }];
    }else {
        @TMUI_weakify(self);
        [TMEmptyView showEmptyInView:self.tableView safeMargin:UIEdgeInsetsMake(30, 20, 0, 30) contentType:self.dataSource[indexPath.section][indexPath.row].type clickBlock:^{
            @TMUI_strongify(self);
            [self.tableView.tmui_emptyView remove];
        }];
    }
    
}

@end
