//
//  NSObject+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/26.
//

#import "NSObject+TMUI.h"
#import "NSString+TMUI.h"
#import <objc/message.h>
#import <TMUICore/TMUICore.h>

@implementation NSObject (TMUI)


- (BOOL)tmui_hasOverrideMethod:(SEL)selector ofSuperclass:(Class)superclass {
    return [NSObject tmui_hasOverrideMethod:selector forClass:self.class ofSuperclass:superclass];
}

+ (BOOL)tmui_hasOverrideMethod:(SEL)selector forClass:(Class)aClass ofSuperclass:(Class)superclass {
    if (![aClass isSubclassOfClass:superclass]) {
        return NO;
    }
    
    if (![superclass instancesRespondToSelector:selector]) {
        return NO;
    }
    
    Method superclassMethod = class_getInstanceMethod(superclass, selector);
    Method instanceMethod = class_getInstanceMethod(aClass, selector);
    if (!instanceMethod || instanceMethod == superclassMethod) {
        return NO;
    }
    return YES;
}

- (id)tmui_performSelectorToSuperclass:(SEL)aSelector {
    struct objc_super mySuper;
    mySuper.receiver = self;
    mySuper.super_class = class_getSuperclass(object_getClass(self));
    
    id (*objc_superAllocTyped)(struct objc_super *, SEL) = (void *)&objc_msgSendSuper;
    return (*objc_superAllocTyped)(&mySuper, aSelector);
}

- (id)tmui_performSelectorToSuperclass:(SEL)aSelector withObject:(id)object {
    struct objc_super mySuper;
    mySuper.receiver = self;
    mySuper.super_class = class_getSuperclass(object_getClass(self));
    
    id (*objc_superAllocTyped)(struct objc_super *, SEL, ...) = (void *)&objc_msgSendSuper;
    return (*objc_superAllocTyped)(&mySuper, aSelector, object);
}

- (id)tmui_performSelector:(SEL)selector withArguments:(void *)firstArgument, ... {
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    
    if (firstArgument) {
        va_list valist;
        va_start(valist, firstArgument);
        [invocation setArgument:firstArgument atIndex:2];// 0->self, 1->_cmd
        
        void *currentArgument;
        NSInteger index = 3;
        while ((currentArgument = va_arg(valist, void *))) {
            [invocation setArgument:currentArgument atIndex:index];
            index++;
        }
        va_end(valist);
    }
    
    [invocation invoke];
    
    const char *typeEncoding = method_getTypeEncoding(class_getInstanceMethod(object_getClass(self), selector));
    
    if (strcmp(typeEncoding, @encode(id)) == 0 || strcmp(typeEncoding, @encode(Class)) == 0 || strcmp(typeEncoding, @encode(void (^)(void))) == 0) {
//    if (isObjectTypeEncoding(typeEncoding)) {
        __unsafe_unretained id returnValue;
        [invocation getReturnValue:&returnValue];
        return returnValue;
    }
    return nil;
}

- (void)tmui_performSelector:(SEL)selector withPrimitiveReturnValue:(void *)returnValue {
    [self tmui_performSelector:selector withPrimitiveReturnValue:returnValue arguments:nil];
}

- (void)tmui_performSelector:(SEL)selector withPrimitiveReturnValue:(void *)returnValue arguments:(void *)firstArgument, ... {
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    
    if (firstArgument) {
        va_list valist;
        va_start(valist, firstArgument);
        [invocation setArgument:firstArgument atIndex:2];// 0->self, 1->_cmd
        
        void *currentArgument;
        NSInteger index = 3;
        while ((currentArgument = va_arg(valist, void *))) {
            [invocation setArgument:currentArgument atIndex:index];
            index++;
        }
        va_end(valist);
    }
    
    [invocation invoke];
    
    if (returnValue) {
        [invocation getReturnValue:returnValue];
    }
}

- (void)tmui_enumrateIvarsUsingBlock:(void (^)(Ivar ivar, NSString *ivarDescription))block {
    [self tmui_enumrateIvarsIncludingInherited:NO usingBlock:block];
}

