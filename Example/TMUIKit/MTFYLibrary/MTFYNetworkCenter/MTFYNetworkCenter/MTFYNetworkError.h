//
//  MTFYNetworkError.h
//  Matafy
//
//  Created by Tiaotiao on 2019/7/16.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTFYNetworkError : NSObject


+ (NSString *)mtfy_errorTip:(nullable NSError *)error;

+ (NSString *)mtfy_errorLoadFaildTip;

@end

NS_ASSUME_NONNULL_END
