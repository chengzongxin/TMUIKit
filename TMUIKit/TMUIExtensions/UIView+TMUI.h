//
//  UIView+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TMUIGradientType) {
    TMUIGradientTypeLeftToRight,
    TMUIGradientTypeTopLeftToBottomRight,
    TMUIGradientTypeTopToBottom,
    TMUIGradientTypeTopRightToBottomLeft,
    TMUIGradientTypeBottomRightToTopLeft,
    TMUIGradientTypeBottomLeftToTopRight,
};

@interface UIView (TMUI)

/// 创建view
+ (instancetype)tmui_view;

/// 相当于 initWithFrame:CGRectMake(0, 0, size.width, size.height)
/// @param size  初始化时的 size
- (instancetype)tmui_initWithSize:(CGSize)size;

/// 移除当前所有 subviews
- (void)tmui_removeAllSubviews;

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
 @note 不可和阴影效果同时设置
 @param direct 半圆的方向,支持 | 操作，比如 UIRectCornerTopLeft | UIRectCornerTopRight 即左上和右上圆角
 UIRectCornerTopLeft     = 1 << 0,
 UIRectCornerTopRight    = 1 << 1,
 UIRectCornerBottomLeft  = 1 << 2,
 UIRectCornerBottomRight = 1 << 3,
 
 @param radius 半圆半径,传0就默认高度一般(半圆)
 */
- (void)tmui_cornerDirect:(UIRectCorner)direct radius:(int)radius;


- (void)tmui_cornerRadius:(CGFloat)cornerRadius;

/**
 设置View和View的阴影圆角
 @note 不可和圆角效果同时设置
 @param color   阴影的颜色
 @param opacity 阴影的透明度
 @param offset 阴影的偏移距离
 @param corner 阴影的圆角
 */
- (void)tmui_shadowColor:(UIColor *)color
                 opacity:(float)opacity
              offsetSize:(CGSize)offset
                  corner:(int)corner;


/**
 设置View边框和颜色
 
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 */
- (void)tmui_borderColor:(UIColor *)borderColor
             borderWidth:(CGFloat)borderWidth;



// MARK: Gradient BackGound Colors

/// 设置渐变
/// @param colors 颜色数组
/// @param gradientType 渐变类型
- (void)tmui_gradientWithColors:(NSArray <UIColor *>*)colors
                   gradientType:(TMUIGradientType)gradientType;

/// 设置渐变
/// @param colors 颜色数组
/// @param gradientType 渐变类型
/// @param locations 渐变开始的位置，从中间开始渐变过渡，@[@0.5]，如果超过两个颜色，需要和颜色数组个数对应 - 1，
- (void)tmui_gradientWithColors:(NSArray <UIColor *>*)colors
                   gradientType:(TMUIGradientType)gradientType
                      locations:(NSArray<NSNumber *>*)locations;

/// 设置渐变
/// @param colors 颜色数组
/// @param gradientType 渐变类型
/// @param locations 渐变开始的位置，从中间开始渐变过渡，@[@0.5]，如果超过两个颜色，需要和颜色数组个数对应 - 1，
/// @param frame 渐变layer的frame，一般不需要传，默认取当前view的bounds
- (void)tmui_gradientWithColors:(NSArray <UIColor *>*)colors
                   gradientType:(TMUIGradientType)gradientType
                      locations:(NSArray<NSNumber *>*)locations
                          frame:(CGRect)frame;

// MARK: View Border
- (void)tmui_border:(UIColor *)color
              width:(CGFloat)width
               type:(UIRectEdge)rect;

@end

@interface UIView (TMUI_IBInspectable)

/**
 *  圆角
 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

/**
 *  描边宽度
 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

/**
 *  描边颜色
 */
@property (nonatomic, copy) IBInspectable UIColor *borderColor;
/**
 *  背景颜色
 */
@property (nonatomic, copy) IBInspectable NSString *bgColorHexString;
/**
 *  描边颜色-16进制
 */
@property (nonatomic, copy) IBInspectable NSString *borderColorHexString;

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
@property(nonatomic, assign) BOOL tmui_isControllerRootView;

/**
 获取当前 view 所在的 UIViewController，会递归查找 superview，因此注意使用场景不要有过于频繁的调用
 */
//@property(nullable, nonatomic, weak, readonly) __kindof UIViewController *tmui_viewController;





@end


/**
 *  方便地将某个 UIView 截图并转成一个 UIImage，注意如果这个 UIView 本身做了 transform，也不会在截图上反映出来，截图始终都是原始 UIView 的截图。
 */
@interface UIView (TMUI_Snapshotting)

- (UIImage *)tmui_snapshotLayerImage;
- (UIImage *)tmui_snapshotImageAfterScreenUpdates:(BOOL)afterScreenUpdates;

@end


/// 显示(退出)动画
typedef NS_ENUM(NSInteger, TMUIViewAnimationType) {
    /// 无动画
    TMUIViewAnimationTypeNone,
    /// 渐显
    TMUIViewAnimationTypeFadeIn,
    /// 渐隐
    TMUIViewAnimationTypeFadeOut,
    /// 逐渐放大, 显示
    TMUIViewAnimationTypeZoomIn,
    /// 逐渐放大, 消失
    TMUIViewAnimationTypeZoomOut,
    /// 从顶部出现
    TMUIViewAnimationTypeTopIn,
    /// 从顶部移除
    TMUIViewAnimationTypeTopOut,
    /// 从底部出现
    TMUIViewAnimationTypeBottomIn,
    /// 从底部移除
    TMUIViewAnimationTypeBottomOut
};


@interface UIView (TMUI_Animate)

- (void)tmui_animateWithDuration:(NSTimeInterval)duration animationType:(TMUIViewAnimationType)type completion:(void (^ __nullable)(BOOL finished))completion;


@end


@interface UIView (TMUI_Nib)

+ (instancetype)tmui_instantiateFromNib;

+ (instancetype)tmui_loadNibViewWithFrame:(CGRect)frame;

+ (instancetype)tmui_loadNibViewWithFrame:(CGRect)frame nibName:(NSString *)name;

+ (instancetype)tmui_loadNibViewWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
