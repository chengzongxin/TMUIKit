//
//  MTFYUtil.h
//  Matafy
//
// Created by Fussa on 2019/12/5.
// Copyright (c) 2019 com.upintech. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTFYUtil : NSObject

/**
 * JSON字符串转换成字典
 */
+ (NSDictionary *)dictionaryFromUtf8JsonStr:(NSString *)string;

@end

NS_ASSUME_NONNULL_END