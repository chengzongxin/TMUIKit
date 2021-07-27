//
//  UIView+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/20.
//

#import <UIKit/UIKit.h>
#import "UIView+TMUIBorder.h"

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
/**
 在 iOS 11 及之后的版本，此属性将返回系统已有的 self.safeAreaInsets。在之前的版本此属性返回 UIEdgeInsetsZero
 */
@property(nonatomic, assign, readonly) UIEdgeInsets tmui_safeAreaInsets;

/**
 有修改过 tintColor，则不会再受 superview.tintColor 的影响
 */
@property(nonatomic, assign, readonly) BOOL tmui_tintColorCustomized;

/// 响应区域需要改变的大小，负值表示往外扩大，正值表示往内缩小
@property(nonatomic,assign) UIEdgeInsets tmui_outsideEdge;

/// 移除当前所有 subviews
- (void)tmui_removeAllSubviews;

/**
 将要设置的 frame 用 CGRectApplyAffineTransformWithAnchorPoint 处理后再设置
 */
@property(nonatomic, assign) CGRect tmui_frameApplyTransform;

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


/// 保持其他三个边缘的位置不变的情况下，将顶边缘拓展到某个指定的位置，注意高度会跟随变化。
@property(nonatomic, assign) CGFloat extendToTop;

/// 保持其他三个边缘的位置不变的情况下，将左边缘拓展到某个指定的位置，注意宽度会跟随变化。
@property(nonatomic, assign) CGFloat extendToLeft;

/// 保持其他三个边缘的位置不变的情况下，将底边缘拓展到某个指定的位置，注意高度会跟随变化。
@property(nonatomic, assign) CGFloat extendToBottom;

/// 保持其他三个边缘的位置不变的情况下，将右边缘拓展到某个指定的位置，注意宽度会跟随变化。
@property(nonatomic, assign) CGFloat extendToRight;

/// 获取当前 view 在 superview 内水平居中时的 left
@property(nonatomic, assign, readonly) CGFloat leftWhenCenterInSuperview;

/// 获取当前 view 在 superview 内垂直居中时的 top
@property(nonatomic, assign, readonly) CGFloat topWhenCenterInSuperview;


/// 等价于 CGRectGetMinY(frame)
@property(nonatomic, assign) CGFloat tmui_top;

/// 等价于 CGRectGetMinX(frame)
@property(nonatomic, assign) CGFloat tmui_left;

/// 等价于 CGRectGetMaxY(frame)
@property(nonatomic, assign) CGFloat tmui_bottom;

/// 等价于 CGRectGetMaxX(frame)
@property(nonatomic, assign) CGFloat tmui_right;

/// 等价于 CGRectGetWidth(frame)
@property(nonatomic, assign) CGFloat tmui_width;

/// 等价于 CGRectGetHeight(frame)
@property(nonatomic, assign) CGFloat tmui_height;

/// 保持其他三个边缘的位置不变的情况下，将顶边缘拓展到某个指定的位置，注意高度会跟随变化。
@property(nonatomic, assign) CGFloat tmui_extendToTop;

/// 保持其他三个边缘的位置不变的情况下，将左边缘拓展到某个指定的位置，注意宽度会跟随变化。
@property(nonatomic, assign) CGFloat tmui_extendToLeft;

/// 保持其他三个边缘的位置不变的情况下，将底边缘拓展到某个指定的位置，注意高度会跟随变化。
@property(nonatomic, assign) CGFloat tmui_extendToBottom;

/// 保持其他三个边缘的位置不变的情况下，将右边缘拓展到某个指定的位置，注意宽度会跟随变化。
@property(nonatomic, assign) CGFloat tmui_extendToRight;

/// 获取当前 view 在 superview 内水平居中时的 left
@property(nonatomic, assign, readonly) CGFloat tmui_leftWhenCenterInSuperview;

/// 获取当前 view 在 superview 内垂直居中时的 top
@property(nonatomic, assign, readonly) CGFloat tmui_topWhenCenterInSuperview;

