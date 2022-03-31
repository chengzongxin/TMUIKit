//
//  NSAttributedString+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import "NSAttributedString+TMUI.h"
#import "NSMutableParagraphStyle+TMUI.h"
#import "NSString+TMUI.h"
#import "TMUICore.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedString (TMUI)

#pragma mark - Text Attribute

+ (instancetype)tmui_attributedStringWithString:(NSString *)str lineSpacing:(CGFloat)lineSpacing{
    return [self tmui_attributedStringWithString:str lineSpacing:lineSpacing lineBreakMode:NSLineBreakByTruncatingTail];
}

+ (instancetype)tmui_attributedStringWithString:(NSString *)str lineSpacing:(CGFloat)lineSpacing lineBreakMode:(NSLineBreakMode)lineBreakMode{
    if (tmui_isNullString(str)) return nil;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle tmui_paragraphStyleWithLineSpacing:lineSpacing lineBreakMode:lineBreakMode];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    return attrStr;
}

+ (instancetype)tmui_attributedStringWithString:(NSString *)str font:(UIFont *)font color:(UIColor *)color{
    if (tmui_isNullString(str)) return nil;
    NSMutableDictionary *attrDict = NSMutableDictionary.dictionary;
    if (font) {
        attrDict[NSFontAttributeName] = font;
    }
    if (color) {
        attrDict[NSForegroundColorAttributeName] = color;
    }
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:str attributes:attrDict];
    return attrStr;
}

+ (instancetype)tmui_attributedStringWithString:(NSString *)str font:(UIFont *)font color:(UIColor *)color lineSpacing:(CGFloat)lineSpacing{
    NSMutableAttributedString *attrStr = [[NSAttributedString tmui_attributedStringWithString:str font:font color:color] mutableCopy];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attrStr tmui_setAttribute:NSParagraphStyleAttributeName value:paragraphStyle];
    return attrStr;
}

#pragma mark - Image Attribute
+ (instancetype)tmui_attributedStringWithImage:(UIImage *)image {
    return [self tmui_attributedStringWithImage:image baselineOffset:0 leftMargin:0 rightMargin:0];
}

+ (instancetype)tmui_attributedStringWithImage:(UIImage *)image baselineOffset:(CGFloat)offset leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin {
    if (!image) {
        return nil;
    }
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    NSMutableAttributedString *string = [[NSAttributedString attributedStringWithAttachment:attachment] mutableCopy];
    [string addAttribute:NSBaselineOffsetAttributeName value:@(offset) range:NSMakeRange(0, string.length)];
    if (leftMargin > 0) {
        [string insertAttributedString:[self tmui_attributedStringWithFixedSpace:leftMargin] atIndex:0];
    }
    if (rightMargin > 0) {
        [string appendAttributedString:[self tmui_attributedStringWithFixedSpace:rightMargin]];
    }
    return string;
}


#pragma mark - Space Attribute
+ (instancetype)tmui_attributedStringWithFixedSpace:(CGFloat)width {
    UIGraphicsBeginImageContext(CGSizeMake(width, 1));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [self tmui_attributedStringWithImage:image];
}


@end


@implementation NSAttributedString (TMUI_Calculate)

//固定宽度计算多行文本高度，支持开头空格、自定义插入的文本图片不纳入计算范围，包含emoji表情符仍然会有较大偏差，但在UITextView和UILabel等控件中不影响显示。向上取整，消除小数转整数误差
- (CGSize)tmui_sizeForWidth:(CGFloat)width {
    NSMutableAttributedString *mAttr = [self mutableCopy];
    NSMutableParagraphStyle *style = [mAttr.tmui_paragraphStyle mutableCopy];
    if (!style) {
        style = [[NSMutableParagraphStyle alloc] init];
    }
    style.lineBreakMode = NSLineBreakByWordWrapping;
    [mAttr tmui_setAttribute:NSParagraphStyleAttributeName value:style];
    CGRect rect = [mAttr boundingRectWithSize:CGSizeMake(width, HUGE)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     context:nil];
    return CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
    
    // text calculate
//    return [self.string tmui_sizeForFont:self.tmui_font size:CGSizeMake(width, CGFLOAT_MAX) lineHeight:self.tmui_paragraphStyle.lineSpacing mode:self.tmui_paragraphStyle.lineBreakMode];
}


- (CGFloat)tmui_heightForFont:(UIFont *)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing {
    CGFloat height = [self tmui_heightForWidth:width];
    if (height < font.pointSize*2+lineSpacing) {
        height = font.lineHeight;
    }
    return ceilf(height);
}

