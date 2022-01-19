//
//  UIImage+TMUI.m
//  Pods-TMUIKitDemo
//
//  Created by nigel.ning on 2020/4/15.
//

#import "UIImage+TMUI.h"
#import "NSObject+TMUI.h"
#import "UIColor+TMUI.h"
#import <objc/runtime.h>
#import "TMUICoreGraphicsDefines.h"
#import "TMUIKitDefines.h"
#import "TMUIHelper.h"
#import "NSArray+TMUI.h"

@interface UIBezierPath (QMUI)

/**
 * 创建一条支持四个角的圆角值不相同的路径
 * @param rect 路径的rect
 * @param cornerRadius 圆角大小的数字，长度必须为4，顺序分别为[左上角、左下角、右下角、右上角]
 * @param lineWidth 描边的大小，如果不需要描边（例如path是用于fill而不是用于stroke），则填0
 */
+ (UIBezierPath *)tmui_bezierPathWithRoundedRect:(CGRect)rect cornerRadiusArray:(NSArray<NSNumber *> *)cornerRadius lineWidth:(CGFloat)lineWidth;
@end

#ifdef DEBUG
#define CGContextInspectContext(context) { \
    if(!context) {NSAssert(NO, @"非法的contenxt, %@:%d %s", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__);} }
#else
#define CGContextInspectContext(context)
#endif

CG_INLINE CGSize
CGSizeFlatSpecificScale(CGSize size, float scale) {
    return CGSizeMake(flatSpecificScale(size.width, scale), flatSpecificScale(size.height, scale));
}


@implementation UIImage (TMUI)

+ (UIImage *)tmui_imageInBundleWithName:(NSString *)imageName{
    return [self tmui_imageInBundle:nil imageName:imageName];
}

+ (UIImage *)tmui_imageInBundle:( NSString * _Nullable)bundleName imageName:(NSString *)imageName{
    if (![imageName isKindOfClass:[NSString class]] || imageName.length<1) {
        return nil;
    }
    
    NSString *imgPath = [self pathForResourceWithBundleName:bundleName
                                                            fileName:[self fullImgNameWithName:imageName]];
    UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
    if (!img && imageName.length>0) {
        if ([[UIScreen mainScreen]scale]>2) {// 没有3x图片使用2x图片代替
            imgPath = [self pathForResourceWithBundleName:bundleName
                                                          fileName:[NSString stringWithFormat:@"%@@2x.png",imageName]];
            img = [UIImage imageWithContentsOfFile:imgPath];
            return img;
        }
    }
    return img;
}

+ (NSString *)fullImgNameWithName:(NSString *)imageName {
    if (![imageName isKindOfClass:[NSString class]] || imageName.length<1) {
        return @"";
    }
    if ([imageName rangeOfString:@"."].length>0) {
        return imageName;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if ([[UIScreen mainScreen]respondsToSelector:@selector(scale)] && [[UIScreen mainScreen]scale] == 2) {
            return [NSString stringWithFormat:@"%@@2x.png",imageName];
        }else{
            return [NSString stringWithFormat:@"%@.png",imageName];
        }
    } else {
        NSInteger scale = (NSInteger)[[UIScreen mainScreen]scale];
        if (scale<2) {//iphone端不考虑1x的图片
            scale = 2;
        }
        return [NSString stringWithFormat:@"%@@%@x.png",imageName,@(scale)];
    }
}

+ (NSString *)pathForResourceWithBundleName:(NSString *)strBundleName fileName:(NSString *)fileName {
    NSBundle *bundle = strBundleName ? [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:strBundleName withExtension:@"bundle"]] : NSBundle.mainBundle;
    NSString *filePath = [bundle pathForResource:fileName ofType:@""];
    
    if (!filePath) {
        NSLog(@"%@",[NSString stringWithFormat:@"#no resource for fileName:%@ Bundle:%@",fileName,[bundle description]]);
    }
    return filePath;
}

+ (nullable UIImage *)tmui_imageWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale actions:(void (^)(CGContextRef contextRef))actionBlock {
    if (!actionBlock || CGSizeEqualToSize(size, CGSizeZero)) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextInspectContext(context);
    actionBlock(context);
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOut;
}

- (BOOL)tmui_resizable {
    BOOL result;
    [self tmui_performSelector:NSSelectorFromString(@"_isResizable") withPrimitiveReturnValue:&result];
    return result;
}


- (UIColor *)tmui_averageColor {
    unsigned char rgba[4] = {};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextInspectContext(context);
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    if(rgba[3] > 0) {
        return [UIColor colorWithRed:((CGFloat)rgba[0] / rgba[3])
                               green:((CGFloat)rgba[1] / rgba[3])
                                blue:((CGFloat)rgba[2] / rgba[3])
                               alpha:((CGFloat)rgba[3] / 255.0)];
    } else {
        return [UIColor colorWithRed:((CGFloat)rgba[0]) / 255.0
                               green:((CGFloat)rgba[1]) / 255.0
                                blue:((CGFloat)rgba[2]) / 255.0
                               alpha:((CGFloat)rgba[3]) / 255.0];
    }
}


- (CGSize)tmui_sizeInPixel {
    CGSize size = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    return size;
}

- (BOOL)tmui_opaque {
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    BOOL opaque = alphaInfo == kCGImageAlphaNoneSkipLast
    || alphaInfo == kCGImageAlphaNoneSkipFirst
    || alphaInfo == kCGImageAlphaNone;
    return opaque;
}

- (nullable UIImage *)tmui_grayImage {
    // CGBitmapContextCreate 是无倍数的，所以要自己换算成1倍
    CGSize size = self.tmui_sizeInPixel;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGBitmapByteOrderDefault);
    CGContextInspectContext(context);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGRect imageRect = CGRectMakeWithSize(size);
    CGContextDrawImage(context, imageRect, self.CGImage);
    
    UIImage *grayImage = nil;
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    if (self.tmui_opaque) {
        grayImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    } else {
        CGContextRef alphaContext = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, nil, kCGImageAlphaOnly);
        CGContextDrawImage(alphaContext, imageRect, self.CGImage);
        CGImageRef mask = CGBitmapContextCreateImage(alphaContext);
        CGImageRef maskedGrayImageRef = CGImageCreateWithMask(imageRef, mask);
        grayImage = [UIImage imageWithCGImage:maskedGrayImageRef scale:self.scale orientation:self.imageOrientation];
        CGImageRelease(mask);
        CGImageRelease(maskedGrayImageRef);
        CGContextRelease(alphaContext);
        
        // 用 CGBitmapContextCreateImage 方式创建出来的图片，CGImageAlphaInfo 总是为 CGImageAlphaInfoNone，导致 tmui_opaque 与原图不一致，所以这里再做多一步
        grayImage = [UIImage tmui_imageWithSize:grayImage.size opaque:NO scale:grayImage.scale actions:^(CGContextRef contextRef) {
            [grayImage drawInRect:CGRectMakeWithSize(grayImage.size)];
        }];
    }
    
    CGContextRelease(context);
    CGImageRelease(imageRef);
    return grayImage;
}

- (nullable UIImage *)tmui_imageWithAlpha:(CGFloat)alpha {
    return [UIImage tmui_imageWithSize:self.size opaque:NO scale:self.scale actions:^(CGContextRef contextRef) {
        [self drawInRect:CGRectMakeWithSize(self.size) blendMode:kCGBlendModeNormal alpha:alpha];
    }];
}

