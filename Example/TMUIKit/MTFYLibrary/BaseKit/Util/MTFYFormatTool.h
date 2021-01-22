//
//  MTFYFormatTool.h
//  Matafy
//
//  Created by Tiaotiao on 2019/4/12.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTFYFormatTool : NSObject



+ (NSString *)mtfy_formatDistance:(NSString *)distanceMStr;

+ (NSString *)mtfy_formatTime:(NSString *)timeStr;



/**
 返回了时间的前30分钟 MM-dd HH：mm

 @param timeStr  yyyy-MM-dd HH:mm:ss
 @return 前30分钟字符串
 */
+ (NSString *)mtfy_formatTravelReservationShowTime:(NSString *)timeStr;

+ (NSDate *)mtfy_formatTravelTimeDate:(NSString *)timeStr;

@end

NS_ASSUME_NONNULL_END
