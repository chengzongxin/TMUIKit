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
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = @"".mutableCopy;
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {[result appendFormat:@"%02x", digest[i]];}
    if (result.length>16) {
        return [result substringToIndex:16];
    }
    return result;
}

- (NSString *)tmui_getMd5_32Bit {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = @"".mutableCopy;
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {[result appendFormat:@"%02x", digest[i]];}
    
    return result;
}

- (NSString *)tmui_getMd5_16Bitmui_upperString {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = @"".mutableCopy;
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {[result appendFormat:@"%02X", digest[i]];}
    if (result.length>16) {
        return [result substringToIndex:16];
    }
    return result;
}

- (NSString *)tmui_getMd5_32Bitmui_upperString {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = @"".mutableCopy;
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {[result appendFormat:@"%02X", digest[i]];}
    
    return result;
}


@end