- (nullable UIImage *)tmui_imageWithTintColor:(nullable UIColor *)tintColor {
    // iOS 13 的 imageWithTintColor: 方法里并不会去更新 CGImage，所以通过它更改了图片颜色后再获取到的 CGImage 依然是旧的，因此暂不使用
    //#ifdef IOS13_SDK_ALLOWED
    //    if (@available(iOS 13.0, *)) {
    //        return [self imageWithTintColor:tintColor];
    //    }
    //#endif
        return [UIImage tmui_imageWithSize:self.size opaque:self.tmui_opaque scale:self.scale actions:^(CGContextRef contextRef) {
            CGContextTranslateCTM(contextRef, 0, self.size.height);
            CGContextScaleCTM(contextRef, 1.0, -1.0);
            CGContextSetBlendMode(contextRef, kCGBlendModeNormal);
            CGContextClipToMask(contextRef, CGRectMakeWithSize(self.size), self.CGImage);
            CGContextSetFillColorWithColor(contextRef, tintColor.CGColor);
            CGContextFillRect(contextRef, CGRectMakeWithSize(self.size));
        }];
}

- (nullable UIImage *)tmui_imageWithSpacingExtensionInsets:(UIEdgeInsets)extension {
    CGSize contextSize = CGSizeMake(self.size.width + UIEdgeInsetsGetHorizontalValue(extension), self.size.height + UIEdgeInsetsGetVerticalValue(extension));
    return [UIImage tmui_imageWithSize:contextSize opaque:self.tmui_opaque scale:self.scale actions:^(CGContextRef contextRef) {
        [self drawAtPoint:CGPointMake(extension.left, extension.top)];
    }];
}


- (nullable UIImage *)tmui_imageWithOrientation:(UIImageOrientation)orientation {
    if (orientation == UIImageOrientationUp) {
        return self;
    }
    
    CGSize contextSize = self.size;
    if (orientation == UIImageOrientationLeft || orientation == UIImageOrientationRight) {
        contextSize = CGSizeMake(contextSize.height, contextSize.width);
    }
            
    return [UIImage tmui_imageWithSize:contextSize opaque:NO scale:self.scale actions:^(CGContextRef contextRef) {
        // 画布的原点在左上角，旋转后可能图片就飞到画布外了，所以旋转前先把图片摆到特定位置再旋转，图片刚好就落在画布里
        switch (orientation) {
            case UIImageOrientationUp:
                // 上
                break;
            case UIImageOrientationDown:
                // 下
                CGContextTranslateCTM(contextRef, contextSize.width, contextSize.height);
                CGContextRotateCTM(contextRef, TMUI_AngleWithDegrees(180));
                break;
            case UIImageOrientationLeft:
                // 左
                CGContextTranslateCTM(contextRef, 0, contextSize.height);
                CGContextRotateCTM(contextRef, TMUI_AngleWithDegrees(-90));
                break;
            case UIImageOrientationRight:
                // 右
                CGContextTranslateCTM(contextRef, contextSize.width, 0);
                CGContextRotateCTM(contextRef, TMUI_AngleWithDegrees(90));
                break;
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
                // 向上、向下翻转是一样的
                CGContextTranslateCTM(contextRef, 0, contextSize.height);
                CGContextScaleCTM(contextRef, 1, -1);
                break;
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
                // 向左、向右翻转是一样的
                CGContextTranslateCTM(contextRef, contextSize.width, 0);
                CGContextScaleCTM(contextRef, -1, 1);
                break;
        }
        
        // 在前面画布的旋转、移动的结果上绘制自身即可，这里不用考虑旋转带来的宽高置换的问题
        [self drawInRect:CGRectMakeWithSize(self.size)];
    }];
}

#pragma mark - generate color image

+ (nullable UIImage *)tmui_imageWithColor:(nullable UIColor *)color {
    return [UIImage tmui_imageWithColor:color size:CGSizeMake(4, 4)];
}

+ (nullable UIImage *)tmui_imageWithColor:(nullable UIColor *)color size:(CGSize)size {
    return [UIImage tmui_imageWithColor:color size:size cornerRadius:0];
}

+ (nullable UIImage *)tmui_imageWithColor:(nullable UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
        
    color = color ? color : [UIColor clearColor];
    BOOL opaque = (cornerRadius == 0.0 && [color tmui_alpha] == 1.0);
    return [UIImage tmui_imageWithSize:size opaque:opaque scale:0 actions:^(CGContextRef contextRef) {
        CGContextSetFillColorWithColor(contextRef, color.CGColor);
        
        if (cornerRadius > 0) {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMakeWithSize(size) cornerRadius:cornerRadius];
            [path addClip];
            [path fill];
        } else {
            CGContextFillRect(contextRef, CGRectMakeWithSize(size));
        }
    }];
}

#pragma mark - generate shape image

+ (UIImage *)tmui_imageWithShape:(TMUIImageShape)shape size:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat lineWidth = 0;
    switch (shape) {
        case TMUIImageShapeNavBack:
            lineWidth = 2.0f;
            break;
        case TMUIImageShapeDisclosureIndicator:
            lineWidth = 1.5f;
            break;
        case TMUIImageShapeCheckmark:
            lineWidth = 1.5f;
            break;
        case TMUIImageShapeDetailButtonImage:
            lineWidth = 1.0f;
            break;
        case TMUIImageShapeNavClose:
            lineWidth = 1.2f;   // 取消icon默认的lineWidth
            break;
        default:
            break;
    }
    return [UIImage tmui_imageWithShape:shape size:size lineWidth:lineWidth tintColor:tintColor];
}

+ (nullable UIImage *)tmui_imageWithShape:(TMUIImageShape)shape size:(CGSize)size lineWidth:(CGFloat)lineWidth tintColor:(nullable UIColor *)tintColor {
    
    tintColor = tintColor ? : [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    return [UIImage tmui_imageWithSize:size opaque:NO scale:0 actions:^(CGContextRef contextRef) {
        UIBezierPath *path = nil;
        BOOL drawByStroke = NO;
        CGFloat drawOffset = lineWidth / 2;
        switch (shape) {
            case TMUIImageShapeOval: {
                path = [UIBezierPath bezierPathWithOvalInRect:CGRectMakeWithSize(size)];
            }
                break;
            case TMUIImageShapeTriangle: {
                path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(0, size.height)];
                [path addLineToPoint:CGPointMake(size.width / 2, 0)];
                [path addLineToPoint:CGPointMake(size.width, size.height)];
                [path closePath];
            }
                break;
            case TMUIImageShapeNavBack: {
                drawByStroke = YES;
                path = [UIBezierPath bezierPath];
                path.lineWidth = lineWidth;
                [path moveToPoint:CGPointMake(size.width - drawOffset, drawOffset)];
                [path addLineToPoint:CGPointMake(0 + drawOffset, size.height / 2.0)];
                [path addLineToPoint:CGPointMake(size.width - drawOffset, size.height - drawOffset)];
            }
                break;
            case TMUIImageShapeDisclosureIndicator: {
                drawByStroke = YES;
                path = [UIBezierPath bezierPath];
                path.lineWidth = lineWidth;
                [path moveToPoint:CGPointMake(drawOffset, drawOffset)];
                [path addLineToPoint:CGPointMake(size.width - drawOffset, size.height / 2)];
                [path addLineToPoint:CGPointMake(drawOffset, size.height - drawOffset)];
            }
                break;
            case TMUIImageShapeCheckmark: {
                CGFloat lineAngle = M_PI_4;
                path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(0, size.height / 2)];
                [path addLineToPoint:CGPointMake(size.width / 3, size.height)];
                [path addLineToPoint:CGPointMake(size.width, lineWidth * sin(lineAngle))];
                [path addLineToPoint:CGPointMake(size.width - lineWidth * cos(lineAngle), 0)];
                [path addLineToPoint:CGPointMake(size.width / 3, size.height - lineWidth / sin(lineAngle))];
                [path addLineToPoint:CGPointMake(lineWidth * sin(lineAngle), size.height / 2 - lineWidth * sin(lineAngle))];
                [path closePath];
            }
                break;
            case TMUIImageShapeDetailButtonImage: {
                drawByStroke = YES;
                path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMakeWithSize(size), drawOffset, drawOffset)];
                path.lineWidth = lineWidth;
            }
                break;
            case TMUIImageShapeNavClose: {
                drawByStroke = YES;
                path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(0, 0)];
                [path addLineToPoint:CGPointMake(size.width, size.height)];
                [path closePath];
                [path moveToPoint:CGPointMake(size.width, 0)];
                [path addLineToPoint:CGPointMake(0, size.height)];
                [path closePath];
                path.lineWidth = lineWidth;
                path.lineCapStyle = kCGLineCapRound;
            }
                break;
            default:
                break;
        }
        
        if (drawByStroke) {
            CGContextSetStrokeColorWithColor(contextRef, tintColor.CGColor);
            [path stroke];
        } else {
            CGContextSetFillColorWithColor(contextRef, tintColor.CGColor);
            [path fill];
        }
        
        if (shape == TMUIImageShapeDetailButtonImage) {
            CGFloat fontPointSize = ceilf(size.height * 0.8);
            UIFont *font = [UIFont fontWithName:@"Georgia" size:fontPointSize];
            NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"i" attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: tintColor}];
            CGSize stringSize = [string boundingRectWithSize:size options:NSStringDrawingUsesFontLeading context:nil].size;
            [string drawAtPoint:CGPointMake(CGFloatGetCenter(size.width, stringSize.width), CGFloatGetCenter(size.height, stringSize.height))];
        }
    }];
}


