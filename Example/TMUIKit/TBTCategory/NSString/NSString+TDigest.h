//
//  NSString+TDigest.h
//  HouseKeeper
//
//  Created by to on 14-7-21.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TDigest)

//md5 16位加密
- (NSString *)getMd5_16Bit;

//md5 32位加密
- (NSString *)getMd5_32Bit;

@end
