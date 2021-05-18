//
//  NSAttributedString+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (TMUI)

/**
 * 设置行间距
 */
+ (instancetype)tmui_attributedStringWithStr:(NSString *)str lineSpacing:(CGFloat)lineSpacing;


/**
 *  按照中文 2 个字符、英文 1 个字符的方式来计算文本长度
 */
//- (NSUInteger)tmui_lengthWhenCountingNonASCIICharacterAsTwo;

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

/**
 * 获取NSAttributedString显示的高度
 */
- (CGFloat)tmui_heightWithMaxWidth:(CGFloat)width;


/**
 * 设置行间距
 */
+ (instancetype)tmui_atsForStr:(NSString *)str lineHeight:(CGFloat)h;

/**
 * 设置行间距 是否用于计算
 */
+ (instancetype)tmui_atsForStr:(NSString *)str lineHeight:(CGFloat)h forCompute:(BOOL)forCompute;


/**
 * 获取设置行间距的NSAttributedString的高度
 */
+ (CGFloat)tmui_heightForAtsWithStr:(NSString *)str font:(UIFont *)ft width:(CGFloat)w lineH:(CGFloat )lh;

- (CGFloat)tmui_heightWithFont:(UIFont *)ft width:(CGFloat)w lineH:(CGFloat)lh;

/**
 *  获取指定字符串的高度
 *
 *  @param str     字符串
 *  @param ft      字体
 *  @param w       限制宽度
 *  @param lineGap 行高
 *  @param lineNum 限制行数，0表示不限制
 *
 *  @return 高度
 */
+ (CGFloat)tmui_heightForAtsWithStr:(NSString *)str font:(UIFont *)ft width:(CGFloat)w lineH:(CGFloat)lineGap maxLine:(NSUInteger)lineNum;

/**
 *  获取字符串高度
 *
 *  @param ft      字体
 *  @param w       限制宽度
 *  @param lh      行高
 *  @param lineNum 限制行数，0表示不限制
 *
 *  @return 高度
 */
- (CGFloat)tmui_heightWithFont:(UIFont *)ft width:(CGFloat)w lineH:(CGFloat)lh maxLine:(NSUInteger)lineNum;

@end


@interface NSAttributedString (TMUI_Drawing)

/// 计算富文本高度的方法
/// @note 高度取决于富文本中最大的字体，计算高度时候最好传入最大的字体
/// @param width 富文本容器宽度
- (CGSize)tmui_sizeForWidth:(CGFloat)width;

@end


NS_ASSUME_NONNULL_END
