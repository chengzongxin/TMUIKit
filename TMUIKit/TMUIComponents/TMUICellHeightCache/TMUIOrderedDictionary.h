//
//  TMUIOrderedDictionary.h
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/27.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 一个简单实现的有序的 key-value 容器，通过 initWithKeysAndObjects: 初始化后，用下标访问即可，如 dict[0] 或 dict[key]
 */
@interface TMUIOrderedDictionary<__covariant KeyType, __covariant ObjectType> : NSObject


- (instancetype)initWithKeysAndObjects:(id)firstKey,...;

@property(readonly) NSUInteger count;
@property(nonatomic, copy, readonly) NSArray<KeyType> *allKeys;
@property(nonatomic, copy, readonly) NSArray<ObjectType> *allValues;
- (void)setObject:(ObjectType)object forKey:(KeyType)key;
- (void)addObject:(ObjectType)object forKey:(KeyType)key;
- (void)addObjects:(NSArray<ObjectType> *)objects forKeys:(NSArray<KeyType> *)keys;
- (void)insertObject:(ObjectType)object forKey:(KeyType)key atIndex:(NSInteger)index;
- (void)insertObjects:(NSArray<ObjectType> *)objects forKeys:(NSArray<KeyType> *)keys atIndex:(NSInteger)index;
- (void)removeObject:(ObjectType)object forKey:(KeyType)key;
- (void)removeObject:(ObjectType)object atIndex:(NSInteger)index;
- (nullable ObjectType)objectForKey:(KeyType)key;
- (ObjectType)objectAtIndex:(NSInteger)index;

// 支持下标的方式访问，需要声明以下两个方法
- (nullable ObjectType)objectForKeyedSubscript:(KeyType)key;
- (ObjectType)objectAtIndexedSubscript:(NSUInteger)idx;

@end

NS_ASSUME_NONNULL_END
