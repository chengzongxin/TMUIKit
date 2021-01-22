//
//  MTFYUnitTool.h
//  Matafy
//
//  Created by Tiaotiao on 2019/4/18.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTFYUnitTool : NSObject

+ (NSString *)mtfy_priceUnitYuan;
+ (NSString *)mtfy_priceUnitTenThousand;

+ (NSString *)mtfy_priceUnitDiscount;

+ (NSString *)mtfy_priceUnitSymbol;


+ (NSString *)mtfy_timeUnitMinute;

@end

NS_ASSUME_NONNULL_END
