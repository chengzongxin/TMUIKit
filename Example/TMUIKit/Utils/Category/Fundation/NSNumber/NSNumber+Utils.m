//
//  NSNumber+Utils.m
//  silu
//
//  Created by liman on 3/27/15.
//  Copyright (c) 2015 upintech. All rights reserved.
//

#import "NSNumber+Utils.h"

@implementation NSNumber (Utils)

// 判断服务器状态码
- (BOOL)statusCodeSuccess
{
    if ([self isEqualToNumber:CODE_200] || [self isEqualToNumber:CODE_201]) {
        return YES;
    }
    
    return NO;
}
@end
