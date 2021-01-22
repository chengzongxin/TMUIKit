//
//  WebViewViewModel.m
//  Matafy
//
//  Created by Fussa on 2019/6/4.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "WebViewViewModel.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "UIImage+Circle.h"
#import "WKWebViewJavascriptBridge.h"
#import <AssetsLibrary/AssetsLibrary.h>

static const NSTimeInterval kOrientationAnimationDuration = 0.25;


@implementation WebViewViewModel

/* 保存截图到相册 */
+ (void)savedPhotosAlbum:(UIImage *)snapShotImage {

    CGImageRef imageRef = snapShotImage.CGImage;
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRef];
    NSLog(@"sendImage==%@",sendImage);
    //保存图片到照片库 （iOS10 以上记得在info.plist添加相册访问权限，否则可能崩溃）
    UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);
    [UIWindow showTips:kLStr(@"common_save_suc")];
}


+ (NSArray<UIButton *> *)createRightItemButtonFrom:(id)data superView:(nonnull UIView *)superView referenceCenterY:(nonnull MASViewAttribute *)centerY {
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *buttonArray = [NSMutableArray array];
    
    if ([data isKindOfClass:[NSDictionary class]]) {
        [array addObject:data];
    } else if ([data isKindOfClass:[NSArray class]]) {
        array = [NSMutableArray arrayWithArray:data];
    } else {
        return buttonArray;
    }
    
    for (NSDictionary *dict in array) {
        // 类型: 0图片 1纯文字
        NSInteger type = [dict[@"type"] integerValue];
        // 图片地址url
        NSString *imageURL = dict[@"image"];
        // 按钮标题
        NSString *title = dict[@"title"];
        // 标题文字
        NSString *color = dict[@"color"];
        // 图标大小(不再支持)

        // 字体名称
        NSString *fontName = dict[@"fontName"];
        // 字体大小
        NSInteger fontSize = [dict[@"fontSize"] integerValue];
        // 标识
        NSInteger btnIndex = [dict[@"index"] integerValue];
        
        fontSize = fontSize == 0 ? 14 : fontSize;
        color = NULLString(color) ? @"#000000" : color;
        NSInteger index = [array indexOfObject:dict];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        // 0图片 1文字
        if (type == 0) {
            [button sd_setImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal placeholderImage: nil];
        } else {
            [button setTitle:title forState:UIControlStateNormal];
        }
        if (NULLString(fontName)) {
            button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        } else {
            button.titleLabel.font = [UIFont fontWithName:fontName size:fontSize];
        }
        [button setTitleColor:[UIColor colorWithHexString:color] forState:UIControlStateNormal];
        
        [buttonArray addObject:button];
        [superView addSubview:button];
        
        [button setEnlargeEdgeWithTop:10 right:20 bottom:10 left:20];
        [button sizeToFit];
        // 根据index标识配置Button的tag
        button.tag = btnIndex;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(centerY).offset(0);
            if (index == 0) {
                make.right.inset(15);
            } else {
                make.right.mas_equalTo(((UIButton *)(buttonArray[index - 1])).mas_left).inset(15);
            }
            if (type == 0) {
                make.size.mas_equalTo(CGSizeMake(25, 25));
            }
        }];
    }
    return buttonArray;
}

//Encoding :
+ (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

//Decoding :
+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}


#pragma mark - iOS调用OC方法
/// 获取分享数据
+ (void)getShareData:(WKWebViewJavascriptBridge *)bridge type:(WebViewShareActivityType)shareType success:(void (^)(WebViewShareActivityType, NSDictionary * _Nonnull))success {
    NSDictionary *param = @{
                             @"type": @(shareType),
                             };
    [bridge callHandler:@"getShareData" data:param responseCallback:^(id responseData) {
        if (success) {
            success(shareType, [NSDictionary dictionaryWithJsonString:responseData]);
        }
    }];
}

/// 给前端传递分享埋点数据
+ (void)setShareActionDataWithBridge:(WKWebViewJavascriptBridge *)bridge type:(WebViewShareActivityType)shareType index:(NSInteger)index responseCallback:(void (^)(id _Nonnull))responseCallback {
    NSDictionary *param = @{
                            @"type": @(shareType),
                            @"index": @(index)
                            };
    [bridge callHandler:@"setShareActionData" data:param responseCallback:^(id responseData) {
        if (responseCallback) {
            responseCallback(responseData);
        }
    }];
}

#pragma mark - 屏幕旋转相关

+ (void)handleDeviceOrientationDidChange {
    UIDevice *device = [UIDevice currentDevice];
    switch (device.orientation) {
        case UIDeviceOrientationFaceUp:
            [self endFullScreen];
            NSLog(@"屏幕朝上平躺");
            break;
            
        case UIDeviceOrientationFaceDown:
            [self endFullScreen];
            NSLog(@"屏幕朝下平躺");
            break;
            
        case UIDeviceOrientationUnknown:
            [self endFullScreen];
            NSLog(@"未知方向");
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            [self startFullScreenRight];
            NSLog(@"屏幕向左横置");
            break;
            
        case UIDeviceOrientationLandscapeRight:
            [self startFullScreenLeft];
            NSLog(@"屏幕向右橫置");
            break;
            
        case UIDeviceOrientationPortrait:
            [self endFullScreen];
            NSLog(@"屏幕直立");
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            [self endFullScreenUpsideDown];
            NSLog(@"屏幕直立，上下顛倒");
            break;
            
        default:
            [self endFullScreen];
            NSLog(@"无法辨识");
            break;
    }
}


+ (void)startFullScreenRight {
    UIApplication *application = [UIApplication sharedApplication];
    [application setStatusBarOrientation: UIInterfaceOrientationLandscapeRight];
    [UIView animateWithDuration:kOrientationAnimationDuration animations:^{
        application.keyWindow.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }];
    application.keyWindow.bounds = CGRectMake(0, 0, kMTFYScreenW, kMTFYScreenH);
}

+ (void)startFullScreenLeft {
    UIApplication *application = [UIApplication sharedApplication];
    [application setStatusBarOrientation: UIInterfaceOrientationLandscapeRight];
    [UIView animateWithDuration:kOrientationAnimationDuration animations:^{
        application.keyWindow.transform = CGAffineTransformMakeRotation(3 * M_PI / 2);
    }];
    application.keyWindow.bounds = CGRectMake(0, 0, kMTFYScreenW, kMTFYScreenH);
}

+ (void)endFullScreen {
    UIApplication *application=[UIApplication sharedApplication];
    [application setStatusBarOrientation: UIInterfaceOrientationPortrait];
    application.keyWindow.bounds = CGRectMake(0, 0, kMTFYScreenW, kMTFYScreenH);
    [UIView animateWithDuration:kOrientationAnimationDuration animations:^{
        application.keyWindow.transform = CGAffineTransformMakeRotation(M_PI * 2);
    }];
    [application setStatusBarHidden:NO];
}

+ (void)endFullScreenUpsideDown {
    UIApplication *application=[UIApplication sharedApplication];
    [application setStatusBarOrientation: UIInterfaceOrientationPortrait];
    application.keyWindow.bounds = CGRectMake(0, 0, kMTFYScreenW, kMTFYScreenH);
    [UIView animateWithDuration:kOrientationAnimationDuration animations:^{
        application.keyWindow.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    [application setStatusBarHidden:NO];
}

@end