+ (UIImage *)tmui_imageWithStrokeColor:(UIColor *)strokeColor size:(CGSize)size path:(UIBezierPath *)path addClip:(BOOL)addClip {
    size = CGSizeFlatted(size);
    return [UIImage tmui_imageWithSize:size opaque:NO scale:0 actions:^(CGContextRef contextRef) {
        CGContextSetStrokeColorWithColor(contextRef, strokeColor.CGColor);
        if (addClip) [path addClip];
        [path stroke];
    }];
}

+ (UIImage *)tmui_imageWithStrokeColor:(UIColor *)strokeColor size:(CGSize)size lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)cornerRadius {
    CGContextInspectSize(size);
    // 往里面缩一半的lineWidth，应为stroke绘制线的时候是往两边绘制的
    // 如果cornerRadius为0的时候使用bezierPathWithRoundedRect:cornerRadius:会有问题，左上角老是会多出一点，所以区分开
    UIBezierPath *path;
    CGRect rect = CGRectInset(CGRectMakeWithSize(size), lineWidth / 2, lineWidth / 2);
    if (cornerRadius > 0) {
        path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    } else {
        path = [UIBezierPath bezierPathWithRect:rect];
    }
    [path setLineWidth:lineWidth];
    return [UIImage tmui_imageWithStrokeColor:strokeColor size:size path:path addClip:NO];
}

+ (UIImage *)tmui_imageWithStrokeColor:(UIColor *)strokeColor size:(CGSize)size lineWidth:(CGFloat)lineWidth borderPosition:(TMUIImageBorderPosition)borderPosition {
    CGContextInspectSize(size);
    if (borderPosition == TMUIImageBorderPositionAll) {
        return [UIImage tmui_imageWithStrokeColor:strokeColor size:size lineWidth:lineWidth cornerRadius:0];
    } else {
        // TODO 使用bezierPathWithRoundedRect:byRoundingCorners:cornerRadii:这个系统接口
        UIBezierPath* path = [UIBezierPath bezierPath];
        if ((TMUIImageBorderPositionBottom & borderPosition) == TMUIImageBorderPositionBottom) {
            [path moveToPoint:CGPointMake(0, size.height - lineWidth / 2)];
            [path addLineToPoint:CGPointMake(size.width, size.height - lineWidth / 2)];
        }
        if ((TMUIImageBorderPositionTop & borderPosition) == TMUIImageBorderPositionTop) {
            [path moveToPoint:CGPointMake(0, lineWidth / 2)];
            [path addLineToPoint:CGPointMake(size.width, lineWidth / 2)];
        }
        if ((TMUIImageBorderPositionLeft & borderPosition) == TMUIImageBorderPositionLeft) {
            [path moveToPoint:CGPointMake(lineWidth / 2, 0)];
            [path addLineToPoint:CGPointMake(lineWidth / 2, size.height)];
        }
        if ((TMUIImageBorderPositionRight & borderPosition) == TMUIImageBorderPositionRight) {
            [path moveToPoint:CGPointMake(size.width - lineWidth / 2, 0)];
            [path addLineToPoint:CGPointMake(size.width - lineWidth / 2, size.height)];
        }
        [path setLineWidth:lineWidth];
        [path closePath];
        return [UIImage tmui_imageWithStrokeColor:strokeColor size:size path:path addClip:NO];
    }
}



#pragma mark - 截图

+ (nullable UIImage *)tmui_imageWithView:(UIView *)view {
    return [UIImage tmui_imageWithSize:view.bounds.size opaque:NO scale:0 actions:^(CGContextRef contextRef) {
        [view.layer renderInContext:contextRef];
    }];
}

+ (UIImage *)tmui_imageWithView:(UIView *)view afterScreenUpdates:(BOOL)afterUpdates {
    // iOS 7 截图新方式，性能好会好一点，不过不一定适用，因为这个方法的使用条件是：界面要已经render完，否则截到得图将会是empty。
    return [UIImage tmui_imageWithSize:view.bounds.size opaque:NO scale:0 actions:^(CGContextRef contextRef) {
        [view drawViewHierarchyInRect:CGRectMakeWithSize(view.bounds.size) afterScreenUpdates:afterUpdates];
    }];
}

@end



@implementation UIImage (TMUI_Scale)

- (NSData *)tmui_imageData{
    return UIImageJPEGRepresentation(self, 1.0);
}

- (NSInteger)tmui_dataLength{
    return [self tmui_imageData].length;
}