@end


extern const CGFloat TMUIViewSelfSizingHeight;

@interface UIView (TMUI_Block)

/**
 在 UIView 的 frame 变化前会调用这个 block，变化途径包括 setFrame:、setBounds:、setCenter:、setTransform:，你可以通过返回一个 rect 来达到修改 frame 的目的，最终执行 [super setFrame:] 时会使用这个 block 的返回值（除了 setTransform: 导致的 frame 变化）。
 @param view 当前的 view 本身，方便使用，省去 weak 操作
 @param followingFrame setFrame: 的参数 frame，也即即将被修改为的 rect 值
 @return 将会真正被使用的 frame 值
 @note 仅当 followingFrame 和 self.frame 值不相等时才会被调用
 */
@property(nullable, nonatomic, copy) CGRect (^tmui_frameWillChangeBlock)(__kindof UIView *view, CGRect followingFrame);

/**
 在 UIView 的 frame 变化后会调用这个 block，变化途径包括 setFrame:、setBounds:、setCenter:、setTransform:，可用于监听布局的变化，或者在不方便重写 layoutSubviews 时使用这个 block 代替。
 @param view 当前的 view 本身，方便使用，省去 weak 操作
 @param precedingFrame 修改前的 frame 值
 */
@property(nullable, nonatomic, copy) void (^tmui_frameDidChangeBlock)(__kindof UIView *view, CGRect precedingFrame);

/**
 在 - [UIView layoutSubviews] 调用后就调用的 block
 @param view 当前的 view 本身，方便使                                                                                                                                                                                                                     用，省去 weak 操作
 */
@property(nullable, nonatomic, copy) void (^tmui_layoutSubviewsBlock)(__kindof UIView *view);

/**
 在 UIView 的 sizeThatFits: 调用后就调用的 block，可返回一个修改后的值来作为原方法的返回值
 @param view 当前的 view 本身，方便使用，省去 weak 操作
 @param size sizeThatFits: 方法被调用时传进来的参数 size
 @param superResult 原本的 sizeThatFits: 方法的返回值
 */
@property(nullable, nonatomic, copy) CGSize (^tmui_sizeThatFitsBlock)(__kindof UIView *view, CGSize size, CGSize superResult);

/**
 当 tintColorDidChange 被调用的时候会调用这个 block，就不用重写方法了
 @param view 当前的 view 本身，方便使用，省去 weak 操作
 */
@property(nullable, nonatomic, copy) void (^tmui_tintColorDidChangeBlock)(__kindof UIView *view);

/**
 当 hitTest:withEvent: 被调用时会调用这个 block，就不用重写方法了
 @param point 事件产生的 point
 @param event 事件
 @param super 的返回结果
 */
@property(nullable, nonatomic, copy) __kindof UIView * (^tmui_hitTestBlock)(CGPoint point, UIEvent *event, __kindof UIView *originalView);

@end

@interface UIView (TMUI_Coordinate)


/**
 Converts a point from the receiver's coordinate system to that of the specified view or window.
 
 @param point A point specified in the local coordinate system (bounds) of the receiver.
 @param view  The view or window into whose coordinate system point is to be converted.
    If view is nil, this method instead converts to window base coordinates.
 @return The point converted to the coordinate system of view.
 */
- (CGPoint)tmui_convertPoint:(CGPoint)point toViewOrWindow:(nullable UIView *)view;

/**
 Converts a point from the coordinate system of a given view or window to that of the receiver.
 
 @param point A point specified in the local coordinate system (bounds) of view.
 @param view  The view or window with point in its coordinate system.
    If view is nil, this method instead converts from window base coordinates.
 @return The point converted to the local coordinate system (bounds) of the receiver.
 */
- (CGPoint)tmui_convertPoint:(CGPoint)point fromViewOrWindow:(nullable UIView *)view;

