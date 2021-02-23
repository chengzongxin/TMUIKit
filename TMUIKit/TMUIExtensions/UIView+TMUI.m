//
//  UIView+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/20.
//

#import "UIView+TMUI.h"
#import <objc/runtime.h>
#import "TMUIWeakObjectContainer.h"
#import "TMUIDefines.h"
#import "UIImage+TMUI.h"
#import "UIColor+TMUI.h"

@implementation UIView (TMUI)

+ (instancetype)tmui_view{
    return [[self alloc] init];
}

- (instancetype)tmui_initWithSize:(CGSize)size{
    return [self initWithFrame:CGRectMakeWithSize(size)];
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

@end

@implementation UIView (TMUI_Appearance)

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


- (void)tmui_shadowColor:(UIColor *)color
                 opacity:(float)opacity
              offsetSize:(CGSize)offset
                  corner:(int)corner{
    self.layer.shadowColor   = color.CGColor;//设置阴影的透明度
    self.layer.shadowOpacity = opacity;//设置阴影的透明度
    self.layer.shadowOffset  = offset;//设置阴影的偏移距离
    self.layer.shadowRadius  = corner;//设置阴影的圆角
}

- (void)tmui_borderColor:(UIColor *)borderColor
             borderWidth:(CGFloat)borderWidth{
    self.layer.borderColor = [borderColor CGColor];
    self.layer.borderWidth = borderWidth;
}


//实现背景渐变
-(void)tmui_gradientLeftToRightWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor{
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint endPoint = CGPointMake(1, 0);
    [self tmui_gradientWithStartColor:startColor endColor:endColor startPoint:startPoint endPoint:endPoint locations:@[@0.5] frame:self.layer.bounds];
}

-(void)tmui_gradientUpToDownWithStartColorToDown:(UIColor *)startColor endColor:(UIColor *)endColor{
    CGPoint startPoint = CGPointMake(1, 1);
    CGPoint endPoint = CGPointMake(1, 0);
    [self tmui_gradientWithStartColor:startColor endColor:endColor startPoint:startPoint endPoint:endPoint locations:@[@0.5] frame:self.layer.bounds];
}


-(void)tmui_gradientWithStartColor:(UIColor *)startColor
                          endColor:(UIColor *)endColor
                        startPoint:(CGPoint)startPoint
                          endPoint:(CGPoint)endPoint
                         locations:(NSArray<NSNumber *>*)locations
                             frame:(CGRect)frame{
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *gradientLayer  = [CAGradientLayer layer];
    
    for (CAGradientLayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:CAGradientLayer.class]) {
            gradientLayer = layer;
        }
    }
    if (!frame.size.height || !frame.size.height) {
        [self layoutIfNeeded];  // masonry 立即刷新界面
        frame = self.layer.bounds;
    }
    gradientLayer.frame = frame;
    gradientLayer.cornerRadius = self.layer.cornerRadius;
    gradientLayer.masksToBounds = YES;
    
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
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = UIColor.clearColor.CGColor;
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.lineWidth = width;
    [self.layer addSublayer:shapeLayer];
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



@implementation UIView (QMUI_ViewController)

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
//    return viewController.qmui_visibleState >= QMUIViewControllerWillAppear && viewController.qmui_visibleState < QMUIViewControllerWillDisappear;
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
