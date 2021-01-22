//
//  NSUserDefaults+MTFY.h
//  Matafy
//
//  Created by Fussa on 2019/11/22.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (MTFY)
+ (void)mtfy_saveBool:(BOOL)value key:(NSString *)key;
+ (BOOL)mtfy_getBoolForKey:(NSString *)key;

+ (void)mtfy_saveFloat:(float)value key:(NSString *)key;
+ (float)mtfy_getFloatForKey:(NSString *)key;

+ (void)mtfy_saveDouble:(double)value key:(NSString *)key;
+ (double)mtfy_getDoubleForKey:(NSString *)key;

+ (void)mtfy_saveInteger:(NSInteger)value key:(NSString *)key;
+ (NSInteger)mtfy_getIntegerForKey:(NSString *)key;

+ (void)mtfy_saveURL:(NSURL *)obj key:(NSString *)key;
+ (NSURL*)mtfy_getURLForKey:(NSString *)key;


+ (void)mtfy_saveObject:(nullable id)obj key:(NSString *)key;
+ (nullable id)mtfy_getObjectForKey:(NSString *)key;
+ (void)mtfy_removeObjectForKey:(NSString *)key;


@end

NS_ASSUME_NONNULL_END
