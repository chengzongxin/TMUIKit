//
//  UIView+TMUIBorder.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, TMUIViewBorderPosition) {
    TMUIViewBorderPositionNone      = 0,
    TMUIViewBorderPositionTop       = 1 << 0,
    TMUIViewBorderPositionLeft      = 1 << 1,
    TMUIViewBorderPositionBottom    = 1 << 2,
    TMUIViewBorderPositionRight     = 1 << 3
};

typedef NS_ENUM(NSUInteger, TMUIViewBorderLocation) {
    TMUIViewBorderLocationInside,
    TMUIViewBorderLocationCenter,
    TMUIViewBorderLocationOutside
};

/**
*  UIView (TMUIBorder) 为 UIView 方便地显示某几个方向上的边框。
*
*  系统的默认实现里，要为 UIView 加边框一般是通过 view.layer 来实现，view.layer 会给四条边都加上边框，如果你只想为其中某几条加上边框就很麻烦，于是 UIView (TMUIBorder) 提供了 tmui_borderPosition 来解决这个问题。
*  @warning 注意如果你需要为 UIView 四条边都加上边框，请使用系统默认的 view.layer 来实现，而不要用 UIView (TMUIBorder)，会浪费资源，这也是为什么 TMUIViewBorderPosition 不提供一个 TMUIViewBorderPositionAll 枚举值的原因。
*/
@interface UIView (TMUIBorder)

/// 设置边框的位置，默认为 TMUIViewBorderLocationInside，与 view.layer.border 一致。
@property(nonatomic, assign) TMUIViewBorderLocation tmui_borderLocation;

/// 设置边框类型，支持组合，例如：`borderPosition = TMUIViewBorderPositionTop|TMUIViewBorderPositionBottom`。默认为 TMUIViewBorderPositionNone。
@property(nonatomic, assign) TMUIViewBorderPosition tmui_borderPosition;

/// 边框的大小，默认为PixelOne。请注意修改 tmui_borderPosition 的值以将边框显示出来。
@property(nonatomic, assign) IBInspectable CGFloat tmui_borderWidth;

/// 边框的颜色，默认为UIColorSeparator。请注意修改 tmui_borderPosition 的值以将边框显示出来。
@property(nullable, nonatomic, strong) IBInspectable UIColor *tmui_borderColor;

/// 虚线 : dashPhase默认是0，且当dashPattern设置了才有效
/// tmui_dashPhase 表示虚线起始的偏移，tmui_dashPattern 可以传一个数组，表示“lineWidth，lineSpacing，lineWidth，lineSpacing...”的顺序，至少传 2 个。
@property(nonatomic, assign) CGFloat tmui_dashPhase;
@property(nullable, nonatomic, copy) NSArray<NSNumber *> *tmui_dashPattern;

/// border的layer
@property(nullable, nonatomic, strong, readonly) CAShapeLayer *tmui_borderLayer;

@end

NS_ASSUME_NONNULL_END
