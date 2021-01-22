//
//  MTFYNetworkURL.m
//  Matafy
//
//  Created by Tiaotiao on 2019/7/8.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYNetworkURL.h"

@implementation MTFYNetworkURL

+ (BOOL)mtfy_isTest {
    
    return DEVELOPMENT;
}

+ (NSString *)mtfy_networkURLCommonH5Index {
    NSString *h5BaseIndexUrl = [self mtfy_isTest] ? CommonH5IndexTest : CommonH5Index;

    return h5BaseIndexUrl;
}

+ (NSString *)mtfy_networkURLCommonH5SelectCoupon:(CGFloat)price {
    NSString *resultUrl = [NSString stringWithFormat:@"%@/selectCoupon?from=car&orderAmount=%lf", [self mtfy_networkURLCommonH5Index], price];
    
    return resultUrl;
}

@end
