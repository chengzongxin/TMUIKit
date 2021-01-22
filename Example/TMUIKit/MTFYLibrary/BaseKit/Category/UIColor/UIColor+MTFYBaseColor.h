//
//  UIColor+MTFYBaseColor.h
//  Matafy
//
//  Created by Tiaotiao on 2019/4/8.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (MTFYBaseColor)

#pragma mark - 导航栏

+ (UIColor *)mtfyBaseNaviTinColor;

#pragma mark - 基本颜色

+ (UIColor *)mtfyBaseColor;

+ (UIColor *)mtfyBaseBgColorF0F2F5;

+ (UIColor *)mtfyBaseBlackColor333333;

+ (UIColor *)mtfyBaseLightGrayColor666666;

+ (UIColor *)mtfyBaseLineColorEEEEEE;

+ (UIColor *)mtfyBaseShadowColor000000;

+ (UIColor *)mtfyHomeBgColorF3F4F6;

+ (UIColor *)mtfyBaseImageBgColorEBEDF1;

#pragma mark - 红色

+ (UIColor *)mtfyLightRedColorFF4B27;
+ (UIColor *)mtfyRedColorFF3434;
+ (UIColor *)mtfyRedColorFF721E;

#pragma mark - 黄色

+ (UIColor *)mtfyYellowColorFF8D1A;

#pragma mark - 灰色

+ (UIColor *)mtfyLightGrayColorNine999999;
+ (UIColor *)mtfyBgLightGrayColorF5F7F9;
+ (UIColor *)mtfyLightGrayColorCCCCCC;
+ (UIColor *)mtfyLightGrayColorE6E6E6;
+ (UIColor *)mtfyLightGrayColor606671;
+ (UIColor *)mtfyLightGrayColor8A98AD;
+ (UIColor *)mtfyLightGrayColorC5CBD6;
+ (UIColor *)mtfyLightGrayColorD8DCE3;
+ (UIColor *)mtfyLightGrayColorE2E5EB;
+ (UIColor *)mtfyLightGrayColor57667A;
+ (UIColor *)mtfyLightGrayColorC4CBD6;


#pragma mark - 蓝色
+ (UIColor *)mtfyLightBlueColor00E7C9;
+ (UIColor *)mtfyLightBlueColor548AF3;
+ (UIColor *)mtfyLightBlueColor16D9D9;

#pragma mark - 黑色

+ (UIColor *)mtfyBlackColor2A323F;
+ (UIColor *)mtfyBlackColor131415;
+ (UIColor *)mtfyBlackColor8C97A7;

#pragma mark - 绿色
+ (UIColor *)mtfyGreenColor09B3B3;
+ (UIColor *)mtfyGreenColor31F3F3;
+ (UIColor *)mtfyGreenColor15CCCC;


@end

@interface UIImage(MTFYBaseColor)

+ (UIImage *)mtfy_placeholderColorImageWithSize:(CGSize)size;
+ (UIImage *)mtfy_placeholderColorImageWithTitle:(NSString *)title ize:(CGSize)size;
+ (UIImage *)mtfy_placeholderAvatar;

@end

NS_ASSUME_NONNULL_END