- (UIImage *)tmui_fixOrientation {
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


/**
 *  缩放到指定大小，也就是指定的size(非等比)
 *
 *  @param thumbRect thumbRect的起始位置为(0,0)
 *
 *  @return 缩放后的图片
 */
- (UIImage*)tmui_resizedInRect:(CGRect)thumbRect {
    UIGraphicsBeginImageContext(thumbRect.size);
    [self drawInRect:thumbRect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/**
 * 按比例缩放 (通过计算得到缩放系数）
 *
 *  @param afterSize 要显示到多大区域
 *
 *  @return 缩放后的图片
 */
- (UIImage *)tmui_imageCompressFitTargetSize:(CGSize)afterSize {
    
    //照片的宽高
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    //目标区域的宽高
    CGFloat targetWidth = afterSize.width;
    CGFloat targetHeight = afterSize.height;
    
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGFloat scaleFactor = 1;

    //目标位置
    CGPoint targetPoint = CGPointMake(0.0, 0.0);
    
    //将imageSize和afterSize的宽和高分别进行比较，都相等的时候返回YES.
    if(CGSizeEqualToSize(imageSize, afterSize) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;

        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            targetPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            targetPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    //目标图片的位置和宽高
    CGRect targetRect = CGRectZero;
    targetRect.origin = targetPoint;//origin = (x = -180, y = 0
    targetRect.size.width = scaledWidth;
    targetRect.size.height = scaledHeight;
    
    //创建一个基于位图的上下文（context）,并将其设置为当前上下文(context)
    UIGraphicsBeginImageContext(afterSize);
    //绘制改变大小的图片
    [self drawInRect:targetRect];
    //从上下文当中生成一张图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

/**
 * 按比例缩放 (以当前屏幕宽自适应,算出缩放系数,进行等比缩放）
 *
 *  区别:如果图片宽度小于屏幕宽,则显示照片实际高度
 *
 *  @return 缩放后的图片
 */
- (UIImage*)tmui_scaleToFit {
    
    //获取当前屏幕的宽
    CGFloat width = [UIScreen mainScreen].scale * [UIScreen mainScreen].bounds.size.width;//6s:375
    CGFloat wid = self.size.width > width? width:self.size.width;
    CGFloat width_scale = wid;//480.0;
    CGFloat height_scale = self.size.height*(wid/self.size.width);
    
    //创建一个基于位图的上下文（context）,并将其设置为当前上下文(context)
    UIGraphicsBeginImageContext(CGSizeMake(floorf(width_scale), floorf(height_scale)));
    //绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, width_scale, height_scale)];
    //从上下文当中生成一张图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文.
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

/**
 *  从图片中按指定的位置大小截取图片的一部分
 *
 *  @param rect 要截取的区域
 *
 *  @return 截取后的图片
 */
- (UIImage*)tmui_getSubImage:(CGRect)rect {
    
    //image:需要被裁剪的图片
    //rect: 裁剪范围
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    //创建一个基于位图的上下文（context）,并将其设置为当前上下文(context)
    UIGraphicsBeginImageContext(smallBounds.size);
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //根据上下文绘制图片
    CGContextDrawImage(context, smallBounds, subImageRef);
    
    //获取裁剪后的图片
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    //关闭上下文
    UIGraphicsEndImageContext();
    //只有当CGImageRef使用creat或retain后才要手动release
    CGImageRelease(subImageRef);
    
    return smallImage;
}

/**
 *  指定大小 等比例缩放,以最大的比率放大,以最小的比率缩小
 *
 *  @param size 要显示到多大区域
 *
 *  @return 缩放后的图片
 */
- (UIImage*)tmui_scaleToSize:(CGSize)size {
    
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;//(CGSize) imageSize = (width = 2448, height = 3264)

    CGFloat verticalRadio = size.height / height; // 0.4411
    CGFloat horizontalRadio = size.width / width; // 0.588

    CGFloat radio = 1;

    //放大
    if(verticalRadio>1 && horizontalRadio>1){
        //放大系数
        radio = verticalRadio < horizontalRadio ? horizontalRadio : verticalRadio;
    }else{
        //缩小系数
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }

    width = width*radio; // 1080
    height = height*radio; //1440

    CGPoint targetPoint = CGPointMake(0.0, 0.0);
    
    targetPoint.x = (size.width - width)/2;
    targetPoint.y = (size.height - height)/2;

    //目标图片的位置和宽高
    CGRect targetRect = CGRectZero;
    targetRect.origin = targetPoint;// origin = (x = 0, y = 240)
    targetRect.size.width = width;
    targetRect.size.height = height;

    //创建一个基于位图的上下文（context）,并将其设置为当前上下文(context)
    UIGraphicsBeginImageContext(size);
    //绘制改变大小的图片
    [self drawInRect:targetRect];
    //从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    return scaledImage;
}

/**
 *  非等比例压缩
 *
 *  @param size 压缩后图片尺寸
 *
 *  @return 压缩后的图片
 */
- (UIImage *)tmui_unProportionScaleToSize:(CGSize)size {
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    CGFloat verticalScale = size.height*1.0/height;
    CGFloat horizontalScale = size.width*1.0/width;
    
    CGFloat scale = 1;
    
    if (width>height) {
        scale = verticalScale;
    }else{
        scale = horizontalScale;
    }
    width = width*scale;
    height = height*scale;
    UIImage *smallImgOfProportionScale = [self tmui_scaleToSize:CGSizeMake(width, height)];
    int xPos = (width-size.width)/2;
    int yPos = (height-size.height)/2;
    UIImage *smallImgOfUnProportionScale = [smallImgOfProportionScale tmui_getSubImage:(CGRect){xPos,yPos,size}];
    
    return smallImgOfUnProportionScale;
}

/**
 *  指定最大data大小 先压缩质量、再压缩size，循环
 *
 *  @param maxDataLen 最大data大小 例：1Mb传 1024*1024
 *
 *  @return 压缩后的图片
 */
- (NSData *)tmui_resizedToMaxDataLen:(NSInteger)maxDataLen {
    return [self tmui_resizedToMaxDataLen:maxDataLen aspectRatio:0];
}

- (NSData *)tmui_resizedToMaxDataLen:(NSInteger)maxDataLen aspectRatio:(CGFloat)aspectRatio {
    CGFloat compression = 1.0;
    CGFloat scale = 1.0;
    CGFloat imgW = self.size.width * self.scale ? : 1;  //防止为0
    CGFloat imgH = self.size.height * self.scale ? : 1;
    //按比例压缩
    if (aspectRatio > 0) {
        CGFloat finalAspectRatio = imgW / imgH;
        if (finalAspectRatio > aspectRatio) {
            imgW = imgH * aspectRatio;
        } else {
            imgH = imgW / aspectRatio;
        }
    }
    UIImage *finalImg = (aspectRatio > 0) ? [self tmui_imageCompressFitTargetSize:CGSizeMake(imgW, imgH)] : self;
    NSData *finalData = UIImageJPEGRepresentation(finalImg, 1.0);
    //符合要求大小
    if (maxDataLen <= 0 || finalData.length <= maxDataLen) {
        return finalData;
    }
    NSLog(@"-iOS image data size before compressed == %f Kb----%@",finalData.length/1024.0, NSStringFromCGSize(self.size));

    //先压缩质量、再压缩size，循环
    BOOL bySize = NO;
    NSUInteger count = 0;
    
    CGFloat scaleMax = 1.0;
    CGFloat scaleMin = 0;
    CGFloat comMax = 1.0;
    CGFloat comMin = 0;
    
    NSUInteger successCount = 0;
    
    //压缩大小在 maxDataLen的0.9～1中间即为合适
    while (finalData.length < maxDataLen * 0.9 || finalData.length > maxDataLen) {
        scale = (scaleMax + scaleMin) / 2;
        compression = (comMax + comMin) / 2;
       
        UIImage *img = (scale < 1.0 || aspectRatio > 0) ? [self tmui_imageCompressFitTargetSize:CGSizeMake(imgW * scale, imgH * scale)] : self;
        finalData = UIImageJPEGRepresentation(img, compression);
        if (finalData.length < maxDataLen * 0.9) {
            successCount ++;
            if (successCount > 6) {//6次基本符合要求，防止频繁压缩
                break;
            }
            if (bySize) {
                scaleMin = scale;
            } else {
                comMin = compression;
            }
        } else if (finalData.length > maxDataLen) {
            if (bySize) {
                scaleMax = scale;
            } else {
                comMax = compression;
            }
        }
        bySize = !bySize;
        count ++;
    }
    NSLog(@"-iOS image data size after compressed == %f Kb---scale%f, com--%f----count--%lu",finalData.length/1024.0, scale, compression, (unsigned long)count);

    return finalData;
}

@end


@implementation UIImage (TMUI_Size)


- (UIImage *)tmui_imageWithAlpha:(CGFloat)alpha {
    return [UIImage tmui_imageWithSize:self.size opaque:NO scale:self.scale actions:^(CGContextRef contextRef) {
        [self drawInRect:CGRectMakeWithSize(self.size) blendMode:kCGBlendModeNormal alpha:alpha];
    }];
}

- (UIImage *)tmui_imageWithTintColor:(UIColor *)tintColor {
    // iOS 13 的 imageWithTintColor: 方法里并不会去更新 CGImage，所以通过它更改了图片颜色后再获取到的 CGImage 依然是旧的，因此暂不使用
//    if (@available(iOS 13.0, *)) {
//        return [self imageWithTintColor:tintColor];
//    }
    BOOL opaque = self.tmui_opaque ? tintColor.tmui_alpha >= 1.0 : NO;// 如果图片不透明但 tintColor 半透明，则生成的图片也应该是半透明的
    UIImage *result = [UIImage tmui_imageWithSize:self.size opaque:opaque scale:self.scale actions:^(CGContextRef contextRef) {
        CGContextTranslateCTM(contextRef, 0, self.size.height);
        CGContextScaleCTM(contextRef, 1.0, -1.0);
        if (!opaque) {
            CGContextSetBlendMode(contextRef, kCGBlendModeNormal);
            CGContextClipToMask(contextRef, CGRectMakeWithSize(self.size), self.CGImage);
        }
        CGContextSetFillColorWithColor(contextRef, tintColor.CGColor);
        CGContextFillRect(contextRef, CGRectMakeWithSize(self.size));
    }];
    
    SEL selector = NSSelectorFromString(@"tmui_generatorSupportsDynamicColor");
    if ([NSStringFromClass(tintColor.class) containsString:@"TMUIThemeColor"] && [UIImage respondsToSelector:selector]) {
        BOOL supports;
        [UIImage.class tmui_performSelector:selector withPrimitiveReturnValue:&supports];
        NSAssert(supports, @"UIImage (TMUI)", @"UIImage (TMUITheme) hook 尚未生效，TMUIThemeColor 生成的图片无法自动转成 TMUIThemeImage，可能导致 theme 切换时无法刷新。");
    }
    return result;
}

- (UIImage *)tmui_imageWithBlendColor:(UIColor *)blendColor {
    UIImage *coloredImage = [self tmui_imageWithTintColor:blendColor];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorBlendMode"];
    [filter setValue:[CIImage imageWithCGImage:self.CGImage] forKey:kCIInputBackgroundImageKey];
    [filter setValue:[CIImage imageWithCGImage:coloredImage.CGImage] forKey:kCIInputImageKey];
    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:outputImage fromRect:outputImage.extent];
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return resultImage;
}

- (UIImage *)tmui_imageWithImageAbove:(UIImage *)image atPoint:(CGPoint)point {
    return [UIImage tmui_imageWithSize:self.size opaque:self.tmui_opaque scale:self.scale actions:^(CGContextRef contextRef) {
        [self drawInRect:CGRectMakeWithSize(self.size)];
        [image drawAtPoint:point];
    }];
}

- (UIImage *)tmui_imageWithSpacingExtensionInsets:(UIEdgeInsets)extension {
    CGSize contextSize = CGSizeMake(self.size.width + UIEdgeInsetsGetHorizontalValue(extension), self.size.height + UIEdgeInsetsGetVerticalValue(extension));
    return [UIImage tmui_imageWithSize:contextSize opaque:self.tmui_opaque scale:self.scale actions:^(CGContextRef contextRef) {
        [self drawAtPoint:CGPointMake(extension.left, extension.top)];
    }];
}

- (UIImage *)tmui_imageWithClippedRect:(CGRect)rect {
    CGContextInspectSize(rect.size);
    CGRect imageRect = CGRectMakeWithSize(self.size);
    if (CGRectContainsRect(rect, imageRect)) {
        // 要裁剪的区域比自身大，所以不用裁剪直接返回自身即可
        return self;
    }
    // 由于CGImage是以pixel为单位来计算的，而UIImage是以point为单位，所以这里需要将传进来的point转换为pixel
    CGRect scaledRect = CGRectApplyScale(rect, self.scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, scaledRect);
    UIImage *imageOut = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return imageOut;
}

- (UIImage *)tmui_imageWithClippedCornerRadius:(CGFloat)cornerRadius {
    return [self tmui_imageWithClippedCornerRadius:cornerRadius scale:self.scale];
}

- (UIImage *)tmui_imageWithClippedCornerRadius:(CGFloat)cornerRadius scale:(CGFloat)scale {
    if (cornerRadius <= 0) {
        return self;
    }
    return [UIImage tmui_imageWithSize:self.size opaque:NO scale:scale actions:^(CGContextRef contextRef) {
        [[UIBezierPath bezierPathWithRoundedRect:CGRectMakeWithSize(self.size) cornerRadius:cornerRadius] addClip];
        [self drawInRect:CGRectMakeWithSize(self.size)];
    }];
}

- (UIImage *)tmui_imageResizedInLimitedSize:(CGSize)size {
    return [self tmui_imageResizedInLimitedSize:size resizingMode:TMUIImageResizingModeScaleAspectFit];
}

- (UIImage *)tmui_imageResizedInLimitedSize:(CGSize)size resizingMode:(TMUIImageResizingMode)resizingMode {
    return [self tmui_imageResizedInLimitedSize:size resizingMode:resizingMode scale:self.scale];
}

- (UIImage *)tmui_imageResizedInLimitedSize:(CGSize)size resizingMode:(TMUIImageResizingMode)resizingMode scale:(CGFloat)scale {
    size = CGSizeFlatSpecificScale(size, scale);
    CGSize imageSize = self.size;
    CGRect drawingRect = CGRectZero;// 图片绘制的 rect
    CGSize contextSize = CGSizeZero;// 画布的大小
    
    if (CGSizeEqualToSize(size, imageSize) && scale == self.scale) {
        return self;
    }
    
    if (resizingMode >= TMUIImageResizingModeScaleAspectFit && resizingMode <= TMUIImageResizingModeScaleAspectFillBottom) {
        CGFloat horizontalRatio = size.width / imageSize.width;
        CGFloat verticalRatio = size.height / imageSize.height;
        CGFloat ratio = 0;
        if (resizingMode >= TMUIImageResizingModeScaleAspectFill && resizingMode < (TMUIImageResizingModeScaleAspectFill + 10)) {
            ratio = MAX(horizontalRatio, verticalRatio);
        } else {
            // 默认按 TMUIImageResizingModeScaleAspectFit
            ratio = MIN(horizontalRatio, verticalRatio);
        }
        CGSize resizedSize = CGSizeMake(flatSpecificScale(imageSize.width * ratio, scale), flatSpecificScale(imageSize.height * ratio, scale));
        contextSize = CGSizeMake(MIN(size.width, resizedSize.width), MIN(size.height, resizedSize.height));
        drawingRect.origin.x = CGFloatGetCenter(contextSize.width, resizedSize.width);
        
        CGFloat originY = 0;
        if (resizingMode % 10 == 1) {
            // toTop
            originY = 0;
        } else if (resizingMode % 10 == 2) {
            // toBottom
            originY = contextSize.height - resizedSize.height;
        } else {
            // default is Center
            originY = CGFloatGetCenter(contextSize.height, resizedSize.height);
        }
        drawingRect.origin.y = originY;
        
        drawingRect.size = resizedSize;
    } else {
        // 默认按照 TMUIImageResizingModeScaleToFill
        drawingRect = CGRectMakeWithSize(size);
        contextSize = size;
    }
    
    return [UIImage tmui_imageWithSize:contextSize opaque:self.tmui_opaque scale:scale actions:^(CGContextRef contextRef) {
        [self drawInRect:drawingRect];
    }];
}

- (UIImage *)tmui_imageWithOrientation:(UIImageOrientation)orientation {
    if (orientation == UIImageOrientationUp) {
        return self;
    }
    
    CGSize contextSize = self.size;
    if (orientation == UIImageOrientationLeft || orientation == UIImageOrientationRight) {
        contextSize = CGSizeMake(contextSize.height, contextSize.width);
    }
    
    contextSize = CGSizeFlatSpecificScale(contextSize, self.scale);
    
    return [UIImage tmui_imageWithSize:contextSize opaque:NO scale:self.scale actions:^(CGContextRef contextRef) {
        // 画布的原点在左上角，旋转后可能图片就飞到画布外了，所以旋转前先把图片摆到特定位置再旋转，图片刚好就落在画布里
        switch (orientation) {
            case UIImageOrientationUp:
                // 上
                break;
            case UIImageOrientationDown:
                // 下
                CGContextTranslateCTM(contextRef, contextSize.width, contextSize.height);
                CGContextRotateCTM(contextRef, AngleWithDegrees(180));
                break;
            case UIImageOrientationLeft:
                // 左
                CGContextTranslateCTM(contextRef, 0, contextSize.height);
                CGContextRotateCTM(contextRef, AngleWithDegrees(-90));
                break;
            case UIImageOrientationRight:
                // 右
                CGContextTranslateCTM(contextRef, contextSize.width, 0);
                CGContextRotateCTM(contextRef, AngleWithDegrees(90));
                break;
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
                // 向上、向下翻转是一样的
                CGContextTranslateCTM(contextRef, 0, contextSize.height);
                CGContextScaleCTM(contextRef, 1, -1);
                break;
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
                // 向左、向右翻转是一样的
                CGContextTranslateCTM(contextRef, contextSize.width, 0);
                CGContextScaleCTM(contextRef, -1, 1);
                break;
        }
        
        // 在前面画布的旋转、移动的结果上绘制自身即可，这里不用考虑旋转带来的宽高置换的问题
        [self drawInRect:CGRectMakeWithSize(self.size)];
    }];
}

- (UIImage *)tmui_imageWithBorderColor:(UIColor *)borderColor path:(UIBezierPath *)path {
    if (!borderColor) {
        return self;
    }
    
    return [UIImage tmui_imageWithSize:self.size opaque:self.tmui_opaque scale:self.scale actions:^(CGContextRef contextRef) {
        [self drawInRect:CGRectMakeWithSize(self.size)];
        CGContextSetStrokeColorWithColor(contextRef, borderColor.CGColor);
        [path stroke];
    }];
}

- (UIImage *)tmui_imageWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius {
    return [self tmui_imageWithBorderColor:borderColor borderWidth:borderWidth cornerRadius:cornerRadius dashedLengths:0];
}

- (UIImage *)tmui_imageWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius dashedLengths:(const CGFloat *)dashedLengths {
    if (!borderColor || !borderWidth) {
        return self;
    }
    
    UIBezierPath *path;
    CGRect rect = CGRectInset(CGRectMake(0, 0, self.size.width, self.size.height), borderWidth / 2, borderWidth / 2);// 调整rect，从而保证绘制描边时像素对齐
    if (cornerRadius > 0) {
        path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    } else {
        path = [UIBezierPath bezierPathWithRect:rect];
    }
    
    path.lineWidth = borderWidth;
    if (dashedLengths) {
        [path setLineDash:dashedLengths count:2 phase:0];
    }
    return [self tmui_imageWithBorderColor:borderColor path:path];
}

- (UIImage *)tmui_imageWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth borderPosition:(TMUIImageBorderPosition)borderPosition {
    if (borderPosition == TMUIImageBorderPositionAll) {
        return [self tmui_imageWithBorderColor:borderColor borderWidth:borderWidth cornerRadius:0];
    } else {
        // TODO 使用bezierPathWithRoundedRect:byRoundingCorners:cornerRadii:这个系统接口
        UIBezierPath* path = [UIBezierPath bezierPath];
        if ((TMUIImageBorderPositionBottom & borderPosition) == TMUIImageBorderPositionBottom) {
            [path moveToPoint:CGPointMake(0, self.size.height - borderWidth / 2)];
            [path addLineToPoint:CGPointMake(self.size.width, self.size.height - borderWidth / 2)];
        }
        if ((TMUIImageBorderPositionTop & borderPosition) == TMUIImageBorderPositionTop) {
            [path moveToPoint:CGPointMake(0, borderWidth / 2)];
            [path addLineToPoint:CGPointMake(self.size.width, borderWidth / 2)];
        }
        if ((TMUIImageBorderPositionLeft & borderPosition) == TMUIImageBorderPositionLeft) {
            [path moveToPoint:CGPointMake(borderWidth / 2, 0)];
            [path addLineToPoint:CGPointMake(borderWidth / 2, self.size.height)];
        }
        if ((TMUIImageBorderPositionRight & borderPosition) == TMUIImageBorderPositionRight) {
            [path moveToPoint:CGPointMake(self.size.width - borderWidth / 2, 0)];
            [path addLineToPoint:CGPointMake(self.size.width - borderWidth / 2, self.size.height)];
        }
        [path setLineWidth:borderWidth];
        [path closePath];
        return [self tmui_imageWithBorderColor:borderColor path:path];
    }
    return self;
}

- (UIImage *)tmui_imageWithMaskImage:(UIImage *)maskImage usingMaskImageMode:(BOOL)usingMaskImageMode {
    CGImageRef maskRef = [maskImage CGImage];
    CGImageRef mask;
    if (usingMaskImageMode) {
        // 用CGImageMaskCreate创建生成的 image mask。
        // 黑色部分显示，白色部分消失，透明部分显示，其他颜色会按照颜色的灰色度对图片做透明处理。
        mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                 CGImageGetHeight(maskRef),
                                 CGImageGetBitsPerComponent(maskRef),
                                 CGImageGetBitsPerPixel(maskRef),
                                 CGImageGetBytesPerRow(maskRef),
                                 CGImageGetDataProvider(maskRef), nil, YES);
    } else {
        // 用一个纯CGImage作为mask。这个image必须是单色(例如：黑白色、灰色)、没有alpha通道、不能被其他图片mask。系统的文档：If `mask' is an image, then it must be in a monochrome color space (e.g. DeviceGray, GenericGray, etc...), may not have alpha, and may not itself be masked by an image mask or a masking color.
        // 白色部分显示，黑色部分消失，透明部分消失，其他灰色度对图片做透明处理。
         mask = maskRef;
    }
    CGImageRef maskedImage = CGImageCreateWithMask(self.CGImage, mask);
    UIImage *returnImage = [UIImage imageWithCGImage:maskedImage scale:self.scale orientation:self.imageOrientation];
    if (usingMaskImageMode) {
        CGImageRelease(mask);
    }
    CGImageRelease(maskedImage);
    return returnImage;
}

+ (UIImage *)tmui_animatedImageWithData:(NSData *)data {
    return [self tmui_animatedImageWithData:data scale:1];
}

+ (UIImage *)tmui_animatedImageWithData:(NSData *)data scale:(CGFloat)scale {
    // http://www.jianshu.com/p/767af9c690a3
    // https://github.com/rs/SDWebImage
    if (!data) {
        return nil;
    }
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage = nil;
    scale = scale == 0 ? ScreenScale : scale;
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data scale:scale];
    } else {
        NSMutableArray<UIImage *> *images = [[NSMutableArray alloc] init];
        NSTimeInterval duration = 0.0f;
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            duration += [self tmui_frameDurationAtIndex:i source:source];
            UIImage *frameImage = [UIImage imageWithCGImage:image scale:scale orientation:UIImageOrientationUp];
            [images addObject:frameImage];
            CGImageRelease(image);
        }
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    CFRelease(source);
    return animatedImage;
}

+ (float)tmui_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary<NSString *, NSDictionary *> *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary<NSString *, NSNumber *> *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    } else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    CFRelease(cfFrameProperties);
    return frameDuration;
}

