//
//  CALayer+Extension.m
//  Futures
//
//  Created by Cheng on 2017/6/26.
//  Copyright © 2017年 Cheng. All rights reserved.
//

#import "CALayer+Extension.h"

@implementation CALayer (Extension)
- (void)setBorderColorWithUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

- (void)setBorderColorE:(UIColor *)color{
    self.borderColor = color.CGColor;
}

- (void)setBorderWidthE:(CGFloat)width{
    self.borderWidth = width;
}

-(void)setCorner:(CGFloat)cornerRadius{
    self.masksToBounds = YES;
    self.cornerRadius = cornerRadius;
}

@end
