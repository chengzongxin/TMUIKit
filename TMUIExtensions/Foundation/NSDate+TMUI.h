//
//  NSDate+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import <Foundation/Foundation.h>

static NSString *const kTMUIDateFormatYMD = @"yyyy-MM-dd";
static NSString *const kTMUIDateFormatYMDHMS = @"yyyy-MM-dd HH:mm:ss";

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (TMUI)


#pragma mark - Component Properties
///=============================================================================
/// @name Component Properties
///=============================================================================

@property (nonatomic, readonly) NSInteger tmui_year; ///< Year component
@property (nonatomic, readonly) NSInteger tmui_month; ///< Month component (1~12)
@property (nonatomic, readonly) NSInteger tmui_day; ///< Day component (1~31)
@property (nonatomic, readonly) NSInteger tmui_hour; ///< Hour component (0~23)
@property (nonatomic, readonly) NSInteger tmui_minute; ///< Minute component (0~59)
@property (nonatomic, readonly) NSInteger tmui_second; ///< Second component (0~59)
@property (nonatomic, readonly) NSInteger tmui_nanosecond; ///< Nanosecond component
@property (nonatomic, readonly) NSInteger tmui_weekday; ///< Weekday component (1~7, first day is based on user setting)
@property (nonatomic, readonly) NSInteger tmui_weekdayOrdinal; ///< WeekdayOrdinal component
@property (nonatomic, readonly) NSInteger tmui_weekOfMonth; ///< WeekOfMonth component (1~5)
@property (nonatomic, readonly) NSInteger tmui_weekOfYear; ///< WeekOfYear component (1~53)
@property (nonatomic, readonly) NSInteger tmui_yearForWeekOfYear; ///< YearForWeekOfYear component
@property (nonatomic, readonly) NSInteger tmui_quarter; ///< Quarter component
@property (nonatomic, readonly) BOOL tmui_isLeapMonth; ///< whether the month is leap month
@property (nonatomic, readonly) BOOL tmui_isLeapYear; ///< whether the year is leap year
@property (nonatomic, readonly) BOOL tmui_isToday; ///< whether date is today (based on current locale)
@property (nonatomic, readonly) BOOL tmui_isYesterday; ///< whether date is yesterday (based on current locale)

#pragma mark - Date modify
///=============================================================================
/// @name Date modify
///=============================================================================

/**
 Returns a date representing the receiver date shifted later by the provided number of years.
 
 @param years  Number of years to add.
 @return Date modified by the number of desired years.
 */
- (nullable NSDate *)tmui_dateByAddingYears:(NSInteger)years;

/**
 Returns a date representing the receiver date shifted later by the provided number of months.
 
 @param months  Number of months to add.
 @return Date modified by the number of desired months.
 */
- (nullable NSDate *)tmui_dateByAddingMonths:(NSInteger)months;

/**
 Returns a date representing the receiver date shifted later by the provided number of weeks.
 
 @param weeks  Number of weeks to add.
 @return Date modified by the number of desired weeks.
 */
- (nullable NSDate *)tmui_dateByAddingWeeks:(NSInteger)weeks;

/**
 Returns a date representing the receiver date shifted later by the provided number of days.
 
 @param days  Number of days to add.
 @return Date modified by the number of desired days.
 */
- (nullable NSDate *)tmui_dateByAddingDays:(NSInteger)days;

/**
 Returns a date representing the receiver date shifted later by the provided number of hours.
 
 @param hours  Number of hours to add.
 @return Date modified by the number of desired hours.
 */
- (nullable NSDate *)tmui_dateByAddingHours:(NSInteger)hours;

/**
 Returns a date representing the receiver date shifted later by the provided number of minutes.
 
 @param minutes  Number of minutes to add.
 @return Date modified by the number of desired minutes.
 */
- (nullable NSDate *)tmui_dateByAddingMinutes:(NSInteger)minutes;

/**
 Returns a date representing the receiver date shifted later by the provided number of seconds.
 
 @param seconds  Number of seconds to add.
 @return Date modified by the number of desired seconds.
 */
- (nullable NSDate *)tmui_dateByAddingSeconds:(NSInteger)seconds;


#pragma mark - Date Format
///=============================================================================
/// @name Date Format
///=============================================================================

