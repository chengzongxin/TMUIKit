//
//  NSUserDefaults+MTFY.m
//  Matafy
//
//  Created by Fussa on 2019/11/22.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "NSUserDefaults+MTFY.h"
#define MTFYStandardUserDefaults [NSUserDefaults standardUserDefaults]


@implementation NSUserDefaults (MTFY)

+ (void)mtfy_saveBool:(BOOL)value key:(NSString *)key {
    [MTFYStandardUserDefaults setBool:value forKey:key];
    [MTFYStandardUserDefaults synchronize];
}

+ (BOOL)mtfy_getBoolForKey:(NSString *)key {
    return [MTFYStandardUserDefaults boolForKey:key];
}

+ (void)mtfy_saveFloat:(float)value key:(NSString *)key {
    [MTFYStandardUserDefaults setFloat:value forKey:key];
    [MTFYStandardUserDefaults synchronize];
}

+ (float)mtfy_getFloatForKey:(NSString *)key {
    return [MTFYStandardUserDefaults floatForKey:key];
}

+ (void)mtfy_saveDouble:(double)value key:(NSString *)key {
    [MTFYStandardUserDefaults setDouble:value forKey:key];
    [MTFYStandardUserDefaults synchronize];
}

+ (double)mtfy_getDoubleForKey:(NSString *)key {
    return [MTFYStandardUserDefaults doubleForKey:key];
}

+ (void)mtfy_saveInteger:(NSInteger)value key:(NSString *)key {
    [MTFYStandardUserDefaults setInteger:value forKey:key];
    [MTFYStandardUserDefaults synchronize];
}

+ (NSInteger)mtfy_getIntegerForKey:(NSString *)key {
    return [MTFYStandardUserDefaults integerForKey:key];
}

+ (void)mtfy_saveURL:(NSURL *)obj key:(NSString *)key {
    [MTFYStandardUserDefaults setURL:obj forKey:key];
    [MTFYStandardUserDefaults synchronize];
}
+ (NSURL *)mtfy_getURLForKey:(NSString *)key {
    return [MTFYStandardUserDefaults URLForKey:key];
}


+ (void)mtfy_saveObject:(id)obj key:(NSString *)key {
    [MTFYStandardUserDefaults setObject:obj forKey:key];
    [MTFYStandardUserDefaults synchronize];
}

+ (id)mtfy_getObjectForKey:(NSString *)key {
    return [MTFYStandardUserDefaults objectForKey:key];
}

+ (void)mtfy_removeObjectForKey:(NSString *)key {
    [MTFYStandardUserDefaults removeObjectForKey:key];
}
@end
