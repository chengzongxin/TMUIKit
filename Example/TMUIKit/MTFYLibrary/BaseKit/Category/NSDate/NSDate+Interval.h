//
// Created by Fussa on 2018/7/28.
// Copyright (c) 2018 Kane. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MTFYInterval : NSObject

/** 天 */
@property(nonatomic, assign) NSInteger day;
/** 小时 */
@property(nonatomic, assign) NSInteger hour;
/** 分钟 */
@property(nonatomic, assign) NSInteger minute;
/** 秒 */
@property(nonatomic, assign) NSInteger second;

@end

@interface NSDate (Interval)
- (MTFYInterval *)mtfy_intervalSinceDate:(NSDate *)date;

- (void)mtfy_intervalSinceDate:(NSDate *)date day:(NSInteger *)dayP hour:(NSInteger *)hourP minute:(NSInteger *)minuteP second:(NSInteger *)secondP;

/**
 * 是否为今天
 */
- (BOOL)mtfy_isInToday;

/**
 * 是否为昨天
 */
- (BOOL)mtfy_isInYesterday;

/**
 * 是否为明天
 */
- (BOOL)mtfy_isInTomorrow;

/**
 * 是否为今年
 */
- (BOOL)mtfy_isInThisYear;

@end
