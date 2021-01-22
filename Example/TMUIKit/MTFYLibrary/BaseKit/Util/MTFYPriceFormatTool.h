//
//  MTFYPriceFormatTool.h
//  Matafy
//
//  Created by Tiaotiao on 2019/4/11.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTFYPriceFormatTool : NSObject

+ (NSMutableAttributedString *)mtfy_formatPrice:(NSString *)priceStr;

+ (NSString *)mtfy_formatPriceWithString:(NSString *)priceStr;

+ (NSString *)mtfy_formatPriceWithInt:(NSInteger)money;

+ (NSString *)mtfy_formatPrice:(CGFloat)yuan decimalPoint:(NSUInteger)decimalPoint;

+ (NSString *)mtfy_formatPriceWithoutZero:(CGFloat)yuan decimalPoint:(NSUInteger)decimalPoint;

+ (NSString*)mtfy_formatPriceWithoutFloatZero:(NSString*)oriString;

+ (NSString*)mtfy_formatPriceValid:(CGFloat)priceCent;

/**
 分转元

 @param cent 分
 @return 元
 */
+ (CGFloat)mtfy_convertPriceCentToYuan:(CGFloat)cent;

/**
 把元转化为带¥的显示字符串

 @param yuanMoney 元
 @return 显示的字符串
 */
+ (NSString *)mtfy_formatPriceShowString:(CGFloat)yuanMoney;


@end

NS_ASSUME_NONNULL_END
