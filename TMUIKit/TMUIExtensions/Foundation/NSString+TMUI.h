//
//  NSString+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/25.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TMUI)


/// 将字符串按一个一个字符拆成数组，类似 JavaScript 里的 split("")，如果多个空格，则每个空格也会当成一个 item
@property(nullable, readonly, copy) NSArray<NSString *> *tmui_toArray;

/// 将字符串按一个一个字符拆成数组，类似 JavaScript 里的 split("")，但会自动过滤掉空白字符
@property(nullable, readonly, copy) NSArray<NSString *> *tmui_toTrimmedArray;

/// 去掉头尾的空白字符
@property(readonly, copy) NSString *tmui_trim;

/// 去掉整段文字内的所有空白字符（包括换行符）
@property(readonly, copy) NSString *tmui_trimAllWhiteSpace;

/// 将文字中的换行符替换为空格
@property(readonly, copy) NSString *tmui_trimLineBreakCharacter;

/// 把该字符串转换为对应的 md5（32位小写）
@property(readonly, copy) NSString *tmui_md5;

/// 32位 大写
@property(readonly, copy) NSString *tmui_md5_upper;

/// 16位 小写
@property(readonly, copy) NSString *tmui_md5_16bit;

/// 16位 大写
@property(readonly, copy) NSString *tmui_md5_16bit_upper;

/// 返回一个符合 query value 要求的编码后的字符串，例如&、#、=等字符均会被变为 %xxx 的编码
/// @see `NSCharacterSet (TMUI) tmui_URLUserInputQueryAllowedCharacterSet`
@property(nullable, readonly, copy) NSString *tmui_stringByEncodingUserInputQuery;

/// 把当前文本的第一个字符改为大写，其他的字符保持不变，例如 backgroundView.tmui_capitalizedString -> BackgroundView（系统的 capitalizedString 会变成 Backgroundview）
@property(nullable, readonly, copy) NSString *tmui_capitalizedString;

/**
 * 用正则表达式匹配的方式去除字符串里一些特殊字符，避免UI上的展示问题
 * @link http://www.croton.su/en/uniblock/Diacriticals.html @/link
 */
@property(nullable, readonly, copy) NSString *tmui_removeMagicalChar;

/**
 *  按照中文 2 个字符、英文 1 个字符的方式来计算文本长度
 */
@property(readonly) NSUInteger tmui_lengthWhenCountingNonASCIICharacterAsTwo;

/**
 *  将字符串从指定的 index 开始裁剪到结尾，裁剪时会避免将 emoji 等 "character sequences" 拆散（一个 emoji 表情占用1-4个长度的字符）。
 *
 *  例如对于字符串“😊😞”，它的长度为4，若调用 [string tmui_substringAvoidBreakingUpCharacterSequencesFromIndex:1]，将返回“😊😞”。
 *  若调用系统的 [string substringFromIndex:1]，将返回“?😞”。（?表示乱码，因为第一个 emoji 表情被从中间裁开了）。
 *
 *  @param index 要从哪个 index 开始裁剪文字
 *  @param lessValue 要按小的长度取，还是按大的长度取
 *  @param countingNonASCIICharacterAsTwo 是否按照 英文 1 个字符长度、中文 2 个字符长度的方式来裁剪
 *  @return 裁剪完的字符
 */
- (NSString *)tmui_substringAvoidBreakingUpCharacterSequencesFromIndex:(NSUInteger)index lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo;

/**
 *  相当于 `tmui_substringAvoidBreakingUpCharacterSequencesFromIndex: lessValue:YES` countingNonASCIICharacterAsTwo:NO
 *  @see tmui_substringAvoidBreakingUpCharacterSequencesFromIndex:lessValue:countingNonASCIICharacterAsTwo:
 */
- (NSString *)tmui_substringAvoidBreakingUpCharacterSequencesFromIndex:(NSUInteger)index;

