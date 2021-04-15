//
//  NSDictionary+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (TMUI)

/**
 *  根据另一个字典dictionary添加键值对
 *
 *  @param dictionary 将要copy的字典
 *
 *  @return 字典
 */
- (NSDictionary *)tmui_dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary;

/**
 *  根据字段集合keys删除字典里对应的键值对
 *
 *  @param keys 键值集合
 *
 *  @return 字典
 */
- (NSDictionary *)tmui_dictionaryByRemovingEntriesWithKeys:(NSSet *)keys;

@end

@interface NSDictionary (Safe)

//key可以是number类型
- (id)tmui_objectForKey:(id)aKey;

/** 安全返回NSString */
- (NSString *)tmui_stringForKey:(id)key;

/** 安全返回NSArray */
- (NSArray *)tmui_arrayForKey:(id)key;

/** 安全返回NSDictionary */
- (NSDictionary *)tmui_dictionaryForKey:(id)key;

@end

NS_ASSUME_NONNULL_END
