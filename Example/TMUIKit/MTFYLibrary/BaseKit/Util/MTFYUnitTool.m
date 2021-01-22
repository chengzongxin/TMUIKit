//
//  MTFYUnitTool.m
//  Matafy
//
//  Created by Tiaotiao on 2019/4/18.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYUnitTool.h"

@implementation MTFYUnitTool

+ (NSString *)mtfy_priceUnitYuan {
    return kLStr(@"common_unit_yuan");
}

+ (NSString *)mtfy_priceUnitTenThousand {
    return kLStr(@"common_unit_ten_thousand");
}

+ (NSString *)mtfy_priceUnitDiscount {
    return kLStr(@"common_unit_discount");
}

+ (NSString *)mtfy_priceUnitSymbol {
    return @"¥";
}


+ (NSString *)mtfy_timeUnitMinute {
    return kLStr(@"common_time_minute_full");
}

@end