/**
 *  将字符串从开头裁剪到指定的 index，裁剪时会避免将 emoji 等 "character sequences" 拆散（一个 emoji 表情占用1-4个长度的字符）。
 *
 *  例如对于字符串“😊😞”，它的长度为4，若调用 [string tmui_substringAvoidBreakingUpCharacterSequencesToIndex:1 lessValue:NO countingNonASCIICharacterAsTwo:NO]，将返回“😊”。
 *  若调用系统的 [string substringToIndex:1]，将返回“?”。（?表示乱码，因为第一个 emoji 表情被从中间裁开了）。
 *
 *  @param index 要裁剪到哪个 index 为止（不包含该 index，策略与系统的 substringToIndex: 一致）
 *  @param lessValue 裁剪时若遇到“character sequences”，是向下取整还是向上取整。
 *  @param countingNonASCIICharacterAsTwo 是否按照 英文 1 个字符长度、中文 2 个字符长度的方式来裁剪
 *  @return 裁剪完的字符
 */
- (NSString *)tmui_substringAvoidBreakingUpCharacterSequencesToIndex:(NSUInteger)index lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo;

/**
 *  相当于 `tmui_substringAvoidBreakingUpCharacterSequencesToIndex:lessValue:YES` countingNonASCIICharacterAsTwo:NO
 *  @see tmui_substringAvoidBreakingUpCharacterSequencesToIndex:lessValue:countingNonASCIICharacterAsTwo:
 */
- (NSString *)tmui_substringAvoidBreakingUpCharacterSequencesToIndex:(NSUInteger)index;

/**
 *  将字符串里指定 range 的子字符串裁剪出来，会避免将 emoji 等 "character sequences" 拆散（一个 emoji 表情占用1-4个长度的字符）。
 *
 *  例如对于字符串“😊😞”，它的长度为4，在 lessValue 模式下，裁剪 (0, 1) 得到的是空字符串，裁剪 (0, 2) 得到的是“😊”。
 *  在非 lessValue 模式下，裁剪 (0, 1) 或 (0, 2)，得到的都是“😊”。
 *
 *  @param range 要裁剪的文字位置
 *  @param lessValue 裁剪时若遇到“character sequences”，是向下取整还是向上取整。
 *  @param countingNonASCIICharacterAsTwo 是否按照 英文 1 个字符长度、中文 2 个字符长度的方式来裁剪
 *  @return 裁剪完的字符
 */
- (NSString *)tmui_substringAvoidBreakingUpCharacterSequencesWithRange:(NSRange)range lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo;

/**
 *  相当于 `tmui_substringAvoidBreakingUpCharacterSequencesWithRange:lessValue:YES` countingNonASCIICharacterAsTwo:NO
 *  @see tmui_substringAvoidBreakingUpCharacterSequencesWithRange:lessValue:countingNonASCIICharacterAsTwo:
 */
- (NSString *)tmui_substringAvoidBreakingUpCharacterSequencesWithRange:(NSRange)range;

/**
 *  移除指定位置的字符，可兼容emoji表情的情况（一个emoji表情占1-4个length）
 *  @param index 要删除的位置
 */
- (NSString *)tmui_stringByRemoveCharacterAtIndex:(NSUInteger)index;

/**
 *  移除最后一个字符，可兼容emoji表情的情况（一个emoji表情占1-4个length）
 *  @see `tmui_stringByRemoveCharacterAtIndex:`
 */
- (NSString *)tmui_stringByRemoveLastCharacter;

/**
 用正则表达式匹配字符串，将匹配到的第一个结果返回，大小写不敏感

 @param pattern 正则表达式
 @return 匹配到的第一个结果，如果没有匹配成功则返回 nil
 */
- (NSString *)tmui_stringMatchedByPattern:(NSString *)pattern;

/**
 *  用正则表达式匹配字符串并将其替换为指定的另一个字符串，大小写不敏感
 *  @param pattern 正则表达式
 *  @param replacement 要替换为的字符串
 *  @return 最终替换后的完整字符串，如果正则表达式匹配不成功则返回原字符串
 */
- (NSString *)tmui_stringByReplacingPattern:(NSString *)pattern withString:(NSString *)replacement;

