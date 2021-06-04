//
//  UIView+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/20.
//

#import "UIView+TMUI.h"
#import <objc/runtime.h>
#import "TMUIWeakObjectContainer.h"
#import "TMUICoreGraphicsDefines.h"
#import "TMUIAssociatedPropertyDefines.h"
#import "UIImage+TMUI.h"
#import "UIColor+TMUI.h"
#import "NSArray+TMUI.h"
#import "TMUIHelper.h"
#import "TMUIRuntime.h"
#import "CALayer+TMUI.h"

@implementation UIView (TMUI)
TMUISynthesizeBOOLProperty(tmui_tintColorCustomized, setTmui_tintColorCustomized)
TMUISynthesizeIdCopyProperty(tmui_frameWillChangeBlock, setTmui_frameWillChangeBlock)
TMUISynthesizeIdCopyProperty(tmui_frameDidChangeBlock, setTmui_frameDidChangeBlock)
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//
//        ExtendImplementationOfVoidMethodWithSingleArgument([UIView class], @selector(setTintColor:), UIColor *, ^(UIView *selfObject, UIColor *tintColor) {
//            selfObject.tmui_tintColorCustomized = !!tintColor;
//        });
//
//        // 这个私有方法在 view 被调用 becomeFirstResponder 并且处于 window 上时，才会被调用，所以比 becomeFirstResponder 更适合用来检测
//        ExtendImplementationOfVoidMethodWithSingleArgument([UIView class], NSSelectorFromString(@"_didChangeToFirstResponder:"), id, ^(UIView *selfObject, id firstArgv) {
//            if (selfObject == firstArgv && [selfObject conformsToProtocol:@protocol(UITextInput)]) {
//                // 像 TMUIModalPresentationViewController 那种以 window 的形式展示浮层，浮层里的输入框 becomeFirstResponder 的场景，[window makeKeyAndVisible] 被调用后，就会立即走到这里，但此时该 window 尚不是 keyWindow，所以这里延迟到下一个 runloop 里再去判断
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (IS_DEBUG && ![selfObject isKindOfClass:[UIWindow class]] && selfObject.window && !selfObject.window.keyWindow) {
//                        [selfObject TMUISymbolicUIViewBecomeFirstResponderWithoutKeyWindow];
//                    }
//                });
//            }
//        });
//    });
//}

- (void)TMUISymbolicUIViewBecomeFirstResponderWithoutKeyWindow {
    NSLog(@"尝试让一个处于非 keyWindow 上的 %@ becomeFirstResponder，可能导致界面显示异常，请添加 '%@' 的 Symbolic Breakpoint 以捕捉此类信息\n%@", NSStringFromClass(self.class), NSStringFromSelector(_cmd), [NSThread callStackSymbols]);
}


+ (instancetype)tmui_view{
    return [[self alloc] init];
}

- (instancetype)tmui_initWithSize:(CGSize)size{
    return [self initWithFrame:CGRectMakeWithSize(size)];
}

- (UIEdgeInsets)tmui_safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}


static char kAssociatedObjectKey_outsideEdge;
- (void)setTmui_outsideEdge:(UIEdgeInsets)tmui_outsideEdge {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_outsideEdge, @(tmui_outsideEdge), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!UIEdgeInsetsEqualToEdgeInsets(tmui_outsideEdge, UIEdgeInsetsZero)) {
        [TMUIHelper executeBlock:^{
            OverrideImplementation([UIView class], @selector(pointInside:withEvent:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^BOOL(UIControl *selfObject, CGPoint point, UIEvent *event) {
                    
                    if (!UIEdgeInsetsEqualToEdgeInsets(selfObject.tmui_outsideEdge, UIEdgeInsetsZero)) {
                        CGRect rect = UIEdgeInsetsInsetRect(selfObject.bounds, selfObject.tmui_outsideEdge);
                        BOOL result = CGRectContainsPoint(rect, point);
                        return result;
                    }
                    
                    // call super
                    BOOL (*originSelectorIMP)(id, SEL, CGPoint, UIEvent *);
                    originSelectorIMP = (BOOL (*)(id, SEL, CGPoint, UIEvent *))originalIMPProvider();
                    BOOL result = originSelectorIMP(selfObject, originCMD, point, event);
                    return result;
                };
            });
        } oncePerIdentifier:@"UIView (TMUI) outsideEdge"];
    }
}

- (UIEdgeInsets)tmui_outsideEdge {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_outsideEdge)) UIEdgeInsetsValue];
}


static char kAssociatedObjectKey_tintColorDidChangeBlock;
- (void)setTmui_tintColorDidChangeBlock:(void (^)(__kindof UIView * _Nonnull))tmui_tintColorDidChangeBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_tintColorDidChangeBlock, tmui_tintColorDidChangeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (tmui_tintColorDidChangeBlock) {
        [TMUIHelper executeBlock:^{
            ExtendImplementationOfVoidMethodWithoutArguments([UIView class], @selector(tintColorDidChange), ^(UIView *selfObject) {
                if (selfObject.tmui_tintColorDidChangeBlock) {
                    selfObject.tmui_tintColorDidChangeBlock(selfObject);
                }
            });
        } oncePerIdentifier:@"UIView (TMUI) tintColorDidChangeBlock"];
    }
}

- (void (^)(__kindof UIView * _Nonnull))tmui_tintColorDidChangeBlock {
    return (void (^)(__kindof UIView * _Nonnull))objc_getAssociatedObject(self, &kAssociatedObjectKey_tintColorDidChangeBlock);
}

