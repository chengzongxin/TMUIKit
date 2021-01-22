//
//  WebViewViewModel.h
//  Matafy
//
//  Created by Fussa on 2019/6/4.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WKWebViewJavascriptBridge;

NS_ASSUME_NONNULL_BEGIN

/**
 分享活动类型
 */
typedef NS_ENUM(NSUInteger, WebViewShareActivityType) {
    WebViewShareActivityTypeDefault               = 0, ///< 默认
    WebViewShareActivityTypeUserRedPacket         = 1, ///< 助力红包分享
    WebViewShareActivityTypePriceContest          = 2  ///< 比码大赛
};

@interface WebViewViewModel : NSObject

/**
 生成导航栏右键按钮
 
 @param data H5传的数据
 @param centerY 按钮的Y轴中心参照点
 @return 生成的按钮数组
 */
+ (NSArray<UIButton *> *)createRightItemButtonFrom:(nullable id)data superView:(UIView *)superView referenceCenterY:(MASViewAttribute *)centerY;

//Encoding :
+ (NSString *)encodeToBase64String:(UIImage *)image;

//Decoding :
+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;


#pragma mark - iOS调用OC方法
/// 从H5获取分享配置数据
+ (void)getShareData:(WKWebViewJavascriptBridge *)bridge
                          type:(WebViewShareActivityType)shareType
                       success:(void (^)(WebViewShareActivityType type, NSDictionary *dict))success;

/// 传分享界面埋点数据给h5
+ (void)setShareActionDataWithBridge:(WKWebViewJavascriptBridge *)bridge
                                type:(WebViewShareActivityType)shareType
                               index:(NSInteger)index
                    responseCallback:(void (^)(id responseData))responseCallback;

#pragma mark - 屏幕旋转相关
/// 处理屏幕旋转
+ (void)handleDeviceOrientationDidChange;

+ (void)endFullScreen;
@end

NS_ASSUME_NONNULL_END
