//
//  MTFYNetworkError.m
//  Matafy
//
//  Created by Tiaotiao on 2019/7/16.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYNetworkError.h"

@implementation MTFYNetworkError

+ (NSString *)mtfy_errorTip:(nullable NSError *)error {
    if (!error) {
        return nil;
    }
    
    if (![kMTFYNetworkCenter checkNetworkIsConnected]) {
        return @"请检查你的网络";
    }
    
    return [self mtfy_errorLoadFaildTip];
}

+ (NSString *)mtfy_errorLoadFaildTip {
    return @"数据加载失败";
}


@end