static char kAssociatedObjectKey_hitTestBlock;
- (void)setTmui_hitTestBlock:(__kindof UIView * _Nonnull (^)(CGPoint, UIEvent * _Nonnull, __kindof UIView * _Nonnull))tmui_hitTestBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_hitTestBlock, tmui_hitTestBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [TMUIHelper executeBlock:^{
        ExtendImplementationOfNonVoidMethodWithTwoArguments([UIView class], @selector(hitTest:withEvent:), CGPoint, UIEvent *, UIView *, ^UIView *(UIView *selfObject, CGPoint point, UIEvent *event, UIView *originReturnValue) {
            if (selfObject.tmui_hitTestBlock) {
                UIView *view = selfObject.tmui_hitTestBlock(point, event, originReturnValue);
                return view;
            }
            return originReturnValue;
        });
    } oncePerIdentifier:@"UIView (TMUI) hitTestBlock"];
}

- (__kindof UIView * _Nonnull (^)(CGPoint, UIEvent * _Nonnull, __kindof UIView * _Nonnull))tmui_hitTestBlock {
    return (__kindof UIView * _Nonnull (^)(CGPoint, UIEvent * _Nonnull, __kindof UIView * _Nonnull))objc_getAssociatedObject(self, &kAssociatedObjectKey_hitTestBlock);
}

- (void)setTmui_frameApplyTransform:(CGRect)tmui_frameApplyTransform {
    self.frame = CGRectApplyAffineTransformWithAnchorPoint(tmui_frameApplyTransform, self.transform, self.layer.anchorPoint);
}

- (CGRect)tmui_frameApplyTransform {
    return self.frame;
}

