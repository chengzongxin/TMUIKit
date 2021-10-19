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

@property (nonatomic, strong) NSMutableArray *vcs;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, assign) CGFloat headerH;
@property (nonatomic, strong) UILabel *label;
@end

@implementation TMPageRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"reload" style:UIBarButtonItemStyleDone target:self action:@selector(reload)];
    
    [self reload];
}

- (void)reload{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadVCs];
        
        [self reloadData];
    });
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
    _headerH = arc4random()%200 + 200;
    return _headerH;
}

- (UIView *)viewForHeader{
    return [self customHeaderView];
}


#pragma mark - 交互事件
// MARK: navbarItemClick
- (void)reloadAllChildvcs{
    [self reloadVCs];
    
    if (_label) {
        _label.str(Str(@"刷新tab和子VC视图,当前个数 %zd",self.vcs.count));
    }
    
    [super reloadChildViewControllers];
}

- (void)reloadVCs{
    self.vcs = [NSMutableArray array];
    self.titles = [NSMutableArray array];
    
    NSArray *vcs = [[@[Table1ViewController.class,
                   Table2ViewController.class,
                   Table3ViewController.class,
                   NormalViewController.class,
                   Table1ViewController.class,
                   Table2ViewController.class,
                   Table3ViewController.class,
                   NormalViewController.class,
                   Table1ViewController.class,
                   Table2ViewController.class,].rac_sequence map:^id _Nullable(Class cls) {
        return [[cls alloc] init];
    }] array];
    
    NSArray *titles = @[@"热门",@"最新",@"涉及",@"案例",@"热门",@"最新",@"涉及",@"案例",@"热门",@"最新"];
    NSInteger count = arc4random()%10 + 1;
    for (int i = 0; i < count; i++) {
        [self.vcs addObject:vcs[i]];
        [self.titles addObject:titles[i]];
    }
}

- (void)switchValueChanged:(UISwitch *)switchControl{
    switch (switchControl.tag) {
        case 1:
            [self addRefreshHeader];
            break;
        case 2:
        {
            [self reloadHeaderView];
            self.wrapperView.mj_header.ignoredScrollViewContentInsetTop = _headerH + self.sliderBarHeight;
        }
            break;
        case 3:
            [self reloadAllChildvcs];
            break;
        default:
            break;
    }
}

- (void)addRefreshHeader{
    self.wrapperView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadAllChildvcs];
            [self.wrapperView.mj_header endRefreshing];
        });
    }];
    self.wrapperView.mj_header.ignoredScrollViewContentInsetTop = _headerH + self.sliderBarHeight;
}

#pragma mark - 添加自定义头部视图
- (UIView *)customHeaderView{
    UIView *view = UIView.new;
    view.backgroundColor = UIColor.tmui_randomColor;
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eren"]];
    [view addSubview:imgV];
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    [imgV tmui_shadowColor:UIColor.blackColor opacity:0.5 offsetSize:CGSizeMake(10, 10) corner:10];
    imgV.layer.cornerRadius = 44;
    imgV.layer.masksToBounds = YES;
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-20);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(88);
    }];
    [imgV tmui_addSingerTapWithBlock:^{
        [TMShowBigImageViewController showBigImageWithImageView:imgV transitionStyle:THKTransitionStylePush];
    }];
    
    id attStr = AttStr(AttStr(@"Tab组件：\n").styles(h1),
           AttStr(@"可在容器页添加刷新头部，子页面头部，尾部，添加刷新组件").styles(h2));
    UILabel *lbl = Label.str(attStr).multiline.lineGap(10).xywh(10,50,300,100).leftAlignment.addTo(view).makeCons(^{
        make.top.left.right.constants(20,20,20);
    });
    
    UISwitch *switchControl1 = [[UISwitch alloc] init];
    [switchControl1 addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    switchControl1.tg(1).addTo(view).makeCons(^{
        make.left.equal.view(lbl).left.constants(0);
        make.top.equal.view(lbl).bottom.constants(20);
    });
    
    Label.str(@"是否添加下拉刷新").styles(h1).addTo(view).makeCons(^{
        make.left.equal.view(switchControl1).right.constants(20);
        make.centerY.equal.view(switchControl1).centerY.constants(0);
    });
    
    UISwitch *switchControl2 = [[UISwitch alloc] init];
    [switchControl2 addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    switchControl2.tg(2).addTo(view).makeCons(^{
        make.left.equal.view(switchControl1).left.constants(0);
        make.top.equal.view(switchControl1).bottom.constants(20);
    });
    
    Label.str(Str(@"刷新头部视图,当前高度，%.0f",_headerH)).styles(h1).addTo(view).makeCons(^{
        make.left.equal.view(switchControl2).right.constants(20);
        make.centerY.equal.view(switchControl2).centerY.constants(0);
    });
    
    UISwitch *switchControl3 = [[UISwitch alloc] init];
    [switchControl3 addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    switchControl3.tg(3).addTo(view).makeCons(^{
        make.left.equal.view(switchControl2).left.constants(0);
        make.top.equal.view(switchControl2).bottom.constants(20);
    });
    
    _label = Label.str(Str(@"刷新tab和子VC视图,当前个数 %zd",self.vcs.count)).styles(h1).addTo(view).makeCons(^{
        make.left.equal.view(switchControl3).right.constants(20);
        make.centerY.equal.view(switchControl3).centerY.constants(0);
    });
    
    return view;
}

@end
