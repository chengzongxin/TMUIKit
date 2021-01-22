//
// Created by Fussa on 2019/11/15.
// Copyright (c) 2019 com.upintech. All rights reserved.
//

#import "NSArray+MTFY.h"


@implementation NSArray (MTFY)

+ (void)load {
    [super load];
    //无论怎样 都要保证方法只交换一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //交换NSArray中的objectAtIndex方法
        [objc_getClass("__NSArrayI") mtfy_systemSelector:@selector(objectAtIndex:) swizzledSelector:@selector(s_objectAtIndex:) error:nil];
        //交换NSArray中的objectAtIndexedSubscript方法
        [objc_getClass("__NSArrayI") mtfy_systemSelector:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(s_objectAtIndexedSubscript:) error:nil];
    });
}

- (id)s_objectAtIndexedSubscript:(NSUInteger)index {
    if (index < self.count) {
        return [self s_objectAtIndexedSubscript:index];
    } else {
        NSLog(@"数组越界, 已处理: %ld, %ld, %@", index, self.count, [self class]);
        return nil;
    }
}

- (id)s_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self s_objectAtIndex:index];
    } else {
        NSLog(@"数组越界, 已处理: %ld, %ld, %@", index, self.count, [self class]);
        return nil;
    }
}

- (NSArray *)mtfy_replace:(id)object atIndex:(NSInteger)index {
    NSMutableArray *array = [self mutableCopy];
    if (!object) {
        return self;
    }
    if (index > array.count - 1) {
        return self;
    }
    if (index < 0) {
        return self;
    }
    array[index] = object;
    return [NSArray arrayWithArray:array];
}

@end