- (void)tmui_removeAllSubviews{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end

@implementation UIView (TMUI_Layout)

@dynamic top;
@dynamic bottom;
@dynamic left;
@dynamic right;

@dynamic width;
@dynamic height;

@dynamic size;

@dynamic x;
@dynamic y;

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.size.height + self.frame.origin.y;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.size.width + self.frame.origin.x;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)value
{
    CGRect frame = self.frame;
    frame.origin.x = value;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)value
{
    CGRect frame = self.frame;
    frame.origin.y = value;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


- (CGFloat)extendToTop {
    return self.top;
}

- (void)setExtendToTop:(CGFloat)extendToTop {
    self.height = self.bottom - extendToTop;
    self.top = extendToTop;
}

- (CGFloat)extendToLeft {
    return self.left;
}

- (void)setExtendToLeft:(CGFloat)extendToLeft {
    self.width = self.right - extendToLeft;
    self.left = extendToLeft;
}

- (CGFloat)extendToBottom {
    return self.bottom;
}

- (void)setExtendToBottom:(CGFloat)extendToBottom {
    self.height = extendToBottom - self.top;
    self.bottom = extendToBottom;
}

- (CGFloat)extendToRight {
    return self.right;
}

- (void)setExtendToRight:(CGFloat)extendToRight {
    self.width = extendToRight - self.left;
    self.right = extendToRight;
}

- (CGFloat)leftWhenCenterInSuperview {
    return CGFloatGetCenter(CGRectGetWidth(self.superview.bounds), CGRectGetWidth(self.frame));
}

- (CGFloat)topWhenCenterInSuperview {
    return CGFloatGetCenter(CGRectGetHeight(self.superview.bounds), CGRectGetHeight(self.frame));
}


- (CGFloat)tmui_top {
    return CGRectGetMinY(self.frame);
}

- (void)setTmui_top:(CGFloat)top {
    self.frame = CGRectSetY(self.frame, top);
}

- (CGFloat)tmui_left {
    return CGRectGetMinX(self.frame);
}

- (void)setTmui_left:(CGFloat)left {
    self.frame = CGRectSetX(self.frame, left);
}

- (CGFloat)tmui_bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setTmui_bottom:(CGFloat)bottom {
    self.frame = CGRectSetY(self.frame, bottom - CGRectGetHeight(self.frame));
}

- (CGFloat)tmui_right {
    return CGRectGetMaxX(self.frame);
}

- (void)setTmui_right:(CGFloat)right {
    self.frame = CGRectSetX(self.frame, right - CGRectGetWidth(self.frame));
}

- (CGFloat)tmui_width {
    return CGRectGetWidth(self.frame);
}

- (void)setTmui_width:(CGFloat)width {
    self.frame = CGRectSetWidth(self.frame, width);
}

- (CGFloat)tmui_height {
    return CGRectGetHeight(self.frame);
}

- (void)setTmui_height:(CGFloat)height {
    self.frame = CGRectSetHeight(self.frame, height);
}

- (CGFloat)tmui_extendToTop {
    return self.tmui_top;
}

- (void)setTmui_extendToTop:(CGFloat)tmui_extendToTop {
    self.tmui_height = self.tmui_bottom - tmui_extendToTop;
    self.tmui_top = tmui_extendToTop;
}

- (CGFloat)tmui_extendToLeft {
    return self.tmui_left;
}

- (void)setTmui_extendToLeft:(CGFloat)tmui_extendToLeft {
    self.tmui_width = self.tmui_right - tmui_extendToLeft;
    self.tmui_left = tmui_extendToLeft;
}

- (CGFloat)tmui_extendToBottom {
    return self.tmui_bottom;
}

- (void)setTmui_extendToBottom:(CGFloat)tmui_extendToBottom {
    self.tmui_height = tmui_extendToBottom - self.tmui_top;
    self.tmui_bottom = tmui_extendToBottom;
}

- (CGFloat)tmui_extendToRight {
    return self.tmui_right;
}

- (void)setTmui_extendToRight:(CGFloat)tmui_extendToRight {
    self.tmui_width = tmui_extendToRight - self.tmui_left;
    self.tmui_right = tmui_extendToRight;
}

- (CGFloat)tmui_leftWhenCenterInSuperview {
    return CGFloatGetCenter(CGRectGetWidth(self.superview.bounds), CGRectGetWidth(self.frame));
}

- (CGFloat)tmui_topWhenCenterInSuperview {
    return CGFloatGetCenter(CGRectGetHeight(self.superview.bounds), CGRectGetHeight(self.frame));
}


@end


const CGFloat TMUIViewSelfSizingHeight = INFINITY;

@implementation UIView (TMUI_Block)
//
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//
//        OverrideImplementation([UIView class], @selector(setFrame:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
//            return ^(UIView *selfObject, CGRect frame) {
//
//                // TMUIViewSelfSizingHeight 的功能
//                if (frame.size.width > 0 && isinf(frame.size.height)) {
//                    CGFloat height = flat([selfObject sizeThatFits:CGSizeMake(CGRectGetWidth(frame), CGFLOAT_MAX)].height);
//                    frame = CGRectSetHeight(frame, height);
//                }
//
//                // 对非法的 frame，Debug 下中 assert，Release 下会将其中的 NaN 改为 0，避免 crash
//                if (CGRectIsNaN(frame)) {
//                    NSLog(@"%@ setFrame:%@，参数包含 NaN，已被拦截并处理为 0。%@", selfObject, NSStringFromCGRect(frame), [NSThread callStackSymbols]);
////                    if (TMUICMIActivated && !ShouldPrintTMUIWarnLogToConsole) {
////                        NSAssert(NO, @"UIView setFrame: 出现 NaN");
////                    }
//                    if (!IS_DEBUG) {
//                        frame = CGRectSafeValue(frame);
//                    }
//                }
//
//                CGRect precedingFrame = selfObject.frame;
//                BOOL valueChange = !CGRectEqualToRect(frame, precedingFrame);
//                if (selfObject.tmui_frameWillChangeBlock && valueChange) {
//                    frame = selfObject.tmui_frameWillChangeBlock(selfObject, frame);
//                }
//
//                // call super
//                void (*originSelectorIMP)(id, SEL, CGRect);
//                originSelectorIMP = (void (*)(id, SEL, CGRect))originalIMPProvider();
//                originSelectorIMP(selfObject, originCMD, frame);
//
//                if (selfObject.tmui_frameDidChangeBlock && valueChange) {
//                    selfObject.tmui_frameDidChangeBlock(selfObject, precedingFrame);
//                }
//            };
//        });
//
//        OverrideImplementation([UIView class], @selector(setBounds:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
//            return ^(UIView *selfObject, CGRect bounds) {
//
//                CGRect precedingFrame = selfObject.frame;
//                CGRect precedingBounds = selfObject.bounds;
//                BOOL valueChange = !CGSizeEqualToSize(bounds.size, precedingBounds.size);// bounds 只有 size 发生变化才会影响 frame
//                if (selfObject.tmui_frameWillChangeBlock && valueChange) {
//                    CGRect followingFrame = CGRectMake(CGRectGetMinX(precedingFrame) + CGFloatGetCenter(CGRectGetWidth(bounds), CGRectGetWidth(precedingFrame)), CGRectGetMinY(precedingFrame) + CGFloatGetCenter(CGRectGetHeight(bounds), CGRectGetHeight(precedingFrame)), bounds.size.width, bounds.size.height);
//                    followingFrame = selfObject.tmui_frameWillChangeBlock(selfObject, followingFrame);
//                    bounds = CGRectSetSize(bounds, followingFrame.size);
//                }
//
//                // call super
//                void (*originSelectorIMP)(id, SEL, CGRect);
//                originSelectorIMP = (void (*)(id, SEL, CGRect))originalIMPProvider();
//                originSelectorIMP(selfObject, originCMD, bounds);
//
//                if (selfObject.tmui_frameDidChangeBlock && valueChange) {
//                    selfObject.tmui_frameDidChangeBlock(selfObject, precedingFrame);
//                }
//            };
//        });
//
//        OverrideImplementation([UIView class], @selector(setCenter:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
//            return ^(UIView *selfObject, CGPoint center) {
//
//                CGRect precedingFrame = selfObject.frame;
//                CGPoint precedingCenter = selfObject.center;
//                BOOL valueChange = !CGPointEqualToPoint(center, precedingCenter);
//                if (selfObject.tmui_frameWillChangeBlock && valueChange) {
//                    CGRect followingFrame = CGRectSetXY(precedingFrame, center.x - CGRectGetWidth(selfObject.frame) / 2, center.y - CGRectGetHeight(selfObject.frame) / 2);
//                    followingFrame = selfObject.tmui_frameWillChangeBlock(selfObject, followingFrame);
//                    center = CGPointMake(CGRectGetMidX(followingFrame), CGRectGetMidY(followingFrame));
//                }
//
//                // call super
//                void (*originSelectorIMP)(id, SEL, CGPoint);
//                originSelectorIMP = (void (*)(id, SEL, CGPoint))originalIMPProvider();
//                originSelectorIMP(selfObject, originCMD, center);
//
//                if (selfObject.tmui_frameDidChangeBlock && valueChange) {
//                    selfObject.tmui_frameDidChangeBlock(selfObject, precedingFrame);
//                }
//            };
//        });
//
//        OverrideImplementation([UIView class], @selector(setTransform:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
//            return ^(UIView *selfObject, CGAffineTransform transform) {
//
//                CGRect precedingFrame = selfObject.frame;
//                CGAffineTransform precedingTransform = selfObject.transform;
//                BOOL valueChange = !CGAffineTransformEqualToTransform(transform, precedingTransform);
//                if (selfObject.tmui_frameWillChangeBlock && valueChange) {
//                    CGRect followingFrame = CGRectApplyAffineTransformWithAnchorPoint(precedingFrame, transform, selfObject.layer.anchorPoint);
//                    selfObject.tmui_frameWillChangeBlock(selfObject, followingFrame);// 对于 CGAffineTransform，无法根据修改后的 rect 来算出新的 transform，所以就不修改 transform 的值了
//                }
//
//                // call super
//                void (*originSelectorIMP)(id, SEL, CGAffineTransform);
//                originSelectorIMP = (void (*)(id, SEL, CGAffineTransform))originalIMPProvider();
//                originSelectorIMP(selfObject, originCMD, transform);
//
//                if (selfObject.tmui_frameDidChangeBlock && valueChange) {
//                    selfObject.tmui_frameDidChangeBlock(selfObject, precedingFrame);
//                }
//            };
//        });
//    });
//}

@end

@implementation UIView (TMUI_Coordinate)

- (CGPoint)tmui_convertPoint:(CGPoint)point toViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point toWindow:nil];
        } else {
            return [self convertPoint:point toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point toView:view];
    point = [self convertPoint:point toView:from];
    point = [to convertPoint:point fromWindow:from];
    point = [view convertPoint:point fromView:to];
    return point;
}

