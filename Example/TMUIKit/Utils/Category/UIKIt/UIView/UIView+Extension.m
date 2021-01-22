//
//  UIView+Extension.m
//  Matafy
//
//  Created by Cheng on 2018/1/19.
//  Copyright © 2018年 com.upintech. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

+ (instancetype)mtfy_viewFromXib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


// 半圆角
- (void)halfCircleCornerDirect:(UIRectCorner)direct radius:(int)radius {
    [self layoutIfNeeded];
    
    // 传0就默认高度一般(半圆)
    radius = radius?radius:self.bounds.size.height / 2;
    UIBezierPath *maskPath  = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:direct cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame         = self.bounds;
    maskLayer.path          = maskPath.CGPath;
    self.layer.mask         = maskLayer;
    self.layer.masksToBounds = YES;
}

- (void)halfAllCircleCornerWithRadius:(int)radius {
    [self halfCircleCornerDirect:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight radius:radius];
}

- (void)shadowCornerRadius:(int)corner color:(UIColor *)color opacity:(float)opacity offset:(int)offset radius:(int)radius{
    [self shadowCornerRadius:corner color:color opacity:opacity offsetSize:CGSizeMake(offset, offset) radius:radius];
}

- (void)shadowCornerRadius:(int)corner color:(UIColor *)color opacity:(float)opacity offsetSize:(CGSize)offset radius:(int)radius {
    // bgView 阴影圆角
    self.layer.cornerRadius  = corner;//设置imageView的圆角
    
    //        _bgView.layer.masksToBounds = YES;  // 设置这一句阴影无效
    self.layer.masksToBounds = NO;
    
    self.layer.shadowColor   = color.CGColor;//设置阴影的透明度
    
    self.layer.shadowOpacity = opacity;//设置阴影的透明度
    
    self.layer.shadowOffset  = offset;//设置阴影的偏移距离
    
    self.layer.shadowRadius  = radius;//设置阴影的圆角
}

- (void)setBorderForColor:(UIColor *)color
                    width:(float)width
                   radius:(float)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [color CGColor];
    self.layer.borderWidth = width;
}


- (void)setViewCornerRadius:(CGFloat)cornerRadius
                borderColor:(UIColor *)borderColor
                borderWidth:(CGFloat)borderWidth{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    [self setViewBorderColor:borderColor borderWidth:borderWidth];
}

- (void)setViewBorderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth{
    self.layer.borderColor = [borderColor CGColor];
    self.layer.borderWidth = borderWidth;
}


//实现背景渐变
-(void)setGradientColorWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    CGPoint startPoint = CGPointMake(1, 0);
    CGPoint endPoint = CGPointMake(1, 1);
    [self setGradientColorWithStartColor:startColor endColor:endColor startPoint:startPoint endPoint:endPoint locations:@[]];
}

-(void)setGradientColorWithStartColorToDown:(UIColor *)startColor endColor:(UIColor *)endColor {
    CGPoint startPoint = CGPointMake(1, 1);
    CGPoint endPoint = CGPointMake(1, 0);
    [self setGradientColorWithStartColor:startColor endColor:endColor startPoint:startPoint endPoint:endPoint locations:@[]];
}
-(void)setGradientColorWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locations:(NSArray<NSNumber *>*)locations {
    [self setGradientColorWithStartColor:startColor endColor:endColor startPoint:startPoint endPoint:endPoint locations:locations frame:self.layer.bounds];
}

-(void)setGradientColorWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locations:(NSArray<NSNumber *>*)locations frame:(CGRect)frame {
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *gradientLayer  = [CAGradientLayer layer];
    
    for (CAGradientLayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:CAGradientLayer.class]) {
            gradientLayer = layer;
        }
    }
    
    gradientLayer.frame = frame;
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)(startColor.CGColor), (__bridge id)endColor.CGColor];
    
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = locations;
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)addBorder:(UIColor *)color width:(CGFloat)width type:(UIRectEdge)rect {
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    switch (rect) {
        case UIRectEdgeAll:
            self.layer.borderWidth = width;
            self.layer.borderColor = color.CGColor;
            break;
        case UIRectEdgeLeft:
            [bezierPath moveToPoint:CGPointMake(0, self.height)];
            [bezierPath addLineToPoint:CGPointZero];
            break;
        case UIRectEdgeRight:
            [bezierPath moveToPoint:CGPointMake(self.width, 0)];
            [bezierPath addLineToPoint:CGPointMake(self.width, self.height)];
            break;
        case UIRectEdgeTop:
            [bezierPath moveToPoint:CGPointMake(0, 0)];
            [bezierPath addLineToPoint:CGPointMake(self.width, 0)];
            break;
        case UIRectEdgeBottom:
            [bezierPath moveToPoint:CGPointMake(0, self.height)];
            [bezierPath addLineToPoint:CGPointMake(self.width, self.height)];
            break;
        default:
            break;
    }
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = UIColor.clearColor.CGColor;
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.lineWidth = width;
    [self.layer addSublayer:shapeLayer];
}
@end
