//
// Created by Fussa on 2019/11/15.
// Copyright (c) 2019 com.upintech. All rights reserved.
//

#import "NSMutableArray+MTFY.h"
#import <objc/runtime.h>


@implementation NSMutableArray (MTFY)
+ (void)load {
    [super load];
    //无论怎样 都要保证方法只交换一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //交换NSMutableArray中的方法
        [objc_getClass("__NSArrayM") mtfy_systemSelector:@selector(objectAtIndex:) swizzledSelector:@selector(s_objectAtIndex:) error:nil];
        //交换NSMutableArray中的方法
        [objc_getClass("__NSArrayM") mtfy_systemSelector:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(s_objectAtIndexedSubscript:) error:nil];
    });
}

- (id)s_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self s_objectAtIndex:index];
    } else {
        NSLog(@"数组越界, 已处理: %ld, %ld, %@", index, self.count, [self class]);
        return nil;
    }
}

- (id)s_objectAtIndexedSubscript:(NSUInteger)index {
    if (index < self.count) {
        return [self s_objectAtIndexedSubscript:index];
    } else {
        NSLog(@"数组越界, 已处理: %ld, %ld, %@", index, self.count, [self class]);
        return nil;
    }
}
@end