- (CGPoint)tmui_convertPoint:(CGPoint)point fromViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point fromWindow:nil];
        } else {
            return [self convertPoint:point fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point fromView:view];
    point = [from convertPoint:point fromView:view];
    point = [to convertPoint:point fromWindow:from];
    point = [self convertPoint:point fromView:to];
    return point;
}

- (CGRect)tmui_convertRect:(CGRect)rect toViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect toWindow:nil];
        } else {
            return [self convertRect:rect toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if (!from || !to) return [self convertRect:rect toView:view];
    if (from == to) return [self convertRect:rect toView:view];
    rect = [self convertRect:rect toView:from];
    rect = [to convertRect:rect fromWindow:from];
    rect = [view convertRect:rect fromView:to];
    return rect;
}

- (CGRect)tmui_convertRect:(CGRect)rect fromViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect fromWindow:nil];
        } else {
            return [self convertRect:rect fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertRect:rect fromView:view];
    rect = [from convertRect:rect fromView:view];
    rect = [to convertRect:rect fromWindow:from];
    rect = [self convertRect:rect fromView:to];
    return rect;
}


@end


@interface UIView (TMUI_Appearance)
// 由于圆角和阴影是无法共存的，如果一定要同时设置，那就要在多创建的layer里去做

/// 圆角layer
@property(nonatomic, strong) CAShapeLayer *tmui_cornerLayer;

/// 阴影layer
@property(nonatomic, strong) CAShapeLayer *tmui_shadowLayer;

/// 边框layer
@property(nonatomic, strong) CAShapeLayer *tmui_borderLayer;

/// 渐变layer
@property(nonatomic, strong) CAGradientLayer *tmui_gradientLayer;

@end

@implementation UIView (TMUI_Appearance)

TMUISynthesizeIdStrongProperty(tmui_cornerLayer, setTmui_cornerLayer);
TMUISynthesizeIdStrongProperty(tmui_shadowLayer, setTmui_shadowLayer);
TMUISynthesizeIdStrongProperty(tmui_borderLayer, setTmui_borderLayer);
TMUISynthesizeIdStrongProperty(tmui_gradientLayer, setTmui_gradientLayer);

// 半圆角
- (void)tmui_cornerDirect:(UIRectCorner)direct radius:(int)radius {
    [self layoutIfNeeded];
    // 传0就默认高度一般(半圆)
    radius = radius?radius:self.bounds.size.height / 2;
    UIBezierPath *maskPath  = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:direct cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame         = self.bounds;
    maskLayer.path          = maskPath.CGPath;
    self.layer.mask         = maskLayer;
}


- (void)tmui_cornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    if (self.tmui_gradientLayer) {
        self.tmui_gradientLayer.cornerRadius = self.layer.cornerRadius;
    }
}

- (void)tmui_shadowColor:(UIColor *)color
                 opacity:(float)opacity
              offsetSize:(CGSize)offset
                  corner:(int)corner{
//    self.layer.masksToBounds = NO;
//    self.layer.shadowColor   = color.CGColor;//设置阴影的透明度
//    self.layer.shadowOpacity = opacity;//设置阴影的透明度
//    self.layer.shadowOffset  = offset;//设置阴影的偏移距离
//    self.layer.shadowRadius  = corner;//设置阴影的圆角
    [self.layer tmui_setLayerShadow:color offset:offset alpha:opacity radius:corner spread:0];
}

- (void)tmui_borderColor:(UIColor *)borderColor
             borderWidth:(CGFloat)borderWidth{
    self.layer.borderColor = [borderColor CGColor];
    self.layer.borderWidth = borderWidth;
}




// MARK: gradient colors

- (void)tmui_gradientWithColors:(NSArray<UIColor *> *)colors gradientType:(TMUIGradientType)gradientType{
    [self tmui_gradientWithColors:colors gradientType:gradientType locations:@[@0.5]];
}


- (void)tmui_gradientWithColors:(NSArray<UIColor *> *)colors gradientType:(TMUIGradientType)gradientType locations:(NSArray<NSNumber *> *)locations{
    CGRect frame = self.layer.bounds;
    if (CGRectIsEmpty(frame)) {
        [self layoutIfNeeded];  // masonry 
        frame = self.layer.bounds;
    }
    [self tmui_gradientWithColors:colors
                     gradientType:gradientType
                        locations:locations
                            frame:frame];
}


