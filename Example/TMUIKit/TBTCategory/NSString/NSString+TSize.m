//
//  NSString+TSize.m
//  TBasicLib
//
//  Created by Jerry.jiang on 14-12-2.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import "NSString+TSize.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

@implementation NSString (TSize)

// 获取字符串显示的高度
- (CGFloat)heightWithFont:(UIFont *)ft width:(CGFloat)w {
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        CGSize size = [self boundingRectWithSize:CGSizeMake(w, 100000)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:ft}
                                         context:nil].size;
        return ceilf(size.height);
    } else {
        CGSize s = [self sizeWithFont:ft constrainedToSize:CGSizeMake(w, 100000)];
        return ceilf(s.height);
    }
}

- (CGSize)sizeWithFont:(UIFont *)ft width:(CGFloat)w {
    CGSize ceilfSize;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        CGSize size = [self boundingRectWithSize:CGSizeMake(w, 100000)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:ft}
                                         context:nil].size;
        ceilfSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    } else {
        CGSize s = [self sizeWithFont:ft constrainedToSize:CGSizeMake(w, 100000)];
        ceilfSize = CGSizeMake(ceilf(s.width), ceilf(s.height));
    }
    return ceilfSize;
}

- (CGFloat)heightWithFont:(UIFont *)ft width:(CGFloat)w maxLine:(NSUInteger)lineNum {
    CGFloat heightOfAll = [self heightWithFont:ft width:w];
    CGFloat heightOfMax = CGFLOAT_MAX;
    if (lineNum != 0) {
        NSString *strTem = @"a";
        for (int i=0; i<lineNum-1; i++) {
            strTem = [strTem stringByAppendingString:@"\na"];
        }
        heightOfMax = [strTem heightWithFont:ft width:w];
    }
    return ceilf(MIN(heightOfAll, heightOfMax));
}

// 获取给定size的换行符
+ (NSString *)strOfLineForSize:(CGSize)s withFont:(UIFont *)ft {
    NSString *str = @"";
    CGFloat h = [@"\n\n\n\n\n\n\n\n\n\n" heightWithFont:ft width:300];
    for (int i=0; i<ceilf(s.height*10/h); i++) {
        str = [str stringByAppendingString:@"\n"];
    }
    return str;
}

+ (NSString *)strOfSpaceForWidth:(CGFloat)width withFont:(UIFont *)ft {
    if (width<=0) {
        return @"";
    }
    NSString *str = @" ";
    CGFloat w = [str sizeWithFont:ft].width;
    NSUInteger num = ceilf(width/w);
    for (int i=1; i<num; i++) {
        str = [str stringByAppendingString:@" "];
    }
    return str;
}

- (NSInteger)tmui_numberOfLinesWithFont:(UIFont *)font contrainstedToWidth:(CGFloat)width
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    label.text = self;
    label.numberOfLines = 0;
    label.font = font?:[UIFont systemFontOfSize:17];
    [label sizeToFit];
    CGFloat height = CGRectGetHeight(label.frame);
    CGFloat lineH = [self tmui_lineHeightWithFont:font contrainstedToWidth:width];
    if (lineH>0) {
        NSInteger lines = height/lineH;
        return lines;
    }
    return 0;
}

- (CGFloat)tmui_lineHeightWithFont:(UIFont *)font contrainstedToWidth:(CGFloat)width
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    label.text = @"o";
    label.numberOfLines = 0;
    label.font = font?:[UIFont systemFontOfSize:17];
    [label sizeToFit];
    CGFloat height = CGRectGetHeight(label.frame);
    return height;
}

@end

#pragma GCC diagnostic pop
