//
//  ShareKit.h
//  Matafy
//
//  Created by Joe on 2019/5/28.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareKit : NSObject

/**
 分享到各大平台 (分享大图)
 
 @param platform 平台类型
 @param image 图像
 */
+ (void)shareImageToPlatform:(SSDKPlatformType)platform
                       image:(id)image
                     success:(nullable void (^)(void))success
                        fail:(nullable void (^)(void))fail;

/**
 分享到各大平台

 @param platform 平台类型
 @param title 标题
 @param content 内容
 @param image 图像
 @param url 链接
 */
+ (void)shareToPlatform:(SSDKPlatformType)platform
                content:(nullable NSString *)content
                  image:(id)image
                    url:(nullable NSString *)url
                  title:(nullable NSString *)title
                success:(nullable void (^)(void))success
                   fail:(nullable void (^)(void))fail;


/**
 分享小程序
 @param title 标题
 @param image 缩略图
 @param pathUrl 跳转到页面路径
 @param webPageUrl 网页地址
 */
+ (void)shareWeixinMiniProgram:(NSString *)title
                         image:(id)image
                       pathUrl:(NSString *)pathUrl
                   webPageuUrl:(NSString *)webPageUrl
                       success:(void (^)(void))success
                          fail:(void (^)(void))fail;

/* 保存截图到相册 */
+ (void)savedPhotoAlbum:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