- (void)tmui_gradientWithColors:(NSArray <UIColor *>*)colors
                   gradientType:(TMUIGradientType)gradientType
                      locations:(NSArray<NSNumber *>*)locations
                          frame:(CGRect)frame{
    [self.tmui_gradientLayer removeFromSuperlayer];
    CAGradientLayer *gradientLayer  = [CAGradientLayer layer];
    
    gradientLayer.frame = frame;
    gradientLayer.cornerRadius = self.layer.cornerRadius;
    gradientLayer.masksToBounds = YES;
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    CGFloat startX = 0, startY = 0, endX = 0, endY = 0;
    switch (gradientType) {
        case TMUIGradientTypeTopLeftToBottomRight: {
            startX = 0;
            startY = 0;
            endX = 1;
            endY = 1;
        }
            break;
        case TMUIGradientTypeTopToBottom: {
            startX = 0;
            startY = 0;
            endX = 0;
            endY = 1;
        }
            break;
        case TMUIGradientTypeLeftToRight: {
            startX = 0;
            startY = 0;
            endX = 1;
            endY = 0;
        }
            break;
        case TMUIGradientTypeTopRightToBottomLeft: {
            startX = 0;
            startY = 1;
            endX = 1;
            endY = 0;
        }
            break;
        case TMUIGradientTypeBottomRightToTopLeft: {
            startX = 1;
            startY = 1;
            endX = 0;
            endY = 0;
        }
            break;
        case TMUIGradientTypeBottomLeftToTopRight: {
            startX = 1;
            startY = 0;
            endX = 1;
            endY = 0;
        }
            break;
    }
    gradientLayer.startPoint = CGPointMake(startX, startY);
    gradientLayer.endPoint = CGPointMake(endX, endY);
    
    //设置颜色数组
    colors = [colors tmui_map:^id _Nonnull(UIColor * _Nonnull item) {
        return (__bridge id)item.CGColor;
    }];
    gradientLayer.colors = colors;
    
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = locations;
    
    self.tmui_gradientLayer = gradientLayer;
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer insertSublayer:self.tmui_gradientLayer atIndex:1];
}


- (void)tmui_border:(UIColor *)color width:(CGFloat)width type:(UIRectEdge)rect {
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
    
    [self.tmui_borderLayer removeFromSuperlayer];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = UIColor.clearColor.CGColor;
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.lineWidth = width;
    self.tmui_borderLayer = shapeLayer;
    [self.layer insertSublayer:self.tmui_borderLayer atIndex:2];
}
@end


@implementation UIView (TMUI_IBInspectable)

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    if (cornerRadius > 0) {
        self.layer.masksToBounds = YES;
    }
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

static char bgColorHexStringKey;

- (void)setBgColorHexString:(NSString *)bgColorHexString {
    self.backgroundColor = [UIColor tmui_colorWithHexString:bgColorHexString];
    objc_setAssociatedObject(self, &bgColorHexStringKey, bgColorHexString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)bgColorHexString {
    return objc_getAssociatedObject(self, &bgColorHexStringKey);
}

static char borderColorHexStringKey;

- (void)setBorderColorHexString:(NSString *)borderColorHexString {
    self.layer.borderColor = [UIColor tmui_colorWithHexString:borderColorHexString].CGColor;
    objc_setAssociatedObject(self, &borderColorHexStringKey, borderColorHexString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)borderColorHexString {
    return objc_getAssociatedObject(self, &borderColorHexStringKey);
}


@end


static const char *tmui_p_singerTapBlockKey;
static const char *tmui_p_doubleTapBlockKey;
static const char *tmui_p_longPressGestureKey;
static const char *tmui_p_pinchGestureKey;
static const char *tmui_p_rotationGestureKey;
static const char *tmui_p_panGestureKey;
static const char *tmui_p_swipeGestureKey;

@implementation UIView (TMUI_Gesture)

- (void)tmui_addSingerTapWithBlock:(void (^)(void))tapBlock {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &tmui_p_singerTapBlockKey);
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_addSingerTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &tmui_p_singerTapBlockKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &tmui_p_singerTapBlockKey, tapBlock, OBJC_ASSOCIATION_COPY);
}

- (void)p_addSingerTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        void(^action)(void) = objc_getAssociatedObject(self, &tmui_p_singerTapBlockKey);
        if (action) {
            action();
        }
    }
}


- (void)tmui_addDoubleTapWithBlock:(void (^)(void))tapBlock {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &tmui_p_doubleTapBlockKey);
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_addDoubleTapGesture:)];
        //需要轻击的次数 默认为2
        gesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &tmui_p_doubleTapBlockKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &tmui_p_doubleTapBlockKey, tapBlock, OBJC_ASSOCIATION_COPY);
}

- (void)p_addDoubleTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
         void(^action)(void) = objc_getAssociatedObject(self, &tmui_p_doubleTapBlockKey);
         if (action) {
             action();
         }
     }
}

- (void)tmui_addLongPressGestureWithMinimumPressDuration:(NSTimeInterval)duration allowableMovement:(CGFloat)movement stateBegin:(void (^)(void))stateBeginBlock stateEnd:(void (^)(void))stateEndBlock {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = objc_getAssociatedObject(self, &tmui_p_longPressGestureKey);
    if (!longPress) {
        longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(p_addLongePressGesture:)];
        // 触发时间
        longPress.minimumPressDuration = duration;
        // 允许长按时间触发前允许手指滑动的范围，默认是10
        longPress.allowableMovement = movement;
        [self addGestureRecognizer:longPress];
        objc_setAssociatedObject(self, &tmui_p_longPressGestureKey, longPress, OBJC_ASSOCIATION_RETAIN);
    }
    
    void(^longPressStateBlock)(UIGestureRecognizerState state) = ^(UIGestureRecognizerState state) {
        switch (state) {
            case UIGestureRecognizerStateBegan:
                if (stateBeginBlock) {
                    stateBeginBlock();
                }
                break;
            case UIGestureRecognizerStateEnded:
                if (stateEndBlock) {
                    stateEndBlock();
                }
                break;
            default:
                break;
        }
    };
    objc_setAssociatedObject(self, &tmui_p_longPressGestureKey, longPressStateBlock, OBJC_ASSOCIATION_COPY);
}

- (void)tmui_addLongPressGestureWithMinimumPressDuration:(NSTimeInterval)duration stateBegin:(void (^)(void))stateBeginBlock stateEnd:(void (^)(void))stateEndBlock {
    [self tmui_addLongPressGestureWithMinimumPressDuration:duration allowableMovement:10 stateBegin:stateBeginBlock stateEnd:stateEndBlock];
}

