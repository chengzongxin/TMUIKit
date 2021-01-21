//
//  UIView+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TMUI)

+ (instancetype)tmui_viewFromXib;

@end

@interface UIView (TMUI_Layout)

@property (assign, nonatomic) CGFloat   top;
@property (assign, nonatomic) CGFloat   bottom;
@property (assign, nonatomic) CGFloat   left;
@property (assign, nonatomic) CGFloat   right;

@property (assign, nonatomic) CGFloat   x;
@property (assign, nonatomic) CGFloat   y;
@property (assign, nonatomic) CGPoint   origin;

@property (assign, nonatomic) CGFloat   centerX;
@property (assign, nonatomic) CGFloat   centerY;

@property (assign, nonatomic) CGFloat   width;
@property (assign, nonatomic) CGFloat   height;
@property (assign, nonatomic) CGSize    size;


@end

@interface UIView (TMUI_Appearance)


/**
 设置半圆View

 @param direct 半圆的方向
 UIRectCornerTopLeft     = 1 << 0,
 UIRectCornerTopRight    = 1 << 1,
 UIRectCornerBottomLeft  = 1 << 2,
 UIRectCornerBottomRight = 1 << 3,
 
 @param radius 半圆半径,传0就默认高度一般(半圆)
 */
- (void)halfCircleCornerDirect:(UIRectCorner)direct radius:(int)radius;


/**
 设置View和View的阴影圆角
 
 @param corner 设置View的圆角
 @param color   阴影的颜色
 @param opacity 阴影的透明度
 @param offset 阴影的偏移距离
 @param radius 阴影的圆角
 */
- (void)shadowCornerRadius:(int)corner color:(UIColor *)color opacity:(float)opacity offsetSize:(CGSize)offset radius:(int)radius;



/**
 设置View边框和颜色

 @param color 颜色
 @param width 宽度
 @param radius 圆角
 */
- (void)setBorderForColor:(UIColor *)color
                    width:(float)width
                   radius:(float)radius;


/**
 设置View圆角,边框和颜色

 @param cornerRadius 圆角
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 */
- (void)setViewCornerRadius:(CGFloat)cornerRadius
                borderColor:(UIColor *)borderColor
                borderWidth:(CGFloat)borderWidth;


/**
 设置View边框和颜色
 
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 */
- (void)setViewBorderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth;


/**
 设置View背景颜色渐变
 @param startColor 起始颜色
 @param endColor 结束颜色
 */
-(void)setGradientColorWithStartColor:(UIColor *)startColor
                             endColor:(UIColor *)endColor;


//
-(void)setGradientColorWithStartColorToDown:(UIColor *)startColor endColor:(UIColor *)endColor;;

/**
 设置View背景颜色渐变
 @param startColor 起始颜色
 @param endColor 结束颜色
 @param startPoint 开始位置
 @param endPoint 结束位置
 @param locations 颜色分割点
 */
-(void)setGradientColorWithStartColor:(UIColor *)startColor
                             endColor:(UIColor *)endColor
                           startPoint:(CGPoint)startPoint
                             endPoint:(CGPoint)endPoint
                            locations:(NSArray<NSNumber *>*)locations;

/**
设置View背景颜色渐变
@param startColor 起始颜色
@param endColor 结束颜色
@param startPoint 开始位置
@param endPoint 结束位置
@param locations 颜色分割点
@param frame  渐变frame，页面没初始化需添加frame
*/
-(void)setGradientColorWithStartColor:(UIColor *)startColor
                             endColor:(UIColor *)endColor
                           startPoint:(CGPoint)startPoint
                             endPoint:(CGPoint)endPoint
                            locations:(NSArray<NSNumber *>*)locations
                                frame:(CGRect)frame;

- (void)addBorder:(UIColor *)color width:(CGFloat)width type:(UIRectEdge)rect;

@end

@interface UIView (TMUI_Gesture)

