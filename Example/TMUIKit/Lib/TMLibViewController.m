//
//  TMLibViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/19.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMLibViewController.h"


@interface TMLibViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *datas;

@end

@implementation TMLibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _datas = @[
        @{@"sections":@"UIView+TMUI",
          @"rows":@[
                  @{
                      @"rowTitle":@"123",
                      @"class":@"UIViewTMUIViewController"
                  },
                  @{
                      @"rowTitle":@"456",
                      @"class":@"UIViewTMUIViewController"
                  },
                  @{
                      @"rowTitle":@"789",
                      @"class":@"UIViewTMUIViewController"
                  }
          ]},
        @{@"sections":@"UIButton+TMUI",
          @"rows":@[
                  @{
                      @"rowTitle":@"123",
                      @"class":@"UIButtonTMUIViewController"
                  }
          ]},
        @{@"sections":@"UILable+TMUI",
          @"rows":@[
                  @{
                      @"rowTitle":@"123",
                      @"class":@"UILabelTMUIViewController"
                  }
          ]},
    ];
    
    
//    _datas = @[
//        @{@"title":@"分类:UIView+TMUI",@"class":@"UIViewTMUIViewController"},
//        @{@"title":@"分类:UIButton+TMUI",@"class":@"UIButtonTMUIViewController"},
//        @{@"title":@"分类:UILable+TMUI",@"class":@"UILabelTMUIViewController"}
//    ];
    
    [self.view addSubview:self.tableView];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_datas[section][@"rows"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _datas[section][@"sections"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    
    NSDictionary *dict = _datas[indexPath.section][@"rows"][indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.textLabel.text = dict[@"rowTitle"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = _datas[indexPath.section][@"rows"][indexPath.row];
    Class class = NSClassFromString(dict[@"class"]);
    UIViewController *vc = [[class alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
