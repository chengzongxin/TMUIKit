//
//  UILabel+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/23.
//

#import "UILabel+TMUI.h"
#import <Foundation/Foundation.h>
#import <TMUICore/TMUICore.h>
#import "NSMutableParagraphStyle+TMUI.h"
#import "UIView+TMUI.h"
#import "NSAttributedString+TMUI.h"
#import "UIColor+TMUI.h"
#import <objc/runtime.h>

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
    CGSize size = [self sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    return CGSizeMake(ceil(MIN(width, size.width)), ceil(size.height));
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
#pragma mark 全部设置富文本
- (void)tmui_setAttributesString:(NSString *)text lineSpacing:(CGFloat)lineSpacing{
    if (tmui_isNullString(text)) return;
    // 1行的时候，修正lineSpacing,还没布局的时候，宽度是0, 例如，cellForRow第一次创建的时候，并没有加载到window上，
    CGFloat height = [NSAttributedString tmui_heightForString:text font:self.font width:self.width lineSpacing:lineSpacing];
    self.attributedText = [NSAttributedString tmui_attributedStringWithString:text lineSpacing:(height<self.font.pointSize*2+lineSpacing)?0:lineSpacing];
}

- (void)tmui_setAttributesString:(NSString *)text lineHeight:(CGFloat)lineHeight{
    if (tmui_isNullString(text)) return;
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle tmui_paragraphStyleWithLineHeight:lineHeight lineBreakMode:self.lineBreakMode textAlignment:self.textAlignment];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:style}];
    self.attributedText = attr;
}

- (void)tmui_setAttributeslineSpacing:(CGFloat)lineSpacing{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle tmui_paragraphStyleWithLineSpacing:lineSpacing];
    [self tmui_setAttribute:NSParagraphStyleAttributeName value:paragraphStyle];
}

- (void)tmui_setAttributesLineOffset:(CGFloat)lineOffset{
    [self tmui_setAttribute:NSBaselineOffsetAttributeName value:@(lineOffset)];
}


- (void)tmui_setAttributesLineSingle{
    [self tmui_setAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]];
}

- (void)tmui_setAttributesUnderLink{
    [self tmui_setAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]];
}

- (void)tmui_setAttribute:(NSAttributedStringKey)name value:(id)value{
    NSMutableAttributedString *mAttrStr = [self.attributedText mutableCopy];
    [mAttrStr tmui_setAttribute:name value:value];
    self.attributedText = mAttrStr;
}

- (void)tmui_setAttribute:(NSDictionary<NSAttributedStringKey, id> *)attrs{
    NSMutableAttributedString *mAttrStr = [self.attributedText mutableCopy];
    [mAttrStr tmui_setAttributes:attrs];
    self.attributedText = mAttrStr;
}


#pragma mark 设置部分富文本
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

@end

@implementation UILabel (TMUI_IB)
#pragma mark - TBTCategory
static char textColorHexStringKey;

- (void)setTextColorHexString:(NSString *)textColorHexString {
    self.textColor = [UIColor tmui_colorWithHexString:textColorHexString];
    objc_setAssociatedObject(self, &textColorHexStringKey, textColorHexString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)textColorHexString {
    return objc_getAssociatedObject(self, &textColorHexStringKey);
}

@end
