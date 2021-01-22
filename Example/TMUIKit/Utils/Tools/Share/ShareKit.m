//
//  ShareKit.m
//  Matafy
//
//  Created by Joe on 2019/5/28.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "ShareKit.h"

@implementation ShareKit

+ (void)shareImageToPlatform:(SSDKPlatformType)platform
                       image:(id)image
                     success:(void (^)(void))success
                        fail:(void (^)(void))fail{
    [self shareToPlatform:platform
                  content:nil
                    image:image
                      url:nil
                    title:nil
                  success:success
                     fail:fail];
}

//MARK: 分享到各大平台

+ (void)shareToPlatform:(SSDKPlatformType)platform
                content:(nullable NSString *)content
                  image:(id)image
                    url:(nullable NSString *)url
                  title:(nullable NSString *)title
                success:(nullable void (^)(void))success
                   fail:(nullable void (^)(void))fail{
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:content
                                     images:@[image?:@""]
                                        url:[NSURL URLWithString:url]
                                      title:title
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:platform //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 if (success) {
                     success();
                 }
                 [KEY_WINDOW makeToast:kLStr(@"share_complete") duration:2 position:CSToastPositionCenter];
             }
                 break;
             case SSDKResponseStateFail:
             {
                 if (fail) {
                     fail();
                 }
                 [KEY_WINDOW makeToast:kLStr(@"share_complete") duration:2 position:CSToastPositionCenter];
             }
                 break;
             default:
                 break;
         }
     }];
}


//MARK: H5分享微信小程序
+ (void)shareWeixinMiniProgram:(NSString *)title
                         image:(id)image
                       pathUrl:(NSString *)pathUrl
                   webPageuUrl:(NSString *)webPageUrl
                       success:(void (^)(void))success
                          fail:(void (^)(void))fail{
    
    if (![WXApi isWXAppInstalled]) {
        [KEY_WINDOW makeToast:kLStr(@"share_wx_no_install") duration:2 position:CSToastPositionCenter];
        return;
    }

    NSString *titleToShare = title;
    if (!NULLString([User sharedInstance].username)){
        [titleToShare stringByReplacingOccurrencesOfString:@"我" withString:[User sharedInstance].username];
    }

    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    [shareParams SSDKSetupWeChatMiniProgramShareParamsByTitle:title
//                                                  description:@"我发现了一个很厉害的旅行预订小程序"
//                                                   webpageUrl:[NSURL URLWithString:webPageUrl]
//                                                         path:pathUrl
//                                                   thumbImage:image
//                                                 hdThumbImage:image
//                                                     userName:WX_MINI_APP_ID
//                                              withShareTicket:YES
//                                              miniProgramType:WX_MINI_PROGRAM_TYPE
//                                           forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    [shareParams SSDKSetupWeChatMiniProgramShareParamsByTitle:title
                                                  description:nil
                                                   webpageUrl:[NSURL URLWithString:webPageUrl]
                                                         path:pathUrl
                                                   thumbImage:image
                                                     userName:WX_MINI_APP_ID
                                              withShareTicket:YES
                                              miniProgramType:WX_MINI_PROGRAM_TYPE
                                           forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    //进行分享
    [ShareSDK share:SSDKPlatformSubTypeWechatSession //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 if (success) {
                     success();
                 }
                 [KEY_WINDOW makeToast:kLStr(@"share_complete") duration:2 position:CSToastPositionCenter];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 if (fail) {
                     fail();
                 }
                 [KEY_WINDOW makeToast:kLStr(@"share_complete") duration:2 position:CSToastPositionCenter];
                 break;
             }
             default:
                 break;
         }
     }];
}


/* 保存截图到相册 */
+ (void)savedPhotoAlbum:(UIImage *)image{
    CGImageRef imageRef = image.CGImage;
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRef];

    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    // 此应用程序没有被授权访问的照片数据。可能是家长控制权限。
    if (status == PHAuthorizationStatusRestricted) {
        //NSLog(@"因为系统原因, 无法访问相册");
    } else if (status == PHAuthorizationStatusDenied) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kLStr(@"common_warming") message:kLStr(@"share_go_setting_privacy_photos_turn_on_access") preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:([UIAlertAction actionWithTitle:kLStr(@"common_alert_cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }])];
        
        [alertController addAction:([UIAlertAction actionWithTitle:kLStr(@"share_go_setting")  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
              NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        ])];
        [[self currentVC] presentViewController:alertController animated:YES completion:nil];
    } else if (status == PHAuthorizationStatusAuthorized) {
        // 用户允许访问相册 放一些使用相册的代码
        // 保存图片到照片库 （iOS10 以上记得在info.plist添加相册访问权限，否则可能崩溃）
        UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);
        [UIWindow showTips:kLStr(@"common_save_suc")];
    } else if (status == PHAuthorizationStatusNotDetermined) {
        // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                // 放一些使用相册的代码
                // 保存图片到照片库 （iOS10 以上记得在info.plist添加相册访问权限，否则可能崩溃）
                UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);
                // 上面是异步回调
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIWindow showTips:kLStr(@"common_save_suc")];
                });
            }
        }];
    }
}

//保存到相册的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //    if (error != NULL) {
    //        [self.chatCellDelegate showToastViewInCell:self toastText:[MQBundleUtil localizedStringForKey:@"save_photo_error"]];
    //    } else {
    //        [self.chatCellDelegate showToastViewInCell:self toastText:[MQBundleUtil localizedStringForKey:@"save_photo_success"]];
    //    }
}


@end
