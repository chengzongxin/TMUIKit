//
//  UIButton+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 针对同时设置了Image和Title的场景时UIButton中的图片和文字的关系
 */
typedef NS_ENUM(NSInteger, TMUIButtonImageTitleStyle) {
    TMUIButtonImageTitleStyleLeft = 0,          //图片在左，文字在右，整体居中。
    TMUIButtonImageTitleStyleRight,             //图片在右，文字在左，整体居中。
    TMUIButtonImageTitleStyleTop,               //图片在上，文字在下，整体居中。
    TMUIButtonImageTitleStyleBottom,            //图片在下，文字在上，整体居中。
    TMUIButtonImageTitleStyleCenterTop,         //图片居中，文字在上距离按钮顶部。
    TMUIButtonImageTitleStyleCenterBottom,      //图片居中，文字在下距离按钮底部。
    TMUIButtonImageTitleStyleCenterUp,          //图片居中，文字在图片上面。
    TMUIButtonImageTitleStyleCenterDown,        //图片居中，文字在图片下面。
    TMUIButtonImageTitleStyleRightLeft,         //图片在右，文字在左，距离按钮两边边距
    TMUIButtonImageTitleStyleLeftRight,         //图片在左，文字在右，距离按钮两边边距
};


/// 主要提供便利方法创建，设置UIButton
@interface UIButton (TMUI)

/// 快速创建按钮
+ (instancetype _Nullable )tmui_button;

/// 只提供属性生成Set和Get方法，访问或者设置按钮文字，不生成成员变量
@property (nonatomic, strong) NSString *tmui_text;

/// 只提供属性生成Set和Get方法，访问或者设置按钮文字字体，不生成成员变量
@property (nonatomic, strong) UIFont *tmui_font;

/// 只提供属性生成Set和Get方法，访问或者设置按钮富文本，不生成成员变量
@property (nonatomic, strong) NSAttributedString *tmui_attrText;

/// 只提供属性生成Set和Get方法，访问或者设置按钮文字颜色，不生成成员变量
@property (nonatomic, strong) UIColor *tmui_titleColor;

/// 只提供属性生成Set和Get方法，访问或者设置按钮图片，不生成成员变量
@property (nonatomic, strong) UIImage *tmui_image;

/// 快速的绑定事件
- (void)tmui_addTarget:(nullable id)target action:(nonnull SEL)sel;

/// 设置默认和选中文本
- (void)tmui_setNormalTitle:(NSString *_Nullable)normalTitle selectedTitle:(NSString *_Nullable)selectedTitle;

/// 设置默认和选中背景色
- (void)tmui_setNormalBackGroundColor:(UIColor *_Nullable)normalColor selectedBackGroundColor:(UIColor *_Nullable)selectedColor;

/// 设置选中和禁用背景色
- (void)tmui_setNormalBackGroundColor:(UIColor *_Nullable)normalColor disableBackGroundColor:(UIColor *_Nullable)disableColor;

/// 初始化方法
+ (instancetype _Nullable)tmui_buttonWithText:(NSString *)text textColor:(UIColor *)textColor font:(CGFloat)font;

/// 初始化方法
+ (instancetype _Nullable)tmui_buttonWithText:(NSString *)text textColor:(UIColor *)textColor font:(CGFloat)font backgoundColor:(UIColor *)backgroudColor target:(nullable id)target action:(nonnull SEL)sel;


@end

/// 主要提供便利布局相关方法
@interface UIButton (TMUI_Layout)


/// 调整按钮的文本和image的布局，前提是title和image同时存在才会调整。padding是调整布局时整个按钮和图文的间隔。
/// @param style 图片和文字布局样式
/// @param padding 图片文字间距
- (void)tmui_buttonImageTitleWithStyle:(TMUIButtonImageTitleStyle)style
                               padding:(CGFloat)padding;



@end

/// 扩大按钮响应范围
@interface UIButton (TMUI_EnlargeEdge)

/// 扩大按钮响应范围
/// @param size 扩大的size
- (void)tmui_setEnlargeEdge:(CGFloat)size;


/// 扩大按钮响应范围
/// @param top 距离上边扩大范围
/// @param right 距离右边扩大范围
/// @param bottom 距离下边扩大范围
/// @param left 距离左边扩大范围
- (void)tmui_setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end


NS_ASSUME_NONNULL_END
