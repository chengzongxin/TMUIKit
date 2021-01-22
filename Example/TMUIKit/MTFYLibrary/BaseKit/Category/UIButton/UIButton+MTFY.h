//
//  UIButton+MTFY.h
//  Matafy
//
// Created by Fussa on 2019/12/2.
// Copyright (c) 2019 com.upintech. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (MTFY)
/// 按钮点击时间
/// @param block 点击回调
- (void)mtfy_clickWithBlock:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
