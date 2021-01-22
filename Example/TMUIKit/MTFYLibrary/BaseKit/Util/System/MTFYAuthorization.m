//
//  MTFYCamera.m
//  Matafy
//
//  Created by Tiaotiao on 2019/7/20.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYAuthorization.h"

@implementation MTFYAuthorization

#pragma mark - 录音授权状态
+ (MTFYAuthorizationStatus)mtfy_recordAuthorization {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            return MTFYAuthorizationStatusNotDetermined;
        case AVAuthorizationStatusRestricted:
            return MTFYAuthorizationStatusRestricted;
        case AVAuthorizationStatusDenied:
            return MTFYAuthorizationStatusDenied;
        case AVAuthorizationStatusAuthorized:
            return MTFYAuthorizationStatusAuthorized;
        default:
            return MTFYAuthorizationStatusRestricted;
    }
}

/// 检查麦克风权限
+ (void)mtfy_requestRecordAuthorization:(AuthCompletionBlock)callback {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    AVAudioSessionRecordPermission permission = session.recordPermission;
    // 用户还未授权
    if (permission == AVAudioSessionRecordPermissionUndetermined) {
        // 请求麦克风权限
        [self mtfy_requestMicrophonePermission:^(BOOL granted) {
            // 同意
            if (granted) {
                [self saveCallback:callback status:MTFYAuthorizationStatusAuthorized];
            }
            // 拒绝, 弹窗提示
            else {
                [self saveCallback:callback status:MTFYAuthorizationStatusDenied];
                [self mtfy_startToOpenRecord];
            }
        }];
    }
    // 已经授权
    else if (permission == AVAudioSessionRecordPermissionGranted) {
        [self saveCallback:callback status:MTFYAuthorizationStatusAuthorized];
    }
    // 拒绝
    else if (permission == AVAudioSessionRecordPermissionDenied) {
        [self saveCallback:callback status:MTFYAuthorizationStatusDenied];
        [self mtfy_startToOpenRecord];
    }
}

/// 请求摄像头权限
+ (void)mtfy_requestCameraPermission:(PermissionCompletionBlock)completionBlock {
    if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType: completionHandler:)]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            // return to main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                if(completionBlock) {
                    completionBlock(granted);
                }
            });
        }];
    } else {
        completionBlock(YES);
    }
}

/// 请求麦克风权限
+ (void)mtfy_requestMicrophonePermission:(PermissionCompletionBlock)completionBlock {
    if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            // return to main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                if(completionBlock) {
                    completionBlock(granted);
                }
            });
        }];
    }
}

/// 弹窗提示授权麦克风
+ (void)mtfy_startToOpenRecord {
    // 请在设置-隐私-定位服务中开启定位服务
    [AlertView showWithTitle:@"需要访问您的麦克风" subtitle:@"请在设置-隐私-麦克风启用麦克风" confirm:kLStr(@"share_go_setting") cancel:kLStr(@"common_alert_cancel") confirmHandle:^{
        [self mtfy_openURL:UIApplicationOpenSettingsURLString completionHandler:nil];
    } cancelHandle:^{
        
    }];
}

#pragma mark - callback

+ (void)saveCallback:(AuthCompletionBlock)callback status:(MTFYAuthorizationStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (callback) {
            callback(status);
        }
    });
}

@end
