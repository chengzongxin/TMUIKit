//
//  NSString+MTFYBaseNSString.h
//  Matafy
//
//  Created by Tiaotiao on 2019/4/12.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MTFYBaseNSString)

+ (NSString *)validStr:(nullable NSString *)string;

+ (NSString *)validStrToZero:(nullable NSString *)string;

/**
 判断字符是否长度为0 当字符串为纯空格的时候返回的是YES
 
 @param string 字符串
 @return 是否长度为0
 */
+ (BOOL)isEmpty:(nullable NSString *)string;
+ (BOOL)isNotEmpty:(nullable NSString *)string;
+ (NSString *)validStrToDividingLine:(NSString *)string;
+ (NSString *)validStrToDoubleDividingLine:(NSString *)string;

- (CGFloat)mtfy_heightWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;
- (CGFloat)mtfy_widthWithFont:(UIFont *)font;
- (CGFloat)mtfy_heightWithFont:(UIFont *)font lineBeakMode:(NSLineBreakMode)lineBreakMode maxWidth:(CGFloat)maxWidth;

@end

NS_ASSUME_NONNULL_END
