//
//  NSArray+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (TMUI)

/**
 将多个对象合并成一个数组，如果参数类型是数组则会将数组内的元素拆解出来加到 return 内（只会拆解一层，所以多维数组不处理）

 @param object 要合并的多个数组
 @return 合并完的结果
 */
+ (instancetype)tmui_arrayWithObjects:(ObjectType)object, ...;

/**
 *  将多维数组打平成一维数组再遍历所有子元素
 */
- (void)tmui_enumerateNestedArrayWithBlock:(void (NS_NOESCAPE^)(id obj, BOOL *stop))block;

/**
 *  将多维数组递归转换成 mutable 多维数组
 */
- (NSMutableArray *)tmui_mutableCopyNestedArray;

/**
 *  过滤数组元素，将 block 返回 YES 的 item 重新组装成一个数组返回
 *  Usages:
 *   [@[@1,@2,@5,@11,@6,@0,@3] tmui_filter:^BOOL(NSNumber *obj) {return (obj.intValue %2 != 0)}];

 */
- (NSArray<ObjectType> *)tmui_filter:(BOOL (NS_NOESCAPE^)(ObjectType item))block;

/**
*  转换数组元素，将每个 item 都经过 block 转换成一遍 返回转换后的新数组
 Usages: NSArray *languages = @[@"objctive-c", @"java", @"swift",@"javascript", @"php"];
 languages = [languages tmui_map:^id _Nonnull(NSString *obj) {
   return [obj stringByAppendingString:@" !!"];
 }];
*/
- (NSArray *)tmui_map:(id (NS_NOESCAPE^)(ObjectType item))block;

/**
 * 按照规则将组内元素一一合并，返回最终结果
 * Usages: id result = [words tmui_reduce:^id _Nonnull(NSString *obj1, NSString *obj2) {
            return [NSString stringWithFormat:@"%@%@", obj1, obj2];
            } initial:@""];
 */

- (id)tmui_reduce:(id(NS_NOESCAPE^)(ObjectType accumulator, ObjectType item))handle initial:(id)initial;
/**
 * 对每个元素做操作
 * Usages: [subviews tmui_forEach:^(UIView *view) {  [view removeFromSuperview];  }];
 */

- (void)tmui_forEach:(void(NS_NOESCAPE^)(id))handle;

@end


@interface NSArray (TMUI_Extensions)

/**
 *  删掉object
 *
 *  @param object 将要删掉的元素
 *
 *  @return 数组
 */
- (NSArray *)tmui_arrayByRemovingObject:(id)object;

/**
 *  删掉数组中的第index个元素
 *
 *  @param index 将要删掉的元素的index
 *
 *  @return 数组
 */
- (NSArray *)tmui_arrayByRemovingObjectAtIndex:(NSUInteger)index;

/**
 *  删掉数组中的第一个元素
 *
 *  @return 数组
 */
- (NSArray *)tmui_arrayByRemovingFirstObject;

/**
 *  删掉数组中的最后一个元素
 *
 *  @return 数组
 */
- (NSArray *)tmui_arrayByRemovingLastObject;

/**
 *  添加object
 *
 *  @param object 将要添加的元素
 *
 *  @return 数组
 */
- (NSArray *)tmui_arrayByAddObject:(id)object;

/**
 *  添加object
 *
 *  @param object 将要添加的元素
 *  @param idx 插入的索引位置
 *
 *  @return 数组
 */
- (NSArray *)tmui_arrayByInsertObject:(id)object atIndex:(NSInteger)idx;

/**
 *  判断数组中第index个元素是不是属于类型aClass
 *
 *  @param aClass 指定的类型
 *  @param index  index
 *
 *  @return obj
 */
- (id)tmui_objectOfClass:(Class)aClass atIndex:(NSUInteger)index;

/**
 Reverse the index of object in this array.
 Example: Before @[ @1, @2, @3 ], After @[ @3, @2, @1 ].
 */
- (NSArray *)tmui_reverse;

/**
 Sort the object in this array randomly.
 */
- (NSArray *)tmui_shuffle;

@end


NS_ASSUME_NONNULL_END
