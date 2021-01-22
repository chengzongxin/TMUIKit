//
//  MTFYUtil.m
//  Matafy
//
// Created by Fussa on 2019/12/5.
// Copyright (c) 2019 com.upintech. All rights reserved.
//
#import "MTFYUtil.h"

@implementation MTFYUtil

+ (NSDictionary *)dictionaryFromUtf8JsonStr:(NSString *)string {
    NSData *json_data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return  [NSJSONSerialization JSONObjectWithData:json_data options:0 error:nil];
}

@end