//
//  ListSearchResultVc.m
//  SearchVcTest
//
//  Created by nigel.ning on 2020/8/5.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "ListSearchResultVc.h"
#import "TMSearchBar.h"

@interface ListSearchResultVc ()
@property (nonatomic, strong)UIView *topView;

@end

@implementation ListSearchResultVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(_back)];
    [self loadTopView];
    self.navigationItem.titleView = self.topView;
    
    UILabel *lbl = [[UILabel alloc] init];
    [self.view addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = [NSString stringWithFormat:@"搜索:%@ 的结果页", self.searchStr];
}

- (void)loadTopView {
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    TMSearchBar *sb = [[TMSearchBar alloc] init];
    sb.bottomLineHide = YES;
    sb.text = self.searchStr;
    [self.topView addSubview:sb];
    [sb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 60);
    }];
    sb.userInteractionEnabled = NO;
    UIButton *btn = [[UIButton alloc] init];
    [self.topView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [btn addTarget:self action:@selector(reSearchAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.navigationController isNavigationBarHidden]) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)_back {
    BOOL animate = NO;
    UINavigationController *nav = self.navigationController;
    [nav popViewControllerAnimated:animate];
    [nav setNavigationBarHidden:YES animated:animate];
}

- (void)reSearchAction {
    BOOL animate = NO;
    UINavigationController *nav = self.navigationController;
    [nav popViewControllerAnimated:animate];
    [nav setNavigationBarHidden:YES animated:animate];
    if (self.reSearchBlock) {
        self.reSearchBlock(@"2");
    }
}

@end
