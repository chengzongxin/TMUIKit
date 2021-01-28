//
//  NSArray+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/25.
//

#import "NSArray+TMUI.h"
#import <objc/runtime.h>
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



@implementation NSArray (TMUI_Extensions)

#pragma mark -

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        Class class = NSClassFromString(@"NSArray");
        [self tmui_instanceSwizzleMethodWithClass:class
                                   orginalMethod:@selector(objectAtIndexedSubscript:)
                                   replaceMethod:@selector(tmui_objectAtIndexedSubscript:)];
        
        [self tmui_instanceSwizzleMethodWithClass:class
                                   orginalMethod:@selector(objectAtIndex:)
                                   replaceMethod:@selector(tmui_objectAtIndex:)];
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 11.0) {
            
            Class classTi = NSClassFromString(@"__NSArrayI");
            [self tmui_instanceSwizzleMethodWithClass:classTi
                                       orginalMethod:@selector(objectAtIndexedSubscript:)
                                       replaceMethod:@selector(ti_objectAtIndexedSubscript:)];
            
            [self tmui_instanceSwizzleMethodWithClass:classTi
                                       orginalMethod:@selector(objectAtIndex:)
                                       replaceMethod:@selector(ti_objectAtIndex:)];
            
            Class classTm = NSClassFromString(@"__NSArrayM");
            [self tmui_instanceSwizzleMethodWithClass:classTm
                                       orginalMethod:@selector(objectAtIndexedSubscript:)
                                       replaceMethod:@selector(tm_objectAtIndexedSubscript:)];
            
            [self tmui_instanceSwizzleMethodWithClass:classTm
                                       orginalMethod:@selector(objectAtIndex:)
                                       replaceMethod:@selector(tm_objectAtIndex:)];
            
            Class classCf = NSClassFromString(@"__NSCFArray");
            [self tmui_instanceSwizzleMethodWithClass:classCf
                                       orginalMethod:@selector(objectAtIndexedSubscript:)
                                       replaceMethod:@selector(tcf_objectAtIndexedSubscript:)];
        }
    });
}

- (id)firstObject {
    if(!self) return nil;
    if (self.count>0) {
        return [self objectAtIndex:0];
    } else {
        return nil;
    }
}

- (id)tmui_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx<self.count) {
        return [self objectAtIndex:idx];
    }
    return nil;
}

- (id)ti_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx<self.count) {
        return [self objectAtIndex:idx];
    }
    return nil;
}

- (id)tm_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx<self.count) {
        return [self objectAtIndex:idx];
    }
    return nil;
}

- (id)tcf_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx<self.count) {
        return [self objectAtIndex:idx];
    }
    return nil;
}

- (id)tmui_objectForKeyedSubscript:(NSString *)key {
    return nil;
}

- (NSArray *)tmui_arrayByAddObject:(id)object {
    if (!object) {
        return self;
    }
    NSMutableArray *result = [NSMutableArray array];
    [result addObjectsFromArray:self];
    [result addObject:object];
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


- (id)tmui_objectAtIndex:(NSUInteger)idx {
    if (idx < self.count) {
        return [self tmui_objectAtIndex:idx];
    }
    return nil;
}

- (id)ti_objectAtIndex:(NSUInteger)idx {
    if (idx < self.count) {
        return [self ti_objectAtIndex:idx];
    }
    return nil;
}

- (id)tm_objectAtIndex:(NSUInteger)idx {
    if (idx < self.count) {
        return [self tm_objectAtIndex:idx];
    }
    return nil;
}

+ (void)tmui_instanceSwizzleMethodWithClass:(Class _Nonnull )klass
                             orginalMethod:(SEL _Nonnull )originalSelector
                             replaceMethod:(SEL _Nonnull )replaceSelector {
    Method origMethod = class_getInstanceMethod(klass, originalSelector);
    Method replaceMeathod = class_getInstanceMethod(klass, replaceSelector);
    
    // class_addMethod:如果发现方法已经存在，会失败返回，也可以用来做检查用,我们这里是为了避免源方法没有实现的情况;
    //                 如果方法没有存在,我们则先尝试添加被替换的方法的实现;
    BOOL didAddMethod = class_addMethod(klass,
                                        originalSelector,
                                        method_getImplementation(replaceMeathod),
                                        method_getTypeEncoding(replaceMeathod));
    if (didAddMethod) {
        // 原方法未实现，则替换原方法防止crash
        class_replaceMethod(klass,
                            replaceSelector,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    } else {
        // 添加失败：说明源方法已经有实现，直接将两个方法的实现交换即
        method_exchangeImplementations(origMethod, replaceMeathod);
    }
}
@end
