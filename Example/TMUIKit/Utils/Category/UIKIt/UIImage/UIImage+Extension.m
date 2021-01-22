//
//  UIImage+Extension.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "UIImage+Extension.h"
#import "UIView+Snapshot.h"
#import "UIImage+PLSClip.h"

@implementation UIImage (Extension)
- (UIImage *)drawRoundedRectImage:(CGFloat)cornerRadius width:(CGFloat)width height:(CGFloat)height {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 1.0f);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, height) cornerRadius:cornerRadius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    [self drawInRect:CGRectMake(0, 0, width, height)];
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}

- (UIImage *)drawCircleImage {
    CGFloat side = MIN(self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(side, side), NO, 1.0f);
    CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), YES);
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, side, side)].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    CGFloat originX = -(self.size.width - side) / 2.f;
    CGFloat originY = -(self.size.height - side) / 2.f;
    [self drawInRect:CGRectMake(originX, originY, self.size.width, self.size.height)];
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}


- (UIImage *)addSlaveImage:(UIImage *)slaveImage toMasterImage:(UIImage *)masterImage {
    CGSize size;
    size.width = masterImage.size.width;
    size.height = masterImage.size.height + slaveImage.size.height;
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    
    [UIColor.whiteColor setFill];
    
    //Draw masterImage
    [masterImage drawInRect:CGRectMake(0, 0, masterImage.size.width, masterImage.size.height)];
    
    //Draw slaveImage
    [slaveImage drawInRect:CGRectMake((masterImage.size.width - slaveImage.size.width)/2, masterImage.size.height, slaveImage.size.width, slaveImage.size.height)];
    
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resultImage;
}

- (UIImage *)combineLongWebImage:(UIImage *)qrImage bottomText:(NSString *)string title:(NSString *)title {
    UIImage *resultImage = nil;
    CGFloat topMargin = 30.0;
    CGFloat titleHeight = 0.0;
    UILabel *titleLbl;
    
    CGFloat w = self.size.width;
    // 网页主体图片的高度
    CGFloat webImageH = self.size.height;
    
    UIFont *textFont = [UIFont systemFontOfSize:15];
    CGFloat titelFontSize = 15;
    
    if (title.length > 0) {
        titleHeight = 64;
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, titleHeight)];
        titleLbl.text = title;
        titleLbl.textColor = UIColor.whiteColor;
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.numberOfLines = 0;
        titleLbl.backgroundColor = HEXCOLOR(0x00C3CE);
        // 跟标题字体一样
        titleLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:kAspectRatio(titelFontSize)];
    }
    
    CGFloat textHeight = 64;
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  w, textHeight)];
    textLabel.text = string;
    textLabel.textColor = UIColor.blackColor;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.numberOfLines = 0;
    textLabel.backgroundColor = UIColor.yellowColor;
    textLabel.font = textFont;
    
    // 二维码宽高
    CGFloat slaveImageW = qrImage.size.width > 120 ? 120 : qrImage.size.width;
    CGFloat slaveImageH = slaveImageW * (qrImage.size.height / qrImage.size.width);
    
    CGSize size;
    size.width = w;
    size.height = titleHeight + webImageH + topMargin + slaveImageH + textHeight;
    
    // 给高度多点
    UIView *slaveBgImgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, webImageH)];
    slaveBgImgView.backgroundColor = UIColor.whiteColor;
    
    UIImage *slaveBgImg = slaveBgImgView.snapshotImage;
    // 过度蒙层
    UIImage *slaveCoverImg = [UIImage imageNamed:@"snap_bottom_cover_bg"];
    UIImage *titleImg = titleLbl.snapshotImage;
    
    @autoreleasepool {
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor.whiteColor CGColor]);
        
        if (titleImg) {
            //Draw title
            [titleImg drawInRect:CGRectMake(0, 0, w, titleHeight)];
        }
        
        //Draw masterImage
        [self drawInRect:CGRectMake(0, titleHeight, w, webImageH)];
        
        //Draw slaveImage
        [slaveBgImg drawInRect:CGRectMake(0, titleHeight + webImageH, w, topMargin + slaveImageH + textHeight)];
        [slaveCoverImg drawInRect:CGRectMake(0, titleHeight + webImageH - 40, w, 40)];
        
        [qrImage drawInRect:CGRectMake((self.size.width - slaveImageW)/2, titleHeight + webImageH + topMargin, slaveImageW, slaveImageH)];
        
        //Draw text
        [textLabel drawTextInRect:CGRectMake(0, titleHeight + webImageH + topMargin + slaveImageH, w, textHeight)];
        
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    return resultImage;
}

