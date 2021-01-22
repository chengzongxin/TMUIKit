//
//  MTFYBuriedPointTravel.h
//  Matafy
//
//  Created by Tiaotiao on 2019/7/3.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTFYBuriedPointTravelConstant.h"
#import "TravelConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface MTFYBuriedPointTravel : NSObject

+ (void)bp_homeClickTravel;

/**
 出行主页右上角分享点击埋点

 @param isMainIndex 是否在主页
 */
+ (void)bp_travelIndexShare:(BOOL)isMainIndex;
+ (void)bp_travelShowCarPriceView;
+ (void)bp_travelShowCarPriceFullShare;
+ (void)bp_travelShowCarPriceFullShare:(NSInteger)type;
/// 点击跳转第三方时候的埋点
+ (void)bp_carComparePage_Jumpnow_click:(NSString *)label;
/// 全屏比价时 点击顶部详情修改按钮
+ (void)bp_carComparePage_backicon_click;
+ (void)bp_carComparePage_modeshift_click;
+ (void)bp_carMainPage_modeshift_click;

/// 拉新红包分享埋点
+ (void)bp_redPkgShareActivity;

@end

NS_ASSUME_NONNULL_END