- (void)p_addLongePressGesture:(UILongPressGestureRecognizer *)gesture {
    void(^action)(UIGestureRecognizerState state) = objc_getAssociatedObject(self, &tmui_p_longPressGestureKey);
    if (action) {
        action(gesture.state);
    }
}

- (void)tmui_addPinchGestureWithBlock:(void (^)(CGFloat, CGFloat, UIGestureRecognizerState))block {
    self.userInteractionEnabled = YES;
    UIPinchGestureRecognizer *gesture = objc_getAssociatedObject(self, &tmui_p_pinchGestureKey);
    if (!gesture) {
        gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(p_addPinchGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &tmui_p_pinchGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &tmui_p_pinchGestureKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)p_addPinchGesture:(UIPinchGestureRecognizer *)gesture {
     void(^action)(CGFloat scale, CGFloat velocity, UIGestureRecognizerState state) = objc_getAssociatedObject(self, &tmui_p_pinchGestureKey);
     if (action) {
         action(gesture.scale, gesture.velocity, gesture.state);
     }
}

- (void)tmui_addRotationGestureWithBlock:(void (^)(CGFloat, CGFloat, UIGestureRecognizerState))block {
 self.userInteractionEnabled = YES;
    UIRotationGestureRecognizer *gesture = objc_getAssociatedObject(self, &tmui_p_rotationGestureKey);
    if (!gesture) {
        gesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(p_addRotationGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &tmui_p_rotationGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &tmui_p_rotationGestureKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)p_addRotationGesture:(UIRotationGestureRecognizer *)gesture {
     void(^action)(CGFloat rotation, CGFloat velocity, UIGestureRecognizerState state) = objc_getAssociatedObject(self, &tmui_p_rotationGestureKey);
     if (action) {
         action(gesture.rotation, gesture.velocity, gesture.state);
     }
}


- (void)tmui_addPanGestureWithMinimumNumberOfTouches:(NSUInteger)min maximumNumberOfTouches:(NSUInteger)max block:(void (^)(CGPoint, UIGestureRecognizerState, UIPanGestureRecognizer *))block {
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *gesture = objc_getAssociatedObject(self, &tmui_p_panGestureKey);
    if (!gesture) {
        gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(p_addPanGesture:)];
        gesture.minimumNumberOfTouches = min;
        gesture.maximumNumberOfTouches = max;
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &tmui_p_panGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &tmui_p_panGestureKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)tmui_addPanGestureWithBlock:(void (^)(CGPoint, UIGestureRecognizerState, UIPanGestureRecognizer *))block {
    [self tmui_addPanGestureWithMinimumNumberOfTouches:1 maximumNumberOfTouches:UINT_MAX block:block];
}

- (void)p_addPanGesture:(UIPanGestureRecognizer *)gesture {
    void(^action)(CGPoint point, UIGestureRecognizerState state, UIPanGestureRecognizer *gesture) = objc_getAssociatedObject(self, &tmui_p_panGestureKey);
    if (action) {
        CGPoint point = [gesture translationInView:self];
        action(point, gesture.state, gesture);
    }
}

- (void)tmui_addSwipeGestureWithDirection:(UISwipeGestureRecognizerDirection)direction numberOfTouchesRequired:(NSUInteger)numberOfTouches block:(void (^)(UIGestureRecognizerState))block {
    self.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *gesture = objc_getAssociatedObject(self, &tmui_p_swipeGestureKey);
    if (!gesture) {
        gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(p_addSwipeGesture:)];
        gesture.direction = direction;
        gesture.numberOfTouchesRequired = numberOfTouches;
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &tmui_p_swipeGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &tmui_p_swipeGestureKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)tmui_addSwipeGestureWithDirection:(UISwipeGestureRecognizerDirection)direction block:(void (^)(UIGestureRecognizerState))block {
    [self tmui_addSwipeGestureWithDirection:direction numberOfTouchesRequired:1 block:block];
}

- (void)p_addSwipeGesture:(UISwipeGestureRecognizer *)gesture {
    void(^action)(UIGestureRecognizerState state) = objc_getAssociatedObject(self, &tmui_p_swipeGestureKey);
    if (action) {
        action(gesture.state);
    }
}

@end



@implementation UIView (TMUI_ViewController)

- (UIViewController *)tmui_viewController {
    return [[self class] tmui_viewControllerOfView:self];
}

+ (UIViewController *)tmui_viewControllerOfView:(UIView *)view {
    UIResponder *nextResponder = view;
    do {
        nextResponder = [nextResponder nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    } while (nextResponder != nil);

    return nil;
}

TMUISynthesizeBOOLProperty(tmui_isControllerRootView, setTmui_isControllerRootView)

- (BOOL)tmui_visible {
    if (self.hidden || self.alpha <= 0.01) {
        return NO;
    }
    if (self.window) {
        return YES;
    }
    if ([self isKindOfClass:UIWindow.class]) {
        if (@available(iOS 13.0, *)) {
            return !!((UIWindow *)self).windowScene;
        } else {
            return YES;
        }
    }
    
    return NO;
//    UIViewController *viewController = self.tmui_viewController;
//    return viewController.tmui_visibleState >= TMUIViewControllerWillAppear && viewController.tmui_visibleState < TMUIViewControllerWillDisappear;
}

//static char kAssociatedObjectKey_viewController;
//- (void)setTmui_viewController:(__kindof UIViewController * _Nullable)tmui_viewController {
//    TMUIWeakObjectContainer *weakContainer = objc_getAssociatedObject(self, &kAssociatedObjectKey_viewController);
//    if (!weakContainer) {
//        weakContainer = [[TMUIWeakObjectContainer alloc] init];
//    }
//    weakContainer.object = tmui_viewController;
//    objc_setAssociatedObject(self, &kAssociatedObjectKey_viewController, weakContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//    self.tmui_isControllerRootView = !!tmui_viewController;
//}
//
//- (__kindof UIViewController *)tmui_viewController {
//    if (self.tmui_isControllerRootView) {
//        return (__kindof UIViewController *)((TMUIWeakObjectContainer *)objc_getAssociatedObject(self, &kAssociatedObjectKey_viewController)).object;
//    }
//    return self.superview.tmui_viewController;
//}

@end

@implementation UIView (TMUI_Snapshotting)

- (UIImage *)tmui_snapshotLayerImage {
    return [UIImage tmui_imageWithView:self];
}

- (UIImage *)tmui_snapshotImageAfterScreenUpdates:(BOOL)afterScreenUpdates {
    return [UIImage tmui_imageWithView:self afterScreenUpdates:afterScreenUpdates];
}

@end



@implementation UIView (Animate)

- (void)tmui_animateWithDuration:(NSTimeInterval)duration animationType:(TMUIViewAnimationType)type completion:(void (^)(BOOL))completion {
    switch (type) {
        case TMUIViewAnimationTypeNone: {
            if (completion) {
                completion(YES);
            }
            break;
        }
        case TMUIViewAnimationTypeFadeIn: {
            CGFloat originAlpha = self.alpha;
            self.alpha = 0;
            [UIView animateWithDuration:duration animations:^{
                self.alpha = originAlpha;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion(finished);
                }
            }];
            break;
        }
        case TMUIViewAnimationTypeFadeOut: {
            [UIView animateWithDuration:duration animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion(finished);
                }
            }];
            break;
        }
        case TMUIViewAnimationTypeZoomIn: {
            self.transform = CGAffineTransformMakeScale(0, 0);
            [UIView animateWithDuration:duration animations:^{
                self.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                if (completion) {
                    completion(finished);
                }
            }];
            break;
        }
        case TMUIViewAnimationTypeZoomOut: {
            [UIView animateWithDuration:duration animations:^{
                self.transform = CGAffineTransformMakeScale(1.5, 1.5);
                self.alpha = 0;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion(finished);
                }
            }];
            break;
        }
        case TMUIViewAnimationTypeTopIn: {
            CGRect orginFrame = self.frame;
            self.frame = CGRectMake(orginFrame.origin.x, -orginFrame.size.height, orginFrame.size.width, orginFrame.size.height);
            [UIView animateWithDuration:duration animations:^{
                self.frame = orginFrame;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion(finished);
                }
            }];
            break;
        }
        case TMUIViewAnimationTypeTopOut: {
            CGRect orginFrame = self.frame;
            [UIView animateWithDuration:duration animations:^{
                self.frame = CGRectMake(orginFrame.origin.x, -orginFrame.size.height, orginFrame.size.width, orginFrame.size.height);
            } completion:^(BOOL finished) {
                if (completion) {
                    completion(finished);
                }
            }];
            break;
        }
        case TMUIViewAnimationTypeBottomIn: {
            CGRect orginFrame = self.frame;
            self.frame = CGRectMake(orginFrame.origin.x, [UIScreen mainScreen].bounds.size.height, orginFrame.size.width, orginFrame.size.height);
            [UIView animateWithDuration:duration animations:^{
                self.frame = orginFrame;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion(finished);
                }
            }];
            break;
        }
        case TMUIViewAnimationTypeBottomOut: {
            CGRect orginFrame = self.frame;
            [UIView animateWithDuration:duration animations:^{
                self.frame = CGRectMake(orginFrame.origin.x, [UIScreen mainScreen].bounds.size.height, orginFrame.size.width, orginFrame.size.height);
            } completion:^(BOOL finished) {
                if (completion) {
                    completion(finished);
                }
            }];
            break;
        }
    }
}
@end

