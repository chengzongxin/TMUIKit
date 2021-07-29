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
    
}

- (UISegmentedControl *)addSegmentedWithLabelText:(NSString *)lbltext titles:(NSArray<NSString *> *)titles click:(void (^)(NSInteger))clickBlock{
    CGFloat y = [self getSubviewsTopViewBottom] - 44;
    return [self addSegmentedWithTop:y labelText:lbltext titles:titles click:clickBlock];
}

- (UISegmentedControl *)addSegmentedWithTop:(CGFloat)top labelText:(NSString *)lbltext titles:(NSArray<NSString *> *)titles click:(void (^)(NSInteger))clickBlock{
    UILabel *label = [[UILabel alloc] init];
    label.text = lbltext;
    label.textColor = UIColor.td_mainTextColor;
//    label.adjustsFontSizeToFitWidth = YES;
    label.font = UIFont(12);
    [self.view addSubview:label];
    
    TMUISegmentedControl *segmentedControl = [[TMUISegmentedControl alloc] initWithItems:titles];
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.clickBlock = clickBlock;
    // 可以比较大程度地修改样式。比如 tintColor，selectedTextColor
    [segmentedControl updateSegmentedUIWithTintColor:UIColor.td_tintColor selectedTextColor:UIColor.whiteColor fontSize:UIFontSemibold(18)];
    [self.view addSubview:segmentedControl];
    
    if (@available(iOS 13.0, *)) {
        segmentedControl.selectedSegmentTintColor = UIColor.td_tintColor;
//        s2.selectedSegmentTintColor = UIColor.td_tintColor;
//        s3.selectedSegmentTintColor = UIColor.td_tintColor;
    } else {
        // Fallback on earlier versions
    }
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(top);
    }];
    
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).offset(15);
        make.top.mas_equalTo(top);
        make.right.mas_offset(-20).priorityLow();
        make.centerY.mas_equalTo(label.mas_centerY);
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
    return [self addSliderWithTop:y labelText:lbltext slide:sliderBlock];
}

- (UISlider *)addSliderWithTop:(CGFloat)top labelText:(NSString *)lbltext slide:(void (^)(float))sliderBlock{
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
        make.top.mas_equalTo(top);
        make.size.mas_equalTo(CGSizeMake(80, 44));
    }];
    
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@120);
        make.top.mas_equalTo(top);
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
