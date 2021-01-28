//
//  NSDate+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import "NSDate+TMUI.h"

@implementation NSDate (TMUI)

//因为创建NSDateFormatter对象比较耗性能，所以用一个单例创建，程序中统一调用它即可
+ (NSDateFormatter *)sharedDateFormatter {
    static dispatch_once_t onceToken;
    static NSDateFormatter *instanceFormatter = nil;
    dispatch_once(&onceToken, ^{
        instanceFormatter = [[NSDateFormatter alloc] init];
        //[instanceFormatter setLocale:[NSLocale systemLocale]];
        //[instanceFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    });
    return instanceFormatter;
}

/// 获取年
+ (NSInteger)year:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *startDate = [dateFormatter dateFromString:dateStr];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:startDate];
    return components.year;
}

/// 获取月
+ (NSInteger)month:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *startDate = [dateFormatter dateFromString:dateStr];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:startDate];
    return components.month;
}


/// 获取星期
+ (NSInteger)week:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *startDate = [dateFormatter dateFromString:dateStr];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:startDate];
    return components.weekday - 1;
}

/// 获取星期 中文
+ (NSString *)getWeekFromDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:date];
    NSInteger week = components.weekday - 1;
    NSDictionary *weekDic = @{@"0":@"日",@"1":@"一",@"2":@"二",@"3":@"三",@"4":@"四",@"5":@"五",@"6":@"六"};
    NSString *key = [NSString stringWithFormat:@"%ld",(long)week];
    return weekDic[key];
}

/// 获取星期中文
+ (NSString *)getChineseWeekFrom:(NSString *)dateStr {
    NSDictionary *weekDic = @{@"0":@"周日",@"1":@"周一",@"2":@"周二",@"3":@"周三",@"4":@"周四",@"5":@"周五",@"6":@"周六"};
    NSInteger week = [NSDate week:dateStr];
    NSString *weekKey = [NSString stringWithFormat:@"%ld",(long)week];
    return weekDic[weekKey];
}

/// 获取日
+ (NSInteger)day:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *startDate = [dateFormatter dateFromString:dateStr];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:startDate];
    return components.day;
}

/// 获取月共有多少天
+ (NSInteger)daysInMonth:(NSString *)dateStr {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[NSDate timeIntervalFromDateString:dateStr] / 1000];
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

//获取当前日期
+ (NSString *)currentDay {
    NSDateFormatter *formater = [self sharedDateFormatter];
    NSDate *date = [NSDate date];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString * time = [formater stringFromDate:date];
    return time;
}

//获取当前小时
+ (NSString *)currentHour {
    NSDateFormatter *formater = [self sharedDateFormatter];
    NSDate *curDate = [NSDate date];
    [formater setDateFormat:@"H:mm"];
    NSString * curTime = [formater stringFromDate:curDate];
    return curTime;
}

//找到两个月后的第一天~ 然后通过减一天来找到下个月的最后一天，所以，下月最后一天
+ (NSString *)nextMonthLastDay {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    //设置日为1号
    dateComponents.day =1;
    //设置月份为后延2个月
    dateComponents.month +=2;
    NSDate * endDayOfNextMonth = [calendar dateFromComponents:dateComponents];
    //两个月后的1号往前推1天，即为下个月最后一天
    endDayOfNextMonth = [endDayOfNextMonth dateByAddingTimeInterval:-1];
    //格式化输出
    NSDateFormatter *formater = [self sharedDateFormatter];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString * curTime = [formater stringFromDate:endDayOfNextMonth];
    return curTime;
}

///判断是否是今天
+ (BOOL)isToday:(NSString *)dateStr {
    BOOL isDay = NO;
    NSString *day = [NSDate timeStringWithInterval:[NSDate date].timeIntervalSince1970];
    if ([dateStr isEqualToString:day]) {
        isDay = YES;
    }
    return isDay;
}

///判断是否是明天
+ (BOOL)isTomorrow:(NSString *)dateStr {
    BOOL isDay = NO;
    NSTimeInterval time = [NSDate date].timeIntervalSince1970 + 24 * 3600;
    NSString *day = [NSDate timeStringWithInterval:time];
    if ([dateStr isEqualToString:day]) {
        isDay = YES;
    }
    return isDay;
}

///判断是否是后天
+ (BOOL)isAfterTomorrow:(NSString *)dateStr {
    BOOL isDay = NO;
    NSTimeInterval time = [NSDate date].timeIntervalSince1970 + 48 * 3600;
    NSString *day = [NSDate timeStringWithInterval:time];
    if ([dateStr isEqualToString:day]) {
        isDay = YES;
    }
    return isDay;
}

/// 判断是否是过去的时间
+ (BOOL)isHistoryTime:(NSString *)dateStr {
    BOOL activity = NO;
    NSTimeInterval timeInterval = [NSDate timeIntervalFromDateString: dateStr];
    NSTimeInterval currentInterval = [NSDate timeIntervalFromDateString:[NSDate currentDay]];
    if (timeInterval < currentInterval) {
        activity = YES;
    }
    return activity;
}

