//
//  NSURL+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (TMUI)

/**
 *  获取当前 query 的参数列表。
 *
 *  @return query 参数列表，以字典返回。如果 absoluteString 为 nil 则返回 nil
 */
@property(nonatomic, copy, readonly) NSDictionary<NSString *, NSString *> *tmui_queryItems;

- (id)tmui_parameterValueForKey:(NSString *)key;

- (instancetype)tmui_replaceParameterKey:(NSString *)key withValue:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
