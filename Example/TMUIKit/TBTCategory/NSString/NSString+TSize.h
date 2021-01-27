//
//  NSString+TSize.h
//  TBasicLib
//
//  Created by Jerry.jiang on 14-12-2.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TSize)

/**
 * 获取字符串显示的高度
 */
- (CGFloat)heightWithFont:(UIFont *)ft width:(CGFloat)w;
/**
 *  获取字符串的宽高（在指定的宽度下）
 *
 *  @param ft 字体
 *  @param w  指定宽
 *
 *  @return 字符串大大小
 */
- (CGSize)sizeWithFont:(UIFont *)ft width:(CGFloat)w;

/**
 *  获取字符串的高度，可限制行数
 *
 *  @param ft      字体
 *  @param w       宽度
 *  @param lineNum 限制行数，0表示不限制
 *
 *  @return 字符串高度
 */
- (CGFloat)heightWithFont:(UIFont *)ft width:(CGFloat)w maxLine:(NSUInteger)lineNum;


/**
 * 获取给定size的换行符
 */
+ (NSString *)strOfLineForSize:(CGSize)s withFont:(UIFont *)ft;


/**
 * 获取给定width的空格符
 */
+ (NSString *)strOfSpaceForWidth:(CGFloat)width withFont:(UIFont *)ft;



@end
