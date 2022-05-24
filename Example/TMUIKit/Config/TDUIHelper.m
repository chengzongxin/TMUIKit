//
//  TDUIHelper.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/4/9.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TDUIHelper.h"

@implementation TDUIHelper

@end

@implementation TDUIHelper (Button1)

+ (TMUIButton *)generateDarkFilledButton {
    TMUIButton *button = [[TMUIButton alloc] tmui_initWithSize:CGSizeMake(200, 40)];
    button.adjustsButtonWhenHighlighted = YES;
    button.titleLabel.font = UIFontBoldMake(14);
    [button setTitleColor:UIColorWhite forState:UIControlStateNormal];
    button.backgroundColor = UIColor.td_tintColor;
    button.highlightedBackgroundColor = [UIColor.td_tintColor tmui_transitionToColor:UIColorBlack progress:.15];// 高亮时的背景色
    button.layer.cornerRadius = 4;
    return button;
}

+ (TMUIButton *)generateLightBorderedButton {
    TMUIButton *button = [[TMUIButton alloc] tmui_initWithSize:CGSizeMake(200, 40)];
    button.titleLabel.font = UIFontBoldMake(14);
    button.tintColorAdjustsTitleAndImage = UIColor.td_tintColor;
    button.backgroundColor = [UIColor.td_tintColor tmui_transitionToColor:UIColorWhite progress:.9];
    button.highlightedBackgroundColor = [UIColor.td_tintColor tmui_transitionToColor:UIColorWhite progress:.75];// 高亮时的背景色
    button.layer.borderColor = [button.backgroundColor tmui_transitionToColor:UIColor.td_tintColor progress:.5].CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 4;
    button.highlightedBorderColor = [button.backgroundColor tmui_transitionToColor:UIColor.td_tintColor progress:.9];// 高亮时的边框颜色
    return button;
}

@end


@implementation TDUIHelper (Theme)

+ (UIImage *)navigationBarBackgroundImageWithThemeColor:(UIColor *)color {
    CGSize size = CGSizeMake(4, 88);
    color = color ? color : UIColorClear;
    
    UIImage *resultImage = [UIImage tmui_imageWithSize:size opaque:YES scale:0 actions:^(CGContextRef contextRef) {
        CGColorSpaceRef spaceRef = CGColorSpaceCreateDeviceRGB();
        UIColor *complexColor = [UIColor tmui_colorWithBackendColor:UIColorWhite frontColor:[color colorWithAlphaComponent:0.86]];
        CGGradientRef gradient = CGGradientCreateWithColors(spaceRef, (CFArrayRef)@[(id)color.CGColor, (id)complexColor.CGColor], NULL);
        CGContextDrawLinearGradient(contextRef, gradient, CGPointZero, CGPointMake(0, size.height), kCGGradientDrawsBeforeStartLocation);
        CGColorSpaceRelease(spaceRef);
        CGGradientRelease(gradient);
    }];
    return [resultImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) resizingMode:UIImageResizingModeStretch];
}

@end

@implementation NSString (Code)

- (void)enumerateCodeStringUsingBlock:(void (^)(NSString *, NSRange))block {
    NSString *pattern = @"\\[?[A-Za-z0-9_.\\(]+\\s?[A-Za-z0-9_:.\\)]+\\]?";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    [regex enumerateMatchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.range.length > 0) {
            if (block) {
                block([self substringWithRange:result.range], result.range);
            }
        }
    }];
}

@end

