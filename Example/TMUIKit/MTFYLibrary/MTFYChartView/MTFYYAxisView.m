//
//  MTFYYAxisView.m
//  Matafy
//
//  Created by Tiaotiao on 2019/7/31.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYYAxisView.h"
#import "UIView+Extension.h"


@interface MTFYYAxisView ()

@property (strong, nonatomic) UIView *separate;

@end


@implementation MTFYYAxisView

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 垂直坐标轴
        UIView *separate = [[UIView alloc] init];
        self.separate = separate;
        [self addSubview:separate];
        
//        self.textFont = [UIFont systemFontOfSize:12];
    }
    return self;
}

#pragma mark - Public

- (void)draw {
    self.hidden = NO;
    self.backgroundColor = self.config.backColor;
    
    // 计算坐标轴的位置以及大小
    NSDictionary *attr = @{NSFontAttributeName : self.config.textFont};
    
    CGSize labelSize = [@"x" sizeWithAttributes:attr];
    
    self.separate.backgroundColor = self.config.axisColor;
    self.separate.x = self.width - 1;
    self.separate.width = 1;
    self.separate.y = 0;
    self.separate.height = self.height - labelSize.height - self.config.xAxisTextGap;
    
    // 为顶部留出的空白
    CGFloat topMargin = 25;
    
    // Label做占据的高度
    CGFloat allLabelHeight = self.height - topMargin - self.config.xAxisTextGap - labelSize.height;
    
    // Label之间的间隙
    CGFloat labelMargin = (allLabelHeight + labelSize.height - (self.config.numberOfYAxisElements + 1) * labelSize.height) / self.config.numberOfYAxisElements;
 
    // 移除所有的Label
    for (UILabel *label in self.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            [label removeFromSuperview];
        }
    }
    
    // 当数值大于10万时，单位按万显示
    //    if (self.yAxisMaxValue >= 100000) {
    //        self.yAxisMaxValue = self.yAxisMaxValue / 10000;
    //
    //        UILabel *label = [[UILabel alloc] init];
    //        label.text = @"万/10k";
    //
    //        label.font = self.textFont;
    //        label.textColor = self.textColor;
    //
    //        label.x = 0;
    //        label.y = 0;
    //        label.height = labelSize.height;
    //        label.width = self.width - 1 - self.yAxisTextGap;
    //
    //        [self addSubview:label];
    //    }
    
    // 添加Label
    for (int i = 0; i < self.config.numberOfYAxisElements + 1; i++) {
        UILabel *label = [[UILabel alloc] init];
        CGFloat avgValue = self.config.yAxisMaxValue / (self.config.numberOfYAxisElements);
        if (self.config.isPercent) {
            label.text = [NSString stringWithFormat:@"%.0f%%", avgValue * i];
        }else{
            label.text = [NSString stringWithFormat:@"%.0f", avgValue * i];
        }
        
        label.textAlignment = NSTextAlignmentRight;// UITextAlignmentRight;
        label.font = self.config.textFont;
        label.textColor = self.config.textColor;
        label.hidden = YES;
        label.x = 0;
        label.height = labelSize.height;
        label.y = self.height - labelSize.height - self.config.xAxisTextGap - (label.height + labelMargin) * i - label.height/2;
        label.width = self.width - 1 - self.config.yAxisTextGap;
        [self addSubview:label];
    }
}

- (void)reset {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.hidden = YES;
}

#pragma mark - Event Respone
#pragma mark - Delegate
#pragma mark - Private
#pragma mark - Getters and Setters
#pragma mark - Supperclass
#pragma mark - NSObject

@end

