//
//  UILabel+AttributeText.m
//  Matafy
//
//  Created by Tiaotiao on 2019/5/7.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "UILabel+AttributeText.h"

@implementation UILabel (AttributeText)

// 给label指定text的颜色、字体
- (void)mtfy_addAttributesText:(NSString *)text color:(UIColor *)color font:(UIFont *)font
{
    NSRange range = [[self.attributedText string] rangeOfString:text];
    if(range.location != NSNotFound) {
        NSMutableAttributedString *mat = [self.attributedText mutableCopy];
        [mat addAttributes:@{NSForegroundColorAttributeName:color} range:range];
        [mat addAttributes:@{NSFontAttributeName:font} range:range];
        self.attributedText = mat;
    }
}

- (void)mtfy_addAttributesText:(CGFloat)lineSpacing
{
    NSRange range = NSMakeRange(0, [self.attributedText string].length);
    if(range.location != NSNotFound) {
        NSMutableAttributedString *mat = [self.attributedText mutableCopy];
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = lineSpacing;
        [mat addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:range];
        self.attributedText = mat;
    }
}

- (void)mtfy_addAttributesLineOffset:(CGFloat)lineOffset
{
    NSRange range = NSMakeRange(0, [self.attributedText string].length);
    if(range.location != NSNotFound) {
        NSMutableAttributedString *mat = [self.attributedText mutableCopy];
        [mat addAttributes:@{NSBaselineOffsetAttributeName: @(lineOffset)} range:range];
        self.attributedText = mat;
    }
}


- (void)mtfy_addAttributesLineSingle
{
    NSRange range = NSMakeRange(0, [self.attributedText string].length);
    if(range.location != NSNotFound) {
        NSMutableAttributedString *mat = [self.attributedText mutableCopy];
        [mat addAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:range];
        self.attributedText = mat;
    }
}

@end
