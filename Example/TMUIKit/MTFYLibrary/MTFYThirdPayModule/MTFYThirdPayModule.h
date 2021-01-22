//
//  MTFYThirdPayModule.h
//  Matafy
//
//  Created by Tiaotiao on 2019/4/25.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

#define kMTFYThirdPayModule [MTFYThirdPayModule shareInstance]
#define WechatPayResult @"wechatPayResult"
#define AliPayResult  @"aliPayResult"
#define PayResult @"PayResult"
#define AggregatePayResult @"AggregatePayResult"

typedef NS_ENUM(NSUInteger, PayType) {
    PayTypeClear = 0,                      // 清闲状态
    PayTypePredict,                        // 预支付
    PayTypeWaitPredict,                    // 待预支付
    PayTypeEnd                             // 结束支付
};

NS_ASSUME_NONNULL_BEGIN

@interface MTFYThirdPayModule : NSObject


+ (instancetype)shareInstance;

@property (nonatomic, assign, readonly) PayType payType;


/**
 微信支付

 @param obj 支付参数dic
 @param payType 支付来源类型
 */
- (void)mtfy_ThirdPayWechat:(NSDictionary *)obj
                       type:(PayType)payType;
/**
 支付宝支付

 @param orderStr 支付参数Dic
 @param payType 支付来源类型
 */
- (void)mtfy_ThirdPayAli:(NSString *)orderStr type:(PayType)payType;

/**
 聚合支付

 @param orderStr 支付参数dic
 @param payType 支付来源类型
 */
- (void)mtfy_ThirdPayAggregate:(NSString *)orderStr type:(PayType)payType;

@end

NS_ASSUME_NONNULL_END
