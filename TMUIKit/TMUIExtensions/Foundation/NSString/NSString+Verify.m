//
//  NSString+Verify.m
//  TMUIKitmui_Example
//
//  Created by cl w on 2021/2/1.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "NSString+Verify.h"

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