@implementation UIView (TMUI_Nib)

+ (instancetype)tmui_instantiateFromNib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
}

+ (instancetype)tmui_loadNibViewWithFrame:(CGRect)frame {
    return [self tmui_loadNibViewWithFrame:frame nibName:NSStringFromClass([self class])];
}

+ (instancetype)tmui_loadNibViewWithName:(NSString *)name {
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
    return [self tmui_loadNibViewWithFrame:[currentWindow frame] nibName:name];
}

+ (instancetype)tmui_loadNibViewWithFrame:(CGRect)frame nibName:(NSString *)name {
    NSArray* nibView =  [[NSBundle bundleForClass:self] loadNibNamed:name owner:self options:nil];
    UIView *view =  [nibView objectAtIndex:0];
    view.frame = frame;
    return view;
}

@end


@implementation UIView (TMUI_Runtime)

- (BOOL)tmui_hasOverrideUIKitMethod:(SEL)selector {
    // 排序依照 Xcode Interface Builder 里的控件排序，但保证子类在父类前面
    NSMutableArray<Class> *viewSuperclasses = [[NSMutableArray alloc] initWithObjects:
                                               [UIStackView class],
                                               [UILabel class],
                                               [UIButton class],
                                               [UISegmentedControl class],
                                               [UITextField class],
                                               [UISlider class],
                                               [UISwitch class],
                                               [UIActivityIndicatorView class],
                                               [UIProgressView class],
                                               [UIPageControl class],
                                               [UIStepper class],
                                               [UITableView class],
                                               [UITableViewCell class],
                                               [UIImageView class],
                                               [UICollectionView class],
                                               [UICollectionViewCell class],
                                               [UICollectionReusableView class],
                                               [UITextView class],
                                               [UIScrollView class],
                                               [UIDatePicker class],
                                               [UIPickerView class],
                                               [UIVisualEffectView class],
                                               // Apple 不再接受使用了 UIWebView 的 App 提交，所以这里去掉 UIWebView
                                               // https://github.com/Tencent/TMUI_iOS/issues/741
//                                               [UIWebView class],
                                               [UIWindow class],
                                               [UINavigationBar class],
                                               [UIToolbar class],
                                               [UITabBar class],
                                               [UISearchBar class],
                                               [UIControl class],
                                               [UIView class],
                                               nil];
    
    for (NSInteger i = 0, l = viewSuperclasses.count; i < l; i++) {
        Class superclass = viewSuperclasses[i];
        if ([self tmui_hasOverrideMethod:selector ofSuperclass:superclass]) {
            return YES;
        }
    }
    return NO;
}

