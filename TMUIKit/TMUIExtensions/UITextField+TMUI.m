//
//  UITextField+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/23.
//

#import "UITextField+TMUI.h"
#import <objc/runtime.h>
#import "TMUIAssociatedObjectDefine.h"
@implementation UITextField (TMUI)

TMUISynthesizeIdCopyProperty(tmui_textLimitBlock, setTmui_textLimitBlock);
TMUISynthesizeIdCopyProperty(tmui_textChangeBlock, setTmui_textChangeBlock);

- (void)tmui_setColor:(nullable UIColor *)color font:(nullable UIFont *)font {
    self.textColor = color;
    self.font = font;
}

- (void)textFieldEditingChanged:(UITextField *)textField{
    NSString *toBeginString = self.text;
    // 获取高亮部分
    UITextRange *selectRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    // 在 iOS 7下, position 对象总是不为 nil
    if ((!position || !selectRange) && (self.tmui_maximumTextLength > 0 && toBeginString.length > self.tmui_maximumTextLength && [self isFirstResponder]))
    {
        NSRange rangeIndex = [toBeginString rangeOfComposedCharacterSequenceAtIndex:self.tmui_maximumTextLength];
        if (rangeIndex.length == 1)
        {
            self.text = [toBeginString substringToIndex:self.tmui_maximumTextLength];
        }
        else
        {
            NSRange tempRange = [toBeginString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.tmui_maximumTextLength)];
            NSInteger tempLength;
            if (tempRange.length > self.tmui_maximumTextLength)
            {
                tempLength = tempRange.length - rangeIndex.length;
            }
            else
            {
                tempLength = tempRange.length;
            }
            self.text = [toBeginString substringWithRange:NSMakeRange(0, tempLength)];
        }
        !self.tmui_textLimitBlock ?: self.tmui_textLimitBlock(self.text,self);
        return;
    }
    !self.tmui_textChangeBlock ?: self.tmui_textChangeBlock(self.text,self);
}

#pragma mark - placeHolder

/// 设置字体
- (void)tmui_setPlaceholderFont:(UIFont *)font {
    [self tmui_setPlaceholderColor:nil font:font];
}

/// 设置颜色
- (void)tmui_setPlaceholderColor:(UIColor *)color {
    [self tmui_setPlaceholderColor:color font:nil];
}

/// 设置颜色和字体
- (void)tmui_setPlaceholderColor:(nullable UIColor *)color font:(nullable UIFont *)font {
    if ([self tmui_checkPlaceholderEmpty]) {
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
- (BOOL)tmui_checkPlaceholderEmpty {
    return (self.placeholder == nil) || ([[self.placeholder stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0);
}

- (void)setTmui_maximumTextLength:(NSUInteger)tmui_maximumTextLength{
    objc_setAssociatedObject(self, @selector(tmui_maximumTextLength), @(tmui_maximumTextLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (NSUInteger)tmui_maximumTextLength{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

@end
