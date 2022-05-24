//
//  TDFilterViewController.m
//  Demo
//
//  Created by Joe.cheng on 2022/3/30.
//

#import "TDFilterViewController.h"
#import "TMUIFilterView.h"

@interface TDFilterViewController ()

@property (nonatomic, strong) UIButton *b1;
@property (nonatomic, strong) UIButton *b2;
@property (nonatomic, strong) UIButton *b3;
@property (nonatomic, strong) UIButton *b4;

@property (nonatomic, assign) NSInteger b1_0;

@property (nonatomic, assign) NSInteger b2_0;
@property (nonatomic, assign) NSInteger b2_1;

@property (nonatomic, assign) NSInteger b3_0;

@property (nonatomic, assign) NSInteger b4_0;

@property (nonatomic, strong) TMUIFilterView *filterView3;
@end

@implementation TDFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationController.navigationBar.barTintColor = UIColor.whiteColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(debug)];
    
    _b1 = Button.str(@"单选筛选组件").bgColor(@"random").addTo(self.view).onClick(^{
        [self filter1];
    });
    
    [_b1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(20);
        make.top.mas_equalTo(200);
        make.height.mas_equalTo(44);
    }];
    
    _b2 = Button.str(@"多选筛选组件").bgColor(@"random").addTo(self.view).onClick(^{
        [self filter2];
    });
    
    [_b2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(20);
        make.top.equalTo(_b1.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];
    
    _b3 = Button.str(@"单选筛选组件记录").bgColor(@"random").addTo(self.view).onClick(^{
        [self filter3];
    });
    
    [_b3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(20);
        make.top.equalTo(_b2.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];
    
    _b4 = Button.str(@"单选组件流式布局").bgColor(@"random").addTo(self.view).onClick(^{
        [self filter4];
    });
    
    [_b4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(20);
        make.top.equalTo(_b3.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];
    
    _b1_0 = NSNotFound;
    _b2_0 = NSNotFound;
    _b2_1 = NSNotFound;
}
- (void)filter1{
    
    TMUIFilterModel *filterModel1 = [[TMUIFilterModel alloc] init];
    filterModel1.title = @"装修公司所在区域";
    filterModel1.subtitle = @"根据装修公司门店所在区域，选择方便到店的装修公司";
    filterModel1.items = @[@"南山区",@"宝安区",@"福田区",@"龙岗区",@"罗湖区",@"盐田区"].filterItemModels;
    filterModel1.defalutItem = _b1_0;
    TMUIFilterView *filterView = [[TMUIFilterView alloc] init];
    filterView.topInset = NavigationContentTop;
    filterView.models = @[filterModel1];
    
    [filterView show];
    
    @weakify(self);
    @weakify(filterView);
    filterView.selectBlock = ^(NSArray<NSIndexPath *> * _Nullable indexPaths, NSArray<TMUIFilterItemModel *> * _Nullable models) {
        @strongify(self);
        @strongify(filterView);
        NSMutableString *str = [NSMutableString string];
        for (NSIndexPath *idxP in indexPaths) {
            NSString *aAtr = filterView.models[idxP.section].items[idxP.item].text;
            [str appendString:aAtr];
            if (idxP.section == 0) {
                self.b1_0 = idxP.item;
            }
        }
        self.b1.tmui_text = str;
    };
}

- (void)filter2{
    TMUIFilterModel *filterModel1 = [[TMUIFilterModel alloc] init];
    filterModel1.title = @"装修公司所在区域";
    filterModel1.subtitle = @"根据装修公司门店所在区域，选择方便到店的装修公司";
    filterModel1.items = @[@"南山区",@"宝安区",@"福田区",@"龙岗区",@"罗湖区",@"盐田区"].filterItemModels;
    filterModel1.defalutItem = _b2_0;
    
    TMUIFilterModel *filterModel2 = [[TMUIFilterModel alloc] init];
    filterModel2.title = @"装修阶段";
    filterModel2.subtitle = @"土巴兔平台根据装修公司综合服务能力排名";
    filterModel2.items = @[@"全部",@"设计阶段",@"水电阶段",@"泥工阶段",@"油漆阶段",@"竣工阶段"].filterItemModels;
    filterModel2.defalutItem = _b2_1;
    
    TMUIFilterModel *filterModel3 = [[TMUIFilterModel alloc] init];
    filterModel3.title = @"装修公司所在区域";
    filterModel3.subtitle = @"根据装修公司门店所在区域，选择方便到店的装修公司";
    filterModel3.items = @[@"南山区",@"宝安区",@"福田区",@"龙岗区",@"罗湖区",@"盐田区"].filterItemModels;
    filterModel3.defalutItem = _b2_0;
    
    TMUIFilterModel *filterModel4 = [[TMUIFilterModel alloc] init];
    filterModel4.title = @"装修阶段";
    filterModel4.subtitle = @"土巴兔平台根据装修公司综合服务能力排名";
    filterModel4.items = @[@"全部",@"设计阶段",@"水电阶段",@"泥工阶段",@"油漆阶段",@"竣工阶段"].filterItemModels;
    filterModel4.defalutItem = _b2_1;
    
    TMUIFilterView *filterView = [[TMUIFilterView alloc] init];
    filterView.topInset = NavigationContentTop;
    filterView.maxHeight = 500;
    filterView.models = @[filterModel1,filterModel2,filterModel3,filterModel4];
    
    [filterView show];
    
    @weakify(self);
    @weakify(filterView);
    filterView.selectBlock = ^(NSArray<NSIndexPath *> * _Nullable indexPaths, NSArray<TMUIFilterItemModel *> * _Nullable models) {
        @strongify(self);
        @strongify(filterView);
        NSMutableString *str = [NSMutableString string];
        for (NSIndexPath *idxP in indexPaths) {
            NSString *aAtr = filterView.models[idxP.section].items[idxP.item].text;
            if (str.length) {
                [str appendString:@","];
            }
            [str appendString:aAtr];
            if (idxP.section == 0) {
                self.b2_0 = idxP.item;
            }else if (idxP.section == 1) {
                self.b2_1 = idxP.item;
            }
        }
        self.b2.tmui_text = str;
    };
}

- (void)filter3{
    if (!_filterView3) {
        TMUIFilterModel *filterModel1 = [[TMUIFilterModel alloc] init];
        filterModel1.title = @"装修公司所在区域";
        filterModel1.subtitle = @"根据装修公司门店所在区域，选择方便到店的装修公司";
        filterModel1.items =@[@"南山区",@"宝安区",@"福田区",@"龙岗区",@"罗湖区",@"盐田区"].filterItemModels;
        filterModel1.defalutItem = _b1_0;
        TMUIFilterView *filterView = [[TMUIFilterView alloc] init];
        filterView.topInset = CGRectGetMaxY(self.b3.frame);
        filterView.models = @[filterModel1];
        
        @weakify(self);
        @weakify(filterView);
        filterView.selectBlock = ^(NSArray<NSIndexPath *> * _Nullable indexPaths, NSArray<TMUIFilterItemModel *> * _Nullable models) {
            @strongify(self);
            @strongify(filterView);
            NSMutableString *str = [NSMutableString string];
            for (NSIndexPath *idxP in indexPaths) {
                NSString *aAtr = filterView.models[idxP.section].items[idxP.item].text;
                [str appendString:aAtr];
                if (idxP.section == 0) {
                    self.b3_0 = idxP.item;
                }
            }
            self.b3.tmui_text = str;
        };
        
        _filterView3 = filterView;
    }
    
    
    
    [_filterView3 show];
    
}


- (void)filter4{
    TMUIFilterModel *filterModel1 = [[TMUIFilterModel alloc] init];
    filterModel1.title = @"装修公司所在区域";
    filterModel1.subtitle = @"根据装修公司门店所在区域，选择方便到店的装修公司";
    filterModel1.items = @[@"南山区南山区",@"宝安",@"福田区田区",@"龙岗龙岗龙岗区",@"罗湖区",@"龙龙岗田区",@"南区",@"宝安宝安宝安",@"福区田区",@"龙岗龙岗龙岗区",@"罗湖区",@"龙岗龙田区"].filterItemModels;
    TMUIFilterView *filterView = [[TMUIFilterView alloc] init];
    filterView.topInset = NavigationContentTop;
    filterView.column = 0;
    filterView.models = @[filterModel1];
    
    [filterView show];
    
    @weakify(self);
    @weakify(filterView);
    filterView.selectBlock = ^(NSArray<NSIndexPath *> * _Nullable indexPaths, NSArray<TMUIFilterItemModel *> * _Nullable models) {
        @strongify(self);
        @strongify(filterView);
        NSMutableString *str = [NSMutableString string];
        for (NSIndexPath *idxP in indexPaths) {
            NSString *aAtr = filterView.models[idxP.section].items[idxP.item].text;
            [str appendString:aAtr];
            if (idxP.section == 0) {
                self.b4_0 = idxP.item;
            }
        }
        self.b4.tmui_text = str;
    };
}



- (void)debug{
//    [self.navigationController pushViewController:[NSClassFromString(@"TDOneFoldLabelViewController") new] animated:YES];
    [self filter1debug];
    
}



- (void)filter1debug{
    TMUIFilterModel *filterModel1 = [[TMUIFilterModel alloc] init];
    filterModel1.title = @"装修公司所在区域";
    filterModel1.subtitle = @"根据装修公司门店所在区域，选择方便到店的装修公司";
    filterModel1.items = @[@"南山区",@"宝安区",@"福田区",@"龙岗区",@"罗湖区",@"盐田区"].filterItemModels;
//    filterModel1.defalutItem = _b1_0;
//    filterModel1.
    TMUIFilterView *filterView = [[TMUIFilterView alloc] init];
    filterView.topInset = NavigationContentTop;
    filterView.column = 4;
    filterView.models = @[filterModel1];
    [filterView showInView:self.tabBarController.view];
    
//    @weakify(self);
//    @weakify(filterView);
//    filterView.selectBlock = ^(NSArray<NSIndexPath *> * _Nullable indexPaths, NSArray<TMUIFilterCell *> * _Nullable cells) {
////        @strongify(self);
//        @strongify(filterView);
//        NSMutableString *str = [NSMutableString string];
//        for (NSIndexPath *idxP in indexPaths) {
//            NSString *aAtr = filterView.models[idxP.section].items[idxP.item];
//            [str appendString:aAtr];
//            if (idxP.section == 0) {
////                self.b1_0 = idxP.item;
//            }
//        }
////        self.b1.tmui_text = str;
//    };
}

@end
