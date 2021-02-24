//
//  NSString+MD5.m
//  TMUIKitmui_Example
//
//  Created by cl w on 2021/2/1.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

- (NSString *)tmui_getMd5_16Bit {
    NSString *byte_32 = [self tmui_getMd5_32Bit];
    if (byte_32.length>16) {
        return [byte_32 substringToIndex:16];
    }
    return byte_32;
}

- (NSString *)tmui_getMd5_32Bit {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = @"".mutableCopy;
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

- (NSString *)tmui_getMd5_16Bit_upperString {
    return [[self tmui_getMd5_16Bit] uppercaseString];
}

- (NSString *)tmui_getMd5_32Bit_upperString {
    return [[self tmui_getMd5_32Bit] uppercaseString];
}


@end
