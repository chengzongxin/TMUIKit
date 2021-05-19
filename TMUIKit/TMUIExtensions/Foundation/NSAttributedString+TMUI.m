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

@implementation NSAttributedString (TMUI)

#pragma mark - Text Attribute

+ (instancetype)tmui_attributedStringWithString:(NSString *)str lineSpacing:(CGFloat)lineSpacing{
    if (tmui_isNullString(str)) return nil;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle tmui_paragraphStyleWithLineSpacing:lineSpacing];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    return attrStr;
}

+ (instancetype)tmui_attributedStringWithString:(NSString *)str font:(UIFont *)font color:(UIColor *)color{
    if (tmui_isNullString(str) || font == nil || color == nil) return nil;
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    return attrStr;
}

+ (instancetype)tmui_attributedStringWithString:(NSString *)str font:(UIFont *)font color:(UIColor *)color lineSpacing:(CGFloat)lineSpacing{
    NSMutableAttributedString *attrStr = [[NSAttributedString tmui_attributedStringWithString:str font:font color:color] mutableCopy];
    NSMutableParagraphStyle *paragraphStyle = [[self alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
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

- (NSUInteger)tmui_lengthWhenCountingNonASCIICharacterAsTwo {
    return self.string.tmui_lengthWhenCountingNonASCIICharacterAsTwo;
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
    NSMutableAttributedString *attributedString = [[NSAttributedString tmui_attributedStringWithString:str lineSpacing:lineSpacing] mutableCopy];
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


//固定宽度计算多行文本高度，支持开头空格、自定义插入的文本图片不纳入计算范围，包含emoji表情符仍然会有较大偏差，但在UITextView和UILabel等控件中不影响显示。向上取整，消除小数转整数误差
- (CGSize)tmui_sizeForWidth:(CGFloat)width {
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, HUGE)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     context:nil];
    return CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
}

- (CGFloat)tmui_heightForWidth:(CGFloat)width {
    return [self tmui_sizeForWidth:width].height;
}

@end




@implementation NSAttributedString (TMUI_Attributes)


//- (UIFont *)tmui_font{
//    return [self tmui_fontAtIndex:0];
//}



//- (UIFont *)tmui_fontAtIndex:(NSUInteger)index {
//    /*
//     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
//     although Apple does not mention it in documentation.
//
//     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
//     but UILabel/UITextView cannot use CTFontRef.
//
//     We use UIFont for both CoreText and UIKit.
//     */
//    UIFont *font = [self _attribute:NSFontAttributeName atIndex:index];
//    if (kSystemVersion <= 6) {
//        if (font) {
//            if (CFGetTypeID((__bridge CFTypeRef)(font)) == CTFontGetTypeID()) {
//                font = [UIFont fontWithCTFont:(CTFontRef)font];
//            }
//        }
//    }
//    return font;
//}
//
//
//- (id)_attribute:(NSString *)attributeName atIndex:(NSUInteger)index {
//    if (!attributeName) return nil;
//    if (index > self.length || self.length == 0) return nil;
//    if (self.length > 0 && index == self.length) index--;
//    return [self attribute:attributeName atIndex:index effectiveRange:NULL];
//}

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
