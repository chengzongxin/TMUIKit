//
//  MTFYAuthorization.h
//  Matafy
//
//  Created by Tiaotiao on 2019/7/20.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MTFYAuthorizationStatus) {
    MTFYAuthorizationStatusAuthorized = 0,      /// 用户已授权
    MTFYAuthorizationStatusDenied,              /// 拒绝
    MTFYAuthorizationStatusRestricted,          /// 应用没有相关权限，且当前用户无法改变这个权限，如家长控制
    MTFYAuthorizationStatusNotSupport,          /// 硬件等不支持
    MTFYAuthorizationStatusNotDetermined,       /// 用户还没有对应用程序授权进行操作
    
};

typedef NS_ENUM(NSUInteger, LMMediaType) {
    LMMediaTypeAlbum = 0,                       /// 相册
    LMMediaTypeCamera,                          /// 相机
    LMMediaTypeAddressBook                      /// 通讯录
};

typedef void(^AuthCompletionBlock)(MTFYAuthorizationStatus status);
typedef void(^PermissionCompletionBlock)(BOOL granted);

@interface MTFYAuthorization : NSObject

+ (MTFYAuthorizationStatus)mtfy_recordAuthorization;
+ (void)mtfy_requestRecordAuthorization:(AuthCompletionBlock)callback;
+ (void)mtfy_requestCameraPermission:(PermissionCompletionBlock)completionBlock;
+ (void)mtfy_requestMicrophonePermission:(PermissionCompletionBlock)completionBlock;
+ (void)mtfy_startToOpenRecord;


@end

NS_ASSUME_NONNULL_END
