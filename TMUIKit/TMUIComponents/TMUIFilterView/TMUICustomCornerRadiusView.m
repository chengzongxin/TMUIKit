//
//  TMUIFilterContentView.m
//  Demo
//
//  Created by Joe.cheng on 2022/3/30.
//

#import "TMUICustomCornerRadiusView.h"

@implementation TMUICustomCornerRadiusView

- (void)layoutSubviews {
    [super layoutSubviews];
    //圆角形状遮罩处理-每次frame变化都需要重新赋值，写在此处更加合理
    self.layer.mask = [self maskCornerRadiusLayer];
    //因相关渐变色在frame变化时也需要重新绘制，故在此处调用以下方法以便重绘
    [self setNeedsDisplay];
}

- (CALayer *)maskCornerRadiusLayer {
    CGRect rect = self.frame;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.customCornerRadius.leftTopRadius, 0)];
    [path addLineToPoint:CGPointMake(rect.size.width - self.customCornerRadius.rightTopRadius, 0)];
    if (self.customCornerRadius.rightTopRadius > 0) {
        [path addQuadCurveToPoint:CGPointMake(rect.size.width, self.customCornerRadius.rightTopRadius) controlPoint:CGPointMake(rect.size.width, 0)];
    }
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height - self.customCornerRadius.rightBottomRadius)];
    if (self.customCornerRadius.rightBottomRadius > 0) {
        [path addQuadCurveToPoint:CGPointMake(rect.size.width - self.customCornerRadius.rightBottomRadius, rect.size.height) controlPoint:CGPointMake(rect.size.width, rect.size.height)];
    }
    [path addLineToPoint:CGPointMake(self.customCornerRadius.leftBottomRadius, rect.size.height)];
    if (self.customCornerRadius.leftBottomRadius > 0) {
        [path addQuadCurveToPoint:CGPointMake(0, rect.size.height - self.customCornerRadius.leftBottomRadius) controlPoint:CGPointMake(0, rect.size.height)];
    }
    [path addLineToPoint:CGPointMake(0, self.customCornerRadius.leftTopRadius)];
    if (self.customCornerRadius.leftTopRadius > 0) {
        [path addQuadCurveToPoint:CGPointMake(self.customCornerRadius.leftTopRadius, 0) controlPoint:CGPointMake(0, 0)];
    }
    return [self maskShapeLayerOfPath:path.CGPath];
}


- (CAShapeLayer *)maskShapeLayerOfPath:(CGPathRef)path {
    if (!path) {
        return nil;
    }
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path;
    return maskLayer;
}

@end