/**
 Returns a formatted string representing this date.
 see http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 for format description.
 
 @param format   String representing the desired date format.
 e.g. @"yyyy-MM-dd HH:mm:ss"
 
 @return NSString representing the formatted date string.
 */
- (nullable NSString *)tmui_stringWithFormat:(NSString *)format;

/**
 Returns a formatted string representing this date.
 see http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 for format description.
 
 @param format    String representing the desired date format.
 e.g. @"yyyy-MM-dd HH:mm:ss"
 
 @param timeZone  Desired time zone.
 
 @param locale    Desired locale.
 
 @return NSString representing the formatted date string.
 */
- (nullable NSString *)tmui_stringWithFormat:(NSString *)format
                               timeZone:(nullable NSTimeZone *)timeZone
                                 locale:(nullable NSLocale *)locale;

/**
 Returns a string representing this date in ISO8601 format.
 e.g. "2010-07-09T16:13:30+12:00"
 
 @return NSString representing the formatted date string in ISO8601.
 */
- (nullable NSString *)tmui_stringWithISOFormat;

/**
 Returns a string representing this date yyyy-MM-dd.
 e.g. "2010-07-09"
 
 @return NSString representing the formatted date string Y-M-D.
 */
- (nullable NSString *)tmui_stringWithDateFormatYMD;

/**
 Returns a string representing this date yyyy-MM-dd HH-mm-ss.
 e.g. "2010-07-09"
 
 @return NSString representing the formatted date string Y-M-D.
 */
- (nullable NSString *)tmui_stringWithDateFormatYMDHMS;

/**
 Returns a date parsed from given string interpreted using the format.
 
 @param dateString The string to parse.
 @param format     The string's date format.
 
 @return A date representation of string interpreted using the format.
 If can not parse the string, returns nil.
 */
+ (nullable NSDate *)tmui_dateWithString:(NSString *)dateString format:(NSString *)format;

/**
 Returns a date parsed from given string interpreted using the format.
 
 @param dateString The string to parse.
 @param format     The string's date format.
 @param timeZone   The time zone, can be nil.
 @param locale     The locale, can be nil.
 
 @return A date representation of string interpreted using the format.
 If can not parse the string, returns nil.
 */
+ (nullable NSDate *)tmui_dateWithString:(NSString *)dateString
                             format:(NSString *)format
                           timeZone:(nullable NSTimeZone *)timeZone
                             locale:(nullable NSLocale *)locale;

/**
 Returns a date parsed from given string interpreted using the ISO8601 format.
 
 @param dateString The date string in ISO8601 format. e.g. "2010-07-09T16:13:30+12:00"
 
 @return A date representation of string interpreted using the format.
 If can not parse the string, returns nil.
 */
+ (nullable NSDate *)tmui_dateWithISOFormatString:(NSString *)dateString;




//创建单例
+ (NSDateFormatter *)tmui_sharedDateFormatter;

/// 获取年
+ (NSInteger)tmui_year:(NSString *)dateStr;
/// 获取月
+ (NSInteger)tmui_month:(NSString *)dateStr;
/// 获取星期
+ (NSInteger)tmui_week:(NSString *)dateStr;
/// 获取星期 中文 日
+ (NSString *)tmui_getWeekFromDate:(NSDate *)date;
/// 获取星期 中文 周日
+ (NSString *)tmui_getChineseWeekFrom:(NSString *)dateStr;
/// 获取日
+ (NSInteger)tmui_day:(NSString *)dateStr;
/// 获取月共有多少天
+ (NSInteger)tmui_daysInMonth:(NSString *)dateStr;

/// 获取当前日期 2018-01-01
+ (NSString *)tmui_currentDay;
/// 获取当前小时 00:00
+ (NSString *)tmui_currentHour;
/// 获取下月最后一天
+ (NSString *)tmui_nextMonthLastDay;

/// 判断是否是今天
+ (BOOL)tmui_isToday:(NSString *)dateStr;
/// 判断是否是明天
+ (BOOL)tmui_isTomorrow:(NSString *)dateStr;
/// 判断是否是后天
+ (BOOL)tmui_isAfterTomorrow:(NSString *)dateStr;
/// 判断是否是过去的时间
+ (BOOL)tmui_isHistoryTime:(NSString *)dateStr;

