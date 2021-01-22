//
//  UIImage+Extension.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

- (UIImage *)drawRoundedRectImage:(CGFloat)cornerRadius width:(CGFloat)width height:(CGFloat)height;

- (UIImage *)drawCircleImage;

/*
 * masterImage  主图片，生成的图片的宽度为masterImage的宽度
 * slaveImage   从图片，拼接在masterImage的下面
 */
- (UIImage *)addSlaveImage:(UIImage *)slaveImage toMasterImage:(UIImage *)masterImage;

/**
 网页长图拼接

 @param qrImage 二维码图片
 @param string 底部文字
 @param title 标题文字
 @return 拼接的长图
 */
- (UIImage *)combineLongWebImage:(UIImage *)qrImage bottomText:(NSString *)string title:(NSString *)title;

+ (UIImage *)scaleImage:(UIImage *)image;

- (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth;

- (UIImage *)cutImage:(CGFloat)maxTargetHeight;

/**
 * 截取当前屏幕
 */
+ (UIImage *)imageWithScreenshot;

+ (UIImage *)imageWithScreenshot:(CGRect)rect;

+ (UIImage *)imageFromView:(UIView *)theView;

+ (UIImage *)imageFromView:(UIView *)view rect:(CGRect)rect;

- (UIImage *)imageWithCornerRadius:(CGFloat)radius;


+ (UIImage *)combineImageUpImage:(UIImage *)upImage DownImage:(UIImage *)downImage;

/**
 * 根据图片和尺寸生成新图片
 */
+ (UIImage *)mtfy_imageResize:(UIImage *)img andResizeTo:(CGSize)newSize;

/**
 * 根据颜色生成图片
 */
+ (UIImage *)mtfy_imageWithColor:(UIColor *)color;

/**
 * 根据颜色和尺寸生成图片
 */
+ (UIImage *)mtfy_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 * 根据颜色和文字生成图片
 * @param color 图片背景颜色
 * @param title 文字
 * @param attributes 文字属性
 * @param size 图片尺寸
 * @return 生成的图片
 */
+ (UIImage *)mtfy_imageWithColor:(UIColor *)color title:(NSString *)title attributes:(NSDictionary *)attributes size:(CGSize)size;


#pragma mark - 图片压缩
// 单位为KB
+ (NSData *)resetSizeOfImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize;
@end
