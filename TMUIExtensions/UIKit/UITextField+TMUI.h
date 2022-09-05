//
//  UITextField+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (TMUI)

/// 快捷初始化
/// @param color 颜色
/// @param font 字体
- (void)tmui_setColor:(nullable UIColor *)color font:(nullable UIFont *)font;

/// 设置最大文本输入长度
@property(nonatomic, assign) NSUInteger tmui_maximumTextLength;

/// 超出字数限制回调
@property(nonatomic, copy) void (^tmui_textLimitBlock)(NSString *text, UITextField *textField);

/// 文字输入改变回调
@property(nonatomic, copy) void (^tmui_textChangeBlock)(NSString *text, UITextField *textField);
/**
 * 设置 placeHolder 文字
 */
- (void)tmui_setPlaceholderFont:(UIFont *)font;

/**
 * 设置 placeHolder 颜色
 */
- (void)tmui_setPlaceholderColor:(UIColor *)color;

/**
 * 设置 placeHolder 颜色和字体
 */
- (void)tmui_setPlaceholderColor:(nullable UIColor *)color font:(nullable UIFont *)font;

/**
 * 检查 placeHolder 是否为空
 */
- (BOOL)tmui_checkPlaceholderEmpty;

@end

NS_ASSUME_NONNULL_END