+ (UIImage *)tmui_animatedImageNamed:(NSString *)name {
    return [UIImage tmui_animatedImageNamed:name scale:1];
}

+ (UIImage *)tmui_animatedImageNamed:(NSString *)name scale:(CGFloat)scale {
    NSString *type = name.pathExtension.lowercaseString;
    type = type.length > 0 ? type : @"gif";
    NSString *path = [[NSBundle mainBundle] pathForResource:name.stringByDeletingPathExtension ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [UIImage tmui_animatedImageWithData:data scale:scale];
}

+ (UIImage *)tmui_imageWithStrokeColor:(UIColor *)strokeColor size:(CGSize)size path:(UIBezierPath *)path addClip:(BOOL)addClip {
    size = CGSizeFlatted(size);
    return [UIImage tmui_imageWithSize:size opaque:NO scale:0 actions:^(CGContextRef contextRef) {
        CGContextSetStrokeColorWithColor(contextRef, strokeColor.CGColor);
        if (addClip) [path addClip];
        [path stroke];
    }];
}

+ (UIImage *)tmui_imageWithStrokeColor:(UIColor *)strokeColor size:(CGSize)size lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)cornerRadius {
    CGContextInspectSize(size);
    // 往里面缩一半的lineWidth，应为stroke绘制线的时候是往两边绘制的
    // 如果cornerRadius为0的时候使用bezierPathWithRoundedRect:cornerRadius:会有问题，左上角老是会多出一点，所以区分开
    UIBezierPath *path;
    CGRect rect = CGRectInset(CGRectMakeWithSize(size), lineWidth / 2, lineWidth / 2);
    if (cornerRadius > 0) {
        path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    } else {
        path = [UIBezierPath bezierPathWithRect:rect];
    }
    [path setLineWidth:lineWidth];
    return [UIImage tmui_imageWithStrokeColor:strokeColor size:size path:path addClip:NO];
}

