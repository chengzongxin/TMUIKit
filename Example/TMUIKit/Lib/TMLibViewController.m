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
                      @"rowTitle":@"设置圆角、阴影、渐变、边框",
                      @"class":@"UIViewTMUIViewController"
                  },
                  @{
                      @"rowTitle":@"快速添加各种手势事件",
                      @"class":@"UIViewTMUI2ViewController"
                  },
                  @{
                      @"rowTitle":@"创建动画",
                      @"class":@"UIViewTMUI3ViewController"
                  }
          ]},
        @{@"sections":@"UILable+TMUI",
          @"rows":@[
                  @{
                      @"rowTitle":@"设置富文本属性、计算文本size、富文本超链接",
                      @"class":@"UILabelTMUIViewController"
                  }
          ]},
        @{@"sections":@"UIButton+TMUI",
          @"rows":@[
                  @{
                      @"rowTitle":@"设置图片位置、图文间距、扩大点击区域",
                      @"class":@"UIButtonTMUIViewController"
                  }
          ]},
        @{@"sections":@"UIViewController+TMUI",
          @"rows":@[
                  @{
                      @"rowTitle":@"获取最上层vc、全局设置导航栏显示隐藏、导航控制器中上一个viewcontroller、导航控制器中下一个viewcontroller",
                      @"class":@"UIViewControllerTMUIViewController"
                  }
          ]},
        @{@"sections":@"UITextField+TMUI",
          @"rows":@[
                  @{
                      @"rowTitle":@"设置最大文本输入长度、设置 placeHolder 颜色和字体、文本回调",
                      @"class":@"UITextFieldTMUIViewController"
                  }
          ]},
    ];
    
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
    vc.title = dict[@"rowTitle"];
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
