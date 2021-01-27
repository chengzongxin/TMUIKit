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
- (NSDictionary *)t_dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary;

/**
 *  根据字段集合keys删除字典里对应的键值对
 *
 *  @param keys 键值集合
 *
 *  @return 字典
 */
- (NSDictionary *)t_dictionaryByRemovingEntriesWithKeys:(NSSet *)keys;

@end

NS_ASSUME_NONNULL_END
