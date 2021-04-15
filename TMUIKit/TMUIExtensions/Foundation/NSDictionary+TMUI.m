//
//  NSDictionary+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import "NSDictionary+TMUI.h"
#import "TMUIRuntime.h"

@implementation NSDictionary (NilSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ExchangeImplementations(self, @selector(initWithObjects:forKeys:count:), @selector(tmui_initWithObjects:forKeys:count:));
        ExchangeImplementations(object_getClass((id)self), @selector(dictionaryWithObjects:forKeys:count:), @selector(tmui_dictionaryWithObjects:forKeys:count:));
    });
}

+ (instancetype)tmui_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        #ifdef DEBUG
        #else
            if (!key || !obj) {
                continue;
            }
        #endif
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self tmui_dictionaryWithObjects:safeObjects forKeys:safeKeys count:j];
}

- (instancetype)tmui_initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        #ifdef DEBUG
        #else
            if (!key || !obj) {
                continue;
            }
        #endif
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self tmui_initWithObjects:safeObjects forKeys:safeKeys count:j];
}

@end

@implementation NSDictionary (TMUI)

- (NSDictionary *)tmui_dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary {
    NSMutableDictionary *result = [self mutableCopy];
    [result addEntriesFromDictionary:dictionary];
    return result;
}

- (NSDictionary *)tmui_dictionaryByRemovingEntriesWithKeys:(NSSet *)keys {
    NSMutableDictionary *result = [self mutableCopy];
    [result removeObjectsForKeys:keys.allObjects];
    return result;
}

@end

@implementation NSDictionary (Safe)

//key可以是number类型
- (id)tmui_objectForKey:(id)aKey
{
    if (!aKey) {
        return nil;
    }
    id obj = [self objectForKey:aKey];
    return obj;
}

/** 安全返回NSString */
- (NSString *)tmui_stringForKey:(id)aKey
{
    if (!aKey) {
        return nil;
    }
    id obj = [self objectForKey:aKey];
    if (![obj isKindOfClass:[NSString class]]) {
        obj = nil;
    }
    return obj;
}

/** 安全返回NSArray */
- (NSArray *)tmui_arrayForKey:(id)aKey
{
    if (!aKey) {
        return nil;
    }
    id obj = [self objectForKey:aKey];
    if (![obj isKindOfClass:[NSArray class]]) {
        obj = nil;
    }
    return obj;
}

/** 安全返回NSDictionary */
- (NSDictionary *)tmui_dictionaryForKey:(id)aKey
{
    if (!aKey) {
        return nil;
    }
    id obj = [self objectForKey:aKey];
    if (![obj isKindOfClass:[self class]]) {
        obj = nil;
    }
    return obj;
}

@end
