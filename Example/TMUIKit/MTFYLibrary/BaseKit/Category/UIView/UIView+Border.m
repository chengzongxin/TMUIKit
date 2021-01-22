//
//  UIView+Border.m
//  MU
//
//  Created by Fussa on 2020/3/1.
//  Copyright © 2020 Matafy. All rights reserved.
//

#import "UIView+Border.h"
#import <objc/runtime.h>

@implementation UIView (Border)

@dynamic borderColor,borderWidth,corderRadius;

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

-(void)setCorderRadius:(CGFloat)corderRadius {
    self.layer.cornerRadius = corderRadius;
    self.layer.masksToBounds = YES;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

@end
