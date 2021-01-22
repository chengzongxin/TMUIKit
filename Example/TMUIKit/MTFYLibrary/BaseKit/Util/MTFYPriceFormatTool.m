//
//  MTFYPriceFormatTool.m
//  Matafy
//
//  Created by Tiaotiao on 2019/4/11.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYPriceFormatTool.h"

@implementation MTFYPriceFormatTool

+ (NSMutableAttributedString *)mtfy_formatPrice:(NSString *)priceStr {
    
    NSMutableAttributedString *attributeDefaultPriceStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange moneyUnitRange = [priceStr rangeOfString:@"元"];
    if (moneyUnitRange.length > 0) {
        NSDictionary *attributesDic = @{
                                        NSFontAttributeName: [UIFont pingFangSCMedium:14.0],
                                        NSBaselineOffsetAttributeName: @(2.5)
                                        };
        [attributeDefaultPriceStr setAttributes:attributesDic range:moneyUnitRange];
    }
    
    return attributeDefaultPriceStr;
}

+ (NSString *)mtfy_formatPriceWithString:(NSString *)priceStr {
    CGFloat totalPrice = [priceStr doubleValue] * 0.01;
    
    return [NSString stringWithFormat:@"%.2f", totalPrice];
}

+ (NSString *)mtfy_formatPriceWithInt:(NSInteger)money {
    CGFloat moneyF = money * 0.01;
    return [NSString stringWithFormat:@"%.2f", moneyF];
}

+ (NSString *)mtfy_formatPrice:(CGFloat)yuan decimalPoint:(NSUInteger)decimalPoint {
    if (yuan <= 0) {
        return @"0.00";
    }
    
    NSString *formatStr = [NSString stringWithFormat:@"%@.%luf", @"%", (unsigned long)decimalPoint];
    NSString *resultStr = [NSString stringWithFormat:formatStr, yuan];
    
    return resultStr;
}

+ (NSString *)mtfy_formatPriceWithoutZero:(CGFloat)yuan decimalPoint:(NSUInteger)decimalPoint {
    if (yuan <= 0) {
        return @"0";
    }
    
    NSString *formatStr = [NSString stringWithFormat:@"%@.%luf", @"%", (unsigned long)decimalPoint];
    NSString *resultStr = [NSString stringWithFormat:formatStr, yuan];
    
    // 处理下小数点为0的情况
    resultStr = [self mtfy_formatPriceWithoutFloatZero:resultStr];
    
    return resultStr;
}

+ (NSString*)mtfy_formatPriceWithoutFloatZero:(NSString*)oriString
{
    NSArray *arrStr = [oriString componentsSeparatedByString:@"."];
    NSString *iStr = arrStr.firstObject;
    NSString *fStr = arrStr.lastObject;
    
    while ([fStr hasSuffix:@"0"]) {
        fStr = [fStr substringToIndex:(fStr.length - 1)];
    }
    return (fStr.length > 0) ? [NSString stringWithFormat:@"%@.%@", iStr, fStr] : iStr;
}

+ (NSString*)mtfy_formatPriceValid:(CGFloat)priceCent
{
    if (priceCent <= 0) {
        return @"--";
    }
    
    NSString *resultStr = [NSString stringWithFormat:@"%.0f", (ceil)(priceCent / 100.0)];

    return resultStr;
}

+ (CGFloat)mtfy_convertPriceCentToYuan:(CGFloat)cent {
    return cent * 0.01;
}

+ (NSString *)mtfy_formatPriceShowString:(CGFloat)yuanMoney {
    if (yuanMoney <= 0) {
        return @"--";
    }
    
    if (yuanMoney < 10000) {
        NSString *priceStr = [NSString stringWithFormat:@"%.0f", yuanMoney];
        NSString *allPriceStr = [NSString stringWithFormat:@"%@%@", [MTFYUnitTool mtfy_priceUnitSymbol], priceStr];
        
        return allPriceStr;
    }
    
    CGFloat tenThousandMoney = yuanMoney / 10000.0;
    
    NSString *priceStr = [NSString stringWithFormat:@"%.1lf", tenThousandMoney];

    if (([priceStr doubleValue] - [priceStr integerValue]) == 0) {
        priceStr = [NSString stringWithFormat:@"%.0f", tenThousandMoney];
    }
 
    NSString *allPriceStr = [NSString stringWithFormat:@"%@%@%@", [MTFYUnitTool mtfy_priceUnitSymbol], priceStr, [MTFYUnitTool mtfy_priceUnitTenThousand]];
    
    return allPriceStr;
}

@end
