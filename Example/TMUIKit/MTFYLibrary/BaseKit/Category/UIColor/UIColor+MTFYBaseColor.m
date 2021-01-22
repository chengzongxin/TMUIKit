//
//  UIColor+MTFYBaseColor.m
//  Matafy
//
//  Created by Tiaotiao on 2019/4/8.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "UIColor+MTFYBaseColor.h"

@implementation UIColor (MTFYBaseColor)

#pragma mark - 导航栏

+ (UIColor *)mtfyBaseNaviTinColor {
    return [UIColor whiteColor];
}

#pragma mark - 主颜色

// 主颜色 蓝色主题
+ (UIColor *)mtfyBaseColor {
    return [UIColor colorWithHexString:@"#00C3CE"];
}

// 主背景颜色 灰色主题
+ (UIColor *)mtfyBaseBgColorF0F2F5 {
    return [UIColor colorWithHexString:@"#F0F2F5"];
}

+ (UIColor *)mtfyBaseBlackColor333333 {
    return [UIColor colorWithHexString:@"#333333"];
}

+ (UIColor *)mtfyBaseLightGrayColor666666 {
    return [UIColor colorWithHexString:@"#666666"];
}

+ (UIColor *)mtfyBaseLineColorEEEEEE {
    return [UIColor colorWithHexString:@"#EEEEEE"];
}

+ (UIColor *)mtfyBaseShadowColor000000 {
    //#000000
    return [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
}

+ (UIColor *)mtfyHomeBgColorF3F4F6 {
    return [UIColor colorWithHexString:@"#F3F4F6"];
}

+(UIColor *)mtfyBaseImageBgColorEBEDF1 {
//    return [UIColor colorWithHexString:@"#EBEDF1"];
    return [UIColor colorWithHexString:@"#F7F9FD"];
}

#pragma mark - 红色

+ (UIColor *)mtfyLightRedColorFF4B27 {
    return [UIColor colorWithHexString:@"#FF4B27"];
}

+ (UIColor *)mtfyRedColorFF3434 {
    return [UIColor colorWithHexString:@"#FF3434"];
}

+ (UIColor *)mtfyRedColorFF721E {
    return [UIColor colorWithHexString:@"#FF721E"];
}


#pragma mark - 黄色

+ (UIColor *)mtfyYellowColorFF8D1A {
    return [UIColor colorWithHexString:@"#FF8D1A"];
}

#pragma mark - 灰色

+ (UIColor *)mtfyLightGrayColorNine999999 {
    return [UIColor colorWithHexString:@"#999999"];
}

+ (UIColor *)mtfyBgLightGrayColorF5F7F9 {
    //#F5F7F9
    return [UIColor colorWithRed:245/255.0 green:247/255.0 blue:249/255.0 alpha:1.0];
}

+ (UIColor *)mtfyLightGrayColorCCCCCC {
    return [UIColor colorWithHexString:@"#CCCCCC"];
}

+ (UIColor *)mtfyLightGrayColorE6E6E6 {
    return [UIColor colorWithHexString:@"#E6E6E6"];
}

+ (UIColor *)mtfyLightGrayColor606671 {
    return [UIColor colorWithHexString:@"#606671"];
}

+ (UIColor *)mtfyLightGrayColor8A98AD {
    return [UIColor colorWithHexString:@"#8A98AD"];
}

+ (UIColor *)mtfyLightGrayColorC5CBD6 {
    return [UIColor colorWithHexString:@"#C5CBD6"];
}

+ (UIColor *)mtfyLightGrayColorD8DCE3 {
    return [UIColor colorWithHexString:@"#D8DCE3"];
}

+ (UIColor *)mtfyLightGrayColorE2E5EB {
    return [UIColor colorWithHexString:@"#E2E5EB"];
}

+ (UIColor *)mtfyLightGrayColor57667A {
    return [UIColor colorWithHexString:@"#57667A"];
}

+ (UIColor *)mtfyLightGrayColorC4CBD6 {
    return [UIColor colorWithHexString:@"#C4CBD6"];
}


#pragma mark - 蓝色

+ (UIColor *)mtfyLightBlueColor00E7C9 {
    return [UIColor colorWithHexString:@"#00E7C9"];
}

+ (UIColor *)mtfyLightBlueColor548AF3 {
    return [UIColor colorWithHexString:@"#548AF3"];
}

+ (UIColor *)mtfyLightBlueColor16D9D9 {
    return [UIColor colorWithHexString:@"#16D9D9"];
}


#pragma mark - 黑色

+ (UIColor *)mtfyBlackColor2A323F {
    return [UIColor colorWithHexString:@"#2A323F"];
}

+ (UIColor *)mtfyBlackColor131415 {
    return [UIColor colorWithHexString:@"#131415"];
}

+ (UIColor *)mtfyBlackColor8C97A7 {
    return [UIColor colorWithHexString:@"#8C97A7"];
}

#pragma mark - 绿色
+ (UIColor *)mtfyGreenColor09B3B3 {
    return [UIColor colorWithHexString:@"#09B3B3"];
}

+ (UIColor *)mtfyGreenColor31F3F3 {
    return [UIColor colorWithHexString:@"#31F3F3"];
}

+ (UIColor *)mtfyGreenColor15CCCC {
    return [UIColor colorWithHexString:@"#15CCCC"];
}



@end

@implementation UIImage (MTFYBaseColor)

+ (UIImage *)mtfy_placeholderColorImageWithSize:(CGSize)size {
    return [UIImage mtfy_imageWithColor:[UIColor mtfyBaseImageBgColorEBEDF1] size:size];
}

+ (UIImage *)mtfy_placeholderColorImageWithTitle:(NSString *)title ize:(CGSize)size {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *attribute = @{
            NSFontAttributeName: [UIFont pingFangSCMedium:13],
            NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#C4CBD6"],
            NSParagraphStyleAttributeName: style
    };
    return [UIImage mtfy_imageWithColor:[UIColor mtfyBaseImageBgColorEBEDF1] title:title attributes:attribute size:size];
}

+ (UIImage *)mtfy_placeholderAvatar {
    return [UIImage imageNamed:@"avatar"];
}
@end