/// 把某个十进制数字转换成十六进制的数字的字符串，例如“10”->“A”
+ (NSString *)tmui_hexStringWithInteger:(NSInteger)integer;

/// 把参数列表拼接成一个字符串并返回，相当于用另一种语法来代替 [NSString stringWithFormat:]
+ (NSString *)tmui_stringByConcat:(id)firstArgv, ...;

/**
 * 将秒数转换为同时包含分钟和秒数的格式的字符串，例如 100->"01:40"
 */
+ (NSString *)tmui_timeStringWithMinsAndSecsFromSecs:(double)seconds;

@end

@interface NSString (TMUI_StringFormat)

+ (instancetype)tmui_stringWithNSInteger:(NSInteger)integerValue;
+ (instancetype)tmui_stringWithCGFloat:(CGFloat)floatValue;
+ (instancetype)tmui_stringWithCGFloat:(CGFloat)floatValue decimal:(NSUInteger)decimal;
@end



@interface NSString (TMUI_Calculate)

///=============================================================================
/// @name Drawing
///=============================================================================

/**
 Returns the size of the string if it were rendered with the specified constraints.
 
 @note 高度取决于富文本中最大的字体，计算高度时候最好传入最大的字体
 
 @param font          The font to use for computing the string size.
 
 @param size          The maximum acceptable size for the string. This value is
 used to calculate where line breaks and wrapping would occur.
 
 @param lineHeight  The The distance in points between the bottom of one line fragment and the top of the next..
 
 @param lineBreakMode The line break options for computing the size of the string.
 For a list of possible values, see NSLineBreakMode.
 
 @return              The width and height of the resulting string's bounding box.
 These values may be rounded up to the nearest whole number.
 */
- (CGSize)tmui_sizeForFont:(UIFont *)font size:(CGSize)size lineHeight:(CGFloat)lineHeight mode:(NSLineBreakMode)lineBreakMode;
/**
 Returns the width of the string if it were to be rendered with the specified
 font on a single line.
 
 @param font  The font to use for computing the string width.
 
 @return      The width of the resulting string's bounding box. These values may be
 rounded up to the nearest whole number.
 */
- (CGFloat)tmui_widthForFont:(UIFont *)font;

/**
 Returns the height of the string if it were rendered with the specified constraints.
 
 @param font   The font to use for computing the string size.
 
 @param width  The maximum acceptable width for the string. This value is used
 to calculate where line breaks and wrapping would occur.
 
 @return       The height of the resulting string's bounding box. These values
 may be rounded up to the nearest whole number.
 */
- (CGFloat)tmui_heightForFont:(UIFont *)font width:(CGFloat)width;


/// 获取行数
/// @param font 字体
/// @param maxWidth 宽度
- (NSArray *)tmui_linesArrayForFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

//////  follow from NSString + TSize
/**
 * 获取字符串显示的高度
 */
- (CGFloat)tmui_heightWithFont:(UIFont *)ft width:(CGFloat)w;

/**
 *  获取字符串的高度，可限制行数
 *
 *  @param ft      字体
 *  @param w       宽度
 *  @param lineNum 限制行数，0表示不限制
 *
 *  @return 字符串高度
 */
- (CGFloat)tmui_heightWithFont:(UIFont *)ft width:(CGFloat)w maxLine:(NSUInteger)lineNum;

/**
 *  获取字符串的宽高（在指定的宽度下）
 *
 *  @param ft 字体
 *  @param w  指定宽
 *
 *  @return 字符串大大小
 */
- (CGSize)tmui_sizeWithFont:(UIFont *)ft width:(CGFloat)w;
/**
 * 获取给定size的换行符
 */
+ (NSString *)tmui_strOfLineForSize:(CGSize)s withFont:(UIFont *)ft;


/**
 * 获取给定width的空格符
 */
+ (NSString *)tmui_strOfSpaceForWidth:(CGFloat)width withFont:(UIFont *)ft;

/**计算文本行数*/
- (NSInteger)tmui_numberOfLinesWithFont:(UIFont *)font
                    contrainstedToWidth:(CGFloat)width;