+ (CGFloat)tmui_heightForString:(NSString *)str font:(UIFont *)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing{
    if (![str isKindOfClass:[NSString class]] || str.length == 0) {
        return 0;
    }
    NSMutableAttributedString *attributedString = [[NSAttributedString tmui_attributedStringWithString:str lineSpacing:lineSpacing lineBreakMode:NSLineBreakByWordWrapping] mutableCopy];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];
    CGFloat height = [attributedString tmui_heightForFont:font width:width lineSpacing:lineSpacing];
    return ceilf(height);
}


+ (CGFloat)tmui_heightForString:(NSString *)str font:(UIFont *)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing maxLine:(NSUInteger)maxLine{
    CGFloat heightOfAll = [self tmui_heightForString:str font:font width:width lineSpacing:lineSpacing];
    CGFloat heightOfMax = CGFLOAT_MAX;
    if (lineSpacing != 0) {
        NSString *strTem = @"a";
        for (int i=0; i< maxLine - 1; i++) {
            strTem = [strTem stringByAppendingString:@"\na"];
        }
        heightOfMax = [self tmui_heightForString:strTem font:font width:width lineSpacing:lineSpacing];
    }
    return ceilf(MIN(heightOfAll, heightOfMax));
}




- (CGFloat)tmui_heightForWidth:(CGFloat)width {
    return [self tmui_sizeForWidth:width].height;
}


- (NSUInteger)tmui_lengthWhenCountingNonASCIICharacterAsTwo {
    return self.string.tmui_lengthWhenCountingNonASCIICharacterAsTwo;
}


@end




@implementation NSAttributedString (TMUI_Attributes)

- (NSMutableParagraphStyle *)tmui_paragraphStyle{
    return [self _attribute:NSParagraphStyleAttributeName atIndex:0];
}

- (NSMutableParagraphStyle *)tmui_paragraphStyle:(NSUInteger)index{
    return [self _attribute:NSParagraphStyleAttributeName atIndex:index];
}

- (UIFont *)tmui_font{
    return [self tmui_fontAtIndex:0];
}

- (UIFont *)tmui_fontAtIndex:(NSUInteger)index {
    /*
     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
     although Apple does not mention it in documentation.

     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
     but UILabel/UITextView cannot use CTFontRef.

     We use UIFont for both CoreText and UIKit.
     */
    UIFont *font = [self _attribute:NSFontAttributeName atIndex:index];
//    if (kSystemVersion <= 6) {
//        if (font) {
//            if (CFGetTypeID((__bridge CFTypeRef)(font)) == CTFontGetTypeID()) {
//                font = [UIFont fontWithCTFont:(CTFontRef)font];
//            }
//        }
//    }
    return font;
}

- (UIColor *)tmui_color {
    return [self tmui_colorAtIndex:0];
}

- (UIColor *)tmui_colorAtIndex:(NSUInteger)index {
    UIColor *color = [self _attribute:NSForegroundColorAttributeName atIndex:index];
    if (!color) {
        CGColorRef ref = (__bridge CGColorRef)([self _attribute:(NSString *)kCTForegroundColorAttributeName atIndex:index]);
        color = [UIColor colorWithCGColor:ref];
    }
    if (color && ![color isKindOfClass:[UIColor class]]) {
        if (CFGetTypeID((__bridge CFTypeRef)(color)) == CGColorGetTypeID()) {
            color = [UIColor colorWithCGColor:(__bridge CGColorRef)(color)];
        } else {
            color = nil;
        }
    }
    return color;
}

- (id)_attribute:(NSString *)attributeName atIndex:(NSUInteger)index {
    if (!attributeName) return nil;
    if (index > self.length || self.length == 0) return nil;
    if (self.length > 0 && index == self.length) index--;
    return [self attribute:attributeName atIndex:index effectiveRange:NULL];
}

@end


@implementation NSMutableAttributedString (TMUI)

- (void)tmui_setAttributes:(NSDictionary *)attributes {
    if (attributes == (id)[NSNull null]) attributes = nil;
    [self setAttributes:@{} range:NSMakeRange(0, self.length)];
    [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self tmui_setAttribute:key value:obj];
    }];
}

- (void)tmui_setAttribute:(NSString *)name value:(id)value {
    [self tmui_setAttribute:name value:value range:NSMakeRange(0, self.length)];
}

- (void)tmui_setAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    if (!name || [NSNull isEqual:name]) return;
    if (value && ![NSNull isEqual:value]) [self addAttribute:name value:value range:range];
    else [self removeAttribute:name range:range];
}

- (void)tmui_removeAttributesInRange:(NSRange)range {
    [self setAttributes:nil range:range];
}


@end
