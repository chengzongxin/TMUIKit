//
//  MTFYShareModule.m
//  Matafy
//
//  Created by Tiaotiao on 2019/5/2.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYShareModule.h"


@implementation MTFYShareModule

/**
 微信
 */
- (void)mtfy_shareWechat:(NSString * _Nullable)text
                   image:(UIImage * _Nullable)shareImage
                     url:(NSURL * _Nullable)url
                   title:(NSString * _Nullable)title
{
    [self mtfy_shareToPlamfort:nil image:shareImage url:url title:title type:SSDKPlatformTypeWechat];
}

/**
 微信朋友圈
 */
- (void)mtfy_shareWechatTimeline:(NSString * _Nullable)text
                           image:(UIImage * _Nullable)shareImage
                             url:(NSURL * _Nullable)url
                           title:(NSString * _Nullable)title
{
    [self mtfy_shareToPlamfort:nil image:shareImage url:url title:title type:SSDKPlatformSubTypeWechatTimeline];
}

- (void)mtfy_shareToPlamfort:(NSString *)text
                       image:(UIImage *)shareImage
                         url:(NSURL *)url
                       title:(NSString *)title
                        type:(SSDKPlatformType)type
{
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text//self.shareContent
                                     images:@[shareImage]
                                        url:url//[NSURL URLWithString:url]
                                      title:title
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:type //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....
         switch (state) {
             case SSDKResponseStateSuccess: {
                 [KEY_WINDOW makeToast:kLStr(@"share_suc") duration:2.0 position:CSToastPositionCenter style:nil];
                 if (self.shareSuccessBlock) {
                     self.shareSuccessBlock();
                 }
             }
                 break;
             case SSDKResponseStateFail: {
                 [KEY_WINDOW makeToast:kLStr(@"share_failed") duration:2.0 position:CSToastPositionCenter style:nil];
                 if (self.shareFailBlock) {
                     self.shareFailBlock(error);
                 }
             }
                 break;
             default:
                 break;
         }
     }];
}

/* 保存截图到相册 */
- (void)mtfy_shareSavedPhotoAlbum:(UIImage *_Nullable)image {
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
        
        [alertController addAction:([UIAlertAction actionWithTitle:kLStr(@"share_go_setting") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }])];
        [[MTFYBaseTool mtfy_fetchCurrentVC] presentViewController:alertController animated:YES completion:nil];
    } else if (status == PHAuthorizationStatusAuthorized) {
        // 用户允许访问相册 放一些使用相册的代码
        // 保存图片到照片库 （iOS10 以上记得在info.plist添加相册访问权限，否则可能崩溃）
        UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);
        [UIWindow showTips:kLStr(@"common_save_suc")];
        if (self.shareSuccessBlock) {
            self.shareSuccessBlock();
        }
    } else if (status == PHAuthorizationStatusNotDetermined) {
        // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                // 放一些使用相册的代码
                // 保存图片到照片库 （iOS10 以上记得在info.plist添加相册访问权限，否则可能崩溃）
                UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);
                if (self.shareSuccessBlock) {
                    self.shareSuccessBlock();
                }
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
