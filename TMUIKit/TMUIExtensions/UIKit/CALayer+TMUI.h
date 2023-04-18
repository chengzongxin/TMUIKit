//
//  CALayer+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/22.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS (NSUInteger, TMUICornerMask) {
    TMUILayerMinXMinYCorner = 1U << 0,
    TMUILayerMaxXMinYCorner = 1U << 1,
    TMUILayerMinXMaxYCorner = 1U << 2,
    TMUILayerMaxXMaxYCorner = 1U << 3,
    TMUILayerAllCorner = TMUILayerMinXMinYCorner|TMUILayerMaxXMinYCorner|TMUILayerMinXMaxYCorner|TMUILayerMaxXMaxYCorner,
};


NS_ASSUME_NONNULL_BEGIN

@interface CALayer (TMUI)


/// 是否为某个 UIView 自带的 layer
@property(nonatomic, assign, readonly) BOOL tmui_isRootLayerOfView;

/// 暂停/恢复当前 layer 上的所有动画
@property(nonatomic, assign) BOOL tmui_pause;

/**
 *  设置四个角是否支持圆角的，iOS11 及以上会调用系统的接口，否则 TMUI 额外实现
 *  @warning 如果对应的 layer 有圆角，则请使用 TMUIBorder，否则系统的 border 会被 clip 掉
 *  @warning 使用 tmui 方法，则超出 layer 范围内的内容都会被 clip 掉，系统的则不会
 *  @warning 如果使用这个接口设置圆角，那么需要获取圆角的值需要用 tmui_originCornerRadius，否则 iOS 11 以下获取到的都是 0
 */
@property(nonatomic, assign) TMUICornerMask tmui_maskedCorners;


/// iOS11 以下 layer 自身的 cornerRadius 一直都是 0，圆角的是通过 mask 做的，tmui_originCornerRadius 保存了当前的圆角
@property(nonatomic, assign, readonly) CGFloat tmui_originCornerRadius;
/**
 *  把某个 sublayer 移动到当前所有 sublayers 的最后面
 *  @param sublayer 要被移动的 layer
 *  @warning 要被移动的 sublayer 必须已经添加到当前 layer 上
 */
- (void)tmui_sendSublayerToBack:(CALayer *)sublayer;

/**
 *  把某个 sublayer 移动到当前所有 sublayers 的最前面
 *  @param sublayer 要被移动的layer
 *  @warning 要被移动的 sublayer 必须已经添加到当前 layer 上
 */
- (void)tmui_bringSublayerToFront:(CALayer *)sublayer;

/**
 * 移除 CALayer（包括 CAShapeLayer 和 CAGradientLayer）所有支持动画的属性的默认动画，方便需要一个不带动画的 layer 时使用。
 */
- (void)tmui_removeDefaultAnimations;

/**
 * 对 CALayer 执行一些操作，不以动画的形式展示过程（默认情况下修改 CALayer 的属性都会以动画形式展示出来）。
 * @param actionsWithoutAnimation 要执行的操作，可以在里面修改 layer 的属性，例如 frame、backgroundColor 等。
 * @note 如果该 layer 的任何属性修改都不需要动画，也可使用 tmui_removeDefaultAnimations。
 */
+ (void)tmui_performWithoutAnimation:(void (NS_NOESCAPE ^)(void))actionsWithoutAnimation;

/**
 * 生成虚线的方法，注意返回的是 CAShapeLayer
 * @param lineLength   每一段的线宽
 * @param lineSpacing  线之间的间隔
 * @param lineWidth    线的宽度
 * @param lineColor    线的颜色
 * @param isHorizontal 是否横向，因为画虚线的缘故，需要指定横向或纵向，横向是 YES，纵向是 NO。
 * 注意：暂不支持 dashPhase 和 dashPattens 数组设置，因为这些都定制性太强，如果用到则自己调用系统方法即可。
 */
+ (CAShapeLayer *)tmui_separatorDashLayerWithLineLength:(NSInteger)lineLength
                                            lineSpacing:(NSInteger)lineSpacing
                                              lineWidth:(CGFloat)lineWidth
                                              lineColor:(CGColorRef)lineColor
                                           isHorizontal:(BOOL)isHorizontal;


/**
 Take snapshot without transform, image's size equals to bounds.
 */
- (nullable UIImage *)tmui_snapshotImage;

/**
 Take snapshot without transform, PDF's page size equals to bounds.
 */
- (nullable NSData *)tmui_snapshotPDF;

/**
 Shortcut to set the layer's shadow
 
 @param color  Shadow Color
 @param offset Shadow offset
 @param radius Shadow radius
 */
- (void)tmui_setLayerShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;

/**
 Shortcut to set the layer's shadow
 
 @param color  Shadow Color
 @param offset Shadow offset
 @param alpha  Shadow Color alpha
 @param radius Shadow radius
 @param spread Shadow spread distance
 */
- (void)tmui_setLayerShadow:(UIColor *)color offset:(CGSize)offset alpha:(float)alpha radius:(CGFloat)radius spread:(CGFloat)spread;

/**
 Remove all sublayers.
 */
- (void)tmui_removeAllSublayers;

@property (nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGPoint center;      ///< Shortcut for center.
@property (nonatomic) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic, getter=frameSize, setter=setFrameSize:) CGSize  size; ///< Shortcut for frame.size.


@property (nonatomic) CGFloat transformRotation;     ///< key path "tranform.rotation"
@property (nonatomic) CGFloat transformRotationX;    ///< key path "tranform.rotation.x"
@property (nonatomic) CGFloat transformRotationY;    ///< key path "tranform.rotation.y"
@property (nonatomic) CGFloat transformRotationZ;    ///< key path "tranform.rotation.z"
@property (nonatomic) CGFloat transformScale;        ///< key path "tranform.scale"
@property (nonatomic) CGFloat transformScaleX;       ///< key path "tranform.scale.x"
@property (nonatomic) CGFloat transformScaleY;       ///< key path "tranform.scale.y"
@property (nonatomic) CGFloat transformScaleZ;       ///< key path "tranform.scale.z"
@property (nonatomic) CGFloat transformTranslationX; ///< key path "tranform.translation.x"
@property (nonatomic) CGFloat transformTranslationY; ///< key path "tranform.translation.y"
@property (nonatomic) CGFloat transformTranslationZ; ///< key path "tranform.translation.z"

/**
 Shortcut for transform.m34, -1/1000 is a good value.
 It should be set before other transform shortcut.
 */
@property (nonatomic) CGFloat transformDepth;

/**
 Add a fade animation to layer's contents when the contents is changed.
 
 @param duration Animation duration
 @param curve    Animation curve.
 */
- (void)tmui_addFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve;


@end


@interface CALayer (TMUI_DynamicColor)

/// 如果 layer 的 backgroundColor、borderColor、shadowColor 是使用 dynamic color（UIDynamicProviderColor、TMUIThemeColor 等）生成的，则调用这个方法可以重新设置一遍这些属性，从而更新颜色
/// iOS 13 系统设置里的界面样式变化（Dark Mode），以及 TMUIThemeManager 触发的主题变化，都会自动调用 layer 的这个方法，业务无需关心。
- (void)tmui_setNeedsUpdateDynamicStyle NS_REQUIRES_SUPER;
@end


NS_ASSUME_NONNULL_END
