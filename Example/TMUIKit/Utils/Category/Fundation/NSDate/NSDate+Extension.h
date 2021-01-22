//
//  NSDate+Extension.h
//  Matafy
//
//  Created by Joe on 2019/7/17.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Extension)


/**
 将某个时间转化成时间戳 egg:[NSDate timeSwitchTimestamp:timeStr andFormatter:@"yyyy-MM-dd HH:mm:ss.SSS"]
 
 @param formatTime 需要转换的字符串
 @param format 转换格式
 @return 返回时间戳
 */
+ (double)dateConvertTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;


/**
 获取当前时间

 @return 当前时间
 */
+(NSDate*)getCurrentTimes;

/**
 获取当前时间
 
 @return 返回当前时间
 */
+(NSString*)getCurrentTime;

/**
 NSString 转 NSDate
 
 @param string NSString
 @return NSDate
 */
+ (NSDate *)stringToDate:(NSString *)string;

/**
 Date转String
 
 @param date NSDate
 @return yyyy-MM-dd
 */
+ (NSString *)dateToString:(NSDate *)date ;

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
                          type:(BOOL)type;
/**
 计算X天后的日期
 
 @param nowDateString yyyy-MM-dd
 @param aDay 多少天后
 @return yyyy-MM-dd
 */
+ (NSString *)distanceDate:(NSString *)nowDateString aDay:(NSInteger)aDay;

/**
 *  把完整时间变成 XX月XX日
 *
 *  @param dateString 完整返回时间
 *
 *  @return XX月XX日
 */
+ (NSString *)getMDStringByString:(NSString *)dateString;

/**
 *  取小时数
 *
 *  @param dateString 完整返回时间
 *
 *  @return XX
 */
+ (NSInteger)getHString:(NSString *)dateString;

/**
 *  取分钟数
 *
 *  @param dateString 完整返回时间
 *
 *  @return XX
 */
+ (NSInteger)getMString:(NSString *)dateString;

/**
 获取当前时间X分钟后的时间
 
 @param periodMin 需要的是多少分钟后的时间
 @return 当前时间X分钟之后的时间字符串
 */
+ (NSString *)getTimerAfterCurrentTime:(NSInteger)periodMin;

/**
 获取指定时间X分钟后的时间
 
 @param periodMin 需要的是多少分钟后的时间
 @return 指定时间X分钟后的时间字符串
 */
+ (NSString *)getTimerAfterTime:(NSString *)time periodMin:(NSInteger)periodMin;

/**
 计算时间差
 
 @param starTime 开始时间
 @param endTime 结束时间
 @return 时间差
 */
+ (NSTimeInterval)pleaseInsertStarTime:(NSString *)starTime andInsertEndTime:(NSString *)endTime;


/**
 计算星期几

 @param inputDate 输入的时间
 @param type YES : 是否显示周几 NO:显示星期几
 @return 返回星期几
 */
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate type:(BOOL)type;
@end

NS_ASSUME_NONNULL_END
