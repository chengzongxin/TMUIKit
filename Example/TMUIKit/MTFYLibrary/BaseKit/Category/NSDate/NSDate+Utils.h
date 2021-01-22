//
//  NSDate+Utils.h
//  BloodSugar
//
//  Created by PeterPan on 13-12-27.
//  Copyright (c) 2013年 shake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NSString *MTFYDateFormatString NS_STRING_ENUM;

static MTFYDateFormatString const MTFYDateFormatStringyyyyMMddHHmmss          = @"yyyy-MM-dd HH:mm:ss";
static MTFYDateFormatString const MTFYDateFormatStringyyyyMMdd                = @"yyyy-MM-dd";
static MTFYDateFormatString const MTFYDateFormatStringMMdd                    = @"MM-dd";
static MTFYDateFormatString const MTFYDateFormatStringMMddHHmm                = @"MM-dd HH:mm";
static MTFYDateFormatString const MTFYDateFormatStringHHmmss                  = @"HH:mm:ss";
static MTFYDateFormatString const MTFYDateFormatStringHHmm                    = @"HH:mm";

static MTFYDateFormatString const MTFYDateFormatStringChineseyyyyMMddHHmmss   = @"yyyy年MM月dd日 HH时mm分ss秒";
static MTFYDateFormatString const MTFYDateFormatStringChineseyyyyMMdd         = @"yyyy年MM月dd日";
static MTFYDateFormatString const MTFYDateFormatStringChineseMMdd             = @"MM月dd日";
static MTFYDateFormatString const MTFYDateFormatStringChineseMMddHHmm         = @"MM月dd日 HH时mm分";
static MTFYDateFormatString const MTFYDateFormatStringChineseHHmmss           = @"HH时mm分ss秒";
static MTFYDateFormatString const MTFYDateFormatStringChineseHHmm             = @"HH时mm分";


@interface NSDate (Utils)

+ (NSDate *)mtfy_dateWithYear:(NSInteger)year
                        month:(NSInteger)month
                          day:(NSInteger)day
                         hour:(NSInteger)hour
                       minute:(NSInteger)minute
                       second:(NSInteger)second;

+ (NSInteger)mtfy_daysOffsetBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

+ (NSDate *)mtfy_dateWithHour:(int)hour
                       minute:(int)minute;

#pragma mark - Getter
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;
- (NSString *)weekday;


#pragma mark - Time string
- (NSString *)mtfy_timeHourMinute;
- (NSString *)mtfy_timeHourMinuteWithPrefix;
- (NSString *)mtfy_timeHourMinuteWithSuffix;
- (NSString *)mtfy_timeHourMinuteWithPrefix:(BOOL)enablePrefix suffix:(BOOL)enableSuffix;

#pragma mark - Date String
- (NSString *)mtfy_stringTime;
- (NSString *)mtfy_stringMonthDay;
- (NSString *)mtfy_stringYearMonthDay;
- (NSString *)mtfy_stringMonthDayHourMinute;
- (NSString *)mtfy_stringMonthDayHourMinuteSecond;
- (NSString *)mtfy_stringYearMonthDayHourMinuteSecond;
+ (NSString *)mtfy_stringYearMonthDayWithDate:(NSDate *)date;      //date为空时返回的是当前年月日
+ (NSString *)mtfy_stringLoacalDate;
- (NSString *)mtfy_stringWithFormat:(NSString *)format;

#pragma mark - Date formate
+ (NSString *)mtfy_dateFormatString;
+ (NSString *)mtfy_timeFormatString;
+ (NSString *)mtfy_timestampFormatString;
+ (NSString *)mtfy_timestampFormatStringSubSeconds;

#pragma mark - Date adjust
- (NSDate *) mtfy_dateByAddingDays: (NSInteger) dDays;
- (NSDate *) mtfy_dateBySubtractingDays: (NSInteger) dDays;

#pragma mark - Relative dates from the date
+ (NSDate *)mtfy_dateTomorrow;
+ (NSDate *)mtfy_dateYesterday;
+ (NSDate *)mtfy_dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *)mtfy_dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *)mtfy_dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *)mtfy_dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *)mtfy_dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *)mtfy_dateWithMinutesBeforeNow: (NSInteger) dMinutes;
+ (NSDate *)mtfy_dateStandardFormatTimeZeroWithDate: (NSDate *) aDate;  //标准格式的零点日期
- (NSInteger)mtfy_daysBetweenCurrentDateAndDate;                     //负数为过去，正数为未来

#pragma mark - Date compare
- (BOOL)mtfy_isEqualToDateIgnoringTime: (NSDate *) aDate;
- (NSString *)mtfy_stringYearMonthDayCompareToday;                 //返回“今天”，“明天”，“昨天”，或年月日

#pragma mark - Date and string convert
+ (NSDate *)mtfy_dateFromString:(NSString *)string;
+ (NSDate *)mtfy_dateFromString:(NSString *)string withFormat:(NSString *)format;
- (NSString *)mtfy_string;
- (NSString *)mtfy_stringCutSeconds;

@end
