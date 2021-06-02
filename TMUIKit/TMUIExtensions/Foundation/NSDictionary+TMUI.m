//
//  NSDictionary+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import "NSDictionary+TMUI.h"
#import "TMUIRuntime.h"

@implementation NSDictionary (TMUI_NilSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ExchangeImplementations(objc_getClass("__NSPlaceholderDictionary"), @selector(initWithObjects:forKeys:count:), @selector(tmui___NSPlaceholderDictionary_initWithObjects:forKeys:count:));
    });
}

// swizz 系统的@{}方法
- (instancetype)tmui___NSPlaceholderDictionary_initWithObjects:(id *)objects forKeys:(id<NSCopying> *)keys count:(NSUInteger)count {
    NSUInteger rightCount = 0;
    for (NSUInteger i = 0; i < count; i++) {
        // 这里只做value 为nil的处理 对key为nil不做处理
        if (objects[i] == nil) {
          objects[i] = [NSNull null]  ; //有看到很多人这个地方判断了objects 和keys 如果它们中有一个为nil 那么就直接break，但是我个人不太建议使用key的值nil的时候直接break。
            // objects[i] = @"" ; 也可以根据个人情况这样写
        }
        rightCount++;
    }
    return [self tmui___NSPlaceholderDictionary_initWithObjects:objects forKeys:keys count:rightCount];
}

//  NSDictionary+NilSafe 中已经存在，先注释掉，等移除后，再打开这里
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        ExchangeImplementations(self, @selector(initWithObjects:forKeys:count:), @selector(tmui_initWithObjects:forKeys:count:));
//        ExchangeImplementations(object_getClass((id)self), @selector(dictionaryWithObjects:forKeys:count:), @selector(tmui_dictionaryWithObjects:forKeys:count:));
//    });
//}
//
//+ (instancetype)tmui_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
//    id safeObjects[cnt];
//    id safeKeys[cnt];
//    NSUInteger j = 0;
//    for (NSUInteger i = 0; i < cnt; i++) {
//        id key = keys[i];
//        id obj = objects[i];
//        #ifdef DEBUG
//        #else
//            if (!key || !obj) {
//                continue;
//            }
//        #endif
//        safeKeys[j] = key;
//        safeObjects[j] = obj;
//        j++;
//    }
//    return [self tmui_dictionaryWithObjects:safeObjects forKeys:safeKeys count:j];
//}
//
//- (instancetype)tmui_initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
//    id safeObjects[cnt];
//    id safeKeys[cnt];
//    NSUInteger j = 0;
//    for (NSUInteger i = 0; i < cnt; i++) {
//        id key = keys[i];
//        id obj = objects[i];
//        #ifdef DEBUG
//        #else
//            if (!key || !obj) {
//                continue;
//            }
//        #endif
//        safeKeys[j] = key;
//        safeObjects[j] = obj;
//        j++;
//    }
//    return [self tmui_initWithObjects:safeObjects forKeys:safeKeys count:j];
//}

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
