//
//  MTFYBuriedPointTravel.m
//  Matafy
//
//  Created by Tiaotiao on 2019/7/3.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYBuriedPointTravel.h"
#import "MTFYBuriedPointRequest.h"

@implementation MTFYBuriedPointTravel

+ (void)bp_homeClickTravel {
    [MobClick event:@"app_iconcar_click"];
}

+ (void)bp_travelIndexShare:(BOOL)isMainIndex {
    NSString *eventId = isMainIndex ? BPT_CarMainPage_Routeshareicon_click : BPT_CarComparePage_closed_Routeshareicon_click;
    
    [MobClick event:eventId];
}

+ (void)bp_travelShowCarPriceView {
    [MobClick event:BPT_CarComparePage_open_view];
}

+ (void)bp_travelShowCarPriceFullShare {
    [MobClick event:BPT_CarComparePage_open_Priceshareicon_click];
}

+ (void)bp_travelShowCarPriceFullShare:(NSInteger)type {
    NSString *typeStr = @"";
    
    switch (type) {
        case TravelShareTypeWechat:
            typeStr = @"wechat";
            break;
        case TravelShareTypeWechatFriend:
            typeStr = @"moments";
            break;
        case TravelShareTypeSaveLocal:
            typeStr = @"picture";
            break;
        case TravelShareTypeCommunity:
            typeStr = @"community";
            break;
        default:
            break;
    }
    
    if (typeStr.length == 0) {
        return;
    }
    
    NSString *eventId = [NSString stringWithFormat:@"%@_%@_click", BPT_CarSharechannelChoiceclick, typeStr];
    [MobClick event:eventId];
}

+ (void)bp_carComparePage_Jumpnow_click:(NSString *)label {
    [MobClick event:@"carComparePage_Jumpnow_click" label:label];
}
+ (void)bp_carComparePage_backicon_click {
    [MobClick event:@"carComparePage_backicon_click"];
}
+ (void)bp_carComparePage_modeshift_click {
    [MobClick event:@"carComparePage_modeshift_click"];
}
+ (void)bp_carMainPage_modeshift_click {
    [MobClick event:@"carMainPage_modeshift_click"];
}
@end
