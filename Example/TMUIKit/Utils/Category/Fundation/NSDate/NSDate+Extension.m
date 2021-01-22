//
//  NSDate+Extension.m
//  Matafy
//
//  Created by Joe on 2019/7/17.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "NSDate+Extension.h"
static NSDateFormatter *_dateFormatter;
@implementation NSDate (Extension)

+ (void)load {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
}

#pragma mark - 将某个时间转化成 时间戳

+ (double)dateConvertTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterFullStyle];
    
    [formatter setTimeStyle:NSDateFormatterFullStyle];
    
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    double timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] doubleValue]*1000;
    
//    NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%f",timeSp); //时间戳的值
    
    return timeSp;
}

+(NSDate*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    return datenow;
}

/**
 获取当前时间

 @return 返回当前时间
 */
+(NSString*)getCurrentTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

/**
 NSString 转 NSDate
 
 @param string NSString
 @return NSDate
 */
+ (NSDate *)stringToDate:(NSString *)string {
    [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [_dateFormatter dateFromString:string];
    return date;
}

/**
 Date转String
 
 @param date NSDate
 @return yyyy-MM-dd
 */
+ (NSString *)dateToString:(NSDate *)date {
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [_dateFormatter stringFromDate:date];
    return strDate;
}

/**
 根据日期计算星期几
 
 @param date 日期
 @param type YES 为周几 NO 为星期几
 @return 周几
 */
//+ (NSString *)currentWeek:(NSString *)date type:(BOOL)type {
//+ (NSString *)currentWeek:(NSDate *)date type:(BOOL)type {

+ (NSString *)fetchCurrentWeek:(NSDate *)date
                      fromDate:(NSDate *)fromDate
                          type:(BOOL)type
{
    NSInteger day = [date daysFrom:fromDate];
    
    if (day < 1) {
        return kLStr(@"common_time_today");
    }
    //    else if (day < 2){
    //        return @"明天";
    //    } else if (day < 3) {
    //        return @"后天";
    //    }
    
    NSString *week = @"";
    NSInteger weekDay = date.weekday;
    if (type) {
        switch (weekDay) {
            case 1:week = @"周日";break;
            case 2:week = @"周一";break;
            case 3:week = @"周二";break;
            case 4:week = @"周三";break;
            case 5:week = @"周四";break;
            case 6:week = @"周五";break;
            case 7:week = @"周六";break;
            default:break;
        }
    } else {
        switch (weekDay) {
            case 1:week = kLStr(@"common_time_sunday");break;
            case 2:week = kLStr(@"common_time_monday");break;
            case 3:week = kLStr(@"common_time_tuesday");break;
            case 4:week = kLStr(@"common_time_wednesday");break;
            case 5:week = kLStr(@"common_time_thursday");break;
            case 6:week = kLStr(@"common_time_friday");break;
            case 7:week = kLStr(@"common_time_saturday");break;
            default:break;
        }
    }
    
    return week;
}


/**
 获取星期几

 @param inputDate 输入的时间
  @param type YES 为周几 NO 为星期几
 @return 返回星期几
 */
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate  type:(BOOL )type{
    
    
      NSMutableArray *weekdays = [NSMutableArray arrayWithCapacity:0];
    if (type) {
     weekdays = [NSMutableArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    } else {
    weekdays = [NSMutableArray arrayWithObjects: [NSNull null], kLStr(@"common_time_sunday"), kLStr(@"common_time_monday"), kLStr(@"common_time_tuesday"), kLStr(@"common_time_wednesday"), kLStr(@"common_time_thursday"), kLStr(@"common_time_friday"), kLStr(@"common_time_saturday"), nil];
    }
    
  
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    if([calendar isDateInToday:inputDate])
    {
        [weekdays replaceObjectAtIndex:theComponents.weekday withObject:kLStr(@"common_time_today")];
    }
    return [weekdays objectAtIndex:theComponents.weekday];
    
}


/**
 计算X天后的日期
 
 @param nowDateString yyyy-MM-dd
 @param aDay 多少天后
 @return yyyy-MM-dd
 */
+ (NSString *)distanceDate:(NSString *)nowDateString aDay:(NSInteger)aDay {
    
    NSDate *date = [self stringToDate:nowDateString];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    comp.day = aDay;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:comp toDate:date options:0];
    
    return [self dateToString:newDate];
}
/**
 *  把完整时间变成 XX月XX日
 *
 *  @param dateString 完整返回时间
 *
 *  @return XX月XX日
 */
+ (NSString *)getMDStringByString:(NSString *)dateString {
    if (dateString.length >= 10) {
        NSString *month = [dateString substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [dateString substringWithRange:NSMakeRange(8, 2)];
        return [NSString stringWithFormat:@"%@月%@日", month, day];
    } else {
        return @"";
    }
    return @"";
}

/**
 *  取小时数
 *
 *  @param dateString 完整返回时间
 *
 *  @return XX
 */
+ (NSInteger)getHString:(NSString *)dateString {
    if (dateString.length >= 13) {
        return [[dateString substringWithRange:NSMakeRange(11, 2)] integerValue];
    } else {
        return 0;
    }
}

/**
 *  取分钟数
 *
 *  @param dateString 完整返回时间
 *
 *  @return XX
 */
+ (NSInteger)getMString:(NSString *)dateString {
    if (dateString.length >= 16) {
        return [[dateString substringWithRange:NSMakeRange(14, 2)] integerValue];
    } else {
        return 0;
    }
}
/**
 获取当前时间X分钟后的时间
 
 @param periodMin 需要的是多少分钟后的时间
 @return 当前时间X分钟之后的时间字符串
 */
+ (NSString *)getTimerAfterCurrentTime:(NSInteger)periodMin {
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *resultStr = [_dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:periodMin * 60]];
    return resultStr;
}

/**
 获取指定时间X分钟后的时间
 
 @param periodMin 需要的是多少分钟后的时间
 @return 指定时间X分钟后的时间字符串
 */
+ (NSString *)getTimerAfterTime:(NSString *)time periodMin:(NSInteger)periodMin {
    
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [_dateFormatter dateFromString:time];
    NSString *resultStr = [_dateFormatter stringFromDate:[date initWithTimeInterval:periodMin*60 sinceDate:date]];
    return resultStr;
}


/**
 计算时间差

 @param starTime 开始时间
 @param endTime 结束时间
 @return 时间差
 */
+ (NSTimeInterval)pleaseInsertStarTime:(NSString *)starTime andInsertEndTime:(NSString *)endTime{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//根据自己的需求定义格式
    NSDate* startDate = [formater dateFromString:starTime];
    NSDate* endDate = [formater dateFromString:endTime];
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    return time;
}

@end
