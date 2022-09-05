//
//  NSMutableDictionary+safe.h
//  Juanpi
//
//  Created by airspuer on 13-5-8.
//  Copyright (c) 2013年 Juanpi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary(TMUI)

+ (instancetype)tmui_dictionaryWithDictionary:(NSDictionary *)dic;

- (void)tmui_setObject:(id)aObj forKey:(id<NSCopying>)aKey;

/** Dictionary add otherDictionary */
- (void)tmui_addEntriesFromDictionary:(NSDictionary *)otherDictionary;

/** 移除aKey */
- (void)tmui_removeObjectForKey:(id<NSCopying>)aKey;

@end
