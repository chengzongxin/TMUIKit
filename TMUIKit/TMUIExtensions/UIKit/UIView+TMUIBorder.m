//
//  UIView+TMUIBorder.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/18.
//

#import "UIView+TMUIBorder.h"
#import "TMUIBasicDefines.h"
#import "TMUICommonDefines.h"
#import "CALayer+TMUI.h"
#import <objc/runtime.h>
#import "TMUIAssociatedPropertyDefines.h"
#import "TMUIRuntime.h"
#import "TMUIConfigurationMacros.h"


@interface CAShapeLayer (TMUIBorder)

@property(nonatomic, weak) UIView *_tmuibd_targetBorderView;
@end

@implementation UIView (TMUIBorder)

TMUISynthesizeIdStrongProperty(tmui_borderLayer, setTmui_borderLayer)

//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//
//        ExtendImplementationOfNonVoidMethodWithSingleArgument([UIView class], @selector(initWithFrame:), CGRect, UIView *, ^UIView *(UIView *selfObject, CGRect frame, UIView *originReturnValue) {
//            [selfObject _tmuibd_setDefaultStyle];
//            return originReturnValue;
//        });
//
//        ExtendImplementationOfNonVoidMethodWithSingleArgument([UIView class], @selector(initWithCoder:), NSCoder *, UIView *, ^UIView *(UIView *selfObject, NSCoder *aDecoder, UIView *originReturnValue) {
//            [selfObject _tmuibd_setDefaultStyle];
//            return originReturnValue;
//        });
//    });
//}

- (void)_tmuibd_setDefaultStyle {
    self.tmui_borderWidth = PixelOne;
    self.tmui_borderColor = UIColorSeparator;
}

- (void)_tmuibd_createBorderLayerIfNeeded {
    BOOL shouldShowBorder = self.tmui_borderWidth > 0 && self.tmui_borderColor && self.tmui_borderPosition != TMUIViewBorderPositionNone;
    if (!shouldShowBorder) {
        self.tmui_borderLayer.hidden = YES;
        return;
    }
    
    [TMUIHelper executeBlock:^{
        OverrideImplementation([UIView class], @selector(layoutSublayersOfLayer:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIView *selfObject, CALayer *firstArgv) {
                
                // call super
                void (*originSelectorIMP)(id, SEL, CALayer *);
                originSelectorIMP = (void (*)(id, SEL, CALayer *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, firstArgv);
                
                if (!selfObject.tmui_borderLayer || selfObject.tmui_borderLayer.hidden) return;
                selfObject.tmui_borderLayer.frame = selfObject.bounds;
                [selfObject.layer tmui_bringSublayerToFront:selfObject.tmui_borderLayer];
                [selfObject.tmui_borderLayer setNeedsLayout];// 把布局刷新逻辑剥离到 layer 内，方便在子线程里直接刷新 layer，如果放在 UIView 内，子线程里就无法主动请求刷新了
            };
        });
    } oncePerIdentifier:@"UIView (TMUIBorder) layoutSublayers"];
    
    if (!self.tmui_borderLayer) {
        self.tmui_borderLayer = [CAShapeLayer layer];
        self.tmui_borderLayer._tmuibd_targetBorderView = self;
        [self.tmui_borderLayer tmui_removeDefaultAnimations];
        self.tmui_borderLayer.fillColor = UIColorClear.CGColor;
        [self.layer addSublayer:self.tmui_borderLayer];
    }
    self.tmui_borderLayer.lineWidth = self.tmui_borderWidth;
    self.tmui_borderLayer.strokeColor = self.tmui_borderColor.CGColor;
    self.tmui_borderLayer.lineDashPhase = self.tmui_dashPhase;
    self.tmui_borderLayer.lineDashPattern = self.tmui_dashPattern;
    self.tmui_borderLayer.hidden = NO;
}

static char kAssociatedObjectKey_borderLocation;
- (void)setTmui_borderLocation:(TMUIViewBorderLocation)tmui_borderLocation {
    BOOL shouldUpdateLayout = self.tmui_borderLocation != tmui_borderLocation;
    objc_setAssociatedObject(self, &kAssociatedObjectKey_borderLocation, @(tmui_borderLocation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _tmuibd_createBorderLayerIfNeeded];
    if (shouldUpdateLayout) {
        [self setNeedsLayout];
    }
}

- (TMUIViewBorderLocation)tmui_borderLocation {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_borderLocation)) unsignedIntegerValue];
}