/// 点击手势
/// @param tapBlock 手势回调
- (void)tmui_addSingerTapWithBlock:(void (^)(void))tapBlock;

/// 双击手势
/// @param tapBlock 手势回调
- (void)tmui_addDoubleTapWithBlock:(void (^)(void))tapBlock;

/// 长按手势
/// @param duration 触发时间
/// @param movement 允许长按时间触发前允许手指滑动的范围，默认是10
/// @param stateBeginBlock 长按开始的回调
/// @param stateEndBlock 长按结束的回调
- (void)tmui_addLongPressGestureWithMinimumPressDuration:(NSTimeInterval)duration allowableMovement:(CGFloat)movement  stateBegin:(void (^)(void))stateBeginBlock stateEnd:(void (^)(void))stateEndBlock;

/// 长按手势
/// @param duration 触发时间
/// @param stateBeginBlock 长按开始的回调
/// @param stateEndBlock 长按结束的回调
- (void)tmui_addLongPressGestureWithMinimumPressDuration:(NSTimeInterval)duration stateBegin:(void (^)(void))stateBeginBlock stateEnd:(void (^)(void))stateEndBlock;

/// 捏合手势
/// @param block 手势回调
- (void)tmui_addPinchGestureWithBlock:(void (^)(CGFloat scale, CGFloat velocity, UIGestureRecognizerState state))block;

/// 旋转手势
/// @param block 手势回调
- (void)tmui_addRotationGestureWithBlock:(void (^)(CGFloat rotation, CGFloat velocity, UIGestureRecognizerState state))block;

/// 移动手势
/// @param block 手势回调
- (void)tmui_addPanGestureWithBlock:(void (^)(CGPoint point, UIGestureRecognizerState state, UIPanGestureRecognizer *gesture))block;

/// 移动手势
/// @param min 最小手指数
/// @param max 最大手指数
/// @param block 手势回调
- (void)tmui_addPanGestureWithMinimumNumberOfTouches:(NSUInteger)min maximumNumberOfTouches:(NSUInteger)max block:(void (^)(CGPoint point, UIGestureRecognizerState state, UIPanGestureRecognizer *gesture))block;

/// 轻扫手势
/// @param direction 手势方向
/// @param block 手势回调
- (void)tmui_addSwipeGestureWithDirection:(UISwipeGestureRecognizerDirection)direction block:(void (^)(UIGestureRecognizerState state))block;

/// 轻扫手势
/// @param direction 手势方向
/// @param numberOfTouches 手指数
/// @param block 手势回调
- (void)tmui_addSwipeGestureWithDirection:(UISwipeGestureRecognizerDirection)direction numberOfTouchesRequired:(NSUInteger)numberOfTouches block:(void (^)(UIGestureRecognizerState state))block;

@end

@interface UIView (TMUI_ViewController)

/**
 获取当前视图显示时对应的的viewController
 @note 若当前视图vc承载进行展示则返回nil
 @note 只读方法，不支持kvo
 */
@property (nonatomic, readonly, nullable)UIViewController *tmui_viewController;

/**返回view展示时对应承载的viewController*/
+ (UIViewController *_Nullable)tmui_viewControllerOfView:(UIView *)view;

/**
 判断当前的 view 是否属于可视（可视的定义为已存在于 view 层级树里，或者在所处的 UIViewController 的 [viewWillAppear, viewWillDisappear) 生命周期之间）
 */
@property(nonatomic, assign, readonly) BOOL tmui_visible;

/**
 当前的 view 是否是某个 UIViewController.view
 */
//@property(nonatomic, assign) BOOL tmui_isControllerRootView;

/**
 获取当前 view 所在的 UIViewController，会递归查找 superview，因此注意使用场景不要有过于频繁的调用
 */
//@property(nullable, nonatomic, weak, readonly) __kindof UIViewController *tmui_viewController;





@end

NS_ASSUME_NONNULL_END