/**
 Converts a rectangle from the receiver's coordinate system to that of another view or window.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of the receiver.
 @param view The view or window that is the target of the conversion operation. If view is nil, this method instead converts to window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)tmui_convertRect:(CGRect)rect toViewOrWindow:(nullable UIView *)view;

/**
 Converts a rectangle from the coordinate system of another view or window to that of the receiver.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of view.
 @param view The view or window with rect in its coordinate system.
    If view is nil, this method instead converts from window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)tmui_convertRect:(CGRect)rect fromViewOrWindow:(nullable UIView *)view;



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


@interface UIView (TMUI_Runtime)

/**
 *  判断当前类是否有重写某个指定的 UIView 的方法
 *  @param selector 要判断的方法
 *  @return YES 表示当前类重写了指定的方法，NO 表示没有重写，使用的是 UIView 默认的实现
 */
- (BOOL)tmui_hasOverrideUIKitMethod:(SEL)selector;

@end


//@interface UIView (TMUI_Block)
//
///**
// 在 UIView 的 frame 变化前会调用这个 block，变化途径包括 setFrame:、setBounds:、setCenter:、setTransform:，你可以通过返回一个 rect 来达到修改 frame 的目的，最终执行 [super setFrame:] 时会使用这个 block 的返回值（除了 setTransform: 导致的 frame 变化）。
// @param view 当前的 view 本身，方便使用，省去 weak 操作
// @param followingFrame setFrame: 的参数 frame，也即即将被修改为的 rect 值
// @return 将会真正被使用的 frame 值
// @note 仅当 followingFrame 和 self.frame 值不相等时才会被调用
// */
//@property(nullable, nonatomic, copy) CGRect (^tmui_frameWillChangeBlock)(__kindof UIView *view, CGRect followingFrame);
//
///**
// 在 UIView 的 frame 变化后会调用这个 block，变化途径包括 setFrame:、setBounds:、setCenter:、setTransform:，可用于监听布局的变化，或者在不方便重写 layoutSubviews 时使用这个 block 代替。
// @param view 当前的 view 本身，方便使用，省去 weak 操作
// @param precedingFrame 修改前的 frame 值
// */
//@property(nullable, nonatomic, copy) void (^tmui_frameDidChangeBlock)(__kindof UIView *view, CGRect precedingFrame);
//
///**
// 在 - [UIView layoutSubviews] 调用后就调用的 block
// @param view 当前的 view 本身，方便使用，省去 weak 操作
// */
//@property(nullable, nonatomic, copy) void (^tmui_layoutSubviewsBlock)(__kindof UIView *view);
//
///**
// 在 UIView 的 sizeThatFits: 调用后就调用的 block，可返回一个修改后的值来作为原方法的返回值
// @param view 当前的 view 本身，方便使用，省去 weak 操作
// @param size sizeThatFits: 方法被调用时传进来的参数 size
// @param superResult 原本的 sizeThatFits: 方法的返回值
// */
//@property(nullable, nonatomic, copy) CGSize (^tmui_sizeThatFitsBlock)(__kindof UIView *view, CGSize size, CGSize superResult);
//
///**
// 当 tintColorDidChange 被调用的时候会调用这个 block，就不用重写方法了
// @param view 当前的 view 本身，方便使用，省去 weak 操作
// */
//@property(nullable, nonatomic, copy) void (^tmui_tintColorDidChangeBlock)(__kindof UIView *view);
//
///**
// 当 hitTest:withEvent: 被调用时会调用这个 block，就不用重写方法了
// @param point 事件产生的 point
// @param event 事件
// @param super 的返回结果
// */
//@property(nullable, nonatomic, copy) __kindof UIView * (^tmui_hitTestBlock)(CGPoint point, UIEvent *event, __kindof UIView *originalView);
//
//@end

@interface UIView (TBTCategorAdd)
// 获取第一个description包含aString的视图
- (UIView *)tmui_subViewOfContainDescription:(NSString *)aString ;
// 获取第一个class=aClass的视图
- (UIView *)tmui_subViewOfClass:(Class)aClass;

@end

NS_ASSUME_NONNULL_END
