//
//  NSString+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/25.
//

#import "NSString+TMUI.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSArray+TMUI.h"
#import "TMUICommonDefines.h"
#import <objc/runtime.h>

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

- (NSString *)tmui_md5_upper {
    return [[self tmui_md5] uppercaseString];
}

- (NSString *)tmui_md5_16bit {
    NSString *byte_32 = [self tmui_md5];
    if (byte_32.length>16) {
        return [byte_32 substringToIndex:16];
    }
    return byte_32;
}

- (NSString *)tmui_md5_16bit_upper {
    return [[self tmui_md5_16bit] uppercaseString];
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
BeginIgnoreDeprecatedWarning

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
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
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


// 获取字符串显示的高度
- (CGFloat)tmui_heightWithFont:(UIFont *)ft width:(CGFloat)w {
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        CGSize size = [self boundingRectWithSize:CGSizeMake(w, 100000)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:ft}
                                         context:nil].size;
        return ceilf(size.height);
    } else {
        CGSize s = [self sizeWithFont:ft constrainedToSize:CGSizeMake(w, 100000)];
        return ceilf(s.height);
    }
}

- (CGSize)tmui_sizeWithFont:(UIFont *)ft width:(CGFloat)w {
    CGSize ceilfSize;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        CGSize size = [self boundingRectWithSize:CGSizeMake(w, 100000)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:ft}
                                         context:nil].size;
        ceilfSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    } else {
        CGSize s = [self sizeWithFont:ft constrainedToSize:CGSizeMake(w, 100000)];
        ceilfSize = CGSizeMake(ceilf(s.width), ceilf(s.height));
    }
    return ceilfSize;
}

- (CGFloat)tmui_heightWithFont:(UIFont *)ft width:(CGFloat)w maxLine:(NSUInteger)lineNum {
    CGFloat heightOfAll = [self tmui_heightWithFont:ft width:w];
    CGFloat heightOfMax = CGFLOAT_MAX;
    if (lineNum != 0) {
        NSString *strTem = @"a";
        for (int i=0; i<lineNum-1; i++) {
            strTem = [strTem stringByAppendingString:@"\na"];
        }
        heightOfMax = [strTem tmui_heightWithFont:ft width:w];
    }
    return ceilf(MIN(heightOfAll, heightOfMax));
}

// 获取给定size的换行符
+ (NSString *)tmui_strOfLineForSize:(CGSize)s withFont:(UIFont *)ft {
    NSString *str = @"";
    CGFloat h = [@"\n\n\n\n\n\n\n\n\n\n" tmui_heightWithFont:ft width:300];
    for (int i=0; i<ceilf(s.height*10/h); i++) {
        str = [str stringByAppendingString:@"\n"];
    }
    return str;
}

+ (NSString *)tmui_strOfSpaceForWidth:(CGFloat)width withFont:(UIFont *)ft {
    if (width<=0) {
        return @"";
    }
    NSString *str = @" ";
    
    CGFloat w = [str sizeWithFont:ft].width;
    NSUInteger num = ceilf(width/w);
    for (int i=1; i<num; i++) {
        str = [str stringByAppendingString:@" "];
    }
    return str;
}

- (NSInteger)tmui_numberOfLinesWithFont:(UIFont *)font contrainstedToWidth:(CGFloat)width
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    label.text = self;
    label.numberOfLines = 0;
    label.font = font?:[UIFont systemFontOfSize:17];
    [label sizeToFit];
    CGFloat height = CGRectGetHeight(label.frame);
    CGFloat lineH = [self tmui_lineHeightWithFont:font contrainstedToWidth:width];
    if (lineH>0) {
        NSInteger lines = height/lineH;
        return lines;
    }
    return 0;
}

- (CGFloat)tmui_lineHeightWithFont:(UIFont *)font contrainstedToWidth:(CGFloat)width
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    label.text = @"o";
    label.numberOfLines = 0;
    label.font = font?:[UIFont systemFontOfSize:17];
    [label sizeToFit];
    CGFloat height = CGRectGetHeight(label.frame);
    return height;
}


@end
EndIgnoreDeprecatedWarning

@implementation NSCharacterSet (TMUI)

+ (NSCharacterSet *)tmui_URLUserInputQueryAllowedCharacterSet {
    NSMutableCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet].mutableCopy;
    [set removeCharactersInString:@"#&="];
    return set.copy;
}

@end



@implementation NSString (TMUI_TCategory)

- (NSMutableAttributedString *)tmui_attributeWithRangeOfString:(NSString *)aString color:(UIColor *)color {
    NSRange range = [self rangeOfString:aString options:NSCaseInsensitiveSearch];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:self];
    [attribute addAttribute:NSForegroundColorAttributeName value:color range:range];
    return attribute;
}

- (NSString *)tmui_trimSpace {
   return  [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)tmui_trimAllSpace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSUInteger)tmui_lenght {
    return [self tmui_lenghtForNSStringEncoding:kCFStringEncodingUTF16];
}

- (NSUInteger)tmui_lenghtForNSStringEncoding:(CFStringEncoding)encoding {
    NSUInteger len = 0;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(encoding);
    len = [self lengthOfBytesUsingEncoding:enc];
    return len;
}

