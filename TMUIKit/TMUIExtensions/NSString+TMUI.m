//
//  NSString+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/25.
//

#import "NSString+TMUI.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSArray+TMUI.h"

@implementation NSString (TMUI)

- (NSArray<NSString *> *)tmui_toArray {
    if (!self.length) {
        return nil;
    }
    
    NSMutableArray<NSString *> *array = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.length; i++) {
        NSString *stringItem = [self substringWithRange:NSMakeRange(i, 1)];
        [array addObject:stringItem];
    }
    return [array copy];
}

- (NSArray<NSString *> *)tmui_toTrimmedArray {
    return [[self tmui_toArray] tmui_filter:^BOOL(NSString *item) {
        return item.tmui_trim.length > 0;
    }];
}

- (NSString *)tmui_trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)tmui_trimAllWhiteSpace {
    return [self stringByReplacingOccurrencesOfString:@"\\s" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

- (NSString *)tmui_trimLineBreakCharacter {
    return [self stringByReplacingOccurrencesOfString:@"[\r\n]" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

- (NSString *)tmui_md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

- (NSString *)tmui_stringByEncodingUserInputQuery {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet tmui_URLUserInputQueryAllowedCharacterSet]];
}

- (NSString *)tmui_capitalizedString {
    if (self.length)
        return [NSString stringWithFormat:@"%@%@", [self substringToIndex:1].uppercaseString, [self substringFromIndex:1]].copy;
    return nil;
}

+ (NSString *)hexLetterStringWithInteger:(NSInteger)integer {
    NSAssert(integer < 16, @"要转换的数必须是16进制里的个位数，也即小于16，但你传给我是%@", @(integer));
    
    NSString *letter = nil;
    switch (integer) {
        case 10:
            letter = @"A";
            break;
        case 11:
            letter = @"B";
            break;
        case 12:
            letter = @"C";
            break;
        case 13:
            letter = @"D";
            break;
        case 14:
            letter = @"E";
            break;
        case 15:
            letter = @"F";
            break;
        default:
            letter = [[NSString alloc]initWithFormat:@"%@", @(integer)];
            break;
    }
    return letter;
}

+ (NSString *)tmui_hexStringWithInteger:(NSInteger)integer {
    NSString *hexString = @"";
    NSInteger remainder = 0;
    for (NSInteger i = 0; i < 9; i++) {
        remainder = integer % 16;
        integer = integer / 16;
        NSString *letter = [self hexLetterStringWithInteger:remainder];
        hexString = [letter stringByAppendingString:hexString];
        if (integer == 0) {
            break;
        }
        
    }
    return hexString;
}

+ (NSString *)tmui_stringByConcat:(id)firstArgv, ... {
    if (firstArgv) {
        NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"%@", firstArgv];
        
        va_list argumentList;
        va_start(argumentList, firstArgv);
        id argument;
        while ((argument = va_arg(argumentList, id))) {
            [result appendFormat:@"%@", argument];
        }
        va_end(argumentList);
        
        return [result copy];
    }
    return nil;
}

+ (NSString *)tmui_timeStringWithMinsAndSecsFromSecs:(double)seconds {
    NSUInteger min = floor(seconds / 60);
    NSUInteger sec = floor(seconds - min * 60);
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)min, (long)sec];
}

- (NSString *)tmui_removeMagicalChar {
    if (self.length == 0) {
        return self;
    }
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\u0300-\u036F]" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length) withTemplate:@""];
    return modifiedString;
}

- (NSUInteger)tmui_lengthWhenCountingNonASCIICharacterAsTwo {
    NSUInteger length = 0;
    for (NSUInteger i = 0, l = self.length; i < l; i++) {
        unichar character = [self characterAtIndex:i];
        if (isascii(character)) {
            length += 1;
        } else {
            length += 2;
        }
    }
    return length;
}

- (NSUInteger)transformIndexToDefaultModeWithIndex:(NSUInteger)index {
    CGFloat strlength = 0.f;
    NSUInteger i = 0;
    for (i = 0; i < self.length; i++) {
        unichar character = [self characterAtIndex:i];
        if (isascii(character)) {
            strlength += 1;
        } else {
            strlength += 2;
        }
        if (strlength >= index + 1) return i;
    }
    return 0;
}

- (NSRange)transformRangeToDefaultModeWithRange:(NSRange)range {
    CGFloat strlength = 0.f;
    NSRange resultRange = NSMakeRange(NSNotFound, 0);
    NSUInteger i = 0;
    for (i = 0; i < self.length; i++) {
        unichar character = [self characterAtIndex:i];
        if (isascii(character)) {
            strlength += 1;
        } else {
            strlength += 2;
        }
        if (strlength >= range.location + 1) {
            if (resultRange.location == NSNotFound) {
                resultRange.location = i;
            }
            
            if (range.length > 0 && strlength >= NSMaxRange(range)) {
                resultRange.length = i - resultRange.location + (strlength == NSMaxRange(range) ? 1 : 0);
                return resultRange;
            }
        }
    }
    return resultRange;
}

