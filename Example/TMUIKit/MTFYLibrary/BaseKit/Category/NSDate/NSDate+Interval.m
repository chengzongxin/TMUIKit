//
// Created by Fussa on 2018/7/28.
// Copyright (c) 2018 Kane. All rights reserved.
//

#import "NSDate+Interval.h"
#import "NSCalendar+Init.h"

@implementation MTFYInterval

@end

@implementation NSDate (Interval)

- (MTFYInterval *)mtfy_intervalSinceDate:(NSDate *)date {

    NSInteger interval = (NSInteger) [self timeIntervalSinceDate:date];
    // 1分钟 = 60秒
    NSInteger secondsPerMinute = 60;
    // 1小时 = 60分钟
    NSInteger secondsPerHour = 60 * secondsPerMinute;
    // 1天 = 24小时
    NSInteger secondsPerDay = 24 * secondsPerMinute;

    MTFYInterval *intervalStruct = [[MTFYInterval alloc] init];
    intervalStruct.day = interval / secondsPerDay;
    intervalStruct.hour = (interval % secondsPerDay) / secondsPerHour;
    intervalStruct.minute = ((interval % secondsPerDay) % secondsPerHour) / secondsPerMinute;
    intervalStruct.second = interval % secondsPerMinute;

    return intervalStruct;
}

- (void)mtfy_intervalSinceDate:(NSDate *)date day:(NSInteger *)dayP hour:(NSInteger *)hourP minute:(NSInteger *)minuteP second:(NSInteger *)secondP {
    NSInteger interval = (NSInteger) [self timeIntervalSinceDate:date];
    // 1分钟 = 60秒
    NSInteger secondsPerMinute = 60;
    // 1小时 = 60分钟
    NSInteger secondsPerHour = 60 * secondsPerMinute;
    // 1天 = 24小时
    NSInteger secondsPerDay = 24 * secondsPerMinute;

    *dayP = interval / secondsPerDay;
    *hourP = (interval % secondsPerDay) / secondsPerHour;
    *minuteP = ((interval % secondsPerDay) % secondsPerHour) / secondsPerMinute;
    *secondP = interval / secondsPerMinute;
}

- (BOOL)mtfy_isInToday {
    NSCalendar *calendar = [NSCalendar mtfy_calendar];
    // 获取年月日
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *selfComponents = [calendar components:unit fromDate:self];
    NSDateComponents *dateComponents = [calendar components:unit fromDate:[NSDate date]];
    return [selfComponents isEqual:dateComponents];
}

- (BOOL)mtfy_isInYesterday {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";

    // 获取只有年月日的字符串对象
    NSString *selfStr = [formatter stringFromDate:self];
    NSString *nowStr = [formatter stringFromDate:[NSDate date]];

    // 获取只有年月日的日期对象
    NSDate *selfDate = [formatter dateFromString:selfStr];
    NSDate *nowDate = [formatter dateFromString:nowStr];

    NSCalendar *calendar = [NSCalendar mtfy_calendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return components.day == 1;
}

- (BOOL)mtfy_isInTomorrow {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";

    // 获取只有年月日的字符串对象
    NSString *selfStr = [formatter stringFromDate:self];
    NSString *nowStr = [formatter stringFromDate:[NSDate date]];

    // 获取只有年月日的日期对象
    NSDate *selfDate = [formatter dateFromString:selfStr];
    NSDate *nowDate = [formatter dateFromString:nowStr];

    NSCalendar *calendar = [NSCalendar mtfy_calendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return components.day == 1;
}

- (BOOL)mtfy_isInThisYear {
    NSCalendar *calendar = [NSCalendar mtfy_calendar];
    // 获取年月日
    NSCalendarUnit unit =  NSCalendarUnitYear;
    NSDateComponents *selfComponents = [calendar components:unit fromDate:self];
    NSDateComponents *dateComponents = [calendar components:unit fromDate:[NSDate date]];
    return [selfComponents isEqual:dateComponents];
}

@end
