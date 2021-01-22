//
//  UILabel+MTFY.m
//  Matafy
//
//  Created by Fussa on 2019/11/27.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "UILabel+MTFY.h"
#import <CoreText/CoreText.h>

@implementation UILabel (MTFY)

- (void)mtfy_setLineBreakByTruncatingLastLineMiddle {
    [self mtfy_setLineBreakByTruncatingLastLineInset:self.frame.size.width / 2];
}

- (void)mtfy_setLineBreakByTruncatingLastLineInset:(CGFloat)inset {
    NSArray *separatedLines = [self mtfy_getSeparatedLinesArray];
    if (!separatedLines || separatedLines.count == 0) {
        return;
    }
    NSMutableString *limitedText = [NSMutableString string];
    if ( separatedLines.count >= self.numberOfLines ) {
        for (int i = 0 ; i < self.numberOfLines; i++) {
            if ( i == self.numberOfLines - 1) {
                UILabel *lastLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - inset, MAXFLOAT)];
                lastLineLabel.font = self.font;
                lastLineLabel.text = separatedLines[(NSUInteger) (self.numberOfLines - 1)];
                lastLineLabel.lineBreakMode = self.lineBreakMode;
                NSArray *subSeparatedLines = [lastLineLabel mtfy_getSeparatedLinesArray];
                NSString *lastLineText = [subSeparatedLines firstObject];
                NSInteger lastLineTextCount = lastLineText.length;
                [limitedText appendString:[NSString stringWithFormat:@"%@...",[lastLineText substringToIndex:lastLineTextCount]]];
            } else {
                [limitedText appendString:separatedLines[i]];
            }
        }
    } else {
        [limitedText appendString:self.text];
    }
    self.text = limitedText;
}

- (NSArray *)mtfy_getSeparatedLinesArray {
    [self setNeedsLayout];
    [self layoutIfNeeded];

    NSString *text = [self text];
    UIFont   *font = [self font];
    CGRect    rect = [self frame];

    if (text == nil) {
        return nil;
    }

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;

    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attStr.length)];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];

    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));

    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);

    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];

    for (id line in lines) {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);

        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return (NSArray *)linesArray;
}

- (void)mtfy_setEndLineTruncationActionWithTitle:(NSString *)title attributes:(NSDictionary *)attributes maxLine:(NSInteger)maxLine clickHandle:(void (^)(void))clickHandle {
    NSArray *contents = [self mtfy_getSeparatedLinesArray];
    if (contents.count <= maxLine) {
        // 如果不足最大行就不显示查看更多，同时取消手势响应
        self.userInteractionEnabled = NO;
        return;
    }
    self.userInteractionEnabled = YES;
    
    NSString *ellipsisStr = @"...";
    NSString *actionTitle = title;
    
    // 截取的长度
    NSUInteger cutLength = actionTitle.length + 1;
    NSMutableString *contentText = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < self.numberOfLines; i++) {
        // 最后一行 进行处理加上...
        if (i == self.numberOfLines - 1) {
            NSString *lastLineText = [NSString stringWithFormat:@"%@",contents[i]];
            NSUInteger lineLength = lastLineText.length;
            if (lineLength > cutLength) {
                lastLineText = [lastLineText substringToIndex:(lastLineText.length - cutLength)];
            }
            [contentText appendString:[NSString stringWithFormat:@"%@%@", lastLineText, ellipsisStr]];
        } else {
            [contentText appendString:contents[i]];
        }
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = self.lineBreakMode;
    NSDictionary *dictionary = @{
                                 NSForegroundColorAttributeName : self.textColor,
                                 NSFontAttributeName : self.font,
                                 NSParagraphStyleAttributeName : style
                                 };
    NSMutableAttributedString *attribText = [[NSMutableAttributedString alloc] initWithString:[contentText stringByAppendingString:actionTitle] attributes:dictionary];
    [attribText setAttributes:attributes range:NSMakeRange(contentText.length, actionTitle.length)];
    self.attributedText = attribText;
    
    [self mtfy_clickRichTextWithStrings:@[actionTitle] clickAction:^(NSString *string, NSRange range, NSInteger index) {
        if (clickHandle) {
            clickHandle();
        }
    }];
}

@end
