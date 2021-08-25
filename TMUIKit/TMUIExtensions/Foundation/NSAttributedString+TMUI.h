//
//  NSAttributedString+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (TMUI)

#pragma mark - 文字富文本
/**
 * 设置行间距
 */
+ (instancetype)tmui_attributedStringWithString:(NSString *)str lineSpacing:(CGFloat)lineSpacing;

+ (instancetype)tmui_attributedStringWithString:(NSString *)str lineSpacing:(CGFloat)lineSpacing lineBreakMode:(NSLineBreakMode)lineBreakMode ;

+ (instancetype)tmui_attributedStringWithString:(NSString *)str font:(UIFont *)font color:(UIColor *)color;

+ (instancetype)tmui_attributedStringWithString:(NSString *)str font:(UIFont *)font color:(UIColor *)color lineSpacing:(CGFloat)lineSpacing;



#pragma mark - 图片富文本
/**
 * @brief 创建一个包含图片的 attributedString
 * @param image 要用的图片
 */
+ (instancetype)tmui_attributedStringWithImage:(UIImage *)image;

/**
 * @brief 创建一个包含图片的 attributedString
 * @param image 要用的图片
 * @param offset 图片相对基线的垂直偏移（当 offset > 0 时，图片会向上偏移）
 * @param leftMargin 图片距离左侧内容的间距
 * @param rightMargin 图片距离右侧内容的间距
 * @note leftMargin 和 rightMargin 必须大于或等于 0
 */
+ (instancetype)tmui_attributedStringWithImage:(UIImage *)image baselineOffset:(CGFloat)offset leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin;

/**
 * @brief 创建一个用来占位的空白 attributedString
 * @param width 空白占位符的宽度
 */
+ (instancetype)tmui_attributedStringWithFixedSpace:(CGFloat)width;

@end


@interface NSAttributedString (TMUI_Calculate)


/// 计算富文本高度的方法
/// @note 如果对应到UILabel，则富文本中属性都需要能取到，例如字体，段落等，因为UILabel中的属性，不一定会全部填充进来
/// @param width 富文本容器宽度
- (CGSize)tmui_sizeForWidth:(CGFloat)width;

#pragma mark - HouseKeeper
- (CGFloat)tmui_heightForFont:(UIFont *)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;

+ (CGFloat)tmui_heightForString:(NSString *)str font:(UIFont *)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;

+ (CGFloat)tmui_heightForString:(NSString *)str font:(UIFont *)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing maxLine:(NSUInteger)maxLine;


/**
 * 获取NSAttributedString显示的高度
 */
- (CGFloat)tmui_heightForWidth:(CGFloat)width;


/**
 *  按照中文 2 个字符、英文 1 个字符的方式来计算文本长度
 */
- (NSUInteger)tmui_lengthWhenCountingNonASCIICharacterAsTwo;


@end





@interface NSAttributedString (TMUI_Attributes)

/**
 The font of the text. (read-only)
 
 @discussion Default is Helvetica (Neue) 12.
 @discussion Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:6.0  YYKit:6.0
 */
@property (nullable, nonatomic, strong, readonly) UIFont *tmui_font;
- (nullable UIFont *)tmui_fontAtIndex:(NSUInteger)index;

@property (nullable, nonatomic, strong, readonly) NSMutableParagraphStyle *tmui_paragraphStyle;
- (nullable NSMutableParagraphStyle *)tmui_paragraphStyle:(NSUInteger)index;


@end

@interface NSMutableAttributedString (TMUI)

/**
 Sets the attributes to the entire text string.
 
 @discussion The old attributes will be removed.
 
 @param attributes  A dictionary containing the attributes to set, or nil to remove all attributes.
 */
- (void)tmui_setAttributes:(nullable NSDictionary<NSString *, id> *)attributes;

/**
 Sets an attribute with the given name and value to the entire text string.
 
 @param name   A string specifying the attribute name.
 @param value  The attribute value associated with name. Pass `nil` or `NSNull` to
 remove the attribute.
 */
- (void)tmui_setAttribute:(NSString *)name value:(nullable id)value;

/**
 Sets an attribute with the given name and value to the characters in the specified range.
 
 @param name   A string specifying the attribute name.
 @param value  The attribute value associated with name. Pass `nil` or `NSNull` to
 remove the attribute.
 @param range  The range of characters to which the specified attribute/value pair applies.
 */
- (void)tmui_setAttribute:(NSString *)name value:(nullable id)value range:(NSRange)range;

/**
 Removes all attributes in the specified range.
 
 @param range  The range of characters.
 */
- (void)tmui_removeAttributesInRange:(NSRange)range;

@end


NS_ASSUME_NONNULL_END
