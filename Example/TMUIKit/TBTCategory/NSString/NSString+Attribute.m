//
//  NSString+Attribute.m
//  TMUIKit_Example
//
//  Created by cl w on 2021/2/3.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "NSString+Attribute.h"
#import "NSString+TSize.h"

@implementation NSString (Attribute)

- (NSMutableAttributedString *)tmui_convertToAttributedStringWithFont:(UIFont *)font textColor:(UIColor *)color
{
    if (!font) {
        font = [UIFont systemFontOfSize:16];
    }
    if (!color) {
        color = [UIColor colorWithRed:17/255.f green:17/255.f blue:17/255.f alpha:1];
    }
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    return mStr;
}

- (NSMutableAttributedString *)tmui_attributedStringFormatLineWithFont:(UIFont *)font
                                                                 color:(UIColor *)color
                                                              maxWidth:(CGFloat)maxWidth
                                                           lineSpacing:(CGFloat)spacing
                                                             alignment:(NSTextAlignment)alignment{
    if (!font) {
        font = [UIFont systemFontOfSize:16];
    }
    if (!color) {
        color = [UIColor colorWithRed:17/255.f green:17/255.f blue:17/255.f alpha:1];
    }
    
    if (self == nil || self.length == 0) {
        return [[NSMutableAttributedString alloc] initWithString:@"" attributes:nil];;
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.lineSpacing = spacing;
    style.alignment = alignment;
    NSDictionary * attributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName:color, NSParagraphStyleAttributeName:style};
    NSInteger line = [self tmui_numberOfLinesWithFont:font contrainstedToWidth:maxWidth];
    if (line == 1){
        //单行的时候去掉行间距
        style.lineSpacing = 0;
    }
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self attributes:attributes];
    return [attributedString mutableCopy];
}

@end
