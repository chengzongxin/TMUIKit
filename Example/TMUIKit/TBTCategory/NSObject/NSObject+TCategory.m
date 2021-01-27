//
//  NSObject+TCategory.m
//  HouseKeeper
//
//  Created by kevin.huang on 14-8-5.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import "NSObject+TCategory.h"
#import <objc/runtime.h>

@implementation NSObject (TCategory)

+ (instancetype)t_instance {
    return [self t_instanceForTarget:[UIApplication sharedApplication].delegate];
}

+ (void)t_setNilForDefaultTarget {
    [self t_setNilForTarget:[UIApplication sharedApplication].delegate];
}

+ (instancetype)t_instanceForTarget:(id)target {
    return [self t_instanceForTarget:target keyName:NSStringFromClass([self class])];
}

+ (void)t_setNilForTarget:(id)target {
    [self t_setNilForTarget:target keyName:NSStringFromClass([self class])];
}

+ (instancetype)t_instanceForTarget:(id)target keyName:(NSString *)strKeyName {
    if (!target) {
        NSAssert(YES, @"no target");
    }
    id obj = objc_getAssociatedObject(target, &strKeyName);
    if ([obj isKindOfClass:[self class]]) {
        return obj;
    }
    obj = [[self alloc]init];
    objc_setAssociatedObject(target, &strKeyName, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return obj;
}

+ (void)t_setNilForTarget:(id)target keyName:(NSString *)strKeyName {
    objc_setAssociatedObject(target, (__bridge const void *)(strKeyName), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@implementation TNone

@end