+ (UIImage *)scaleImage:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 1);
    
    if (data.length < 3 *(1024*1024)) {
        return image;
    }
    
    NSData *d = UIImageJPEGRepresentation(image, 0.5);
    
    return [UIImage imageWithData:d];
}

- (UIImage *)compressImage:(UIImage*)sourceImage toTargetWidth:(CGFloat)targetWidth {
    if (sourceImage.size.width < targetWidth) return self;
    
    UIImage *newImage;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetHeight = (targetWidth / width) * height;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetWidth, targetHeight), YES, 0);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor.whiteColor CGColor]);
    [sourceImage drawInRect:CGRectMake(0,0, targetWidth, targetHeight)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)cutImage:(CGFloat)maxTargetHeight {
    if (self.size.height <= maxTargetHeight) return self;
    
    UIImage *resultImage = self;
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGRect maxRect = CGRectMake(0, 0, self.size.width * scale , maxTargetHeight * scale);
    CGImageRef imageRef = self.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, maxRect);
    UIGraphicsBeginImageContextWithOptions(self.size, YES, 0);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), maxRect, subImageRef);
    resultImage = [UIImage imageWithCGImage:subImageRef];
    
    UIGraphicsEndImageContext();
    
    // 再尝试缩小些
    resultImage = [self compressImage:resultImage toTargetWidth:kScreenWidth];
    
    return resultImage;
}


