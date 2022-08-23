//
//  TDSearchViewController.m
//  Demo
//
//  Created by Joe.cheng on 2022/3/9.
//

#import "TDSearchViewController.h"
#import "TMUISearchBar.h"


#define invoke(method) \
SEL selector = NSSelectorFromString(method); \
IMP imp = [self methodForSelector:selector]; \
void (*func)(id, SEL) = (void *)imp; \
func(self, selector);

@interface TDSearchViewController ()

//@property (nonatomic, strong) THKNavigationBar *navBar;

@end

@implementation TDSearchViewController

- (void)demoaction{
    UIEdgeInsets paddings = UIEdgeInsetsMake(24 + NavigationContentTop, 24 + self.view.tmui_safeAreaInsets.left, 24 +  self.view.tmui_safeAreaInsets.bottom, 24 + self.view.tmui_safeAreaInsets.right);
    
    TMUIFloatLayoutView *layoutView = [[TMUIFloatLayoutView alloc] tmui_initWithSize:TMUIFloatLayoutViewAutomaticalMaximumItemSize];
    layoutView.itemMargins = UIEdgeInsetsMake(0, 0, 8, 8);
    
    NSArray *btns = @[@"显示/隐藏左边",@"显示/隐藏右边",@"结束编辑"];
    
    [btns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TMUIButton *btn = [TMUIButton tmui_button];
        btn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        btn.cornerRadius = 8;
        btn.tmui_text = obj;
        btn.tmui_titleColor = UIColorWhite;
        btn.backgroundColor = UIColor.tmui_randomColor;
        btn.tag = idx;
        [btn tmui_addTarget:self action:@selector(btnClick:)];
        [layoutView addSubview:btn];
    }];
    
    layoutView.frame = CGRectMake(paddings.left, paddings.top, CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(paddings), TMUIViewSelfSizingHeight);
    
    [self.view addSubview:layoutView];
}

- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 0) {
//        _navBar.isBackButtonHidden = !_navBar.isBackButtonHidden;
    }else if (btn.tag == 1) {
//        _navBar.isRightButtonHidden = !_navBar.isRightButtonHidden;
    }else if (btn.tag == 2) {
//        [self.view endEditing:YES];
        TMUISearchBar *search = (TMUISearchBar *)self.navigationItem.titleView;
        [search resignFirstResponder];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [Label.str(@"这里是用的自定义导航栏实现搜索容器，由于还没封装完善，并且某些组件跟项目耦合，只能在Demo中查看完整效果").lines(0).addTo(self.view) mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(300);
        make.left.right.equalTo(self.view);
    }];
    
//    self.navBarHidden = YES;
//    _navBar = [[THKNavigationBar alloc] init];
//    [self.view addSubview:_navBar];
    
    [self demoaction];
    
    NSString *method = [NSString stringWithFormat:@"style%zd",_style];
    invoke(method)
    
    TMUISearchBar *search = (TMUISearchBar *)self.navigationItem.titleView;
    if ([search isKindOfClass:TMUISearchBar.class]) {
        
        search.maxTextLength = 50;
        __weak typeof(search) weakSearch = search;
        search.cityClick = ^(UIButton * _Nonnull btn) {
            NSLog(@"【cityClick】：%@",btn);
            [weakSearch setCurrentCity:@"广州"];
        };
//        search.isCanInput = NO; // 禁用输入才会到这里
        search.textBegin = ^(UITextField * _Nonnull textField) {
            NSLog(@"【textClick】：%@",textField);
        };
        search.textChange = ^(UITextField * _Nonnull textField, NSString * _Nonnull text) {
            NSLog(@"【textChange】：%@\n%@",textField.text,textField);
        };
        search.textEnd = ^(UITextField * _Nonnull textField, NSString * _Nonnull text) {
            NSLog(@"【textEnd】：%@\n%@",textField.text,textField);
        };
        search.maxLength = ^(UITextField * _Nonnull textField, NSRange range, NSString * _Nonnull replacementString) {
            NSLog(@"【maxLength】：%@-%@-%@",textField,NSStringFromRange(range),replacementString);
        };
    }
}


/// 滚动搜索
- (void)style0{
//    TMUIScrollSearchBar *search = [[TMUIScrollSearchBar alloc] init];
//    [search setHotwords:@[@"123",@"456"]];
//
//    _navBar.titleView = search;
    TMUISearchBar *search = [[TMUISearchBar alloc] initWithStyle:TMUISearchBarStyle_City_White frame:CGRectMake(20, 500, TMUI_SCREEN_WIDTH - 40, 44)];
    
    [self.view addSubview:search];
    
}


/// 常用搜索
- (void)style1{
    TMUISearchBar *search = [[TMUISearchBar alloc] init];
    
    self.navigationItem.titleView = search;
}


/// 城市搜索
- (void)style2{
    TMUISearchBar *search = [[TMUISearchBar alloc] initWithStyle:TMUISearchBarStyle_City];
    
    self.navigationItem.titleView = search;
}

- (void)style3{
//    self.navBarHidden = NO;
//    [_navBar removeFromSuperview];
    
    TMUISearchBar *search = [[TMUISearchBar alloc] initWithStyle:TMUISearchBarStyle_City];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.titleView = search;
    self.navigationItem.rightBarButtonItems = [UIBarButtonItem cancelItemWithTarget:self action:@selector(navBackAction:)];
}

@end