- (NSString *)tmui_substringAvoidBreakingUpCharacterSequencesFromIndex:(NSUInteger)index lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo {
    NSAssert(index < self.length, @"index out of bounds");
    if (index >= self.length) return @"";
    index = countingNonASCIICharacterAsTwo ? [self transformIndexToDefaultModeWithIndex:index] : index;
    NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:index];
    BOOL matchedCharacterSequence = range.length > 1;
    return [self substringFromIndex:matchedCharacterSequence && lessValue ? NSMaxRange(range) : range.location];
}

- (NSString *)tmui_substringAvoidBreakingUpCharacterSequencesFromIndex:(NSUInteger)index {
    return [self tmui_substringAvoidBreakingUpCharacterSequencesFromIndex:index lessValue:YES countingNonASCIICharacterAsTwo:NO];
}

- (NSString *)tmui_substringAvoidBreakingUpCharacterSequencesToIndex:(NSUInteger)index lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo {
    NSAssert(index <= self.length, @"index out of bounds");
    if (index == 0 || index > self.length) return @"";
    index = countingNonASCIICharacterAsTwo ? [self transformIndexToDefaultModeWithIndex:index] : index;
    NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:index - 1];
    BOOL matchedCharacterSequence = range.length > 1;
    return [self substringToIndex:matchedCharacterSequence && lessValue ? range.location + 1 : NSMaxRange(range)];
}

- (NSString *)tmui_substringAvoidBreakingUpCharacterSequencesToIndex:(NSUInteger)index {
    return [self tmui_substringAvoidBreakingUpCharacterSequencesToIndex:index lessValue:YES countingNonASCIICharacterAsTwo:NO];
}

- (NSString *)tmui_substringAvoidBreakingUpCharacterSequencesWithRange:(NSRange)range lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo {
    range = countingNonASCIICharacterAsTwo ? [self transformRangeToDefaultModeWithRange:range] : range;
    NSRange characterSequencesRange = lessValue ? [self downRoundRangeOfComposedCharacterSequencesForRange:range] : [self rangeOfComposedCharacterSequencesForRange:range];
    NSString *resultString = [self substringWithRange:characterSequencesRange];
    return resultString;
}

- (NSString *)tmui_substringAvoidBreakingUpCharacterSequencesWithRange:(NSRange)range {
    return [self tmui_substringAvoidBreakingUpCharacterSequencesWithRange:range lessValue:YES countingNonASCIICharacterAsTwo:NO];
}

- (NSRange)downRoundRangeOfComposedCharacterSequencesForRange:(NSRange)range {
    if (range.length == 0) {
        return range;
    }
    
    NSRange resultRange = [self rangeOfComposedCharacterSequencesForRange:range];
    if (NSMaxRange(resultRange) > NSMaxRange(range)) {
        return [self downRoundRangeOfComposedCharacterSequencesForRange:NSMakeRange(range.location, range.length - 1)];
    }
    return resultRange;
}

- (NSString *)tmui_stringByRemoveCharacterAtIndex:(NSUInteger)index {
    NSRange rangeForRemove = [self rangeOfComposedCharacterSequenceAtIndex:index];
    NSString *resultString = [self stringByReplacingCharactersInRange:rangeForRemove withString:@""];
    return resultString;
}

- (NSString *)tmui_stringByRemoveLastCharacter {
    return [self tmui_stringByRemoveCharacterAtIndex:self.length - 1];
}

- (NSString *)tmui_stringMatchedByPattern:(NSString *)pattern {
    NSRange range = [self rangeOfString:pattern options:NSRegularExpressionSearch|NSCaseInsensitiveSearch];
    if (range.location != NSNotFound) {
        return [self substringWithRange:range];
    }
    return nil;
}

- (NSString *)tmui_stringByReplacingPattern:(NSString *)pattern withString:(NSString *)replacement {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        return self;
    }
    return [regex stringByReplacingMatchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length) withTemplate:replacement];
}

@end

@implementation NSString (TMUI_StringFormat)

+ (instancetype)tmui_stringWithNSInteger:(NSInteger)integerValue {
    return @(integerValue).stringValue;
}

+ (instancetype)tmui_stringWithCGFloat:(CGFloat)floatValue {
    return [NSString tmui_stringWithCGFloat:floatValue decimal:2];
}

+ (instancetype)tmui_stringWithCGFloat:(CGFloat)floatValue decimal:(NSUInteger)decimal {
    NSString *formatString = [NSString stringWithFormat:@"%%.%@f", @(decimal)];
    return [NSString stringWithFormat:formatString, floatValue];
}

@end


@implementation NSString (TMUI_Drawing)


- (CGSize)tmui_sizeForFont:(UIFont *)font size:(CGSize)size lineHeight:(CGFloat)lineHeight mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping || lineHeight) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            paragraphStyle.lineSpacing = lineHeight;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return CGSizeMake(ceilf(result.width), ceilf(result.height));
}

- (CGFloat)tmui_widthForFont:(UIFont *)font {
    CGSize size = [self tmui_sizeForFont:font size:CGSizeMake(HUGE, HUGE) lineHeight:0 mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)tmui_heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self tmui_sizeForFont:font size:CGSizeMake(width, HUGE) lineHeight:0 mode:NSLineBreakByWordWrapping];
    return size.height;
}


@end


@implementation NSCharacterSet (TMUI)

+ (NSCharacterSet *)tmui_URLUserInputQueryAllowedCharacterSet {
    NSMutableCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet].mutableCopy;
    [set removeCharactersInString:@"#&="];
    return set.copy;
}

@end
