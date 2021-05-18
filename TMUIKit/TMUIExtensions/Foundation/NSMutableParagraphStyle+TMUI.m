//
//  NSMutableParagraphStyle+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/26.
//

#import "NSMutableParagraphStyle+TMUI.h"

@implementation NSMutableParagraphStyle (TMUI)

+ (instancetype)tmui_paragraphStyleWithLineSpacing:(CGFloat)lineSpacing{
    NSMutableParagraphStyle *paragraphStyle = [[self alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    return paragraphStyle;
}

+ (instancetype)tmui_paragraphStyleWithLineHeight:(CGFloat)lineHeight {
    return [self tmui_paragraphStyleWithLineHeight:lineHeight lineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentLeft];
}

+ (instancetype)tmui_paragraphStyleWithLineHeight:(CGFloat)lineHeight lineBreakMode:(NSLineBreakMode)lineBreakMode {
    return [self tmui_paragraphStyleWithLineHeight:lineHeight lineBreakMode:lineBreakMode textAlignment:NSTextAlignmentLeft];
}

+ (instancetype)tmui_paragraphStyleWithLineHeight:(CGFloat)lineHeight lineBreakMode:(NSLineBreakMode)lineBreakMode textAlignment:(NSTextAlignment)textAlignment {
    NSMutableParagraphStyle *paragraphStyle = [[self alloc] init];
    paragraphStyle.minimumLineHeight = lineHeight;
    paragraphStyle.maximumLineHeight = lineHeight;
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = textAlignment;
    return paragraphStyle;
}

@end
