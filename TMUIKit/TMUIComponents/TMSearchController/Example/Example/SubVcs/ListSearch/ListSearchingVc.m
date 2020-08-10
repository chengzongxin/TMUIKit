//
//  ListSearchingVc.m
//  SearchVcTest
//
//  Created by nigel.ning on 2020/8/5.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "ListSearchingVc.h"
#import "ListSearchResultVc.h"

@interface ListSearchingVc ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *testOriginDataList;
@property (nonatomic, strong)NSMutableArray *searchingDataSource;
@end

@implementation ListSearchingVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
    
    if (@available(iOS 11, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    if (@available(iOS 13.0, *)) {
        self.tableView.automaticallyAdjustsScrollIndicatorInsets = NO;
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.testOriginDataList = [@"0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,abc" componentsSeparatedByString:@","];
    
    self.searchingDataSource = [NSMutableArray array];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchingDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kCell"];
    
    cell.textLabel.text = self.searchingDataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //收起键盘
    [self.navigationController.view endEditing:YES];
    
    NSString *selectedText = self.testOriginDataList[indexPath.row];
    ListSearchResultVc *vc = [[ListSearchResultVc alloc] init];
    vc.searchStr = selectedText;    
    [vc setReSearchBlock:self.reSearchBlock];
    [self.navigationController pushViewController:vc animated:NO];
}

- (UINavigationController *)navigationController {
    UINavigationController *nav = [super navigationController];
    if (!nav) {
        nav = self.presentingViewController.navigationController;
    }
    return nav;
}

#pragma mark - protocol methods
- (void)fuzzySearchForText:(NSString *)searchText {
    if (searchText.length > 0) {
        NSString *likeStr = [NSString stringWithFormat:@"*%@*", searchText];
        NSArray *arr = [self.testOriginDataList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self like [c] %@", likeStr]];
        [self.searchingDataSource removeAllObjects];
        [self.searchingDataSource addObjectsFromArray:arr];
    }else {
        [self.searchingDataSource removeAllObjects];
    }
    [self.tableView reloadData];
}

- (void)clickSearchWithText:(NSString *)searchText {
    if (searchText.length > 0) {
        NSString *likeStr = [NSString stringWithFormat:@"*%@*", searchText];
        NSArray *arr = [self.testOriginDataList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self like [c] %@", likeStr]];
        [self.searchingDataSource removeAllObjects];
        [self.searchingDataSource addObjectsFromArray:arr];
    }else {
        [self.searchingDataSource removeAllObjects];
    }
    [self.tableView reloadData];
}

@end
