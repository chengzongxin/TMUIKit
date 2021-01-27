//
//  NSArray+TCategory.h
//  TBasicLib
//
//  Created by kevin.huang on 14-8-4.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (TCategory)

/**
 *  删掉object
 *
 *  @param object 将要删掉的元素
 *
 *  @return 数组
 */
- (NSArray *)t_arrayByRemovingObject:(id)object;

/**
 *  删掉数组中的第index个元素
 *
 *  @param index 将要删掉的元素的index
 *
 *  @return 数组
 */
- (NSArray *)t_arrayByRemovingObjectAtIndex:(NSUInteger)index;

/**
 *  删掉数组中的第一个元素
 *
 *  @return 数组
 */
- (NSArray *)t_arrayByRemovingFirstObject;

/**
 *  删掉数组中的最后一个元素
 *
 *  @return 数组
 */
- (NSArray *)t_arrayByRemovingLastObject;

/**
 *  添加object
 *
 *  @param object 将要添加的元素
 *
 *  @return 数组
 */
- (NSArray *)t_arrayByAddObject:(id)object;

/**
 *  判断数组中第index个元素是不是属于类型aClass
 *
 *  @param aClass 指定的类型
 *  @param index  index
 *
 *  @return obj
 */
- (id)objectOfClass:(Class)aClass atIndex:(NSUInteger)index;


@end
