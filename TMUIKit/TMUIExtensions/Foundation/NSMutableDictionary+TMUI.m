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
// NSDictionary+NilSafe 已经添加，之后移除后再放开
//#pragma mark - Safe Crash avoid
//+ (void)load{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        ExchangeImplementations(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKey:), @selector(tmui___NSDictionaryM_setObject:forKey:));
//        ExchangeImplementations(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKeyedSubscript:), @selector(tmui___NSDictionaryM_setObject:forKeyedSubscript:));
//    });
//
//}
//
//- (void)tmui___NSDictionaryM_setObject:(id)obj forKey:(id<NSCopying>)key
//{
//    if (!key || !obj) {
//        return;
//    }
//    [self tmui___NSDictionaryM_setObject:obj forKey:key];
//}
//
//- (void)tmui___NSDictionaryM_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key
//{
//    if (!key || !obj) {
//        return;
//    }
//    [self tmui___NSDictionaryM_setObject:obj forKeyedSubscript:key];
//}

#pragma mark - Safe Method
+ (instancetype)tmui_dictionaryWithDictionary:(NSDictionary *)dic {
    if ([dic isKindOfClass:[NSDictionary class]]) {
        return [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    return [NSMutableDictionary dictionary];
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
