//
//  MTFYThirdPayModule.m
//  Matafy
//
//  Created by Tiaotiao on 2019/4/25.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYThirdPayModule.h"

@interface MTFYThirdPayModule ()

// 当前支付的操作类型 目前还没有很频繁的调用 都是按顺序来 所以先不加队列
@property (nonatomic, assign, readwrite) PayType payType;

@end


@implementation MTFYThirdPayModule

static MTFYThirdPayModule  *thirdPayShareInstance = nil;
static dispatch_once_t MTFYThirdPay_onceToken;

+ (instancetype)shareInstance {
    dispatch_once(&MTFYThirdPay_onceToken, ^{
        thirdPayShareInstance = [[MTFYThirdPayModule alloc] init];
    });
    return thirdPayShareInstance;
}

#pragma mark 微信支付

- (void)mtfy_ThirdPayWechat:(NSDictionary *)obj
                       type:(PayType)payType
{
    self.payType = payType;
    
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [obj objectForKey:@"partnerid"];
    request.prepayId= [obj objectForKey:@"prepayid"];
    request.package = @"Sign=WXPay";
    request.nonceStr= [obj objectForKey:@"noncestr"];
    NSString *timeString = [obj objectForKey:@"timestamp"];
    int time = [timeString intValue];
    request.timeStamp= (UInt32) time;
    request.sign= [obj objectForKey:@"sign"];
    [WXApi sendReq:request];
}

#pragma mark 支付宝支付

- (void)mtfy_ThirdPayAli:(NSString *)orderStr
                    type:(PayType)payType
{
    self.payType = payType;

    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"aliPayGo" callback:^(NSDictionary *resultDic) {
        [[NSNotificationCenter defaultCenter] postNotificationName:AliPayResult object:resultDic];
    }];
}

#pragma mark 聚合支付
- (void)mtfy_ThirdPayAggregate:(NSString *)orderStr type:(PayType)payType {
    self.payType = payType;
}



@end