static char kAssociatedObjectKey_borderPosition;
- (void)setTmui_borderPosition:(TMUIViewBorderPosition)tmui_borderPosition {
    BOOL shouldUpdateLayout = self.tmui_borderPosition != tmui_borderPosition;
    objc_setAssociatedObject(self, &kAssociatedObjectKey_borderPosition, @(tmui_borderPosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _tmuibd_createBorderLayerIfNeeded];
    if (shouldUpdateLayout) {
        [self setNeedsLayout];
    }
}

- (TMUIViewBorderPosition)tmui_borderPosition {
    return (TMUIViewBorderPosition)[objc_getAssociatedObject(self, &kAssociatedObjectKey_borderPosition) unsignedIntegerValue];
}

static char kAssociatedObjectKey_borderWidth;
- (void)setTmui_borderWidth:(CGFloat)tmui_borderWidth {
    BOOL shouldUpdateLayout = self.tmui_borderWidth != tmui_borderWidth;
    objc_setAssociatedObject(self, &kAssociatedObjectKey_borderWidth, @(tmui_borderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _tmuibd_createBorderLayerIfNeeded];
    if (shouldUpdateLayout) {
        [self setNeedsLayout];
    }
}

- (CGFloat)tmui_borderWidth {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_borderWidth)) doubleValue];
}

static char kAssociatedObjectKey_borderColor;
- (void)setTmui_borderColor:(UIColor *)tmui_borderColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_borderColor, tmui_borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _tmuibd_createBorderLayerIfNeeded];
    [self setNeedsLayout];
}

- (UIColor *)tmui_borderColor {
    return (UIColor *)objc_getAssociatedObject(self, &kAssociatedObjectKey_borderColor);
}

static char kAssociatedObjectKey_dashPhase;
- (void)setTmui_dashPhase:(CGFloat)tmui_dashPhase {
    BOOL shouldUpdateLayout = self.tmui_dashPhase != tmui_dashPhase;
    objc_setAssociatedObject(self, &kAssociatedObjectKey_dashPhase, @(tmui_dashPhase), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _tmuibd_createBorderLayerIfNeeded];
    if (shouldUpdateLayout) {
        [self setNeedsLayout];
    }
}

- (CGFloat)tmui_dashPhase {
    return [(NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_dashPhase) doubleValue];
}

static char kAssociatedObjectKey_dashPattern;
- (void)setTmui_dashPattern:(NSArray<NSNumber *> *)tmui_dashPattern {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_dashPattern, tmui_dashPattern, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _tmuibd_createBorderLayerIfNeeded];
    [self setNeedsLayout];
}

- (NSArray *)tmui_dashPattern {
    return (NSArray<NSNumber *> *)objc_getAssociatedObject(self, &kAssociatedObjectKey_dashPattern);
}

@end

