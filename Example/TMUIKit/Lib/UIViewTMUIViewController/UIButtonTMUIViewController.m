//
//  UIButtonTMUIViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/22.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UIButtonTMUIViewController.h"

@interface UIButtonTMUIViewController ()

@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation UIButtonTMUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton tmui_button];
    btn.tmui_image = [UIImage imageNamed:@"icon_moreOperation_shareWeibo"];
    btn.tmui_text = @"yyds";
    
//    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.center = self.view.center;
    btn.backgroundColor = UIColor.grayColor;
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(-100);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"click button");
    }];
    
    [btn tmui_buttonImageTitleWithStyle:TMUIButtonImageTitleStyleLeft padding:0];
    
    /*
     TMUIButtonImageTitleStyleLeft = 0,          //图片在左，文字在右，整体居中。
     TMUIButtonImageTitleStyleRight,             //图片在右，文字在左，整体居中。
     TMUIButtonImageTitleStyleTop,               //图片在上，文字在下，整体居中。
     TMUIButtonImageTitleStyleBottom,            //图片在下，文字在上，整体居中。
     TMUIButtonImageTitleStyleCenterTop,         //图片居中，文字在上距离按钮顶部。
     TMUIButtonImageTitleStyleCenterBottom,      //图片居中，文字在下距离按钮底部。
     TMUIButtonImageTitleStyleCenterUp,          //图片居中，文字在图片上面。
     TMUIButtonImageTitleStyleCenterDown,        //图片居中，文字在图片下面。
     TMUIButtonImageTitleStyleRightLeft,         //图片在右，文字在左，距离按钮两边边距
     TMUIButtonImageTitleStyleLeftRight,         //图片在左，文字在右，距离按钮两边边距
     */
    @weakify(self);
    _segment = [self addSegmentedWithTop:520 labelText:@"图片位置:" titles:@[@"left",@"right",@"up",@"down"] click:^(NSInteger index) {
        @strongify(self);
        [btn tmui_buttonImageTitleWithStyle:index padding:self.slider.value];
    }];
    
    _slider = [self addSliderWithTop:570 labelText:@"图文间距" slide:^(float padding) {
        @strongify(self);
        [btn tmui_buttonImageTitleWithStyle:self.segment.selectedSegmentIndex padding:padding];
    }];
    
    [self addSliderWithTop:620 labelText:@"扩大响应范围:" slide:^(float padding) {
        [btn tmui_setEnlargeEdgeWithTop:padding right:padding bottom:padding left:padding];
    }];
    
    
    
}

@end
