//
//  TMUIKitViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/19.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUIKitViewController.h"
#import "TDDebugViewController.h"

@interface TMUIKitViewController ()

@end

@implementation TMUIKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(debug)];
    
    GroupTV(
            SECTION_CREATE(
                           ROW_CREATE(@"设置圆角、阴影、渐变、边框", @"UIViewTMUIViewController"),
                           ROW_CREATE(@"快速添加各种手势事件、坐标系转换", @"UIViewTMUI2ViewController"),
                           ROW_CREATE(@"创建动画", @"UIViewTMUI3ViewController"),
                           ROW_CREATE(@"UIView+TMUIBorder",@"设置边框", @"UIViewTMUI4ViewController"),
                           ).THEME_TITLE(@"UIView+TMUI"),
            SECTION_CREATE(
                           ROW_CREATE(@"UILable+TMUI",
                                      @"设置富文本属性、计算文本size、富文本超链接",
                                      @"UILabelTMUIViewController"),
                           ROW_CREATE(@"UILable+TMUI",
                                      @"富文本展示、尺寸计算2",
                                      @"UILabelTMUIViewController2"),
                           ROW_CREATE(@"UIButton+TMUI",
                                      @"设置图片位置、图文间距、扩大点击区域",
                                      @"UIButtonTMUIViewController"),
                           ROW_CREATE(@"UIViewController+TMUI",
                                      @"获取最上层vc、全局设置导航栏显示隐藏、导航控制器中上一个viewcontroller、导航控制器中下一个viewcontroller",
                                      @"UIViewControllerTMUIViewController"),
                           ROW_CREATE(@"UITextField+TMUI",
                                      @"设置最大文本输入长度、设置 placeHolder 颜色和字体、文本回调",
                                      @"UITextFieldTMUIViewController"),
                           ROW_CREATE(@"CALayer+TMUI",
                                      @"frame、tranform属性快速访问、修改、移除默认动画、不带动画修改layer属性",
                                      @"CALayerTMUIViewController"),
                           ROW_CREATE(@"CAAnimation+TMUI",
                                      @"支持用 block 的形式添加对 animationDidStart 和 animationDidStop 的监听，无需自行设置 delegate",
                                      @"CAAnimationTMUIViewController"),
                           ROW_CREATE(@"UIBarButtonItem+TMUI",
                                      @"全局配置的barButtonItem，快速创建使用",
                                      @"UIBarButtonItemTMUIViewController"),
                           ).THEME_TITLE(@"UIKit+TMUI"),
            SECTION_CREATE(
                           ROW_CREATE(@"设置图片外观",@"UIImageTMUIViewController1"),
                           ROW_CREATE(@"图片创建、压缩、裁剪",@"UIImageTMUIViewController2"),
                           ).THEME_TITLE(@"UIImage+TMUI"),
            ).embedIn(self.view);
}

- (void)debug{
//    [self.navigationController pushViewController:[NSClassFromString(@"TDOneFoldLabelViewController") new] animated:YES];
    [self filter1];
    
}



- (void)filter1{
    
    TMUIFilterModel *filterModel1 = [[TMUIFilterModel alloc] init];
    filterModel1.title = @"装修公司所在区域";
    filterModel1.subtitle = @"根据装修公司门店所在区域，选择方便到店的装修公司";
    filterModel1.items = @[@"南山区",@"宝安区",@"福田区",@"龙岗区",@"罗湖区",@"盐田区"];
//    filterModel1.defalutItem = _b1_0;
//    filterModel1.
    TMUIFilterView *filterView = [[TMUIFilterView alloc] init];
    filterView.column = 4;
//    filterView.topInset = NavigationContentTop;
    filterView.models = @[filterModel1];
    [filterView showInView:self.tabBarController.view topInset:0];
    
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