+ (UIImage *)tmui_imageWithStrokeColor:(UIColor *)strokeColor size:(CGSize)size lineWidth:(CGFloat)lineWidth borderPosition:(TMUIImageBorderPosition)borderPosition {
    CGContextInspectSize(size);
    if (borderPosition == TMUIImageBorderPositionAll) {
        return [UIImage tmui_imageWithStrokeColor:strokeColor size:size lineWidth:lineWidth cornerRadius:0];
    } else {
        // TODO 使用bezierPathWithRoundedRect:byRoundingCorners:cornerRadii:这个系统接口
        UIBezierPath* path = [UIBezierPath bezierPath];
        if ((TMUIImageBorderPositionBottom & borderPosition) == TMUIImageBorderPositionBottom) {
            [path moveToPoint:CGPointMake(0, size.height - lineWidth / 2)];
            [path addLineToPoint:CGPointMake(size.width, size.height - lineWidth / 2)];
        }
        if ((TMUIImageBorderPositionTop & borderPosition) == TMUIImageBorderPositionTop) {
            [path moveToPoint:CGPointMake(0, lineWidth / 2)];
            [path addLineToPoint:CGPointMake(size.width, lineWidth / 2)];
        }
        if ((TMUIImageBorderPositionLeft & borderPosition) == TMUIImageBorderPositionLeft) {
            [path moveToPoint:CGPointMake(lineWidth / 2, 0)];
            [path addLineToPoint:CGPointMake(lineWidth / 2, size.height)];
        }
        if ((TMUIImageBorderPositionRight & borderPosition) == TMUIImageBorderPositionRight) {
            [path moveToPoint:CGPointMake(size.width - lineWidth / 2, 0)];
            [path addLineToPoint:CGPointMake(size.width - lineWidth / 2, size.height)];
        }
        [path setLineWidth:lineWidth];
        [path closePath];
        return [UIImage tmui_imageWithStrokeColor:strokeColor size:size path:path addClip:NO];
    }
}

