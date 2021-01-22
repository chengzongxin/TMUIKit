//
//  UIColor+GradientRamp.m
//  Matafy
//
//  Created by sawyerzhang on 2018/1/28.
//  Copyright © 2018年 com.upintech. All rights reserved.
//

#import "UIColor+GradientRamp.h"

@implementation UIColor (GradientRamp)
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr{
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:fromHexColorStr].CGColor,(__bridge id)[UIColor colorWithHexString:toHexColorStr].CGColor];
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)  (0,0)(1.0,0)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
 
    return gradientLayer;
}

@end
