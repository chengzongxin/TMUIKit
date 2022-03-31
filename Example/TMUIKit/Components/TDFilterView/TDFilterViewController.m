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

@property (nonatomic, assign) NSInteger b1_0;

@property (nonatomic, assign) NSInteger b2_0;
@property (nonatomic, assign) NSInteger b2_1;

@end

@implementation TDFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationController.navigationBar.barTintColor = UIColor.whiteColor;
    
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
        make.top.mas_equalTo(264);
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
    filterModel1.items = @[@"南山区",@"宝安区",@"福田区",@"龙岗区",@"罗湖区",@"盐田区"];
    filterModel1.defalutItem = _b1_0;
    TMUIFilterView *filterView = [[TMUIFilterView alloc] init];
    filterView.models = @[filterModel1];
    
    [filterView show];
    
    @weakify(self);
    @weakify(filterView);
    filterView.selectBlock = ^(NSArray<NSIndexPath *> *indexPaths) {
        @strongify(self);
        @strongify(filterView);
        NSMutableString *str = [NSMutableString string];
        for (NSIndexPath *idxP in indexPaths) {
            NSString *aAtr = filterView.models[idxP.section].items[idxP.item];
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
    filterModel1.items = @[@"南山区",@"宝安区",@"福田区",@"龙岗区",@"罗湖区",@"盐田区"];
    filterModel1.defalutItem = _b2_0;
    
    TMUIFilterModel *filterModel2 = [[TMUIFilterModel alloc] init];
    filterModel2.title = @"装修阶段";
    filterModel2.subtitle = @"土巴兔平台根据装修公司综合服务能力排名";
    filterModel2.items = @[@"全部",@"设计阶段",@"水电阶段",@"泥工阶段",@"油漆阶段",@"竣工阶段"];
    filterModel2.defalutItem = _b2_1;
    
    TMUIFilterView *filterView = [[TMUIFilterView alloc] init];
    filterView.models = @[filterModel1,filterModel2];
    
    [filterView show];
    
    @weakify(self);
    @weakify(filterView);
    filterView.selectBlock = ^(NSArray<NSIndexPath *> *indexPaths) {
        @strongify(self);
        @strongify(filterView);
        NSMutableString *str = [NSMutableString string];
        for (NSIndexPath *idxP in indexPaths) {
            NSString *aAtr = filterView.models[idxP.section].items[idxP.item];
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

@end
