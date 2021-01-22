//
//  MTFYFormatTool.m
//  Matafy
//
//  Created by Tiaotiao on 2019/4/12.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYFormatTool.h"

@implementation MTFYFormatTool

+ (NSString *)mtfy_formatDistance:(NSString *)distanceMStr {
    NSInteger distanceM = [distanceMStr integerValue];
    
    if (!distanceMStr || distanceM == 0) {
        return @"-米";
    }
    
    NSString *resultStr = distanceMStr;
    if (distanceM > 1000) {
        NSString *resultString =  [NSString floatOne:distanceMStr calculationType:CalculationTypeForDivide floatTwo:@"1000"];
        resultStr = [NSString stringWithFormat:@"%@公里",resultString];
    } else {
        resultStr = [NSString stringWithFormat:@"%@米", distanceMStr];
    }
    
    return resultStr;
}

+ (NSString *)mtfy_formatTime:(NSString *)timeStr {
    if (!timeStr
        || [timeStr isKindOfClass:[NSNull class]]
        || [timeStr isEqualToString:@"<null>"]) {
        return @"-";
    }
    
    if ([timeStr doubleValue] <= 0) {
        return @"-";
    }
 
    return timeStr;
}


+ (NSString *)mtfy_formatTravelReservationShowTime:(NSString *)timeStr
{
    if (!timeStr) {
        return @"--";
    }
    
    if ([timeStr containsString:@"T"]) {
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    }
    
    NSString *dateFormat = @"yyyy-MM-dd HH:mm:ss";
    if (timeStr) {
        NSArray *resultArr = [timeStr componentsSeparatedByString:@":"];
        dateFormat = resultArr.count == 2 ? @"yyyy-MM-dd HH:mm" :  dateFormat;
    }
    
    NSDate *timeDate = [NSDate dateWithString:timeStr formatString:dateFormat];
    NSDate *beforeThirtyMinuteDate = [timeDate dateBySubtractingMinutes:30];
    NSString *resultStr = [beforeThirtyMinuteDate formattedDateWithFormat:@"MM-dd HH:mm"];
    
    return resultStr;
}

+ (NSDate *)mtfy_formatTravelTimeDate:(NSString *)timeStr
{
    if (!timeStr) {
        return nil;
    }
    
    if ([timeStr containsString:@"T"]) {
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    }
    
    NSString *dateFormat = @"yyyy-MM-dd HH:mm:ss";
    if (timeStr) {
        NSArray *resultArr = [timeStr componentsSeparatedByString:@":"];
        dateFormat = resultArr.count == 2 ? @"yyyy-MM-dd HH:mm" : dateFormat;
    }
    
    NSDate *timeDate = [NSDate dateWithString:timeStr formatString:dateFormat];
    
    return timeDate;
}

@end
