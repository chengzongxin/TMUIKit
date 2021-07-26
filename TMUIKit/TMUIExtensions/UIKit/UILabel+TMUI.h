//
//  UILabel+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 提供基本快捷方法、初始化等
@interface UILabel (TMUI)

/// 快速创建Label方法
/// @param font 字体
/// @param textColor 文本颜色
- (instancetype)tmui_initWithFont:(UIFont *)font textColor:(UIColor *)textColor;



@end

#pragma mark - 计算尺寸
@interface UILabel (TMUI_Caculate)

/// 计算Label的size 含有Image的富文本需要额外加上图片尺寸
/// @param width label占据屏幕宽度
- (CGSize)tmui_sizeForWidth:(CGFloat)width;

/// 返回段落行高
- (CGFloat)tmui_attributeTextLineHeight;

/**
 * 在UILabel的样式（如字体）设置完后，将label的text设置为一个测试字符，再调用sizeToFit，从而令label的高度适应字体
 * @warning 会setText:，因此确保在配置完样式后、设置text之前调用
 */
- (void)tmui_calculateHeightAfterSetAppearance;


/// 获取attrText时，填充字体属性
@property (nullable, nonatomic, strong, readonly) NSAttributedString *tmui_attributedText;

@end


#pragma mark - 设置富文本
@interface UILabel (TMUI_AttributeText)

#pragma mark 全部设置富文本
/// 给label指定文本设置文本、行距,(注意，需要在设置之前保证label的宽度不为0，否则设置行距失败)
/// @param text 文本
/// @param lineSpacing 行距
- (void)tmui_setAttributesString:(NSString *)text lineSpacing:(CGFloat)lineSpacing;

/// 给label指定文本设置文本、行高
/// @param text 文本
/// @param lineHeight 行高
- (void)tmui_setAttributesString:(NSString *)text lineHeight:(CGFloat)lineHeight;

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

/// 给label设置特定属性
- (void)tmui_setAttribute:(NSAttributedStringKey)name value:(id)value;

/// 给label设置特定集合属性
- (void)tmui_setAttribute:(NSDictionary<NSAttributedStringKey, id> *)attrs;


#pragma mark 指定设置副本text富文本
/// 给label指定text的颜色、字体，分段设置
/// @param text 指定文本
/// @param color 指定文本颜色
/// @param font 指定文本字体
- (void)tmui_setAttributesString:(NSString *)text color:(UIColor *)color font:(UIFont *)font;

/// 给label追加text的颜色、字体，分段设置
/// @param text 指定文本
/// @param color 指定文本颜色
/// @param font 指定文本字体
- (void)tmui_appendAttributesString:(NSString *)text color:(UIColor *)color font:(UIFont *)font;

@end


NS_ASSUME_NONNULL_END
