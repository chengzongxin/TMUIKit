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

