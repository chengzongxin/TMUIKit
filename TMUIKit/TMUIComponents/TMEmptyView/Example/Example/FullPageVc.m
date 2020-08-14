//
//  FullPageVc.m
//  Example
//
//  Created by nigel.ning on 2020/8/14.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "FullPageVc.h"

@interface FullPageVc ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *topBarView;
@end

@implementation FullPageVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.clipsToBounds = YES;
    self.topBarView = [[UIView alloc] init];
    [self.view addSubview:self.topBarView];
    [self.topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(MAX(20, tmui_safeAreaTopInset()) + 44);
    }];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.topBarView.mas_bottom);
    }];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //
    self.topBarView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    [self.topBarView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(8);
        make.width.height.mas_equalTo(44);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)onBack {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
    
    TMEmptyView *emptyV = nil;
    if (indexPath.section == 0) {
        @TMUI_weakify(self);
            emptyV = [TMEmptyView showEmptyInView:self.view safeMargin:UIEdgeInsetsZero contentType:self.dataSource[indexPath.section][indexPath.row].type clickBlock:^{
            @TMUI_strongify(self);
            [self.view.tmui_emptyView remove];
        }];
    }else {
        @TMUI_weakify(self);
        emptyV = [TMEmptyView showEmptyInView:self.tableView safeMargin:UIEdgeInsetsMake(30, 20, 0, 30) contentType:self.dataSource[indexPath.section][indexPath.row].type clickBlock:^{
            @TMUI_strongify(self);
            [self.tableView.tmui_emptyView remove];
        }];
    }
    
    if (emptyV) {
        @TMUI_weakify(self);
        emptyV.navBackBtnCustomClickBlock = ^{
            @TMUI_strongify(self);
            [self onBack];
        };
    }
    
}

@end
