//
// Created by Fussa on 2019/10/30.
// Copyright (c) 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITextField (MTFY)

#pragma mark - placeHolder


- (void)mtfy_setColor:(nullable UIColor *)color font:(nullable UIFont *)font;


/**
 * 设置 placeHolder 文字
 */
- (void)mtfy_setPlaceholderFont:(UIFont *)font;

/**
 * 设置 placeHolder 颜色
 */
- (void)mtfy_setPlaceholderColor:(UIColor *)color;

/**
 * 设置 placeHolder 颜色和文字
 */
- (void)mtfy_setPlaceholderColor:(nullable UIColor *)color font:(nullable UIFont *)font;

/**
 * 检查 placeHolder 是否为空
 */
- (BOOL)mtfy_checkPlaceholderEmpty;

@end