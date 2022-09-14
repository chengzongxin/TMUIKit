//
//  NSObject+TMUIMultipleDelegates.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/26.
//

#import "NSObject+TMUIMultipleDelegates.h"
#import "TMUIMultipleDelegates.h"
#import "TMUICore.h"
#import "NSString+TMUI.h"
#import <TMUICore/TMUICore.h>
#import "TMUIRuntime.h"
#import "TMUICommonDefines.h"


@interface NSObject ()

@property(nonatomic, strong) NSMutableDictionary<NSString *, TMUIMultipleDelegates *> *tmuimd_delegates;
@end


@implementation NSObject (TMUIMultipleDelegates)

TMUISynthesizeIdStrongProperty(tmuimd_delegates, setTmuimd_delegates)

static char kAssociatedObjectKey_tmuiMultipleDelegatesEnabled;
- (void)setTmui_multipleDelegatesEnabled:(BOOL)tmui_multipleDelegatesEnabled{
    objc_setAssociatedObject(self, &kAssociatedObjectKey_tmuiMultipleDelegatesEnabled, @(tmui_multipleDelegatesEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (tmui_multipleDelegatesEnabled) {
        if (!self.tmuimd_delegates) {
            self.tmuimd_delegates = [NSMutableDictionary dictionary];
        }
        [self tmui_registerDelegateSelector:@selector(delegate)];
        if ([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]]) {
            [self tmui_registerDelegateSelector:@selector(dataSource)];
        }
    }
}
- (BOOL)tmui_multipleDelegatesEnabled{
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_tmuiMultipleDelegatesEnabled)) boolValue];
}

- (void)tmui_registerDelegateSelector:(SEL)getter {
    if (!self.tmui_multipleDelegatesEnabled) {
        return;
    }
    
    Class targetClass = [self class];
    SEL originDelegateSetter = setterWithGetter(getter);
    SEL newDelegateSetter = [self newSetterWithGetter:getter];
    Method originMethod = class_getInstanceMethod(targetClass, originDelegateSetter);
    if (!originMethod) {
        return;
    }
    
    // 为这个 selector 创建一个 TMUIMultipleDelegates 容器
    NSString *delegateGetterKey = NSStringFromSelector(getter);
    if (!self.tmuimd_delegates[delegateGetterKey]) {
        objc_property_t prop = class_getProperty(self.class, delegateGetterKey.UTF8String);
        TMUIPropertyDescriptor *property = [TMUIPropertyDescriptor descriptorWithProperty:prop];
        if (property.isStrong) {
            // strong property
            TMUIMultipleDelegates *strongDelegates = [TMUIMultipleDelegates strongDelegates];
            strongDelegates.parentObject = self;
            self.tmuimd_delegates[delegateGetterKey] = strongDelegates;
        } else {
            // weak property
            TMUIMultipleDelegates *weakDelegates = [TMUIMultipleDelegates weakDelegates];
            weakDelegates.parentObject = self;
            self.tmuimd_delegates[delegateGetterKey] = weakDelegates;
        }
    }
    
    [TMUIHelper executeBlock:^{
        IMP originIMP = method_getImplementation(originMethod);
        void (*originSelectorIMP)(id, SEL, id);
        originSelectorIMP = (void (*)(id, SEL, id))originIMP;
        
        BOOL isAddedMethod = class_addMethod(targetClass, newDelegateSetter, imp_implementationWithBlock(^(NSObject *selfObject, id aDelegate){
            
            // 这一段保护的原因请查看 https://github.com/Tencent/TMUI_iOS/issues/292
            if (!selfObject.tmui_multipleDelegatesEnabled || selfObject.class != targetClass) {
                originSelectorIMP(selfObject, originDelegateSetter, aDelegate);
                return;
            }
            
            TMUIMultipleDelegates *delegates = selfObject.tmuimd_delegates[delegateGetterKey];
            
            if (!aDelegate) {
                // 对应 setDelegate:nil，表示清理所有的 delegate
                [delegates removeAllDelegates];
                // 只要 tmui_multipleDelegatesEnabled 开启，就会保证 delegate 一直是 delegates，所以不去调用系统默认的 set nil
                // originSelectorIMP(selfObject, originDelegateSetter, nil);
                return;
            }
            
            if (aDelegate != delegates) {// 过滤掉容器自身，避免把 delegates 传进去 delegates 里，导致死循环
                [delegates addDelegate:aDelegate];
            }
            
            originSelectorIMP(selfObject, originDelegateSetter, nil);// 先置为 nil 再设置 delegates，从而避免这个问题 https://github.com/Tencent/TMUI_iOS/issues/305
            originSelectorIMP(selfObject, originDelegateSetter, delegates);// 不管外面将什么 object 传给 setDelegate:，最终实际上传进去的都是 TMUIMultipleDelegates 容器
            
        }), method_getTypeEncoding(originMethod));
        if (isAddedMethod) {
            Method newMethod = class_getInstanceMethod(targetClass, newDelegateSetter);
            method_exchangeImplementations(originMethod, newMethod);
        }
    } oncePerIdentifier:[NSString stringWithFormat:@"MultipleDelegates %@-%@", NSStringFromClass(targetClass), NSStringFromSelector(getter)]];
    
    // 如果原来已经有 delegate，则将其加到新建的容器里
    // @see https://github.com/Tencent/TMUI_iOS/issues/378
    BeginIgnorePerformSelectorLeaksWarning
    id originDelegate = [self performSelector:getter];
    if (originDelegate && originDelegate != self.tmuimd_delegates[delegateGetterKey]) {
        [self performSelector:originDelegateSetter withObject:originDelegate];
    }
    EndIgnorePerformSelectorLeaksWarning
}

- (void)tmui_removeDelegate:(id)delegate {
    if (!self.tmui_multipleDelegatesEnabled) {
        return;
    }
    NSMutableArray<NSString *> *delegateGetters = [[NSMutableArray alloc] init];
    [self.tmuimd_delegates enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, TMUIMultipleDelegates * _Nonnull obj, BOOL * _Nonnull stop) {
        BOOL removeSucceed = [obj removeDelegate:delegate];
        if (removeSucceed) {
            [delegateGetters addObject:key];
        }
    }];
    if (delegateGetters.count > 0) {
        for (NSString *getterString in delegateGetters) {
            [self refreshDelegateWithGetter:NSSelectorFromString(getterString)];
        }
    }
}

- (void)refreshDelegateWithGetter:(SEL)getter {
    SEL originSetterSEL = [self newSetterWithGetter:getter];
    BeginIgnorePerformSelectorLeaksWarning
    id originDelegate = [self performSelector:getter];
    [self performSelector:originSetterSEL withObject:nil];// 先置为 nil 再设置 delegates，从而避免这个问题 https://github.com/Tencent/TMUI_iOS/issues/305
    [self performSelector:originSetterSEL withObject:originDelegate];
    EndIgnorePerformSelectorLeaksWarning
}

// 根据 delegate property 的 getter，得到 TMUIMultipleDelegates 为它的 setter 创建的新 setter 方法，最终交换原方法，因此利用这个方法返回的 SEL，可以调用到原来的 delegate property setter 的实现
- (SEL)newSetterWithGetter:(SEL)getter {
    return NSSelectorFromString([NSString stringWithFormat:@"tmuimd_%@", NSStringFromSelector(setterWithGetter(getter))]);
}
@end
