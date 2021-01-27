//
//  NSArray+TCategory.m
//  TBasicLib
//
//  Created by kevin.huang on 14-8-4.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import "NSArray+TCategory.h"
#import <objc/runtime.h>

@implementation NSArray (TCategory)

#pragma mark -

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        Class class = NSClassFromString(@"NSArray");
        [self sjb_instanceSwizzleMethodWithClass:class
                                   orginalMethod:@selector(objectAtIndexedSubscript:)
                                   replaceMethod:@selector(t_objectAtIndexedSubscript:)];
        
        [self sjb_instanceSwizzleMethodWithClass:class
                                   orginalMethod:@selector(objectAtIndex:)
                                   replaceMethod:@selector(t_objectAtIndex:)];
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 11.0) {
            
            Class classTi = NSClassFromString(@"__NSArrayI");
            [self sjb_instanceSwizzleMethodWithClass:classTi
                                       orginalMethod:@selector(objectAtIndexedSubscript:)
                                       replaceMethod:@selector(ti_objectAtIndexedSubscript:)];
            
            [self sjb_instanceSwizzleMethodWithClass:classTi
                                       orginalMethod:@selector(objectAtIndex:)
                                       replaceMethod:@selector(ti_objectAtIndex:)];
            
            Class classTm = NSClassFromString(@"__NSArrayM");
            [self sjb_instanceSwizzleMethodWithClass:classTm
                                       orginalMethod:@selector(objectAtIndexedSubscript:)
                                       replaceMethod:@selector(tm_objectAtIndexedSubscript:)];
            
            [self sjb_instanceSwizzleMethodWithClass:classTm
                                       orginalMethod:@selector(objectAtIndex:)
                                       replaceMethod:@selector(tm_objectAtIndex:)];
            
            Class classCf = NSClassFromString(@"__NSCFArray");
            [self sjb_instanceSwizzleMethodWithClass:classCf
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

- (id)t_objectAtIndexedSubscript:(NSUInteger)idx {
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

- (id)objectForKeyedSubscript:(NSString *)key {
    return nil;
}

- (NSArray *)t_arrayByAddObject:(id)object {
    if (!object) {
        return self;
    }
    NSMutableArray *result = [NSMutableArray array];
    [result addObjectsFromArray:self];
    [result addObject:object];
    return result;
}

- (NSArray *)t_arrayByRemovingObject:(id)object {
	NSMutableArray *result = [self mutableCopy];
	[result removeObject:object];
	return result;
}

- (NSArray *)t_arrayByRemovingObjectAtIndex:(NSUInteger)index {
    if (index>=self.count) {
        return self;
    }
    NSMutableArray *result = [self mutableCopy];
	[result removeObjectAtIndex:index];
	return result;
}



- (NSArray *)t_arrayByRemovingFirstObject {
	if (self.count == 0) return self;
    
	return [self subarrayWithRange:NSMakeRange(1, self.count - 1)];
}

- (NSArray *)t_arrayByRemovingLastObject {
	if (self.count == 0) return self;
    
	return [self subarrayWithRange:NSMakeRange(0, self.count - 1)];
}

- (id)objectOfClass:(Class)aClass atIndex:(NSUInteger)index {
    id obj = self[index];
    if ([obj isKindOfClass:aClass]) {
        return obj;
    }
    return nil;
}


- (id)t_objectAtIndex:(NSUInteger)idx {
    if (idx < self.count) {
        return [self t_objectAtIndex:idx];
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

+ (void)sjb_instanceSwizzleMethodWithClass:(Class _Nonnull )klass
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