- (void)tmui_enumrateIvarsIncludingInherited:(BOOL)includingInherited usingBlock:(void (^)(Ivar ivar, NSString *ivarDescription))block {
    NSMutableArray<NSString *> *ivarDescriptions = [NSMutableArray new];
    NSString *ivarList = [self tmui_ivarList];
    NSError *error;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"in %@:(.*?)((?=in \\w+:)|$)", NSStringFromClass(self.class)] options:NSRegularExpressionDotMatchesLineSeparators error:&error];
    if (!error) {
        NSArray<NSTextCheckingResult *> *result = [reg matchesInString:ivarList options:NSMatchingReportCompletion range:NSMakeRange(0, ivarList.length)];
        [result enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *ivars = [ivarList substringWithRange:[obj rangeAtIndex:1]];
            [ivars enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
                if (![line hasPrefix:@"\t\t"]) {// 有些 struct 类型的变量，会把 struct 的成员也缩进打出来，所以用这种方式过滤掉
                    line = line.tmui_trim;
                    if (line.length > 2) {// 过滤掉空行或者 struct 结尾的"}"
                        NSRange range = [line rangeOfString:@":"];
                        if (range.location != NSNotFound)// 有些"unknow type"的变量不会显示指针地址（例如 UIView->_viewFlags）
                            line = [line substringToIndex:range.location];// 去掉指针地址
                        NSUInteger typeStart = [line rangeOfString:@" ("].location;
                        line = [NSString stringWithFormat:@"%@ %@", [line substringWithRange:NSMakeRange(typeStart + 2, line.length - 1 - (typeStart + 2))], [line substringToIndex:typeStart]];// 交换变量类型和变量名的位置，变量类型在前，变量名在后，空格隔开
                        [ivarDescriptions addObject:line];
                    }
                }
            }];
        }];
    }
    
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(self.class, &outCount);
    for (unsigned int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithFormat:@"%s", ivar_getName(ivar)];
        for (NSString *desc in ivarDescriptions) {
            if ([desc hasSuffix:ivarName]) {
                block(ivar, desc);
                break;
            }
        }
    }
    free(ivars);
    
    if (includingInherited) {
        Class superclass = self.superclass;
        if (superclass) {
            [NSObject tmui_enumrateIvarsOfClass:superclass includingInherited:includingInherited usingBlock:block];
        }
    }
}

+ (void)tmui_enumrateIvarsOfClass:(Class)aClass includingInherited:(BOOL)includingInherited usingBlock:(void (^)(Ivar, NSString *))block {
    if (!block) return;
    NSObject *obj = nil;
    if ([aClass isSubclassOfClass:[UICollectionView class]]) {
        obj = [[aClass alloc] initWithFrame:CGRectZero collectionViewLayout:UICollectionViewFlowLayout.new];
    } else if ([aClass isSubclassOfClass:[UIApplication class]]) {
        obj = UIApplication.sharedApplication;
    } else {
        obj = [aClass new];
    }
    [obj tmui_enumrateIvarsIncludingInherited:includingInherited usingBlock:block];
}

- (void)tmui_enumratePropertiesUsingBlock:(void (^)(objc_property_t property, NSString *propertyName))block {
    [NSObject tmui_enumratePropertiesOfClass:self.class includingInherited:NO usingBlock:block];
}

+ (void)tmui_enumratePropertiesOfClass:(Class)aClass includingInherited:(BOOL)includingInherited usingBlock:(void (^)(objc_property_t, NSString *))block {
    if (!block) return;
    
    unsigned int propertiesCount = 0;
    objc_property_t *properties = class_copyPropertyList(aClass, &propertiesCount);
    
    for (unsigned int i = 0; i < propertiesCount; i++) {
        objc_property_t property = properties[i];
        if (block) block(property, [NSString stringWithFormat:@"%s", property_getName(property)]);
    }
    
    free(properties);
    
    if (includingInherited) {
        Class superclass = class_getSuperclass(aClass);
        if (superclass) {
            [NSObject tmui_enumratePropertiesOfClass:superclass includingInherited:includingInherited usingBlock:block];
        }
    }
}

- (void)tmui_enumrateInstanceMethodsUsingBlock:(void (^)(Method, SEL))block {
    [NSObject tmui_enumrateInstanceMethodsOfClass:self.class includingInherited:NO usingBlock:block];
}

+ (void)tmui_enumrateInstanceMethodsOfClass:(Class)aClass includingInherited:(BOOL)includingInherited usingBlock:(void (^)(Method, SEL))block {
    if (!block) return;
    
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(aClass, &methodCount);
    
    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        if (block) block(method, selector);
    }
    
    free(methods);
    
    if (includingInherited) {
        Class superclass = class_getSuperclass(aClass);
        if (superclass) {
            [NSObject tmui_enumrateInstanceMethodsOfClass:superclass includingInherited:includingInherited usingBlock:block];
        }
    }
}

