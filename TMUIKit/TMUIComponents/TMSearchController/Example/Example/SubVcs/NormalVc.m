//
//  NormalVc.m
//  SearchVcTest
//
//  Created by nigel.ning on 2020/8/4.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "NormalVc.h"
#import "ListSearchVc.h"
#import "ListSearchingVc.h"


@interface NormalVc ()
@property (nonatomic, strong)TMSearchController *searchVc;
@end

@implementation NormalVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"NormalVc";
    
    if (self.navBarShouldHide) {
        UIButton *backBtn = [[UIButton alloc] init];
        backBtn.backgroundColor = [UIColor lightGrayColor];
        [backBtn setTitle:@"自定义|无导航条时则点击->返回" forState:UIControlStateNormal];
        [self.view addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        [backBtn addTarget:self action:@selector(_onBack) forControlEvents:UIControlEventTouchUpInside];
    }else {
        UILabel *lbl = [[UILabel alloc] init];
        [self.view addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
        
        lbl.text = @"自定义的视图";
    }
    
    [self initSearchController];
}

- (void)initSearchController
{
    self.searchVc = [[ListSearchVc alloc] initWithSearchingController:[ListSearchingVc new]];
    [self.view addSubview:self.searchVc.searchBar];
    self.searchVc.searchBar.frame = CGRectMake(50, 100, [UIScreen mainScreen].bounds.size.width - 50 * 2, 44);
}

- (void)_onBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navBarShouldHide != self.navigationController.isNavigationBarHidden &&
        ![self.searchVc isActive]) {
        [self.navigationController setNavigationBarHidden:self.navBarShouldHide animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

@end