+ (UIImage *)tmui_imageWithColor:(UIColor *)color {
    return [UIImage tmui_imageWithColor:color size:CGSizeMake(4, 4) cornerRadius:0];
}

+ (UIImage *)tmui_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
    size = CGSizeFlatted(size);
    CGContextInspectSize(size);
    
    color = color ? color : UIColor.clearColor;
    BOOL opaque = (cornerRadius == 0.0 && [color tmui_alpha] == 1.0);
    UIImage *result = [UIImage tmui_imageWithSize:size opaque:opaque scale:0 actions:^(CGContextRef contextRef) {
        CGContextSetFillColorWithColor(contextRef, color.CGColor);
        
        if (cornerRadius > 0) {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMakeWithSize(size) cornerRadius:cornerRadius];
            [path addClip];
            [path fill];
        } else {
            CGContextFillRect(contextRef, CGRectMakeWithSize(size));
        }
    }];
    SEL selector = NSSelectorFromString(@"tmui_generatorSupportsDynamicColor");
    if ([NSStringFromClass(color.class) containsString:@"TMUIThemeColor"] && [UIImage respondsToSelector:selector]) {
        BOOL supports;
        [UIImage.class tmui_performSelector:selector withPrimitiveReturnValue:&supports];
        NSAssert(supports, @"UIImage (TMUI)", @"UIImage (TMUITheme) hook 尚未生效，TMUIThemeColor 生成的图片无法自动转成 TMUIThemeImage，可能导致 theme 切换时无法刷新。");
    }
    return result;
}

