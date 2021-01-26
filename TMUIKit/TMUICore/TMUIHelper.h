//
//  TMUIHelper.h
//  Masonry
//
//  Created by nigel.ning on 2020/4/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**提供工程全局可能用到的一些通用帮助方法*/
@interface TMUIHelper : NSObject

/**
 用一个 identifier 标记某一段 block，使其对应该 identifier 只会被运行一次
 @param block 要执行的一段逻辑
 @param identifier 唯一的标记，建议在 identifier 里添加当前这段业务的特有名称，例如用于 swizzle 的可以加“swizzled”前缀，以避免与其他业务共用同一个 identifier 引发 bug
 */
+ (BOOL)executeBlock:(void (NS_NOESCAPE ^)(void))block oncePerIdentifier:(NSString *)identifier;

@end

@interface TMUIHelper(Animation)

/**
 在 animationBlock 里的操作完成之后会调用 completionBlock，常用于一些不提供 completionBlock 的系统动画操作，例如 [UINavigationController pushViewController:animated:YES] 的场景，注意 UIScrollView 系列的滚动无法使用这个方法。

 @param animationBlock 要进行的带动画的操作
 @param completionBlock 操作完成后的回调
 @warning UIScrollView 系列的滚动无法使用这个方法
 @warning 不要在此方法的传参animationBlock里嵌套再调用此方法
 */
+ (void)executeAnimationBlock:(nonnull __attribute__((noescape)) void (^)(void))animationBlock completionBlock:(nullable __attribute__((noescape)) void (^)(void))completionBlock;

@end

NS_ASSUME_NONNULL_END
