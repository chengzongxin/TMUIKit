//
//  NSArray+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/25.
//

#import "NSArray+TMUI.h"

@implementation NSArray (TMUI)

+ (instancetype)tmui_arrayWithObjects:(id)object, ... {
    void (^addObjectToArrayBlock)(NSMutableArray *array, id obj) = ^void(NSMutableArray *array, id obj) {
        if ([obj isKindOfClass:[NSArray class]]) {
            [array addObjectsFromArray:obj];
        } else {
            [array addObject:obj];
        }
    };
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    addObjectToArrayBlock(result, object);
    
    va_list argumentList;
    va_start(argumentList, object);
    id argument;
    while ((argument = va_arg(argumentList, id))) {
        addObjectToArrayBlock(result, argument);
    }
    va_end(argumentList);
    if ([self isKindOfClass:[NSMutableArray class]]) {
        return result;
    }
    return result.copy;
}

- (void)tmui_enumerateNestedArrayWithBlock:(void (NS_NOESCAPE ^)(id _Nonnull, BOOL *))block {
    BOOL stop = NO;
    for (NSInteger i = 0; i < self.count; i++) {
        id object = self[i];
        if ([object isKindOfClass:[NSArray class]]) {
            [((NSArray *)object) tmui_enumerateNestedArrayWithBlock:block];
        } else {
            block(object, &stop);
        }
        if (stop) {
            return;
        }
    }
}

- (NSMutableArray *)tmui_mutableCopyNestedArray {
    NSMutableArray *mutableResult = [self mutableCopy];
    for (NSInteger i = 0; i < self.count; i++) {
        id object = self[i];
        if ([object isKindOfClass:[NSArray class]]) {
            NSMutableArray *mutableItem = [((NSArray *)object) tmui_mutableCopyNestedArray];
            [mutableResult replaceObjectAtIndex:i withObject:mutableItem];
        }
    }
    return mutableResult;
}

- (NSArray *)tmui_filterWithBlock:(BOOL (NS_NOESCAPE^)(id _Nonnull))block {
    if (!block) {
        return self;
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.count; i++) {
        id item = self[i];
        if (block(item)) {
            [result addObject:item];
        }
    }
    return [result copy];
}

- (NSArray *)tmui_mapWithBlock:(id (NS_NOESCAPE^)(id item))block {
    if (!block) {
        return self;
    }

    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:self.count];
    for (NSInteger i = 0; i < self.count; i++) {
        [result addObject:block(self[i])];
    }
    return [result copy];
}

@end
