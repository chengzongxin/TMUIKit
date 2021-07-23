//
//  UILabel+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/23.
//

#import "UILabel+TMUI.h"
#import <Foundation/Foundation.h>
#import "TMUICommonDefines.h"
#import "NSMutableParagraphStyle+TMUI.h"
#import "UIView+TMUI.h"
#import "NSAttributedString+TMUI.h"

#pragma mark - 提供基本快捷方法、初始化等
@implementation UILabel (TMUI)

- (instancetype)tmui_initWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    BeginIgnoreClangWarning(-Wunused-value)
    [self init];
    EndIgnoreClangWarning
    self.font = font;
    self.textColor = textColor;
    return self;
}


@end

#pragma mark - 计算尺寸
@implementation UILabel (TMUI_Caculate)

- (CGSize)tmui_sizeForWidth:(CGFloat)width{
    if (width == 0) {
        if (self.width == 0) {
            [self layoutIfNeeded];
        }
        width = self.width;
    }
    
    CGSize size = CGSizeZero;
    if (self.lineBreakMode == NSLineBreakByWordWrapping) {
        // NSString 计算
        size = [self.text tmui_sizeForFont:self.font
                                      size:CGSizeMake(width, HUGE)
                                lineHeight:self.tmui_attributeTextLineHeight
                                      mode:self.lineBreakMode];
    }else{
        size = [self sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    }
    
    return size;
}



- (CGFloat)tmui_attributeTextLineHeight{
    return [(NSMutableParagraphStyle *)[self.attributedText attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil] lineSpacing];
}

- (void)tmui_calculateHeightAfterSetAppearance {
    self.text = @"测";
    [self sizeToFit];
    self.text = nil;
}


- (NSAttributedString *)tmui_attributedText{
    NSMutableAttributedString *attr = [self.attributedText mutableCopy];
    if (!attr.tmui_font) {
        [attr tmui_setAttribute:NSFontAttributeName value:self.font];
    }
    return attr;
}

@end


#pragma mark - 设置富文本
@implementation UILabel (TMUI_AttributeText)

- (void)tmui_setAttributesString:(NSString *)text lineSpacing:(CGFloat)lineSpacing{
    if (tmui_isNullString(text)) return;
    if (self.width == 0) {
        // 还没布局的时候，宽度是0，这里提前渲染方便后面计算
        [self layoutIfNeeded];
    }
    // 1行的时候，修正lineSpacing
    CGFloat height = [NSAttributedString tmui_heightForString:text font:self.font width:self.width lineSpacing:lineSpacing];
    self.attributedText = [NSAttributedString tmui_attributedStringWithString:text lineSpacing:(height<self.font.pointSize*2+lineSpacing)?0:lineSpacing];
}

- (void)tmui_setAttributesString:(NSString *)text lineHeight:(CGFloat)lineHeight{
    if (tmui_isNullString(text)) return;
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle tmui_paragraphStyleWithLineHeight:lineHeight lineBreakMode:self.lineBreakMode textAlignment:self.textAlignment];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:style}];
    self.attributedText = attr;
}

- (void)tmui_setAttributesString:(NSString *)string color:(UIColor *)color font:(UIFont *)font{
    NSRange range = [[self.attributedText string] rangeOfString:string];
    if(range.location != NSNotFound && range.length) {
        // 找到对应的字段
        NSMutableAttributedString *mat = [self.attributedText mutableCopy];
        [mat addAttributes:@{NSForegroundColorAttributeName:color} range:range];
        [mat addAttributes:@{NSFontAttributeName:font} range:range];
        self.attributedText = mat;
    }else{
        // 没有，在后面追加
        [self tmui_appendAttributesString:string color:color font:font];
    }
}

- (void)tmui_appendAttributesString:(NSString *)string color:(UIColor *)color font:(UIFont *)font{
    if (!tmui_isNullString(string)) {
        NSRange range = NSMakeRange(0, string.length);
        NSMutableAttributedString *appendAtr = [[NSMutableAttributedString alloc] initWithString:string];
        [appendAtr addAttributes:@{NSForegroundColorAttributeName:color} range:range];
        [appendAtr addAttributes:@{NSFontAttributeName:font} range:range];
        NSMutableAttributedString *mat = [self.attributedText mutableCopy] ?: [[NSMutableAttributedString alloc] init];
        [mat appendAttributedString:appendAtr];
        self.attributedText = mat;
    }
}

- (void)tmui_setAttributeslineSpacing:(CGFloat)lineSpacing{
    NSRange range = NSMakeRange(0, [self.attributedText string].length);
    if(range.location != NSNotFound) {
        NSMutableAttributedString *mAttrStr = [self.attributedText mutableCopy];
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = lineSpacing;
        [mAttrStr addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:range];
        self.attributedText = mAttrStr;
    }
}

- (void)tmui_setAttributesLineOffset:(CGFloat)lineOffset{
    NSRange range = NSMakeRange(0, [self.attributedText string].length);
    if(range.location != NSNotFound) {
        NSMutableAttributedString *mAttrStr = [self.attributedText mutableCopy];
        [mAttrStr addAttributes:@{NSBaselineOffsetAttributeName: @(lineOffset)} range:range];
        self.attributedText = mAttrStr;
    }
}


- (void)tmui_setAttributesLineSingle{
    NSRange range = NSMakeRange(0, [self.attributedText string].length);
    if(range.location != NSNotFound) {
        NSMutableAttributedString *mAttrStr = [self.attributedText mutableCopy];
        [mAttrStr addAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:range];
        self.attributedText = mAttrStr;
    }
}

- (void)tmui_setAttributesUnderLink{
    NSRange range = NSMakeRange(0, [self.attributedText string].length);
    if(range.location != NSNotFound) {
        NSMutableAttributedString *mAttrStr = [self.attributedText mutableCopy];
        [mAttrStr addAttributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:range];
        self.attributedText = mAttrStr;
    }
}

@end