@implementation CAShapeLayer (TMUIBorder)
TMUISynthesizeIdWeakProperty(_tmuibd_targetBorderView, set_tmuibd_targetBorderView)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ExtendImplementationOfVoidMethodWithoutArguments([CAShapeLayer class], @selector(layoutSublayers), ^(CAShapeLayer *selfObject) {
            if (!selfObject._tmuibd_targetBorderView) return;
            
            UIView *view = selfObject._tmuibd_targetBorderView;
            CGFloat borderWidth = selfObject.lineWidth;
            
            UIBezierPath *path = [UIBezierPath bezierPath];;
            
            CGFloat (^adjustsLocation)(CGFloat, CGFloat, CGFloat) = ^CGFloat(CGFloat inside, CGFloat center, CGFloat outside) {
                return view.tmui_borderLocation == TMUIViewBorderLocationInside ? inside : (view.tmui_borderLocation == TMUIViewBorderLocationCenter ? center : outside);
            };
            
            CGFloat lineOffset = adjustsLocation(borderWidth / 2.0, 0, -borderWidth / 2.0); // 为了像素对齐而做的偏移
            CGFloat lineCapOffset = adjustsLocation(0, borderWidth / 2.0, borderWidth); // 两条相邻的边框连接的位置
            
            BOOL shouldShowTopBorder = (view.tmui_borderPosition & TMUIViewBorderPositionTop) == TMUIViewBorderPositionTop;
            BOOL shouldShowLeftBorder = (view.tmui_borderPosition & TMUIViewBorderPositionLeft) == TMUIViewBorderPositionLeft;
            BOOL shouldShowBottomBorder = (view.tmui_borderPosition & TMUIViewBorderPositionBottom) == TMUIViewBorderPositionBottom;
            BOOL shouldShowRightBorder = (view.tmui_borderPosition & TMUIViewBorderPositionRight) == TMUIViewBorderPositionRight;
            
            UIBezierPath *topPath = [UIBezierPath bezierPath];
            UIBezierPath *leftPath = [UIBezierPath bezierPath];
            UIBezierPath *bottomPath = [UIBezierPath bezierPath];
            UIBezierPath *rightPath = [UIBezierPath bezierPath];
            
            if (view.layer.tmui_originCornerRadius > 0) {
                
                CGFloat cornerRadius = view.layer.tmui_originCornerRadius;
                
                if (view.layer.tmui_maskedCorners) {
                    if ((view.layer.tmui_maskedCorners & TMUILayerMinXMinYCorner) == TMUILayerMinXMinYCorner) {
                        [topPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:1.25 * M_PI endAngle:1.5 * M_PI clockwise:YES];
                        [topPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, lineOffset)];
                        [leftPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:-0.75 * M_PI endAngle:-1 * M_PI clockwise:NO];
                        [leftPath addLineToPoint:CGPointMake(lineOffset, CGRectGetHeight(selfObject.bounds) - cornerRadius)];
                    } else {
                        [topPath moveToPoint:CGPointMake(shouldShowLeftBorder ? -lineCapOffset : 0, lineOffset)];
                        [topPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, lineOffset)];
                        [leftPath moveToPoint:CGPointMake(lineOffset, shouldShowTopBorder ? -lineCapOffset : 0)];
                        [leftPath addLineToPoint:CGPointMake(lineOffset, CGRectGetHeight(selfObject.bounds) - cornerRadius)];
                    }
                    if ((view.layer.tmui_maskedCorners & TMUILayerMinXMaxYCorner) == TMUILayerMinXMaxYCorner) {
                        [leftPath addArcWithCenter:CGPointMake(cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1 * M_PI endAngle:-1.25 * M_PI clockwise:NO];
                        [bottomPath addArcWithCenter:CGPointMake(cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1.25 * M_PI endAngle:-1.5 * M_PI clockwise:NO];
                        [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, CGRectGetHeight(selfObject.bounds) - lineOffset)];
                    } else {
                        [leftPath addLineToPoint:CGPointMake(lineOffset, CGRectGetHeight(selfObject.bounds) + (shouldShowBottomBorder ? lineCapOffset : 0))];
                        CGFloat y = CGRectGetHeight(selfObject.bounds) - lineOffset;
                        [bottomPath moveToPoint:CGPointMake(shouldShowLeftBorder ? -lineCapOffset : 0, y)];
                        [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, y)];
                    }
                    if ((view.layer.tmui_maskedCorners & TMUILayerMaxXMaxYCorner) == TMUILayerMaxXMaxYCorner) {
                        [bottomPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1.5 * M_PI endAngle:-1.75 * M_PI clockwise:NO];
                        [rightPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1.75 * M_PI endAngle:-2 * M_PI clockwise:NO];
                        [rightPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - lineOffset, cornerRadius)];
                    } else {
                        CGFloat y = CGRectGetHeight(selfObject.bounds) - lineOffset;
                        [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) + (shouldShowRightBorder ? lineCapOffset : 0), y)];
                        CGFloat x = CGRectGetWidth(selfObject.bounds) - lineOffset;
                        [rightPath moveToPoint:CGPointMake(x, CGRectGetHeight(selfObject.bounds) + (shouldShowBottomBorder ? lineCapOffset : 0))];
                        [rightPath addLineToPoint:CGPointMake(x, cornerRadius)];
                    }
                    if ((view.layer.tmui_maskedCorners & TMUILayerMaxXMinYCorner) == TMUILayerMaxXMinYCorner) {
                        [rightPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:0 * M_PI endAngle:-0.25 * M_PI clockwise:NO];
                        [topPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:1.5 * M_PI endAngle:1.75 * M_PI clockwise:YES];
                    } else {
                        CGFloat x = CGRectGetWidth(selfObject.bounds) - lineOffset;
                        [rightPath addLineToPoint:CGPointMake(x, shouldShowTopBorder ? -lineCapOffset : 0)];
                        [topPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) + (shouldShowRightBorder ? lineCapOffset : 0), lineOffset)];
                    }
                } else {
                    [topPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:1.25 * M_PI endAngle:1.5 * M_PI clockwise:YES];
                    [topPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, lineOffset)];
                    [topPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:1.5 * M_PI endAngle:1.75 * M_PI clockwise:YES];
                    
                    [leftPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:-0.75 * M_PI endAngle:-1 * M_PI clockwise:NO];
                    [leftPath addLineToPoint:CGPointMake(lineOffset, CGRectGetHeight(selfObject.bounds) - cornerRadius)];
                    [leftPath addArcWithCenter:CGPointMake(cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1 * M_PI endAngle:-1.25 * M_PI clockwise:NO];
                    
                    [bottomPath addArcWithCenter:CGPointMake(cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1.25 * M_PI endAngle:-1.5 * M_PI clockwise:NO];
                    [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, CGRectGetHeight(selfObject.bounds) - lineOffset)];
                    [bottomPath addArcWithCenter:CGPointMake(CGRectGetHeight(selfObject.bounds) - cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1.5 * M_PI endAngle:-1.75 * M_PI clockwise:NO];
                    
                    [rightPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, CGRectGetHeight(selfObject.bounds) - cornerRadius) radius:cornerRadius - lineOffset startAngle:-1.75 * M_PI endAngle:-2 * M_PI clockwise:NO];
                    [rightPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) - lineOffset, cornerRadius)];
                    [rightPath addArcWithCenter:CGPointMake(CGRectGetWidth(selfObject.bounds) - cornerRadius, cornerRadius) radius:cornerRadius - lineOffset startAngle:0 * M_PI endAngle:-0.25 * M_PI clockwise:NO];
                }
                
            } else {
                [topPath moveToPoint:CGPointMake(shouldShowLeftBorder ? -lineCapOffset : 0, lineOffset)];
                [topPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) + (shouldShowRightBorder ? lineCapOffset : 0), lineOffset)];
                
                [leftPath moveToPoint:CGPointMake(lineOffset, shouldShowTopBorder ? -lineCapOffset : 0)];
                [leftPath addLineToPoint:CGPointMake(lineOffset, CGRectGetHeight(selfObject.bounds) + (shouldShowBottomBorder ? lineCapOffset : 0))];
                
                CGFloat y = CGRectGetHeight(selfObject.bounds) - lineOffset;
                [bottomPath moveToPoint:CGPointMake(shouldShowLeftBorder ? -lineCapOffset : 0, y)];
                [bottomPath addLineToPoint:CGPointMake(CGRectGetWidth(selfObject.bounds) + (shouldShowRightBorder ? lineCapOffset : 0), y)];
                
                CGFloat x = CGRectGetWidth(selfObject.bounds) - lineOffset;
                [rightPath moveToPoint:CGPointMake(x, CGRectGetHeight(selfObject.bounds) + (shouldShowBottomBorder ? lineCapOffset : 0))];
                [rightPath addLineToPoint:CGPointMake(x, shouldShowTopBorder ? -lineCapOffset : 0)];
            }
            
            if (shouldShowTopBorder && ![topPath isEmpty]) {
                [path appendPath:topPath];
            }
            if (shouldShowLeftBorder && ![leftPath isEmpty]) {
                [path appendPath:leftPath];
            }
            if (shouldShowBottomBorder && ![bottomPath isEmpty]) {
                [path appendPath:bottomPath];
            }
            if (shouldShowRightBorder && ![rightPath isEmpty]) {
                [path appendPath:rightPath];
            }
            
            selfObject.path = path.CGPath;
        });
    });
}
@end
