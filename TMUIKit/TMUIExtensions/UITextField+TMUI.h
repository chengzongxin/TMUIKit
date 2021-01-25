//
//  UITextField+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (TMUI)

@property(nonatomic, assign) NSUInteger tmui_maximumTextLength;

- (void)tmui_setColor:(nullable UIColor *)color font:(nullable UIFont *)font;



/**
 * 设置 placeHolder 文字
 */
- (void)tmui_setPlaceholderFont:(UIFont *)font;

/**
 * 设置 placeHolder 颜色
 */
- (void)tmui_setPlaceholderColor:(UIColor *)color;

/**
 * 设置 placeHolder 颜色和文字
 */
- (void)tmui_setPlaceholderColor:(nullable UIColor *)color font:(nullable UIFont *)font;

/**
 * 检查 placeHolder 是否为空
 */
- (BOOL)tmui_checkPlaceholderEmpty;

@end

NS_ASSUME_NONNULL_END
