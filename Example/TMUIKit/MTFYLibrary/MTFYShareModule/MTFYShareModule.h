//
//  MTFYShareModule.h
//  Matafy
//
//  Created by Tiaotiao on 2019/5/2.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <MessageUI/MessageUI.h>
#import <Photos/Photos.h>

typedef void(^MTFYShareSuccessBlock)(void);
typedef void(^MTFYShareFailBlock)(NSError * _Nullable error);

// 使用者先自己创造实例  先不单例化
@interface MTFYShareModule : NSObject

@property (nonatomic, nullable, copy) MTFYShareSuccessBlock shareSuccessBlock;

@property (nonatomic, nullable, copy) MTFYShareFailBlock shareFailBlock;

- (void)mtfy_shareWechat:(NSString * _Nullable)text
                   image:(UIImage * _Nullable)shareImage
                     url:(NSURL * _Nullable)url
                   title:(NSString * _Nullable)title;

- (void)mtfy_shareWechatTimeline:(NSString * _Nullable)text
                           image:(UIImage * _Nullable)shareImage
                             url:(NSURL * _Nullable)url
                           title:(NSString * _Nullable)title;

- (void)mtfy_shareSavedPhotoAlbum:(UIImage *_Nullable)image;

@end
