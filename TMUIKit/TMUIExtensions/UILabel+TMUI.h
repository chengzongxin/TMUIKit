//
//  UILabel+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (TMUI)

/// 快速创建Label方法
/// @param font 字体
/// @param textColor 文本颜色
- (instancetype)tmui_initWithFont:(UIFont *)font textColor:(UIColor *)textColor;

/// 返回段落行高
- (CGFloat)tmui_attributeTextLineHeight;

@end

@interface UILabel (TMUI_AttributeText)


/// 给label设置文本、行距
/// @param text 文本
/// @param lineSpacing 行距
- (void)tmui_setAttributesText:(NSString *)text lineSpacing:(CGFloat)lineSpacing;

/// 给label指定text的颜色、字体，分段设置
/// @param text 指定文本
/// @param color 指定文本颜色
/// @param font 指定文本字体
- (void)tmui_setAttributesText:(NSString *)text color:(UIColor *)color font:(UIFont *)font;

/// 设置文字行间距,统一设置
/// @param lineSpacing 行间距
- (void)tmui_setAttributeslineSpacing:(CGFloat)lineSpacing;

/// 给label文本设置垂直偏移
/// @param lineOffset 偏移量
- (void)tmui_setAttributesLineOffset:(CGFloat)lineOffset;

/// 给label设置横线穿过样式
- (void)tmui_setAttributesLineSingle;

/// 给label设置下划线样式
- (void)tmui_setAttributesUnderLink;

@end




@protocol TMUIAttrTextDelegate <NSObject>
@optional
/**
 *  TMUIAttrTextDelegate
 *
 *  @param string  点击的字符串
 *  @param range   点击的字符串range
 *  @param index   点击的字符在数组中的index
 */
- (void)didClickAttrText:(NSString *)string range:(NSRange)range index:(NSInteger)index;
@end

@interface UILabel (TMUI_AttributeAction)

/**
 *  是否打开点击效果，默认是打开
 */
@property (nonatomic, assign) BOOL tmui_enabledClickEffect;

/**
 *  是否扩大点击范围，默认是打开
 */
@property (nonatomic, assign) CGPoint tmui_enlargeClickArea;

/**
 *  点击效果颜色 默认lightGrayColor
 */
@property (nonatomic, strong) UIColor *tmui_clickEffectColor;

/**
 * 给文本添加Block点击事件回调
 *
 * @param strings  需要添加的字符串数组
 * @param clickAction 点击事件回调
 */
- (void)tmui_clickAttrTextWithStrings:(NSArray <NSString *> *)strings clickAction:(void (^) (NSString *string, NSRange range, NSInteger index))clickAction;

/**
 * 给文本添加Block点击事件回调
 *
 * @param strings  需要添加的字符串数组
 * @param attributes  需要添加的字符的富文本属性
 * @param clickAction 点击事件回调
 */
- (void)tmui_clickAttrTextWithStrings:(NSArray <NSString *> *)strings attributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attributes clickAction:(void (^) (NSString *string, NSRange range, NSInteger index))clickAction;

/**
 * 给文本添加点击事件delegate回调
 *
 * @param strings  需要添加的字符串数组
 * @param delegate 富文本代理
 */
- (void)tmui_clickAttrTextWithStrings:(NSArray <NSString *> *)strings delegate:(id <TMUIAttrTextDelegate> )delegate;

/**
 * 给文本添加点击事件delegate回调
 *
 * @param strings  需要添加的字符串数组
 * @param attributes  需要添加的字符的富文本属性
 * @param delegate 富文本代理
 */
- (void)tmui_clickAttrTextWithStrings:(NSArray <NSString *> *)strings attributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attributes delegate:(id <TMUIAttrTextDelegate> )delegate;


/// 移除点击事件
- (void)tmui_removeAttributeAction;

@end



NS_ASSUME_NONNULL_END
