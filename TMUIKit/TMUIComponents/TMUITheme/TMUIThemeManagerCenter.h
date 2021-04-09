//
//  TMUIThemeManagerCenter.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/4/8.
//

#import <Foundation/Foundation.h>
#import "TMUIThemeManager.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const TMUIThemeManagerNameDefault;

/**
 用于获取 TMUIThemeManager，具体使用请查看 TMUIThemeManager 的注释。
 */
@interface TMUIThemeManagerCenter : NSObject

@property(class, nonatomic, strong, readonly) TMUIThemeManager *defaultThemeManager;
@property(class, nonatomic, copy, readonly) NSArray<TMUIThemeManager *> *themeManagers;
+ (nullable TMUIThemeManager *)themeManagerWithName:(__kindof NSObject<NSCopying> *)name;
@end

NS_ASSUME_NONNULL_END
