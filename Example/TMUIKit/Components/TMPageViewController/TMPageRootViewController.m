//
//  TMPageRootViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/26.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMPageRootViewController.h"
#import "Table1ViewController.h"
#import "Table2ViewController.h"
#import "Table3ViewController.h"
#import "NormalViewController.h"
#import "THKSegmentControl.h"
#import "THKColorsDefine.h"

@interface TMPageRootViewController ()

@property (nonatomic, strong) NSArray *vcs;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) THKSegmentControl *slideBar;
@end

@implementation TMPageRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"23";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"reload" style:UIBarButtonItemStyleDone target:self action:@selector(reload)];
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.vcs = [[@[Table1ViewController.class,
                       Table2ViewController.class,
                       Table3ViewController.class,
                       NormalViewController.class].rac_sequence map:^id _Nullable(Class cls) {
                            return [[cls alloc] init];
                       }] array];
        self.titles = @[@"热门",@"最新",@"涉及",@"案例"];
        
        [self reloadData];
    });
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:UIImage.new forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void)reload{
    self.vcs = [[@[Table1ViewController.class,
                   Table2ViewController.class,
                   Table3ViewController.class,
                   NormalViewController.class,
                   Table1ViewController.class,
                   Table2ViewController.class,
                   Table3ViewController.class,
                   NormalViewController.class].rac_sequence map:^id _Nullable(Class cls) {
        return [[cls alloc] init];
    }] array];
    self.titles = @[@"热门",@"最新",@"涉及",@"案例",@"热门",@"最新",@"涉及",@"案例"];
    self.slideBar = nil;
    
    [self reloadData];
}


- (NSArray<__kindof UIViewController *> *)childViewControllers{
    return self.vcs;
}

- (NSArray<NSString *> *)titlesForChildViewControllers{
    return self.titles;
}

- (CGFloat)heightForSliderBar{
    return 44;
}


- (void)segmentControlConfig:(THKSegmentControl *)control{
    control.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    control.autoAlignmentCenter = YES;
    control.backgroundColor = [UIColor orangeColor];
    control.indicatorView.backgroundColor = UIColor.blueColor;
    control.indicatorView.layer.cornerRadius = 0.0;
    [control setTitleFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium] forState:UIControlStateNormal];
    [control setTitleFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium] forState:UIControlStateSelected];
    [control setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    [control setTitleColor:UIColor.greenColor forState:UIControlStateSelected];
}

- (CGFloat)heightForHeader{
//    THKUserCenterHeaderViewModel *viewModel = [[THKUserCenterHeaderViewModel alloc] init];
//    return viewModel.viewHeight;
    return 300;
}

- (UIView *)viewForHeader{
    UIView *view = UIView.new;
    view.backgroundColor = UIColor.tmui_randomColor;
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eren"]];
    [view addSubview:imgV];
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    [imgV tmui_shadowColor:UIColor.blackColor opacity:0.5 offsetSize:CGSizeMake(10, 10) corner:10];
    imgV.layer.cornerRadius = 50;
    imgV.layer.masksToBounds = YES;
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(100);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    [imgV tmui_addSingerTapWithBlock:^{
        [TMShowBigImageViewController showBigImageWithImageView:imgV transitionStyle:THKTransitionStylePush];
    }];
    [view addSubview:UISwitch.new];
    return view;
}

- (UIView *)viewForTabSegmentControl{
    return self.slideBar;
}

- (void)pageViewControllerDidScrolFrom:(NSInteger)fromVC to:(NSInteger)toVC{
    NSLog(@"%zd-%zd",fromVC,toVC);
    self.slideBar.selectedIndex = toVC;
}

- (THKSegmentControl *)slideBar {
    if (!_slideBar) {
        CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
        _slideBar = [[THKSegmentControl alloc] initWithFrame:frame titles:self.titles];
        _slideBar.backgroundColor = [UIColor whiteColor];
        _slideBar.indicatorView.backgroundColor = THKColor_WeakDeepRedColor;
        [_slideBar setTitleFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium] forState:UIControlStateNormal];
        [_slideBar setTitleFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium] forState:UIControlStateSelected];
        [_slideBar setTitleColor:UIColorHex(#BABDC6) forState:UIControlStateNormal];
        [_slideBar setTitleColor:THKColor_WeakDeepRedColor forState:UIControlStateSelected];
        [_slideBar addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventValueChanged];
        _slideBar.indicatorView.height = 3;
        _slideBar.indicatorView.y -= 3; // 需要放到最后设置
    }
    
    return _slideBar;
}

- (void)btnClick:(THKSegmentControl *)sender{
    NSLog(@"%@",sender);
    [self scrollToIndex:sender.selectedIndex];
}

@end
