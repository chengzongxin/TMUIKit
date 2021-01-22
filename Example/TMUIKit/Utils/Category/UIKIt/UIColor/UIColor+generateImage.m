//
//  UIColor+generateImage.m
//  Matafy
//
//  Created by Jason on 2018/7/2.
//  Copyright © 2018年 com.upintech. All rights reserved.
//

#import "UIColor+generateImage.h"

@implementation UIColor (generateImage)

- (UIImage *)generateImageWithSize:(CGSize)size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
