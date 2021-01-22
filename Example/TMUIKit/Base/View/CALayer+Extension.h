//
//  CALayer+Extension.h
//  Futures
//
//  Created by Cheng on 2017/6/26.
//  Copyright © 2017年 Cheng. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Extension)

// xib快速设置

// xib 设置边框颜色
- (void)setBorderColorWithUIColor:(UIColor *)color;
// xib 设置边框颜色
- (void)setBorderColorE:(UIColor *)color;
// xib 设置边框颜色
- (void)setBorderWidthE:(CGFloat)width;
// xib 设置圆角
-(void)setCorner:(CGFloat)cornerRadius;

@end