+ (NSString *)tmui_replaceUnicode:(NSString *)unicodeStr {
    if (![unicodeStr isKindOfClass:[NSString class]] || unicodeStr.length<1) {
        return @"";
    }
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData
                                                                    options:NSPropertyListImmutable
                                                                     format:nil
                                                                      error:nil];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

- (BOOL)tmui_isalnum {
    unichar c;
    for (int i=0; i<self.length; i++) {
        c=[self characterAtIndex:i];
        if (!isalnum(c)) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)tmui_haspunct {
    unichar c;
    for (int i=0; i<self.length; i++) {
        c=[self characterAtIndex:i];
        if (ispunct(c)) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)tmui_containsEmoji {
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar hs = [substring characterAtIndex:0];
                              if (0xd800 <= hs && hs <= 0xdbff) {
                                  if (substring.length > 1) {
                                      const unichar ls = [substring characterAtIndex:1];
                                      const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                      if (0x1d000 <= uc && uc <= 0x1f77f) {
                                          returnValue = YES;
                                      }
                                  }
                              } else if (substring.length > 1) {
                                  const unichar ls = [substring characterAtIndex:1];
                                  if (ls == 0x20e3) {
                                      returnValue = YES;
                                  }
                              } else {
                                  if (0x2100 <= hs && hs <= 0x27ff) {
                                      returnValue = YES;
                                  } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                      returnValue = YES;
                                  } else if (0x2934 <= hs && hs <= 0x2935) {
                                      returnValue = YES;
                                  } else if (0x3297 <= hs && hs <= 0x3299) {
                                      returnValue = YES;
                                  } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                      returnValue = YES;
                                  }
                              }
                          }];
    return returnValue;
}

-(NSString *)tmui_mobileFormat{
    if (self.length<7) {
        return self;
    }
    return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}


+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selName = NSStringFromSelector(sel);
    if ([selName isEqualToString:@"containsString:"]) {
        return class_addMethod(self, sel, (IMP)tmui_containsString, "i@:@");
    }
    return [super resolveInstanceMethod:sel];
}

int tmui_containsString(NSString *self, SEL _cmd, NSString *aString) {
    return [self rangeOfString:aString].length > 0;
}

#pragma mark - 格式化评论、点赞、收藏数
+ (NSString *)tmui_formatTextFromDefault:(NSString *)defaultText number:(NSNumber *)number {
    NSString * formatText = nil;
    if ([number respondsToSelector:@selector(integerValue)]) {
        if (!number.integerValue) {
            formatText = defaultText;
        } else if (number.integerValue >= 10000) {
            CGFloat floatValue = number.floatValue/1000.0f;
            CGFloat resultValue = floatValue + 0.5f;
            formatText = [NSString stringWithFormat:@"%.1fW", floorf(resultValue)/10.0f];
        } else {
            formatText = [NSString stringWithFormat:@"%@", number];
        }
    } else {
        formatText = defaultText;
    }
    return formatText;
}

@end

@implementation NSString (Verify)

+ (BOOL)tmui_isEmpty:(NSString *)string
{
    if (!string) {
        return YES;
    } else if (![string isKindOfClass:[NSString class]]) {
        return YES;
    } else if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)tmui_isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)tmui_isMobileNumber
{
    NSString *Regex = @"^(1[3-9])\\d{9}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    BOOL ret = [mobileTest evaluateWithObject:self];
    return ret;
}

- (BOOL)tmui_containsSubstring:(NSString *)string
{
    return [self tmui_containsSubstring:string ignoreCase:NO];
}

- (BOOL)tmui_containsSubstring:(NSString *)string ignoreCase:(BOOL)ignore
{
    if (!string || ![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    if (!ignore) {
        return [self rangeOfString:string].location != NSNotFound;
    }
    return [[self uppercaseString] rangeOfString:[string uppercaseString]].location != NSNotFound;
}

@end

@implementation NSString (Attribute)

- (NSMutableAttributedString *)tmui_convertToAttributedStringWithFont:(UIFont *)font textColor:(UIColor *)color
{
    if (!font) {
        font = [UIFont systemFontOfSize:16];
    }
    if (!color) {
        color = [UIColor colorWithRed:17/255.f green:17/255.f blue:17/255.f alpha:1];
    }
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    return mStr;
}

- (NSMutableAttributedString *)tmui_attributedStringFormatLineWithFont:(UIFont *)font
                                                                 color:(UIColor *)color
                                                              maxWidth:(CGFloat)maxWidth
                                                           lineSpacing:(CGFloat)spacing
                                                             alignment:(NSTextAlignment)alignment{
    if (!font) {
        font = [UIFont systemFontOfSize:16];
    }
    if (!color) {
        color = [UIColor colorWithRed:17/255.f green:17/255.f blue:17/255.f alpha:1];
    }
    
    if (self == nil || self.length == 0) {
        return [[NSMutableAttributedString alloc] initWithString:@"" attributes:nil];;
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.lineSpacing = spacing;
    style.alignment = alignment;
    NSDictionary * attributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName:color, NSParagraphStyleAttributeName:style};
    NSInteger line = [self tmui_numberOfLinesWithFont:font contrainstedToWidth:maxWidth];
    if (line == 1){
        //单行的时候去掉行间距
        style.lineSpacing = 0;
    }
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self attributes:attributes];
    return [attributedString mutableCopy];
}

@end