+ (UIImage *)tmui_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadiusArray:(NSArray<NSNumber *> *)cornerRadius {
    size = CGSizeFlatted(size);
    CGContextInspectSize(size);
    color = color ? color : [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    return [UIImage tmui_imageWithSize:size opaque:NO scale:0 actions:^(CGContextRef contextRef) {
        
        CGContextSetFillColorWithColor(contextRef, color.CGColor);
        
        UIBezierPath *path = [UIBezierPath tmui_bezierPathWithRoundedRect:CGRectMakeWithSize(size) cornerRadiusArray:cornerRadius lineWidth:0];
        [path addClip];
        [path fill];
    }];
}

+ (UIImage *)tmui_imageWithGradientColors:(NSArray<UIColor *> *)colors type:(TMUIImageGradientType)type locations:(NSArray<NSNumber *> *)locations size:(CGSize)size cornerRadiusArray:(NSArray<NSNumber *> *)cornerRadius {
    size = CGSizeFlatted(size);
    CGContextInspectSize(size);
    locations = locations ?: @[@0, @1];
    NSAssert(type != TMUIImageGradientTypeRadial || (type == TMUIImageGradientTypeRadial && locations.count == 2), @"UIImage (TMUI)", @"TMUIImageGradientTypeRadial 只能与2个 location 搭配使用，目前 locations 为 %@ 个", @(locations.count));
    return [UIImage tmui_imageWithSize:size opaque:NO scale:0 actions:^(CGContextRef  _Nonnull contextRef) {
        if (cornerRadius) {
            UIBezierPath *path = [UIBezierPath tmui_bezierPathWithRoundedRect:CGRectMakeWithSize(size) cornerRadiusArray:cornerRadius lineWidth:0];
            [path addClip];
        }
        
        // 这里不用 CAGradientLayer 来渲染，因为发现实际效果会产生一些色差，暂不清楚为什么，所以只能用 Core Graphic 渲染
        CGColorSpaceRef spaceRef = CGColorSpaceCreateDeviceRGB();
        CGFloat cLocations[locations.count];
        for (NSInteger i = 0; i < locations.count; i++) {
            cLocations[i] = locations[i].doubleValue;
        }

        CGGradientRef gradient = CGGradientCreateWithColors(spaceRef, (CFArrayRef)[colors tmui_map:^id _Nonnull(UIColor * _Nonnull item) {
            return (id)item.CGColor;
        }], cLocations);
        if (type == TMUIImageGradientTypeRadial) {
            CGFloat minSize = MIN(size.width, size.height);
            CGFloat radius = minSize / 2;
            CGFloat horizontalRatio = size.width / minSize;
            CGFloat verticalRatio = size.height / minSize;
            // 缩放是为了让渐变的圆形可以按照 size 变成椭圆的
            CGContextTranslateCTM(contextRef, -(horizontalRatio - 1) * size.width / 2, -(verticalRatio - 1) * size.height / 2);
            CGContextScaleCTM(contextRef, horizontalRatio, verticalRatio);
            CGContextDrawRadialGradient(contextRef,
                                        gradient,
                                        CGPointMake(size.width / 2, size.height / 2),
                                        0,
                                        CGPointMake(size.width / 2, size.height / 2),
                                        radius,
                                        kCGGradientDrawsBeforeStartLocation);
        } else {
            CGPoint startPoint = CGPointZero;
            CGPoint endPoint = CGPointZero;
            if (type == TMUIImageGradientTypeHorizontal) {
                startPoint = CGPointMake(0, 0);
                endPoint = CGPointMake(size.width, 0);
            } else if(type == TMUIImageGradientTypeVertical) {
                startPoint = CGPointMake(0, 0);
                endPoint = CGPointMake(0, size.height);
            }else if (type == TMUIImageGradientTypeTopLeftToBottomRight){
                startPoint = CGPointMake(0, 0);
                endPoint = CGPointMake(size.width, size.height);
            }else if (type == TMUIImageGradientTypeTopRightToBottomLeft){
                startPoint = CGPointMake(size.width, 0);
                endPoint = CGPointMake(0, size.height);
            }
            CGContextDrawLinearGradient(contextRef, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
        }
        CGColorSpaceRelease(spaceRef);
        CGGradientRelease(gradient);
    }];
}

+ (UIImage *)tmui_imageWithShape:(TMUIImageShape)shape size:(CGSize)size lineWidth:(CGFloat)lineWidth tintColor:(UIColor *)tintColor {
    size = CGSizeFlatted(size);
    CGContextInspectSize(size);
    
    tintColor = tintColor ? : [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    return [UIImage tmui_imageWithSize:size opaque:NO scale:0 actions:^(CGContextRef contextRef) {
        UIBezierPath *path = nil;
        BOOL drawByStroke = NO;
        CGFloat drawOffset = lineWidth / 2;
        switch (shape) {
            case TMUIImageShapeOval: {
                path = [UIBezierPath bezierPathWithOvalInRect:CGRectMakeWithSize(size)];
            }
                break;
            case TMUIImageShapeTriangle: {
                path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(0, size.height)];
                [path addLineToPoint:CGPointMake(size.width / 2, 0)];
                [path addLineToPoint:CGPointMake(size.width, size.height)];
                [path closePath];
            }
                break;
            case TMUIImageShapeNavBack: {
                drawByStroke = YES;
                path = [UIBezierPath bezierPath];
                path.lineWidth = lineWidth;
                [path moveToPoint:CGPointMake(size.width - drawOffset, drawOffset)];
                [path addLineToPoint:CGPointMake(0 + drawOffset, size.height / 2.0)];
                [path addLineToPoint:CGPointMake(size.width - drawOffset, size.height - drawOffset)];
            }
                break;
            case TMUIImageShapeDisclosureIndicator: {
                drawByStroke = YES;
                path = [UIBezierPath bezierPath];
                path.lineWidth = lineWidth;
                [path moveToPoint:CGPointMake(drawOffset, drawOffset)];
                [path addLineToPoint:CGPointMake(size.width - drawOffset, size.height / 2)];
                [path addLineToPoint:CGPointMake(drawOffset, size.height - drawOffset)];
            }
                break;
            case TMUIImageShapeCheckmark: {
                CGFloat lineAngle = M_PI_4;
                path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(0, size.height / 2)];
                [path addLineToPoint:CGPointMake(size.width / 3, size.height)];
                [path addLineToPoint:CGPointMake(size.width, lineWidth * sin(lineAngle))];
                [path addLineToPoint:CGPointMake(size.width - lineWidth * cos(lineAngle), 0)];
                [path addLineToPoint:CGPointMake(size.width / 3, size.height - lineWidth / sin(lineAngle))];
                [path addLineToPoint:CGPointMake(lineWidth * sin(lineAngle), size.height / 2 - lineWidth * sin(lineAngle))];
                [path closePath];
            }
                break;
            case TMUIImageShapeDetailButtonImage: {
                drawByStroke = YES;
                path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMakeWithSize(size), drawOffset, drawOffset)];
                path.lineWidth = lineWidth;
            }
                break;
            case TMUIImageShapeNavClose: {
                drawByStroke = YES;
                path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(0, 0)];
                [path addLineToPoint:CGPointMake(size.width, size.height)];
                [path closePath];
                [path moveToPoint:CGPointMake(size.width, 0)];
                [path addLineToPoint:CGPointMake(0, size.height)];
                [path closePath];
                path.lineWidth = lineWidth;
                path.lineCapStyle = kCGLineCapRound;
            }
                break;
            default:
                break;
        }
        
        if (drawByStroke) {
            CGContextSetStrokeColorWithColor(contextRef, tintColor.CGColor);
            [path stroke];
        } else {
            CGContextSetFillColorWithColor(contextRef, tintColor.CGColor);
            [path fill];
        }
        
        if (shape == TMUIImageShapeDetailButtonImage) {
            CGFloat fontPointSize = flat(size.height * 0.8);
            UIFont *font = [UIFont fontWithName:@"Georgia" size:fontPointSize];
            NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"i" attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: tintColor}];
            CGSize stringSize = [string boundingRectWithSize:size options:NSStringDrawingUsesFontLeading context:nil].size;
            [string drawAtPoint:CGPointMake(CGFloatGetCenter(size.width, stringSize.width), CGFloatGetCenter(size.height, stringSize.height))];
        }
    }];
}

+ (UIImage *)tmui_imageWithShape:(TMUIImageShape)shape size:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat lineWidth = 0;
    switch (shape) {
        case TMUIImageShapeNavBack:
            lineWidth = 2.0f;
            break;
        case TMUIImageShapeDisclosureIndicator:
            lineWidth = 1.5f;
            break;
        case TMUIImageShapeCheckmark:
            lineWidth = 1.5f;
            break;
        case TMUIImageShapeDetailButtonImage:
            lineWidth = 1.0f;
            break;
        case TMUIImageShapeNavClose:
            lineWidth = 1.2f;   // 取消icon默认的lineWidth
            break;
        default:
            break;
    }
    return [UIImage tmui_imageWithShape:shape size:size lineWidth:lineWidth tintColor:tintColor];
}

+ (UIImage *)tmui_imageWithView:(UIView *)view {
    CGContextInspectSize(view.bounds.size);
    return [UIImage tmui_imageWithSize:view.bounds.size opaque:NO scale:0 actions:^(CGContextRef contextRef) {
        [view.layer renderInContext:contextRef];
    }];
}

+ (UIImage *)tmui_imageWithView:(UIView *)view afterScreenUpdates:(BOOL)afterUpdates {
    // iOS 7 截图新方式，性能好会好一点，不过不一定适用，因为这个方法的使用条件是：界面要已经render完，否则截到得图将会是empty。
    CGContextInspectSize(view.bounds.size);
    return [UIImage tmui_imageWithSize:view.bounds.size opaque:NO scale:0 actions:^(CGContextRef contextRef) {
        [view drawViewHierarchyInRect:CGRectMakeWithSize(view.bounds.size) afterScreenUpdates:afterUpdates];
    }];
}
@end




@implementation UIBezierPath (QMUI)

+ (UIBezierPath *)tmui_bezierPathWithRoundedRect:(CGRect)rect cornerRadiusArray:(NSArray<NSNumber *> *)cornerRadius lineWidth:(CGFloat)lineWidth {
    CGFloat topLeftCornerRadius = cornerRadius[0].floatValue;
    CGFloat bottomLeftCornerRadius = cornerRadius[1].floatValue;
    CGFloat bottomRightCornerRadius = cornerRadius[2].floatValue;
    CGFloat topRightCornerRadius = cornerRadius[3].floatValue;
    CGFloat lineCenter = lineWidth / 2.0;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(topLeftCornerRadius, lineCenter)];
    [path addArcWithCenter:CGPointMake(topLeftCornerRadius, topLeftCornerRadius) radius:topLeftCornerRadius - lineCenter startAngle:M_PI * 1.5 endAngle:M_PI clockwise:NO];
    [path addLineToPoint:CGPointMake(lineCenter, CGRectGetHeight(rect) - bottomLeftCornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomLeftCornerRadius, CGRectGetHeight(rect) - bottomLeftCornerRadius) radius:bottomLeftCornerRadius - lineCenter startAngle:M_PI endAngle:M_PI * 0.5 clockwise:NO];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect) - bottomRightCornerRadius, CGRectGetHeight(rect) - lineCenter)];
    [path addArcWithCenter:CGPointMake(CGRectGetWidth(rect) - bottomRightCornerRadius, CGRectGetHeight(rect) - bottomRightCornerRadius) radius:bottomRightCornerRadius - lineCenter startAngle:M_PI * 0.5 endAngle:0.0 clockwise:NO];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect) - lineCenter, topRightCornerRadius)];
    [path addArcWithCenter:CGPointMake(CGRectGetWidth(rect) - topRightCornerRadius, topRightCornerRadius) radius:topRightCornerRadius - lineCenter startAngle:0.0 endAngle:M_PI * 1.5 clockwise:NO];
    [path closePath];
    
    return path;
}

@end