+ (void)tmui_enumerateProtocolMethods:(Protocol *)protocol usingBlock:(void (^)(SEL))block {
    if (!block) return;
    
    unsigned int methodCount = 0;
    struct objc_method_description *methods = protocol_copyMethodDescriptionList(protocol, NO, YES, &methodCount);
    for (int i = 0; i < methodCount; i++) {
        struct objc_method_description methodDescription = methods[i];
        if (block) {
            block(methodDescription.name);
        }
    }
    free(methods);
}

@end

@implementation NSObject (TMUI_KeyValueCoding)

- (id)tmui_valueForKey:(NSString *)key {
    if (@available(iOS 13.0, *)) {
        if ([self isKindOfClass:[UIView class]]) {
            BeginIgnoreUIKVCAccessProhibited
            id value = [self valueForKey:key];
            EndIgnoreUIKVCAccessProhibited
            return value;
        }
    }
    return [self valueForKey:key];
}

- (void)tmui_setValue:(id)value forKey:(NSString *)key {
    if (@available(iOS 13.0, *)) {
        if ([self isKindOfClass:[UIView class]]) {
            BeginIgnoreUIKVCAccessProhibited
            [self setValue:value forKey:key];
            EndIgnoreUIKVCAccessProhibited
            return;
        }
    }
    
    [self setValue:value forKey:key];
}

- (BOOL)tmui_canGetValueForKey:(NSString *)key {
    NSArray<NSString *> *getters = @[
        [NSString stringWithFormat:@"get%@", key.tmui_capitalizedString],   // get<Key>
        key,
        [NSString stringWithFormat:@"is%@", key.tmui_capitalizedString],    // is<Key>
        [NSString stringWithFormat:@"_%@", key]                             // _<key>
    ];
    for (NSString *selectorString in getters) {
        if ([self respondsToSelector:NSSelectorFromString(selectorString)]) return YES;
    }
    
    if (![self.class accessInstanceVariablesDirectly]) return NO;
    
    return [self _tmui_hasSpecifiedIvarWithKey:key];
}

- (BOOL)tmui_canSetValueForKey:(NSString *)key {
    NSArray<NSString *> *setter = @[
        [NSString stringWithFormat:@"set%@:", key.tmui_capitalizedString],   // set<Key>:
        [NSString stringWithFormat:@"_set%@", key.tmui_capitalizedString]   // _set<Key>
    ];
    for (NSString *selectorString in setter) {
        if ([self respondsToSelector:NSSelectorFromString(selectorString)]) return YES;
    }
    
    if (![self.class accessInstanceVariablesDirectly]) return NO;
    
    return [self _tmui_hasSpecifiedIvarWithKey:key];
}

- (BOOL)_tmui_hasSpecifiedIvarWithKey:(NSString *)key {
    __block BOOL result = NO;
    NSArray<NSString *> *ivars = @[
        [NSString stringWithFormat:@"_%@", key],
        [NSString stringWithFormat:@"_is%@", key.tmui_capitalizedString],
        key,
        [NSString stringWithFormat:@"is%@", key.tmui_capitalizedString]
    ];
    [NSObject tmui_enumrateIvarsOfClass:self.class includingInherited:YES usingBlock:^(Ivar  _Nonnull ivar, NSString * _Nonnull ivarDescription) {
        if (!result) {
            NSString *ivarName = [NSString stringWithFormat:@"%s", ivar_getName(ivar)];
            if ([ivars containsObject:ivarName]) {
                result = YES;
            }
        }
    }];
    return result;
}

@end


@implementation NSObject (TMUI_DataBind)

static char kAssociatedObjectKey_TMUIAllBoundObjects;
- (NSMutableDictionary<id, id> *)tmui_allBoundObjects {
    NSMutableDictionary<id, id> *dict = objc_getAssociatedObject(self, &kAssociatedObjectKey_TMUIAllBoundObjects);
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &kAssociatedObjectKey_TMUIAllBoundObjects, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dict;
}