/// 从时间戳获取具体时间 格式:6:00
+ (NSString *)hourStringWithInterval:(NSTimeInterval)timeInterval {
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    [dateFormatter setDateFormat:@"H:mm"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

/// 从时间戳获取具体小时 格式:6
+ (NSString *)hourTagWithInterval:(NSTimeInterval)timeInterval {
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    [dateFormatter setDateFormat:@"H"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

/// 从毫秒级时间戳获取具体小时 格式:600
+ (NSString *)hourNumberWithInterval:(NSTimeInterval)timeInterval {
    NSString *hourStr = [self hourStringWithInterval:timeInterval / 1000];
    NSString *hourNumber = [hourStr stringByReplacingOccurrencesOfString:@":" withString:@""];
    return hourNumber;
}

/// 从时间戳获取具体日期 格式:2018-03-05
+ (NSString *)timeStringWithInterval:(NSTimeInterval)timeInterval {
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

/// 根据具体日期获取时间戳(毫秒)
+ (NSTimeInterval)timeIntervalFromDateString:(NSString *)dateStr {
    //要精确到毫秒2018-01-01 与 2018-01-01 00:00 都要转换成2018-01-01 00:00:00
    if (dateStr.length == 10) {
        dateStr = [dateStr stringByAppendingString:@" 00:00:00"];
    } else if (dateStr.length == 16) {
        dateStr = [dateStr stringByAppendingString:@":00"];
    }
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    NSTimeInterval interval = [date timeIntervalSince1970] * 1000;
    return interval;
}

/// 获取当前天的后几天的星期
+ (NSString *)getWeekAfterDay:(NSInteger)day {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:[NSDate date]];
    NSInteger currentWeek = components.weekday - 1;
    NSDictionary *weekDic = @{@"0":@"日",@"1":@"一",@"2":@"二",@"3":@"三",@"4":@"四",@"5":@"五",@"6":@"六"};
    NSInteger week = currentWeek + day;
    if (week >= 7) {
        week -= 7;
    }
    NSString *key = [NSString stringWithFormat:@"%ld",(long)week];
    return weekDic[key];
}


/// 获取当前天的后几天的日
+ (NSString *)getDayAfterDay:(NSInteger)day {
    NSTimeInterval time = [NSDate date].timeIntervalSince1970 + 24 * 3600 * day;
    NSString *date = [NSDate timeStringWithInterval:time];
    NSInteger dayNum = [self day:date];
    NSString *dayStr = [NSString stringWithFormat:@"%ld",(long)dayNum];
    return dayStr;
}

/// 获取当前月的后几月
+ (NSString *)getMonthAfterMonth:(NSInteger)Month {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [self sharedDateFormatter];
    [formatter setDateFormat:@"yyyy-MM"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    //    [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    [lastMonthComps setMonth:Month];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    NSString *dateStr = [formatter stringFromDate:newdate];
    return dateStr;
}

//NSString转NSDate
+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter {
    
    NSDateFormatter *dateFormatter = [NSDate sharedDateFormatter];
    [dateFormatter setDateFormat: (formatter == nil || formatter.length == 0) ? @"yyyy-MM-dd" : formatter];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}


//NSDate转NSString
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [NSDate sharedDateFormatter];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:(formatter == nil || formatter.length == 0) ? @"yyyy-MM-dd" : formatter];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

//通过数字返回星期几
+(NSString *)getWeekStringFromInteger:(NSInteger)week
{
    NSString *str_week = nil;
    
    switch (week) {
        case 1:
            str_week = @"周日";
            break;
        case 2:
            str_week = @"周一";
            break;
        case 3:
            str_week = @"周二";
            break;
        case 4:
            str_week = @"周三";
            break;
        case 5:
            str_week = @"周四";
            break;
        case 6:
            str_week = @"周五";
            break;
        case 7:
            str_week = @"周六";
            break;
    }
    return str_week;
}

//计算这个月有多少天
- (NSUInteger)numberOfDaysInCurrentMonth {
    
    // 频繁调用 [NSCalendar currentCalendar] 可能存在性能问题
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}


//获取这个月有多少周
- (NSUInteger)numberOfWeeksInCurrentMonth
{
    NSUInteger weekday = [[self firstDayOfCurrentMonth] weeklyOrdinality];
    NSUInteger days = [self numberOfDaysInCurrentMonth];
    NSUInteger weeks = 0;
    
    if (weekday > 1) {
        weeks += 1;
        days -= (7 - weekday + 1);
    }
    
    weeks += days / 7;
    weeks += (days % 7 > 0) ? 1 : 0;
    
    return weeks;
}



/*计算这个月的第一天是礼拜几*/
- (NSUInteger)weeklyOrdinality
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:self];
}



//计算这个月最开始的一天
- (NSDate *)firstDayOfCurrentMonth
{
    NSDate *startDate = nil;
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
    return startDate;
}

//获取这个月的最后一天
- (NSDate *)lastDayOfCurrentMonth
{
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];
    dateComponents.day = [self numberOfDaysInCurrentMonth];
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

//获取年月日对象
- (NSDateComponents *)YMDComponents
{
    return [[NSCalendar currentCalendar] components:
            NSCalendarUnitYear|
            NSCalendarUnitMonth|
            NSCalendarUnitDay|
            NSCalendarUnitWeekday fromDate:self];
}

//周日是“1”，周一是“2”...
-(NSInteger)getWeekIntValue
{
    NSInteger weekIntValue;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *comps= [calendar components:(NSCalendarUnitYear |
                                                   NSCalendarUnitMonth |
                                                   NSCalendarUnitDay |
                                                   NSCalendarUnitWeekday) fromDate:self];
    return weekIntValue = [comps weekday];
}

//是否是今年
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unit = NSCalendarUnitYear;
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return nowCmps.year == selfCmps.year;
    
}

//格式化消息的时间
+(NSString*)formatMessageDateFromInterval:(long long)interval {
    NSDateFormatter *dateFormatter = [NSDate sharedDateFormatter];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dayStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]];
    if ([NSDate isToday:dayStr]) {
        //今天
        dateFormatter.dateFormat = @"HH:mm";
        return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]];
    }else{
        //非今天s
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval];
        BOOL isThisYear = [date isThisYear];
        if (isThisYear) {
            //今年
            dateFormatter.dateFormat = @"MM-dd";
            return  [dateFormatter stringFromDate:date];
        }
    }
    return dayStr;
}


