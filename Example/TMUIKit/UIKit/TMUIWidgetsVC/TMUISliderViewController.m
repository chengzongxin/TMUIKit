//
//  TMUISliderViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/11.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUISliderViewController.h"

@interface TMUISliderViewController ()
@property(nonatomic, strong) TMUISlider *slider;
@property(nonatomic, strong) UISlider *systemSlider;
@property(nonatomic, strong) UILabel *label1;
@property(nonatomic, strong) UILabel *label2;
@end

@implementation TMUISliderViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    Label.str(self.demoInstructions).styles(h2).lineGap(5).addTo(self.view).makeCons(^{
        make.top.left.right.constants(NavigationContentTop+20,20,-20);
    });
    
    self.slider = [[TMUISlider alloc] init];
    self.slider.value = .3;
    self.slider.minimumTrackTintColor = UIColor.tmui_randomColor;
    self.slider.maximumTrackTintColor = UIColor.tmui_randomColor;
    self.slider.trackHeight = 1;// 支持修改背后导轨的高度
    self.slider.thumbColor = self.slider.minimumTrackTintColor;
    self.slider.thumbSize = CGSizeMake(20, 20);// 支持修改拖拽圆点的大小
    
    // 支持修改圆点的阴影样式
    self.slider.thumbShadowColor = [self.slider.minimumTrackTintColor colorWithAlphaComponent:.8];
    self.slider.thumbShadowOffset = CGSizeMake(5, 5);
    self.slider.thumbShadowRadius = 3;
    
    [self.view addSubview:self.slider];
    
    self.systemSlider = [[UISlider alloc] init];
    self.systemSlider.minimumTrackTintColor = self.slider.minimumTrackTintColor;
    self.systemSlider.maximumTrackTintColor = self.slider.maximumTrackTintColor;
    self.systemSlider.thumbTintColor = self.slider.minimumTrackTintColor;
    self.systemSlider.value = self.slider.value;
    [self.view addSubview:self.systemSlider];
    
    self.label1 = [[UILabel alloc] tmui_initWithFont:UIFontMake(14) textColor:UIColor.blackColor];
    self.label1.text = @"TMUISlider";
    [self.label1 sizeToFit];
    [self.view addSubview:self.label1];
    
    self.label2 = [[UILabel alloc] init];
//    [self.label2 tmui_setTheSameAppearanceAsLabel:self.label1];
    self.label2.text = @"UISlider";
    [self.label2 sizeToFit];
    [self.view addSubview:self.label2];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(64 + tmui_navigationBarHeight(), 24, 24, 24);
    
    self.label1.frame = CGRectSetXY(self.label1.frame, padding.left, padding.top);
    
    [self.slider sizeToFit];
    self.slider.frame = CGRectMake(padding.left, CGRectGetMaxY(self.label1.frame) + 16, CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding), CGRectGetHeight(self.slider.frame));
    
    self.label2.frame = CGRectSetXY(self.label2.frame, padding.left, CGRectGetMaxY(self.slider.frame) + 64);
    
    [self.systemSlider sizeToFit];
    self.systemSlider.frame = CGRectSetY(self.slider.frame, CGRectGetMaxY(self.label2.frame) + 16);
}

@end
