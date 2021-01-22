//
//  MTFYRequestConstants.h
//  Matafy
//
// Created by Fussa on 2019/12/5.
// Copyright (c) 2019 com.upintech. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 请求返回Code
 */
typedef NS_ENUM(NSUInteger, MTFYResponseCode) {
    MTFYResponseCodeSuccess,                   ///< 成功
};


/// 请求类型
typedef NSString *MTFYRequestType NS_STRING_ENUM;
static MTFYRequestType const GET        = @"GET";
static MTFYRequestType const POST       = @"POST";
static MTFYRequestType const DELETE     = @"DELETE";


@interface MTFYRequestConstants : NSObject
@end

NS_ASSUME_NONNULL_END