///格式化直播预告时间
+(NSString*)formatLivePreviewDateFromInterval:(NSTimeInterval)timeInterval isShowHour:(BOOL *)isShowHour{
    NSTimeInterval nowTimeInterval = [NSDate date].timeIntervalSince1970;
    NSTimeInterval interval = timeInterval - nowTimeInterval;
    if (interval < (24 * 3600)){
        //不超过一天
        
        *isShowHour = YES;
        int hours = (int)(interval/3600);
        int minute = (int)(interval - hours * 3600)/60;
        if (hours < 0) {
            hours = 0;
        }
        if (minute < 0) {
            minute = 0;
        }
        return [NSString stringWithFormat:@"%d小时%d分钟",hours,minute];
    }else{

        NSDateFormatter *dateFormatter = [self sharedDateFormatter];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dayStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
        return dayStr;
    }

    return nil;
}

@end


@implementation NSDate (TMUI_Extensions)

//上一个月
- (NSDate *)dayInThePreviousMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//下一个月
- (NSDate *)dayInTheFollowingMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}


//获取当前日期之后的几个月
- (NSDate *)dayInTheFollowingMonth:(NSInteger)month
{
    if (month == 0) {
        return self;
    }
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = month;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//获取当前日期之后的几天
- (NSDate *)dayInTheFollowingDay:(NSInteger)day
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = day;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}


+ (NSInteger)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//日历控件对象
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:today toDate:beforday options:0];
    //    NSDateComponents *components = [calendar components:NSMonthCalendarUnit|NSDayCalendarUnit fromDate:today toDate:beforday options:0];
    NSInteger day = [components day];//两个日历之间相差多少月//    NSInteger days = [components day];//两个之间相差几天
    return day;
}

//判断日期是今天,明天,后天,周几
-(NSString *)compareIfTodayWithDate
{
    NSDate *todate = [NSDate date];//今天
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *comps_today= [calendar components:(NSCalendarUnitYear |
                                                         NSCalendarUnitMonth |
                                                         NSCalendarUnitDay |
                                                         NSCalendarUnitWeekday) fromDate:todate];
    
    
    NSDateComponents *comps_other= [calendar components:(NSCalendarUnitYear |
                                                         NSCalendarUnitMonth |
                                                         NSCalendarUnitDay |
                                                         NSCalendarUnitWeekday) fromDate:self];
    
    
    //获取星期对应的数字
    NSInteger weekIntValue = [self getWeekIntValue];
    
    if (comps_today.year == comps_other.year &&
        comps_today.month == comps_other.month &&
        comps_today.day == comps_other.day) {
        return @"今天";
        
    }
//7.13版本后，时间格式化规则变更，除今天日期外，其它均按统一格式返回，故以下明天、后天的处理逻辑暂屏蔽
//    else if (comps_today.year == comps_other.year &&
//              comps_today.month == comps_other.month &&
//              (comps_today.day - comps_other.day) == -1){
//        return @"明天";
//
//    } else if (comps_today.year == comps_other.year &&
//              comps_today.month == comps_other.month &&
//              (comps_today.day - comps_other.day) == -2){
//        return @"后天";
//
//    }
    else {
        //直接返回当时日期的字符串(这里让它返回空)
        return [NSDate getWeekStringFromInteger:weekIntValue];//周几
    }
}

@end
