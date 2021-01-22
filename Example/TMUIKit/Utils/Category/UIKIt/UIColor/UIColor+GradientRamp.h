//
//  UIColor+GradientRamp.h
//  Matafy
//
//  Created by sawyerzhang on 2018/1/28.
//  Copyright © 2018年 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (GradientRamp)
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;
@end
