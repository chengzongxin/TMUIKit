//
//  NSString+MTFYBaseNSString.m
//  Matafy
//
//  Created by Tiaotiao on 2019/4/12.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "NSString+MTFYBaseNSString.h"

@implementation NSString (MTFYBaseNSString)

+ (NSString *)validStr:(nullable NSString *)string
{
    if (!string
        || [string isKindOfClass:[NSNull class]]
        || [string isEqualToString:@"<null>"]) {
        return @"";
    }
    return string;
}

+ (NSString *)validStrToZero:(nullable NSString *)string
{
    if (!string
        || [string isKindOfClass:[NSNull class]]
        || [string isEqualToString:@"<null>"]) {
        return @"0";
    }
    return string;
}


+ (BOOL)isEmpty:(nullable NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }

    if ([string isKindOfClass:[NSNull class]] || ![string isKindOfClass:[NSString class]] || [string isEqualToString:@""]) {
        return YES;
    }

    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }

    return NO;
}

+ (BOOL)isNotEmpty:(nullable NSString *)string {
    return ![self isEmpty:string];
}


+ (NSString *)validStrToDividingLine:(NSString *)string
{
    if (!string
        || [string isKindOfClass:[NSNull class]]
        || [string isEqualToString:@"<null>"]) {
        return @"-";
    }
    return string;
}

+ (NSString *)validStrToDoubleDividingLine:(NSString *)string
{
    if (!string
        || [string isKindOfClass:[NSNull class]]
        || [string isEqualToString:@"<null>"]) {
        return @"--";
    }
    return string;
}

- (CGFloat)mtfy_heightWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    CGSize size = [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    size = CGSizeMake(ceilf(size.width), ceilf(size.height));
    return size.height;
}

- (CGFloat)mtfy_widthWithFont:(UIFont *)font {
    CGSize size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    size = CGSizeMake(ceilf(size.width), ceilf(size.height));
    return size.width;
}

- (CGFloat)mtfy_heightWithFont:(UIFont *)font lineBeakMode:(NSLineBreakMode)lineBreakMode maxWidth:(CGFloat)maxWidth {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: style
    };
    CGSize size = [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    size = CGSizeMake(ceilf(size.width), ceilf(size.height));
    return ceil(size.height) + 1;
}

@end
