//
//  MTFYMoudleBase.m
//  Matafy
//
//  Created by Tiaotiao on 2019/5/20.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYMoudleBase.h"


@interface MTFYMoudleBase ()

/**
 提供api的类
 */
@property (nonatomic, strong) NSMapTable<NSString *, id<NSObject>> *provideApiInstanceTable;

@end


@implementation MTFYMoudleBase

+ (NSString *)moduleKey
{
    NSAssert(NO, @"模块:%@没有实现moduleKey方法", NSStringFromClass(self.class));
    return nil;
}

- (void)addProviceApiInstance:(id<NSObject>)instance
{
    NSParameterAssert(instance);
    [self.provideApiInstanceTable setObject:instance forKey:NSStringFromClass(instance.class)];
}

- (id<NSObject>)findForwardingTarget:(SEL)aSelector
{
    id<NSObject> target = nil;
    
    if ([super respondsToSelector:aSelector]) {
        target = self;
        return target;
    }
    
    NSArray<id<NSObject>> *allInstances = self.provideApiInstanceTable.objectEnumerator.allObjects;
    for (id<NSObject> instance in allInstances) {
        if ([instance respondsToSelector:aSelector]) {
            target = instance;
            break;
        }
    }
    
    return target;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    
    id<NSObject> target = [self findForwardingTarget:aSelector];
    
    if (target) {
        return YES;
    }
    
    return [super respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    id<NSObject> target = [self findForwardingTarget:aSelector];
    
    if (target) {
        return target;
    }
    
    return [super forwardingTargetForSelector:aSelector];
}

- (NSMapTable<NSString *, id<NSObject>> *)provideApiInstanceTable
{
    if (!_provideApiInstanceTable) {
        _provideApiInstanceTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableWeakMemory capacity:16];
    }
    
    return _provideApiInstanceTable;
}

@end
