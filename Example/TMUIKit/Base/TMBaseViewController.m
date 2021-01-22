//
//  TMBaseViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/22.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMBaseViewController.h"
#import "UISegmentedControl+associateObject.h"
#import "UISlider+associateObject.h"

@interface TMBaseViewController ()

@end

@implementation TMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
}


- (UISegmentedControl *)addSegmentedWithLabelText:(NSString *)lbltext titles:(NSArray<NSString *> *)titles click:(void (^)(NSInteger))clickBlock{
    CGFloat y = [self getSubviewsTopViewBottom] - 44;

    UILabel *label = [[UILabel alloc] init];
    label.text = lbltext;
    label.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:label];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:titles];
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.clickBlock = clickBlock;
    [self.view addSubview:segmentedControl];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(y);
        make.size.mas_equalTo(CGSizeMake(80, 44));
    }];
    
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@120);
        make.top.mas_equalTo(y);
        make.right.mas_offset(-20);
        make.height.mas_equalTo(44);
    }];
    
    return segmentedControl;
}


- (void)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl {
    NSInteger index = segmentedControl.selectedSegmentIndex;
    NSLog(@"%zd",index);
    !segmentedControl.clickBlock ?: segmentedControl.clickBlock(index);
}


- (UISlider *)addSliderWithLabelText:(NSString *)lbltext slide:(void (^)(float))sliderBlock{
    CGFloat y = [self getSubviewsTopViewBottom] - 44;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = lbltext;
    label.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:label];
    
    UISlider *slider = [[UISlider alloc] init];
    slider.minimumValue = 0;
    slider.maximumValue = 100;
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    slider.slideBlock = sliderBlock;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(y);
        make.size.mas_equalTo(CGSizeMake(80, 44));
    }];
    
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@120);
        make.top.mas_equalTo(y);
        make.right.mas_offset(-20);
        make.height.mas_equalTo(44);
    }];
    
    return slider;
}

- (void)sliderValueChanged:(UISlider *)slider{
    NSLog(@"%f",slider.value);
    !slider.slideBlock ?: slider.slideBlock(slider.value);
}


/// 获取最底下的view
- (CGFloat)getSubviewsTopViewBottom{
    // 强迫立即刷新，view调用的方法为rootview，刷新它的子类。
    [self.view layoutIfNeeded];
    CGFloat y = self.view.height -  tmui_safeAreaBottomInset();
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:UISegmentedControl.class] || [view isKindOfClass:UISlider.class]) {
            y = MIN(view.y, y);
        }
    }
    return y;
}

@end
