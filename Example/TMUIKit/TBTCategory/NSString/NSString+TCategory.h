//
//  NSString+TCategory.h
//  HouseKeeper
//
//  Created by to on 14-8-26.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TCategory)

// 不区分大小写查找文字，并添加颜色
- (NSMutableAttributedString *)attributeWithRangeOfString:(NSString *)aString color:(UIColor *)color;

/**
 *  去掉空格后字符串的长度
 *
 *  @return 去掉字符串后的字符串
 */
- (NSString *)trimSpace;

/**
 *  替换掉空格后字符串的长度
 *
 */
- (NSString *)trimAllSpace;

/**
 *  字符串字节长度(默认一个汉字两个字符：kCFStringEncodingUTF16)
 *
 *  @return 长度
 */
- (NSUInteger)t_lenght;
/**
 *  字符串字节长度
 *
 *  @param encoding NSStringEncoding
 *
 *  @return 长度
 */
- (NSUInteger)t_lenghtForNSStringEncoding:(CFStringEncoding)encoding;

/**
 *  将Unicode字符装成汉字
 *
 *  @param unicodeStr unicode字符
 *
 *  @return 返回汉字
 */
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

/**
 *  是否为数字或字母
 *
 */
- (BOOL)isalnum;

/**
 *  是否包含标点符号
 *
 */
- (BOOL)haspunct;

/**
 *  是否包含Emoji
 *
 */
- (BOOL)containsEmoji;

/**
 *  手机号码格式字符串 （中间四位换成*）
 *
 */
- (NSString *)t_mobileFormat;

/**
 * 根据给定的评论、点赞、收藏默认字符返回经过格式化处理的字符串
 * 格式化规则如下:
 * 0 : defaultTextde
 * 10000 : 1W
 * 10999 : 1W
 * 11234 : 1.1W
 */
+ (NSString *)formatTextFromDefault:(NSString *)defaultText number:(NSNumber *)number;

@end
