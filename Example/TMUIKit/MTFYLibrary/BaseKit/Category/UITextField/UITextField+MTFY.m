//
// Created by Fussa on 2019/10/30.
// Copyright (c) 2019 com.upintech. All rights reserved.
//

#import "UITextField+MTFY.h"


@implementation UITextField (MTFY)

- (void)mtfy_setColor:(nullable UIColor *)color font:(nullable UIFont *)font {
    self.textColor = color;
    self.font = font;
}

#pragma mark - placeHolder

/// 设置字体
- (void)mtfy_setPlaceholderFont:(UIFont *)font {
    [self mtfy_setPlaceholderColor:nil font:font];
}

/// 设置颜色
- (void)mtfy_setPlaceholderColor:(UIColor *)color {
    [self mtfy_setPlaceholderColor:color font:nil];
}

/// 设置颜色和字体
- (void)mtfy_setPlaceholderColor:(nullable UIColor *)color font:(nullable UIFont *)font {
    if ([self mtfy_checkPlaceholderEmpty]) {
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.placeholder];
    if (color) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.placeholder.length)];
    }
    if (font) {
        [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.placeholder.length)];
    }

    [self setAttributedPlaceholder:attributedString];
}

/// 检查是否为空
- (BOOL)mtfy_checkPlaceholderEmpty {
    return (self.placeholder == nil) || ([[self.placeholder stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0);
}

@end