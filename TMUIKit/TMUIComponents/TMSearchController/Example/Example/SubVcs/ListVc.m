//
//  ListVc.m
//  SearchVcTest
//
//  Created by nigel.ning on 2020/8/4.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "ListVc.h"
#import "ListSearchVc.h"
#import "ListSearchingVc.h"

@interface ListVc ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)TMSearchController *searchVc;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *testOriginDataList;

@end

@implementation ListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"ListVc";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.testOriginDataList = [@"0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,abc" componentsSeparatedByString:@","];
    [self initSearchController];
}

- (void)initSearchController
{
    self.searchVc = [[ListSearchVc alloc] initWithSearchingController:[ListSearchingVc new]];
    self.tableView.tableHeaderView = self.searchVc.searchBar;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.testOriginDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCell"];
    cell.textLabel.text = self.testOriginDataList[indexPath.row];
    return cell;
}

@end
