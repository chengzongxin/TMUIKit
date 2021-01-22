//
//  UIView+Extension.h
//  Matafy
//
//  Created by Cheng on 2018/1/19.
//  Copyright © 2018年 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

+ (instancetype)mtfy_viewFromXib;

/**
 设置半圆View

 @param direct 半圆的方向
 UIRectCornerTopLeft     = 1 << 0,
 UIRectCornerTopRight    = 1 << 1,
 UIRectCornerBottomLeft  = 1 << 2,
 UIRectCornerBottomRight = 1 << 3,
 
 @param radius 半圆半径,传0就默认高度一般(半圆)
 */
- (void)halfCircleCornerDirect:(UIRectCorner)direct radius:(int)radius;

/**
 设置View全部u圆角
 @param radius 半圆半径,传0就默认高度一般(半圆)
 */
- (void)halfAllCircleCornerWithRadius:(int)radius;


/**
 设置View和View的阴影圆角
 
 @param corner 设置View的圆角
 @param color   阴影的颜色
 @param opacity 阴影的透明度
 @param offset 阴影的偏移距离
 @param radius 阴影的圆角
 */
- (void)shadowCornerRadius:(int)corner color:(UIColor *)color opacity:(float)opacity offset:(int)offset radius:(int)radius;

/**
 设置View和View的阴影圆角
 
 @param corner 设置View的圆角
 @param color   阴影的颜色
 @param opacity 阴影的透明度
 @param offset 阴影的偏移距离
 @param radius 阴影的圆角
 */
- (void)shadowCornerRadius:(int)corner color:(UIColor *)color opacity:(float)opacity offsetSize:(CGSize)offset radius:(int)radius;



/**
 设置View边框和颜色

 @param color 颜色
 @param width 宽度
 @param radius 圆角
 */
- (void)setBorderForColor:(UIColor *)color
                    width:(float)width
                   radius:(float)radius;


/**
 设置View圆角,边框和颜色

 @param cornerRadius 圆角
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 */
- (void)setViewCornerRadius:(CGFloat)cornerRadius
                borderColor:(UIColor *)borderColor
                borderWidth:(CGFloat)borderWidth;


/**
 设置View边框和颜色
 
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 */
- (void)setViewBorderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth;


/**
 设置View背景颜色渐变
 @param startColor 起始颜色
 @param endColor 结束颜色
 */
-(void)setGradientColorWithStartColor:(UIColor *)startColor
                             endColor:(UIColor *)endColor;


//
-(void)setGradientColorWithStartColorToDown:(UIColor *)startColor endColor:(UIColor *)endColor;;

/**
 设置View背景颜色渐变
 @param startColor 起始颜色
 @param endColor 结束颜色
 @param startPoint 开始位置
 @param endPoint 结束位置
 @param locations 颜色分割点
 */
-(void)setGradientColorWithStartColor:(UIColor *)startColor
                             endColor:(UIColor *)endColor
                           startPoint:(CGPoint)startPoint
                             endPoint:(CGPoint)endPoint
                            locations:(NSArray<NSNumber *>*)locations;

/**
设置View背景颜色渐变
@param startColor 起始颜色
@param endColor 结束颜色
@param startPoint 开始位置
@param endPoint 结束位置
@param locations 颜色分割点
@param frame  渐变frame，页面没初始化需添加frame
*/
-(void)setGradientColorWithStartColor:(UIColor *)startColor
                             endColor:(UIColor *)endColor
                           startPoint:(CGPoint)startPoint
                             endPoint:(CGPoint)endPoint
                            locations:(NSArray<NSNumber *>*)locations
                                frame:(CGRect)frame;

- (void)addBorder:(UIColor *)color width:(CGFloat)width type:(UIRectEdge)rect;


@end
