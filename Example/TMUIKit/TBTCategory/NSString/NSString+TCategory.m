//
//  NSString+TCategory.m
//  HouseKeeper
//
//  Created by to on 14-8-26.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import "NSString+TCategory.h"
#import <objc/runtime.h>

@implementation NSString (TCategory)

- (NSMutableAttributedString *)attributeWithRangeOfString:(NSString *)aString color:(UIColor *)color {
    NSRange range = [self rangeOfString:aString options:NSCaseInsensitiveSearch];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:self];
    [attribute addAttribute:NSForegroundColorAttributeName value:color range:range];
    return attribute;
}

- (NSString *)trimSpace {
   return  [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)trimAllSpace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSUInteger)t_lenght {
    return [self t_lenghtForNSStringEncoding:kCFStringEncodingUTF16];
}

- (NSUInteger)t_lenghtForNSStringEncoding:(CFStringEncoding)encoding {
    NSUInteger len = 0;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(encoding);
    len = [self lengthOfBytesUsingEncoding:enc];
    return len;
}

+ (NSString *)replaceUnicode:(NSString *)unicodeStr {
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

- (BOOL)isalnum {
    unichar c;
    for (int i=0; i<self.length; i++) {
        c=[self characterAtIndex:i];
        if (!isalnum(c)) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)haspunct {
    unichar c;
    for (int i=0; i<self.length; i++) {
        c=[self characterAtIndex:i];
        if (ispunct(c)) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containsEmoji {
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

-(NSString *)t_mobileFormat{
    if (self.length<7) {
        return self;
    }
    return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}


+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selName = NSStringFromSelector(sel);
    if ([selName isEqualToString:@"containsString:"]) {
        return class_addMethod(self, sel, (IMP)t_containsString, "i@:@");
    }
    return [super resolveInstanceMethod:sel];
}

int t_containsString(NSString *self, SEL _cmd, NSString *aString) {
    return [self rangeOfString:aString].length > 0;
}

#pragma mark - 格式化评论、点赞、收藏数
+ (NSString *)formatTextFromDefault:(NSString *)defaultText number:(NSNumber *)number {
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
