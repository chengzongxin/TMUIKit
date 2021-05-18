//
//  TMFoundationViewController.m
//  TMUIKit_Example
//
//  Created by cl w on 2021/2/1.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMFoundationViewController.h"

@interface TMFoundationViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TMFoundationViewController
{
    NSArray *_datas;
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _datas = @[
    @{@"title":@"NSString",
      @"sectionTitles":
        @[@{@"title":@"NSString+MD5",@"desc":@"md5",@"class":@"MD5VC"},
        @{@"title":@"NSString+Verify",@"desc":@"校验",@"class":@"VerifyViewController"},
        @{@"title":@"NSString+Format",@"desc":@"格式化"},
          @{@"title":@"NSString+Attribute",@"desc":@"富文本",@"class":@"AttributeTextVC"},
        @{@"title":@"NSString+Size",@"desc":@"size计算"}],
    },
    @{@"title":@"NSArray",
      @"sectionTitles":
        @[@{@"title":@"NSArray+TMUI",@"desc":@"Crash avoid、高阶函数、不可变数组增删改查、打乱、逆置",@"class":@"NSArrayTMUIViewController"}],
    },
    @{@"title":@"NSDictionary"},
    @{@"title":@"NSDate"}
    ];
    _tableView = [self tableView];
    [self.view addSubview:_tableView];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_datas[section][@"sectionTitles"] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    NSDictionary *titleDict = _datas[indexPath.section][@"sectionTitles"][indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.textLabel.text = titleDict[@"title"];
    cell.detailTextLabel.text = titleDict[@"desc"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _datas[section][@"title"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = _datas[indexPath.section][@"sectionTitles"][indexPath.row];
    Class class = NSClassFromString(dict[@"class"]);
    NSString *title = dict[@"title"];
    UIViewController *vc = [[class alloc] init];
    vc.title = title;
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
