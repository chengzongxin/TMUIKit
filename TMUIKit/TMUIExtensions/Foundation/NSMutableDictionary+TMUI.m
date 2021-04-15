//
//  NSMutableDictionary+safe.m
//  Juanpi
//
//  Created by airspuer on 13-5-8.
//  Copyright (c) 2013年 Juanpi. All rights reserved.
//

#import "NSMutableDictionary+TMUI.h"
#import "TMUIRuntime.h"
@implementation NSMutableDictionary(TMUI)

+ (void)load
{
    ExchangeImplementations(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKeyedSubscript:), @selector(tmui_setObject:forKeyedSubscript:));
    ExchangeImplementations(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKey:), @selector(tmui_safe_setObject:forKey:));
}

+ (instancetype)tmui_dictionaryWithDictionary:(NSDictionary *)dic {
    if ([dic isKindOfClass:[NSDictionary class]]) {
        return [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    return [NSMutableDictionary dictionary];
}

- (void)tmui_safe_setObject:(id)obj forKey:(id<NSCopying>)key
{
    if (!key || !obj) {
        return;
    }
    [self tmui_safe_setObject:obj forKey:key];
}

- (void)tmui_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key
{
    if (!key || !obj) {
        return;
    }
    [self tmui_setObject:obj forKeyedSubscript:key];
}

- (void)tmui_setObject:(id)aObj forKey:(id<NSCopying>)aKey
{
    if (aObj && aKey) {
        [self setObject:aObj forKey:aKey];
    }
}

- (void)tmui_removeObjectForKey:(id<NSCopying>)aKey {
    if (aKey) {
        return [self removeObjectForKey:aKey];
    }
}

- (void)tmui_addEntriesFromDictionary:(NSDictionary *)otherDictionary {
    if ([otherDictionary isKindOfClass:[NSDictionary class]] && [otherDictionary count]) {
        [self addEntriesFromDictionary:otherDictionary];
    }
}

@end