/**每一行文本高度*/
- (CGFloat)tmui_lineHeightWithFont:(UIFont *)font
               contrainstedToWidth:(CGFloat)width;


@end



@interface NSCharacterSet (TMUI)

/**
 也即在系统的 URLQueryAllowedCharacterSet 基础上去掉“#&=”这3个字符，专用于 URL query 里来源于用户输入的 value，避免服务器解析出现异常。
 */
@property (class, readonly, copy) NSCharacterSet *tmui_URLUserInputQueryAllowedCharacterSet;

@end



@interface NSString (TMUI_TCategory)

// 不区分大小写查找文字，并添加颜色
- (NSMutableAttributedString *)tmui_attributeWithRangeOfString:(NSString *)aString color:(UIColor *)color;

/**
 *  去掉空格后字符串的长度
 *
 *  @return 去掉字符串后的字符串
 */
- (NSString *)tmui_trimSpace;

/**
 *  替换掉空格后字符串的长度
 *
 */
- (NSString *)tmui_trimAllSpace;

/**
 *  字符串字节长度(默认一个汉字两个字符：kCFStringEncodingUTF16)
 *
 *  @return 长度
 */
- (NSUInteger)tmui_lenght;
/**
 *  字符串字节长度
 *
 *  @param encoding NSStringEncoding
 *
 *  @return 长度
 */
- (NSUInteger)tmui_lenghtForNSStringEncoding:(CFStringEncoding)encoding;

/**
 *  将Unicode字符装成汉字
 *
 *  @param unicodeStr unicode字符
 *
 *  @return 返回汉字
 */
+ (NSString *)tmui_replaceUnicode:(NSString *)unicodeStr;

/**
 *  是否为数字或字母
 *
 */
- (BOOL)tmui_isalnum;

/**
 *  是否包含标点符号
 *
 */
- (BOOL)tmui_haspunct;

/**
 *  是否包含Emoji
 *
 */
- (BOOL)tmui_containsEmoji;

/**
 *  手机号码格式字符串 （中间四位换成*）
 *
 */
- (NSString *)tmui_mobileFormat;

/**
 * 根据给定的评论、点赞、收藏默认字符返回经过格式化处理的字符串
 * 格式化规则如下:
 * 0 : defaultTextde
 * 10000 : 1W
 * 10999 : 1W
 * 11234 : 1.1W
 */
+ (NSString *)tmui_formatTextFromDefault:(NSString *)defaultText number:(NSNumber *)number;

@end

@interface NSString (Verify)

/**判空 使用+方法 因为如果使用-方法，类型不对或者空对象，根本不会执行该方法
空对象、类型不对、纯空格或者长度为0，都是YES*/
+ (BOOL)tmui_isEmpty:(NSString *)string;

/**整数*/
- (BOOL)tmui_isPureInt;

/**电话号码，11位*/
- (BOOL)tmui_isMobileNumber;

/**包含子串，iOS8以前没有containsString这个API；
默认不忽略大小写*/
- (BOOL)tmui_containsSubstring:(NSString *)string;

/**包含子串，ignoreCase：是否忽略大小写*/
- (BOOL)tmui_containsSubstring:(NSString *)string ignoreCase:(BOOL)ignore;

@end

@interface NSString (Attribute)

/**转化为富文本*/
- (NSMutableAttributedString *)tmui_convertToAttributedStringWithFont:(UIFont *)font
                                                            textColor:(UIColor *)color;
/**转化为富文本，支持设置行间距*/
- (NSMutableAttributedString *)tmui_attributedStringFormatLineWithFont:(UIFont *)font
                                                                 color:(UIColor *)color
                                                              maxWidth:(CGFloat)maxWidth
                                                           lineSpacing:(CGFloat)spacing
                                                             alignment:(NSTextAlignment)alignment;

@end

@interface NSString (Debug)

/// 生成随机汉字（100个）
+ (NSString *)tmui_random;

/// 生成随机汉字
/// @param count 汉字个数
+ (NSString *)tmui_random:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
