//
// Created by Fussa on 2018/7/28.
// Copyright (c) 2018 Kane. All rights reserved.
//

#import "NSCalendar+Init.h"


@implementation NSCalendar (Init)

+ (instancetype)mtfy_calendar {
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}

@end