- (void)tmui_bindObject:(id)object forKey:(NSString *)key {
    if (!key.length) {
        NSAssert(NO, @"");
        return;
    }
    if (object) {
        [[self tmui_allBoundObjects] setObject:object forKey:key];
    } else {
        [[self tmui_allBoundObjects] removeObjectForKey:key];
    }
}

- (void)tmui_bindObjectWeakly:(id)object forKey:(NSString *)key {
    if (!key.length) {
        NSAssert(NO, @"");
        return;
    }
    if (object) {
        TMUIWeakObjectContainer *container = [[TMUIWeakObjectContainer alloc] initWithObject:object];
        [self tmui_bindObject:container forKey:key];
    } else {
        [[self tmui_allBoundObjects] removeObjectForKey:key];
    }
}

- (id)tmui_getBoundObjectForKey:(NSString *)key {
    if (!key.length) {
        NSAssert(NO, @"");
        return nil;
    }
    id storedObj = [[self tmui_allBoundObjects] objectForKey:key];
    if ([storedObj isKindOfClass:[TMUIWeakObjectContainer class]]) {
        storedObj = [(TMUIWeakObjectContainer *)storedObj object];
    }
    return storedObj;
}

- (void)tmui_bindDouble:(double)doubleValue forKey:(NSString *)key {
    [self tmui_bindObject:@(doubleValue) forKey:key];
}

- (double)tmui_getBoundDoubleForKey:(NSString *)key {
    id object = [self tmui_getBoundObjectForKey:key];
    if ([object isKindOfClass:[NSNumber class]]) {
        double doubleValue = [(NSNumber *)object doubleValue];
        return doubleValue;
        
    } else {
        return 0.0;
    }
}

- (void)tmui_bindBOOL:(BOOL)boolValue forKey:(NSString *)key {
    [self tmui_bindObject:@(boolValue) forKey:key];
}

- (BOOL)tmui_getBoundBOOLForKey:(NSString *)key {
    id object = [self tmui_getBoundObjectForKey:key];
    if ([object isKindOfClass:[NSNumber class]]) {
        BOOL boolValue = [(NSNumber *)object boolValue];
        return boolValue;
        
    } else {
        return NO;
    }
}

- (void)tmui_bindLong:(long)longValue forKey:(NSString *)key {
    [self tmui_bindObject:@(longValue) forKey:key];
}

- (long)tmui_getBoundLongForKey:(NSString *)key {
    id object = [self tmui_getBoundObjectForKey:key];
    if ([object isKindOfClass:[NSNumber class]]) {
        long longValue = [(NSNumber *)object longValue];
        return longValue;
        
    } else {
        return 0;
    }
}

- (void)tmui_clearBindingForKey:(NSString *)key {
    [self tmui_bindObject:nil forKey:key];
}

- (void)tmui_clearAllBinding {
    [[self tmui_allBoundObjects] removeAllObjects];
}

- (NSArray<NSString *> *)tmui_allBindingKeys {
    NSArray<NSString *> *allKeys = [[self tmui_allBoundObjects] allKeys];
    return allKeys;
}

- (BOOL)tmui_hasBindingKey:(NSString *)key {
    return [[self tmui_allBindingKeys] containsObject:key];
}

@end

@implementation NSObject (TMUI_Debug)

BeginIgnorePerformSelectorLeaksWarning
- (NSString *)tmui_methodList {
    return [self performSelector:NSSelectorFromString(@"_methodDescription")];
}

- (NSString *)tmui_shortMethodList {
    return [self performSelector:NSSelectorFromString(@"_shortMethodDescription")];
}

- (NSString *)tmui_ivarList {
    return [self performSelector:NSSelectorFromString(@"_ivarDescription")];
}
EndIgnorePerformSelectorLeaksWarning

@end

@implementation NSThread (TMUI_KVC)

TMUISynthesizeBOOLProperty(tmui_shouldIgnoreUIKVCAccessProhibited, setTmui_shouldIgnoreUIKVCAccessProhibited)

@end

@interface NSException (TMUI_KVC)

@end

@implementation NSException (TMUI_KVC)

