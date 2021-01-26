//
//  NSPointerArray+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/26.
//

#import "NSPointerArray+TMUI.h"

@implementation NSPointerArray (TMUI)


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


- (NSUInteger)qmui_indexOfPointer:(nullable void *)pointer {
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

- (BOOL)qmui_containsPointer:(void *)pointer {
    if (!pointer) {
        return NO;
    }
    if ([self qmui_indexOfPointer:pointer] != NSNotFound) {
        return YES;
    }
    return NO;
}

@end