@end



@implementation UIView (TMUI_Debug)

TMUISynthesizeBOOLProperty(tmui_needsDifferentDebugColor, setTmui_needsDifferentDebugColor)
TMUISynthesizeBOOLProperty(tmui_hasDebugColor, setTmui_hasDebugColor)

static char kAssociatedObjectKey_shouldShowDebugColor;
- (void)setTmui_shouldShowDebugColor:(BOOL)tmui_shouldShowDebugColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_shouldShowDebugColor, @(tmui_shouldShowDebugColor), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (tmui_shouldShowDebugColor) {
        [TMUIHelper executeBlock:^{
            ExtendImplementationOfVoidMethodWithoutArguments([UIView class], @selector(layoutSubviews), ^(UIView *selfObject) {
                if (selfObject.tmui_shouldShowDebugColor) {
                    selfObject.tmui_hasDebugColor = YES;
                    selfObject.backgroundColor = [selfObject debugColor];
                    [selfObject renderColorWithSubviews:selfObject.subviews];
                }
            });
        } oncePerIdentifier:@"UIView (TMUIDebug) shouldShowDebugColor"];
        
        [self setNeedsLayout];
    }
}
- (BOOL)tmui_shouldShowDebugColor {
    BOOL flag = [objc_getAssociatedObject(self, &kAssociatedObjectKey_shouldShowDebugColor) boolValue];
    return flag;
}

static char kAssociatedObjectKey_layoutSubviewsBlock;
- (void)setTmui_layoutSubviewsBlock:(void (^)(__kindof UIView * _Nonnull))tmui_layoutSubviewsBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_layoutSubviewsBlock, tmui_layoutSubviewsBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    Class viewClass = self.class;
    [TMUIHelper executeBlock:^{
        ExtendImplementationOfVoidMethodWithoutArguments(viewClass, @selector(layoutSubviews), ^(__kindof UIView *selfObject) {
            if (selfObject.tmui_layoutSubviewsBlock && [selfObject isMemberOfClass:viewClass]) {
                selfObject.tmui_layoutSubviewsBlock(selfObject);
            }
        });
    } oncePerIdentifier:[NSString stringWithFormat:@"UIView %@-%@", NSStringFromClass(viewClass), NSStringFromSelector(@selector(layoutSubviews))]];
}

- (void (^)(UIView * _Nonnull))tmui_layoutSubviewsBlock {
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_layoutSubviewsBlock);
}

static char kAssociatedObjectKey_sizeThatFitsBlock;
- (void)setTmui_sizeThatFitsBlock:(CGSize (^)(__kindof UIView * _Nonnull, CGSize, CGSize))tmui_sizeThatFitsBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_sizeThatFitsBlock, tmui_sizeThatFitsBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (!tmui_sizeThatFitsBlock) return;
    
    // Extend 每个实例对象的类是为了保证比子类的 sizeThatFits 逻辑要更晚调用
    Class viewClass = self.class;
    [TMUIHelper executeBlock:^{
        ExtendImplementationOfNonVoidMethodWithSingleArgument(viewClass, @selector(sizeThatFits:), CGSize, CGSize, ^CGSize(UIView *selfObject, CGSize firstArgv, CGSize originReturnValue) {
            if (selfObject.tmui_sizeThatFitsBlock && [selfObject isMemberOfClass:viewClass]) {
                originReturnValue = selfObject.tmui_sizeThatFitsBlock(selfObject, firstArgv, originReturnValue);
            }
            return originReturnValue;
        });
    } oncePerIdentifier:[NSString stringWithFormat:@"UIView %@-%@", NSStringFromClass(viewClass), NSStringFromSelector(@selector(sizeThatFits:))]];
}

- (CGSize (^)(__kindof UIView * _Nonnull, CGSize, CGSize))tmui_sizeThatFitsBlock {
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_sizeThatFitsBlock);
}

- (void)renderColorWithSubviews:(NSArray *)subviews {
    for (UIView *view in subviews) {
        if ([view isKindOfClass:[UIStackView class]]) {
            UIStackView *stackView = (UIStackView *)view;
            [self renderColorWithSubviews:stackView.arrangedSubviews];
        }
        view.tmui_hasDebugColor = YES;
        view.tmui_shouldShowDebugColor = self.tmui_shouldShowDebugColor;
        view.tmui_needsDifferentDebugColor = self.tmui_needsDifferentDebugColor;
        view.backgroundColor = [self debugColor];
    }
}

- (UIColor *)debugColor {
    if (!self.tmui_needsDifferentDebugColor) {
        return UIColor.redColor;
    } else {
        return [[UIColor tmui_randomColor] colorWithAlphaComponent:.3];
    }
}

@end


@implementation UIView (TBTCategorAdd)

- (UIView *)tmui_subViewOfContainDescription:(NSString *)aString {
    if(![aString isKindOfClass:[NSString class]]){
        return nil;
    }
    if (@available(iOS 13.0, *)) {
        if ([@"UISearchBarTextField" isEqualToString:aString] && [self isKindOfClass:[UISearchBar class]]) {
            return ((UISearchBar *)self).searchTextField;
        }
    }
    UIView *aView = nil;
    NSMutableArray *views = [self.subviews mutableCopy];
    while (!aView && views.count>0) {
        UIView *temp = [views firstObject];
        if ([temp.description rangeOfString:aString].length>0) {
            aView = temp;
        }else{
            [views addObjectsFromArray:temp.subviews];
            [views removeObject:temp];
        }
    }
    return aView;
}


@end