/// 从时间戳获取具体时间 格式:6:00
+ (NSString *)tmui_hourStringWithInterval:(NSTimeInterval)timeInterval;
/// 从时间戳获取具体小时 格式:6
+ (NSString *)tmui_hourTagWithInterval:(NSTimeInterval)timeInterval;
/// 从毫秒级时间戳获取具体小时 格式:600
+ (NSString *)tmui_hourNumberWithInterval:(NSTimeInterval)timeInterval;
/// 从时间戳获取具体日期 格式:2018-03-05
+ (NSString *)tmui_timeStringWithInterval:(NSTimeInterval)timeInterval;
/// 从具体日期获取时间戳 毫秒
+ (NSTimeInterval)tmui_timeIntervalFromDateString:(NSString *)dateStr;

/// 获取当前天的后几天的星期
+ (NSString *)tmui_getWeekAfterDay:(NSInteger)day;
/// 获取当前天的后几天的日
+ (NSString *)tmui_getDayAfterDay:(NSInteger)day;
/// 获取当前月的后几月
+ (NSString *)tmui_getMonthAfterMonth:(NSInteger)Month;

//NSString转NSDate
+ (NSDate *)tmui_dateFromString:(NSString *)dateString formatter:(NSString *)formatter;
//NSDate转NSString
+ (NSString *)tmui_stringFromDate:(NSDate *)date formatter:(NSString *)formatter;
//通过数字返回星期几
+ (NSString *)tmui_getWeekStringFromInteger:(NSInteger)week;

//计算这个月有多少天
- (NSUInteger)tmui_numberOfDaysInCurrentMonth;
//获取这个月有多少周
- (NSUInteger)tmui_numberOfWeeksInCurrentMonth;
//计算这个月的第一天是礼拜几
- (NSUInteger)tmui_weeklyOrdinality;
//计算这个月最开始的一天
- (NSDate *)tmui_firstDayOfCurrentMonth;
//获取这个月的最后一天
- (NSDate *)tmui_lastDayOfCurrentMonth;
//获取年月日对象
- (NSDateComponents *)tmui_YMDComponents;
//获取当前日期是周几的数字：//周日是“1”，周一是“2”...
- (NSInteger)tmui_getWeekIntValue;
//是否是今年
- (BOOL)tmui_isThisYear;

///格式化消息的时间
+ (NSString *)tmui_formatMessageDateFromInterval:(long long)interval;

///格式化直播预告时间
+ (NSString *)tmui_formatLivePreviewDateFromInterval:(NSTimeInterval)timeInterval isShowHour:(BOOL *)isShowHour;
//判断是否是同一天
- (BOOL)tmui_isSameDay:(NSDate *)date;
//判断是否是同月
- (BOOL)tmui_isSameMonth:(NSDate *)date;
//将日期转换成年月日的格式
- (NSDateComponents *)tmui_createDateComponentsWithYMD;
//将当前日期转换成只有日月年的NSDate
- (NSDate *)tmui_dateWithSampleWithYMD;

@end


/*
 G: 公元时代，例如AD公元
 yy: 年的后2位
 yyyy: 完整年
 MM: 月，显示为1-12
 MMM: 月，显示为英文月份简写,如 Jan
 MMMM: 月，显示为英文月份全称，如 Janualy
 dd: 日，2位数表示，如02
 d: 日，1-2位显示，如 2
 EEE: 简写星期几，如Sun
 EEEE: 全写星期几，如Sunday
 aa: 上下午，AM/PM
 H: 时，24小时制，0-23
 K：时，12小时制，0-11
 m: 分，1-2位
 mm: 分，2位
 s: 秒，1-2位
 ss: 秒，2位
 S: 毫秒
 Z：GMT
 */


@interface NSDate (TMUI_Extensions)

- (NSDate *)tmui_dayInThePreviousMonth;
- (NSDate *)tmui_dayInTheFollowingMonth;
- (NSDate *)tmui_dayInTheFollowingMonth:(NSInteger)month;//获取当前日期之后的几个月
- (NSDate *)tmui_dayInTheFollowingDay:(NSInteger)day;//获取当前日期之后的几个天
+ (NSInteger)tmui_getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday;
//判断日期是今天,明天,后天,周几
- (NSString *)tmui_compareIfTodayWithDate;

@end

NS_ASSUME_NONNULL_END
