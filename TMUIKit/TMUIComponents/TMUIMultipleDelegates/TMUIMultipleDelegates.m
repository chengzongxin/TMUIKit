//
//  TMUIMultipleDelegates.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/26.
//

#import "TMUIMultipleDelegates.h"
#import <objc/runtime.h>
#import <TMUIExtensions/NSObject+TMUI.h>

@interface TMUIMultipleDelegates ()

@property(nonatomic, strong, readwrite) NSPointerArray *delegates;
@property(nonatomic, strong) NSInvocation *forwardingInvocation;

@end

@implementation TMUIMultipleDelegates

+ (instancetype)weakDelegates {
    TMUIMultipleDelegates *delegates = [[self alloc] init];
    delegates.delegates = [NSPointerArray weakObjectsPointerArray];
    return delegates;
}

+ (instancetype)strongDelegates {
    TMUIMultipleDelegates *delegates = [[self alloc] init];
    delegates.delegates = [NSPointerArray strongObjectsPointerArray];
    return delegates;
}

- (void)resetClassNameIfNeeded {
    if ([self.parentObject isKindOfClass:CALayer.class] || [self.parentObject isKindOfClass:CAAnimation.class]) {
        // CALayer 和 CAAnimation 会缓存同一个 delegate class 的 respondsToSelector: 结果，但是在 multipleDelegates 的设计下，可能存在当前的 delegate 无法响应某个 selector，而后添加了可以响应的 delegate，系统这个缓存机制仍会认为无法响应，所以每次添加新的 delegate 都要设置与之前不同的 className
        // 这里设置一个 TMUIMultipleDelegates 的 subClass，其 className 由所有 delegate className 拼接而成。
        NSMutableString *className = [NSMutableString stringWithString:NSStringFromClass(TMUIMultipleDelegates.class)];
        [self.delegates.allObjects enumerateObjectsUsingBlock:^(id  _Nonnull delegate, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *delegateClassName = NSStringFromClass(object_getClass(delegate));
            [className appendFormat:@"_%@", delegateClassName];
        }];
        Class class = NSClassFromString(className);
        if (!class) {
            class = objc_allocateClassPair(TMUIMultipleDelegates.class, className.UTF8String, 0);
            objc_registerClassPair(class);
        }
        object_setClass(self, class);
    }
}

- (void)addDelegate:(id)delegate {
    if (![self containsDelegate:delegate] && delegate != self) {
        [self.delegates addPointer:(__bridge void *)delegate];
        [self resetClassNameIfNeeded];
    }
}

- (BOOL)removeDelegate:(id)delegate {
    NSUInteger index = [self.delegates tmui_indexOfPointer:(__bridge void *)delegate];
    if (index != NSNotFound) {
        [self.delegates removePointerAtIndex:index];
        return YES;
    }
    return NO;
}

- (void)removeAllDelegates {
    for (NSInteger i = self.delegates.count - 1; i >= 0; i--) {
        [self.delegates removePointerAtIndex:i];
    }
}

