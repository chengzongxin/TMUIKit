//
//  UIFont+MTFYBaseFont.m
//  Matafy
//
//  Created by Tiaotiao on 2019/4/8.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "UIFont+MTFYBaseFont.h"

@implementation UIFont (MTFYBaseFont)

#pragma mark - Public

+ (UIFont *)mafy_fontWithName:(NSString *)name size:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:name size:size];
    if (!font) {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

+ (UIFont *)pingFangSCRegular:(CGFloat)size {
    return [UIFont mafy_fontWithName:@"PingFangSC-Regular" size:size];
}

+ (UIFont *)pingFangSCMedium:(CGFloat)size {
    return [UIFont mafy_fontWithName:@"PingFangSC-Medium" size:size];
}

+ (UIFont *)pingFangSCSemibold:(CGFloat)size {
    return [UIFont mafy_fontWithName:@"PingFangSC-Semibold" size:size];
}

#pragma mark - 自定义字体

+ (UIFont *)simplonBPMedium:(CGFloat)size {
    return [UIFont mafy_fontWithName:@"SimplonBP-Medium" size:size];
}

+ (UIFont *)simplonBPBold:(CGFloat)size {
    return [UIFont mafy_fontWithName:@"SimplonBP-Bold" size:size];
}

+ (UIFont *)dinAlternateBold:(CGFloat)size {
    return [UIFont mafy_fontWithName:@"DINAlternate-Bold" size:size];
}

+ (UIFont *)hurmelSemiBold:(CGFloat)size {
    UIFont *font = [UIFont mafy_fontWithName:@"HurmeGeometricSans3 SemiBold" size:size];
    return font;
}

+ (UIFont *)AvertaStdBold:(CGFloat)size {
    return [UIFont fontWithName:@"AvertaStd-Bold" size:size];
}

@end
