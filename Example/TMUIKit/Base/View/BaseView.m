//
//  BaseView.m
//  MyApp
//
//  Created by Jason on 2018/5/28.
//  Copyright © 2018年 Jason. All rights reserved.
//

#import "BaseView.h"

IB_DESIGNABLE
@implementation BaseView

+ (instancetype)view {
    return [[self alloc] init];
}

+ (instancetype)xibView {
    NSString* nibName = NSStringFromClass(self);
    
    NSArray* views = [[NSBundle mainBundle] loadNibNamed:nibName owner:nibName options:nil];
    for (UIView* view in views) {
        if ([nibName isEqualToString:NSStringFromClass(view.class)]) {
            return (BaseView *)view;
        }
    }
    
    return nil;
}


//    [self.layer applyShadow:_shadowColor alpha:_shadowAlpha x:_shadowX y:_shadowY blue:_shadowBlue spread:_shadowSpread];

- (void)setShadowColor:(UIColor *)shadowColor{
    _shadowColor = shadowColor;
    self.layer.shadowColor = _shadowColor.CGColor;
}

- (void)setShadowAlpha:(CGFloat)shadowAlpha{
    _shadowAlpha = shadowAlpha;
    self.layer.shadowOpacity = _shadowAlpha;
}

- (void)setShadowOffset:(CGPoint)shadowOffset{
    _shadowOffset = shadowOffset;
    self.layer.shadowOffset = CGSizeMake(_shadowOffset.x, _shadowOffset.y);
}

- (void)setShadowBlur:(CGFloat)shadowBlur{
    _shadowBlur = shadowBlur;
    self.layer.shadowRadius = _shadowBlur / 2.0;
}

- (void)setShadowSpread:(CGFloat)shadowSpread{
    _shadowSpread = shadowSpread;
    if (_shadowSpread == 0){
        self.layer.shadowPath = nil;
    } else {
        CGFloat dx = -_shadowSpread;
        CGRect rect = CGRectInset(self.layer.bounds, dx, dx);
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:rect].CGPath;
    }
}



- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius  = _cornerRadius;
    self.layer.masksToBounds = YES;
    
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}

- (void)applyShadowCorner:(float)cornerRadius color:(UIColor *)color alpha:(float)alpha x:(CGFloat)x y:(CGFloat)y blue:(CGFloat)blur spread:(CGFloat)spread{
    
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    
//    UIView *shadowView = [[UIView alloc] initWithFrame:self.frame];
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = self.frame;
    shadowLayer.shadowColor = color.CGColor;
    shadowLayer.shadowOpacity = alpha;
    shadowLayer.shadowOffset = CGSizeMake(x, y);
    shadowLayer.shadowRadius = blur / 2.0;
    if (spread == 0){
        shadowLayer.shadowPath = nil;
    } else {
        CGFloat dx = -spread;
        CGRect rect = CGRectInset(self.bounds, dx, dx);
        shadowLayer.shadowPath = [UIBezierPath bezierPathWithRect:rect].CGPath;
    }
    [self.superview.layer insertSublayer:shadowLayer below:self.layer];
}


@end