#pragma mark 屏幕截图
/**
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
+ (UIImage *)imageWithScreenshot
{
    NSData *imageData = [self dataWithScreenshotInPNGFormat:CGSizeZero];
    return [UIImage imageWithData:imageData];
}

+ (UIImage *)imageWithScreenshot:(CGRect)rect{
    NSData *imageData = [self dataWithScreenshotInPNGFormat:rect.size];
    return [UIImage imageWithData:imageData];
//    UIImage *image = [self imageWithScreenshot];
//    UIImageView *imgV = [[UIImageView alloc] initWithImage:image];
//    return [self imageFromView:imgV rect:rect];
}

//获得屏幕图像
+ (UIImage *)imageFromView: (UIView *) theView
{
    
    //    UIGraphicsBeginImageContext(theView.frame.size);
    UIGraphicsBeginImageContextWithOptions(theView.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage*)imageFromView:(UIView *)view rect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGRect myImageRect = rect;
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef,myImageRect );
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return smallImage;
}
/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
+ (NSData *)dataWithScreenshotInPNGFormat:(CGSize)size
{
    
    CGSize imageSize = size;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (size.width * size.height == 0) {
        if (UIInterfaceOrientationIsPortrait(orientation))
            imageSize = [UIScreen mainScreen].bounds.size;
        else
            imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

- (UIImage*)imageWithCornerRadius:(CGFloat)radius{
    UIImage *image = self;
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    const CGRect RECT = CGRectMake(0, 0, image.size.width, image.size.height);
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:RECT cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:RECT];
    
    // Get the image, here setting the UIImageView image
    //imageView.image
    UIImage* imageNew = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return imageNew;
//
//    // 利用绘图建立上下文
//    UIGraphicsBeginImageContextWithOptions(self.size, true, 0);
//    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
//    // 填充颜色
//    [UIColor.whiteColor setFill];
//    UIRectFill(rect);
//    // 贝塞尔裁切
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
//    [path addClip];
//    [self drawInRect:rect];
//
//    // 获取结果
//    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
//    // 关闭上下文
//    UIGraphicsEndImageContext();
//
//    return resultImage;
}



+ (UIImage *)combineImageUpImage:(UIImage *)upImage  DownImage:(UIImage *)downImage{
    
    UIImage * image1 = upImage;
    UIImage * image2 = downImage;
    
    if (image1 == nil) {
        return image2;
    }
    CGFloat width = image2.size.width;
    CGFloat height = image1.size.height  + image2.size.height;
    CGSize offScreenSize = CGSizeMake(width, height);
    // UIGraphicsBeginImageContext(offScreenSize);用这个重绘图片会模糊
    UIGraphicsBeginImageContextWithOptions(offScreenSize, NO, [UIScreen mainScreen].scale);
    
    CGRect rectUp = CGRectMake(0, 0, image1.size.width, image1.size.height);
    [image1 drawInRect:rectUp];
    
    CGRect rectDown = CGRectMake((width - image2.size.width)/2, rectUp.origin.y + rectUp.size.height, image2.size.width, image2.size.height);
    [image2 drawInRect:rectDown];
    
    UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imagez;
}

+ (UIImage *)mtfy_imageResize:(UIImage*)img andResizeTo:(CGSize)newSize {
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)mtfy_imageWithColor:(UIColor *)color {
    return [self yy_imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)mtfy_imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)mtfy_imageWithColor:(UIColor *)color title:(NSString *)title attributes:(NSDictionary *)attributes size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);

    if (title) {
        CGSize textSize = [title boundingRectWithSize:rect.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        CGFloat width = rect.size.width;
        CGFloat height = rect.size.height;
        CGRect textRect = CGRectMake((width-textSize.width)/2, (height-textSize.height)/2, textSize.width, textSize.height);
        [title drawInRect:textRect withAttributes:attributes];
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




#pragma mark - 图片压缩
// 单位为KB
+ (NSData *)resetSizeOfImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize {
    //先判断当前质量是否满足要求，不满足再进行压缩
    __block NSData *finallImageData = UIImageJPEGRepresentation(sourceImage,1.0);
    NSUInteger sizeOrigin   = finallImageData.length;
    NSUInteger sizeOriginKB = sizeOrigin / 1000;
    
    if (sizeOriginKB <= maxSize) {
        return finallImageData;
    }
    
    //获取原图片宽高比
    CGFloat sourceImageAspectRatio = sourceImage.size.width/sourceImage.size.height;
    //先调整分辨率
    CGSize defaultSize = CGSizeMake(1024, 1024/sourceImageAspectRatio);
    UIImage *newImage = [self newSizeImage:defaultSize image:sourceImage];
    
    finallImageData = UIImageJPEGRepresentation(newImage,1.0);
    
    //保存压缩系数
    NSMutableArray *compressionQualityArr = [NSMutableArray array];
    CGFloat avg   = 1.0/250;
    CGFloat value = avg;
    for (int i = 250; i >= 1; i--) {
        value = i*avg;
        [compressionQualityArr addObject:@(value)];
    }
    
    /*
     调整大小
     说明：压缩系数数组compressionQualityArr是从大到小存储。
     */
    //思路：使用二分法搜索
    finallImageData = [self halfFuntion:compressionQualityArr image:newImage sourceData:finallImageData maxSize:maxSize];
    //如果还是未能压缩到指定大小，则进行降分辨率
    while (finallImageData.length == 0) {
        //每次降100分辨率
        CGFloat reduceWidth = 100.0;
        CGFloat reduceHeight = 100.0/sourceImageAspectRatio;
        if (defaultSize.width-reduceWidth <= 0 || defaultSize.height-reduceHeight <= 0) {
            break;
        }
        defaultSize = CGSizeMake(defaultSize.width-reduceWidth, defaultSize.height-reduceHeight);
        UIImage *image = [self newSizeImage:defaultSize
                                      image:[UIImage imageWithData:UIImageJPEGRepresentation(newImage,[[compressionQualityArr lastObject] floatValue])]];
        finallImageData = [self halfFuntion:compressionQualityArr image:image sourceData:UIImageJPEGRepresentation(image,1.0) maxSize:maxSize];
    }
    return finallImageData;
}
#pragma mark 调整图片分辨率/尺寸（等比例缩放）
+ (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)sourceImage {
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth = newSize.width / size.width;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    } else if (tempHeight > 1.0 && tempWidth < tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark 二分法
+ (NSData *)halfFuntion:(NSArray *)arr image:(UIImage *)image sourceData:(NSData *)finallImageData maxSize:(NSInteger)maxSize {
    NSData *tempData = [NSData data];
    NSUInteger start = 0;
    NSUInteger end = arr.count - 1;
    NSUInteger index = 0;
    
    NSUInteger difference = NSIntegerMax;
    while(start <= end) {
        index = start + (end - start)/2;
        
        finallImageData = UIImageJPEGRepresentation(image,[arr[index] floatValue]);
        
        NSUInteger sizeOrigin = finallImageData.length;
        NSUInteger sizeOriginKB = sizeOrigin / 1024;
        NSLog(@"当前降到的质量：%ld", (unsigned long)sizeOriginKB);
        NSLog(@"\nstart：%zd\nend：%zd\nindex：%zd\n压缩系数：%lf", start, end, (unsigned long)index, [arr[index] floatValue]);
        
        if (sizeOriginKB > maxSize) {
            start = index + 1;
        } else if (sizeOriginKB < maxSize) {
            if (maxSize-sizeOriginKB < difference) {
                difference = maxSize-sizeOriginKB;
                tempData = finallImageData;
            }
            if (index<=0) {
                break;
            }
            end = index - 1;
        } else {
            break;
        }
    }
    return tempData;
}

@end