//+ (void)load {
//    if (@available(iOS 13.0, *)) {
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            OverrideImplementation(object_getClass([NSException class]), @selector(raise:format:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
//                return ^(NSObject *selfObject, NSExceptionName raise, NSString *format, ...) {
//                    
//                    if (raise == NSGenericException && [format isEqualToString:@"Access to %@'s %@ ivar is prohibited. This is an application bug"]) {
//                        BOOL shouldIgnoreUIKVCAccessProhibited = ((TMUICMIActivated && IgnoreKVCAccessProhibited) || NSThread.currentThread.tmui_shouldIgnoreUIKVCAccessProhibited);
//                        if (shouldIgnoreUIKVCAccessProhibited) return;
//                        
//                        TMUILogWarn(@"NSObject (TMUI)", @"使用 KVC 访问了 UIKit 的私有属性，会触发系统的 NSException，建议尽量避免此类操作，仍需访问可使用 BeginIgnoreUIKVCAccessProhibited 和 EndIgnoreUIKVCAccessProhibited 把相关代码包裹起来，或者直接使用 tmui_valueForKey: 、tmui_setValue:forKey:");
//                    }
//                    
//                    id (*originSelectorIMP)(id, SEL, NSExceptionName name, NSString *, ...);
//                    originSelectorIMP = (id (*)(id, SEL, NSExceptionName name, NSString *, ...))originalIMPProvider();
//                    va_list args;
//                    va_start(args, format);
//                    NSString *reason =  [[NSString alloc] initWithFormat:format arguments:args];
//                    originSelectorIMP(selfObject, originCMD, raise, reason);
//                    va_end(args);
//                };
//            });
//        });
//    }
//}

@end



@implementation NSObject (TMUI_Associate)

+ (instancetype)tmui_instance {
    return [self tmui_instanceForTarget:[UIApplication sharedApplication].delegate];
}

+ (void)tmui_setNilForDefaultTarget {
    [self tmui_setNilForTarget:[UIApplication sharedApplication].delegate];
}

+ (instancetype)tmui_instanceForTarget:(id)target {
    return [self tmui_instanceForTarget:target keyName:NSStringFromClass([self class])];
}

+ (void)tmui_setNilForTarget:(id)target {
    [self tmui_setNilForTarget:target keyName:NSStringFromClass([self class])];
}

+ (instancetype)tmui_instanceForTarget:(id)target keyName:(NSString *)strKeyName {
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

+ (void)tmui_setNilForTarget:(id)target keyName:(NSString *)strKeyName {
    objc_setAssociatedObject(target, (__bridge const void *)(strKeyName), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end



@implementation NSObject (TMUI_Extensions)

+ (BOOL)tmui_overrideMethod:(SEL)origSel withMethod:(SEL)altSel{
    Method origMethod =class_getInstanceMethod(self, origSel);
    if (!origSel) {
        NSLog(@"original method %@ not found for class %@", NSStringFromSelector(origSel), [self class]);
        return NO;
    }

    Method altMethod =class_getInstanceMethod(self, altSel);
    if (!altMethod) {
        NSLog(@"original method %@ not found for class %@", NSStringFromSelector(altSel), [self class]);
        return NO;
    }

    method_setImplementation(origMethod, class_getMethodImplementation(self, altSel));

    return YES;
}

+ (BOOL)tmui_overrideClassMethod:(SEL)origSel withClassMethod:(SEL)altSel{
    Class c = object_getClass((id)self);
    return [c tmui_overrideMethod:origSel withMethod:altSel];
}

+ (BOOL)tmui_exchangeMethod:(SEL)origSel withMethod:(SEL)altSel{
    Method origMethod =class_getInstanceMethod(self, origSel);
    if (!origSel) {
        NSLog(@"original method %@ not found for class %@", NSStringFromSelector(origSel), [self class]);
        return NO;
    }

    Method altMethod =class_getInstanceMethod(self, altSel);
    if (!altMethod) {
        NSLog(@"original method %@ not found for class %@", NSStringFromSelector(altSel), [self class]);
        return NO;
    }

    class_addMethod(self,
                    origSel,
                    class_getMethodImplementation(self, origSel),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel,
                    class_getMethodImplementation(self, altSel),
                    method_getTypeEncoding(altMethod));

    method_exchangeImplementations(class_getInstanceMethod(self, origSel),class_getInstanceMethod(self, altSel));

    return YES;
}

+ (BOOL)tmui_exchangeClassMethod:(SEL)origSel withClassMethod:(SEL)altSel{
    Class c = object_getClass((id)self);
    return [c tmui_exchangeMethod:origSel withMethod:altSel];
}


- (NSDictionary *)tmui_propertiesToDictionary{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}
@end
