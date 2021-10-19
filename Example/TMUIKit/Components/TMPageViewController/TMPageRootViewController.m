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
#import <MJRefresh.h>

@interface TMPageRootViewController ()

@property (nonatomic, strong) NSArray *vcs;
@property (nonatomic, strong) NSArray *titles;
//@property (nonatomic, strong) THKSegmentControl *slideBar;
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
        
        [self addRefreshHeader:nil];
    });
}

- (void)addRefreshHeader:(UIControl *)contorl{
    
    self.wrapperView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self reload];
        });
    }];
    self.wrapperView.mj_header.ignoredScrollViewContentInsetTop = [self heightForHeader]+44;
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
//    self.slideBar = nil;
    
    [self reloadData];
}

#pragma mark - TMUIPageViewController DataSource
- (NSArray<__kindof UIViewController *> *)viewControllersForChildViewControllers{
    return self.vcs;
}

- (NSArray<NSString *> *)titlesForChildViewControllers{
    return self.titles;
}

- (void)segmentControlConfig:(THKSegmentControl *)control{
    control.height = 44;
}

- (CGFloat)heightForHeader{
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
        make.left.mas_equalTo(200);
        make.top.mas_equalTo(100);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    [imgV tmui_addSingerTapWithBlock:^{
        [TMShowBigImageViewController showBigImageWithImageView:imgV transitionStyle:THKTransitionStylePush];
    }];
    
    id attStr = AttStr(AttStr(@"Tab组件：\n").styles(h1),
           AttStr(@"可在容器页添加刷新头部，子页面头部，尾部，添加刷新组件").styles(h2));
    UILabel *lbl = Label.str(attStr).multiline.lineGap(10).xywh(10,50,300,100).leftAlignment.addTo(view).makeCons(^{
        make.top.left.right.constants(20,20,20);
    });
    
    UISwitch *switchControl = [[UISwitch alloc] init];
    [switchControl addTarget:self action:@selector(addRefreshHeader:) forControlEvents:UIControlEventValueChanged];
    switchControl.addTo(view).makeCons(^{
        make.left.equal.view(lbl).left.constants(0);
        make.top.equal.view(lbl).bottom.constants(20);
    });
    
    Label.str(@"是否添加头部").styles(h1).addTo(view).makeCons(^{
        make.left.equal.view(switchControl).right.constants(20);
        make.centerY.equal.view(switchControl).centerY.constants(0);
    });
    
    return view;
}

@end
