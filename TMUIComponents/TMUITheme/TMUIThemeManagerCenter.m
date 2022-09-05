//
//  TMUIThemeManagerCenter.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/4/8.
//

#import "TMUIThemeManagerCenter.h"

NSString *const TMUIThemeManagerNameDefault = @"Default";

@interface TMUIThemeManager ()

// 这个方法的实现在 TMUIThemeManager.m 里，这里只是为了内部使用而显式声明一次
- (instancetype)initWithName:(__kindof NSObject<NSCopying> *)name;
@end

@interface TMUIThemeManagerCenter ()

@property(nonatomic, strong) NSMutableArray<TMUIThemeManager *> *allManagers;
@end

@implementation TMUIThemeManagerCenter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static TMUIThemeManagerCenter *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
        instance.allManagers = NSMutableArray.new;
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

+ (TMUIThemeManager *)themeManagerWithName:(__kindof NSObject<NSCopying> *)name {
    TMUIThemeManagerCenter *center = [TMUIThemeManagerCenter sharedInstance];
    for (TMUIThemeManager *manager in center.allManagers) {
        if ([manager.name isEqual:name]) return manager;
    }
    TMUIThemeManager *manager = [[TMUIThemeManager alloc] initWithName:name];
    [center.allManagers addObject:manager];
    return manager;
}

+ (TMUIThemeManager *)defaultThemeManager {
    return [TMUIThemeManagerCenter themeManagerWithName:TMUIThemeManagerNameDefault];
}

+ (NSArray<TMUIThemeManager *> *)themeManagers {
    return [TMUIThemeManagerCenter sharedInstance].allManagers.copy;
}

@end
