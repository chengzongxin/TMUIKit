//
//  NSArray+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/25.
//

#import "NSArray+TMUI.h"
#import <objc/runtime.h>
#import "TMUIRuntime.h"

#define TMUI_OBJECT_AT_INDEXED_SUBSCRIPT(cls) \
- (id)tmui_##cls##_objectAtIndexedSubscript:(NSUInteger)idx {\
    if (idx<self.count) {\
        return [self objectAtIndex:idx];\
    }\
    NSLog(@"array beyond bounds [%@ %@]",NSStringFromClass(self.class),NSStringFromSelector(_cmd));\
    return nil;\
}\
- (id)tmui_##cls##_objectAtIndex:(NSUInteger)idx {\
    if (idx < self.count) {\
        return [self tmui_##cls##_objectAtIndex:idx];\
    }\
    NSLog(@"array beyond bounds [%@ %@]",NSStringFromClass(self.class),NSStringFromSelector(_cmd));\
    return nil;\
}


@implementation NSArray (TMUI)


TMUI_OBJECT_AT_INDEXED_SUBSCRIPT(NSArray);
TMUI_OBJECT_AT_INDEXED_SUBSCRIPT(__NSArray0);
TMUI_OBJECT_AT_INDEXED_SUBSCRIPT(__NSSingleObjectArrayI);
TMUI_OBJECT_AT_INDEXED_SUBSCRIPT(__NSArrayI);
TMUI_OBJECT_AT_INDEXED_SUBSCRIPT(__NSArrayM);

#pragma clang diagnostic pop


// MARK: Crash Avoid
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // MARK: 访问越界处理
        NSArray *classes = @[@"NSArray",@"__NSArray0",@"__NSSingleObjectArrayI",@"__NSArrayI",@"__NSArrayM"];
        for (NSString *cls in classes) {
            Class class = NSClassFromString(cls);
            NSString *objectAtIndexStr = [NSString stringWithFormat:@"tmui_%@_objectAtIndex:",cls];
            NSString *objectAtIndexedSubscriptStr = [NSString stringWithFormat:@"tmui_%@_objectAtIndexedSubscript:",cls];
            
            ExchangeImplementations(class, @selector(objectAtIndex:), NSSelectorFromString(objectAtIndexStr));
            ExchangeImplementations(class, @selector(objectAtIndexedSubscript:), NSSelectorFromString(objectAtIndexedSubscriptStr));
        }
        
        // insert crash
        ExchangeImplementations(NSClassFromString(@"__NSArrayM"), @selector(insertObject:atIndex:), @selector(tmui___NSArrayM_insertObject:atIndex:));
        
    });
    
    
}

- (void)tmui___NSArrayM_insertObject:(id)object atIndex:(NSInteger)index{
    if (object && index <= self.count) {
        [self tmui___NSArrayM_insertObject:object atIndex:index];
    }else{
        NSLog(@"insert beyond bounds %@,%@",self,NSStringFromSelector(_cmd));
    }
}

// MARK: Function
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

- (NSArray *)tmui_filter:(BOOL (NS_NOESCAPE^)(id _Nonnull))block {
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

- (NSArray *)tmui_map:(id (NS_NOESCAPE^)(id item))block {
    if (!block) {
        return self;
    }

    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:self.count];
    for (NSInteger i = 0; i < self.count; i++) {
        [result addObject:block(self[i])];
    }
    return [result copy];
}

- (id)tmui_reduce:(id(NS_NOESCAPE^)(id accumulator, id item))handle initial:(id)initial {
    if (!handle || !self || !initial) return self;
    if (self.count <1) return initial;
    
    id value = initial;
    for (id obj in self) {
        value = handle(value, obj);
    }
    return value;
}

- (void)tmui_forEach:(void(NS_NOESCAPE^)(id))handle {
    if (!handle || !self) return;
    
    for (id obj in self) {
        handle(obj);
    }
}

@end



@implementation NSArray (TMUI_Extensions)

#pragma mark -


- (NSArray *)tmui_arrayByAddObject:(id)object {
    if (!object) {
        return self;
    }
    NSMutableArray *result = [NSMutableArray array];
    [result addObjectsFromArray:self];
    [result addObject:object];
    return result;
}

- (NSArray *)tmui_arrayByInsertObject:(id)object atIndex:(NSInteger)idx {
    if (!object || idx > self.count - 1 || idx < 0) {
        return self;
    }
    NSMutableArray *result = [NSMutableArray array];
    [result addObjectsFromArray:self];
    [result insertObject:object atIndex:idx];
    return result;
}

- (NSArray *)tmui_arrayByRemovingObject:(id)object {
    NSMutableArray *result = [self mutableCopy];
    [result removeObject:object];
    return result;
}

- (NSArray *)tmui_arrayByRemovingObjectAtIndex:(NSUInteger)index {
    if (index>=self.count) {
        return self;
    }
    NSMutableArray *result = [self mutableCopy];
    [result removeObjectAtIndex:index];
    return result;
}



- (NSArray *)tmui_arrayByRemovingFirstObject {
    if (self.count == 0) return self;
    
    return [self subarrayWithRange:NSMakeRange(1, self.count - 1)];
}

- (NSArray *)tmui_arrayByRemovingLastObject {
    if (self.count == 0) return self;
    
    return [self subarrayWithRange:NSMakeRange(0, self.count - 1)];
}

- (id)tmui_objectOfClass:(Class)aClass atIndex:(NSUInteger)index {
    id obj = self[index];
    if ([obj isKindOfClass:aClass]) {
        return obj;
    }
    return nil;
}

- (NSArray *)tmui_reverse {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [array exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
    return array;
}

- (NSArray *)tmui_shuffle {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self];
    for (NSUInteger i = self.count; i > 1; i--) {
        [array exchangeObjectAtIndex:(i - 1)
                  withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
    return array;
}
@end