- (BOOL)containsDelegate:(id)delegate {
    return [self.delegates tmui_containsPointer:(__bridge void *)delegate];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *result = nil;
    NSPointerArray *delegates = [self.delegates copy];
    for (id delegate in delegates) {
        result = [delegate methodSignatureForSelector:aSelector];
        if (result && [delegate respondsToSelector:aSelector]) {
            return result;
        }
    }
    
//    return NSMethodSignature.tmui_avoidExceptionSignature;
    return [NSMethodSignature signatureWithObjCTypes:"@^v^c"]; // 兜底
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL selector = anInvocation.selector;
    
    // RAC 那边会把相同的 invocation 传回来 TMUIMultipleDelegates，引发死循环，所以这里做了个屏蔽
    // https://github.com/Tencent/TMUI_iOS/issues/970
    if (self.forwardingInvocation.selector != NULL && self.forwardingInvocation.selector == selector) {
        NSUInteger returnLength = anInvocation.methodSignature.methodReturnLength;
        if (returnLength) {
            void *buffer = (void *)malloc(returnLength);
            [self.forwardingInvocation getReturnValue:buffer];
            [anInvocation setReturnValue:buffer];
            free(buffer);
        }
        return;
    }
    
    NSPointerArray *delegates = self.delegates.copy;
    for (id delegate in delegates) {
        if ([delegate respondsToSelector:selector]) {
            // 当前 delegate 的实现可能再次调用原始 delegate 的实现，如果原始 delegate 是 TMUIMultipleDelegates 就会造成死循环，所以要做 2 事：
            // 1、检测到循环就打破
            // 2、但是检测到循环时，新生成的 anInvocation 默认没有 returnValue，需要用上一次循环之前的结果
            self.forwardingInvocation = anInvocation;
            [anInvocation invokeWithTarget:delegate];
        }
    }

    self.forwardingInvocation = nil;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    
    NSPointerArray *delegates = [self.delegates copy];
    for (id delegate in delegates) {
        if (class_respondsToSelector(self.class, aSelector)) {
            return YES;
        }
        
        // 对 TMUIMultipleDelegates 额外处理的解释在这里：https://github.com/Tencent/TMUI_iOS/issues/357
        BOOL delegateCanRespondToSelector = [delegate isKindOfClass:TMUIMultipleDelegates.class] ? [delegate respondsToSelector:aSelector] : class_respondsToSelector(object_getClass(delegate), aSelector);
        if (delegateCanRespondToSelector) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Overrides

- (BOOL)isKindOfClass:(Class)aClass {
    BOOL result = [super isKindOfClass:aClass];
    if (result) return YES;
    
    NSPointerArray *delegates = [self.delegates copy];
    for (id delegate in delegates) {
        if ([delegate isKindOfClass:aClass]) return YES;
    }
    
    return NO;
}

- (BOOL)isMemberOfClass:(Class)aClass {
    BOOL result = [super isMemberOfClass:aClass];
    if (result) return YES;
    
    NSPointerArray *delegates = [self.delegates copy];
    for (id delegate in delegates) {
        if ([delegate isMemberOfClass:aClass]) return YES;
    }
    
    return NO;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    BOOL result = [super conformsToProtocol:aProtocol];
    if (result) return YES;
    
    NSPointerArray *delegates = [self.delegates copy];
    for (id delegate in delegates) {
        if ([delegate conformsToProtocol:aProtocol]) return YES;
    }
    
    return NO;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, parentObject is %@, %@", [super description], self.parentObject, self.delegates];
}

- (id)valueForKey:(NSString *)key {
    NSPointerArray *delegates = [self.delegates copy];
    for (id delegate in delegates) {
        if ([delegate tmui_canGetValueForKey:key]) {
            return [delegate valueForKey:key];
        }
    }
    return [super valueForKey:key];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    NSPointerArray *delegates = [self.delegates copy];
    for (id delegate in delegates) {
        if ([delegate tmui_canSetValueForKey:key]) {
            [delegate setValue:value forKey:key];
        }
    }
}

@end


@implementation NSPointerArray (TMUI_TMUIMultipleDelegates)


//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        ExtendImplementationOfNonVoidMethodWithoutArguments([NSPointerArray class], @selector(description), NSString *, ^NSString *(NSPointerArray *selfObject, NSString *originReturnValue) {
//            NSMutableString *result = [[NSMutableString alloc] initWithString:originReturnValue];
//            NSPointerArray *array = [selfObject copy];
//            for (NSInteger i = 0; i < array.count; i++) {
//                ([result appendFormat:@"\npointer[%@] is %@", @(i), [array pointerAtIndex:i]]);
//            }
//            return result;
//        });
//    });
//}


- (NSUInteger)tmui_indexOfPointer:(nullable void *)pointer {
    if (!pointer) {
        return NSNotFound;
    }
    
    NSPointerArray *array = [self copy];
    for (NSUInteger i = 0; i < array.count; i++) {
        if ([array pointerAtIndex:i] == ((void *)pointer)) {
            return i;
        }
    }
    return NSNotFound;
}

- (BOOL)tmui_containsPointer:(void *)pointer {
    if (!pointer) {
        return NO;
    }
    if ([self tmui_indexOfPointer:pointer] != NSNotFound) {
        return YES;
    }
    return NO;
}

@end
