//
//  Table2ViewController.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/27.
//

#import "Table2ViewController.h"
#import <MJRefresh.h>

@interface Table2ViewController ()
@property (nonatomic, assign) NSInteger count;
@end

@implementation Table2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.count = 20;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"ddddd");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.count += 20;
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        });
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"123323");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.count += 20;
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        });
    }];
    self.tableView.tmui_isAddRefreshControl = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.count;
}




@end
