//
//  NSString+TDigest.m
//  HouseKeeper
//
//  Created by to on 14-7-21.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import "NSString+TDigest.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (TDigest)

- (NSString *)md5Digest {
    const char* cstr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result[i]];
    }
    return ret;
}

- (NSString *)getMd5_16Bit {
    // 提取32位MD5散列的中间16位
    NSString *md5_32Bit_String=[self getMd5_32Bit];
    NSString *result = [[md5_32Bit_String substringToIndex:24] substringFromIndex:8];//即9～25位
    
    return result;
}

- (NSString *)getMd5_32Bit {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

@end
