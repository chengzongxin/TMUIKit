//
//  UIVisualEffect+TMUITheme.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/4/8.
//


#import "UIVisualEffect+TMUITheme.h"
#import "TMUIThemeManager.h"
#import "TMUIThemeManagerCenter.h"
#import "TMUIThemePrivate.h"
#import "NSMethodSignature+TMUI.h"
#import "TMUICore.h"

@implementation TMUIThemeVisualEffect

- (id)copyWithZone:(NSZone *)zone {
    TMUIThemeVisualEffect *effect = [[self class] allocWithZone:zone];
    effect.managerName = self.managerName;
    effect.themeProvider = self.themeProvider;
    return effect;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *result = [super methodSignatureForSelector:aSelector];
    if (result) {
        return result;
    }
    
    result = [self.tmui_rawEffect methodSignatureForSelector:aSelector];
    if (result && [self.tmui_rawEffect respondsToSelector:aSelector]) {
        return result;
    }
    
    return [NSMethodSignature tmui_avoidExceptionSignature];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL selector = anInvocation.selector;
    if ([self.tmui_rawEffect respondsToSelector:selector]) {
        [anInvocation invokeWithTarget:self.tmui_rawEffect];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    
    return [self.tmui_rawEffect respondsToSelector:aSelector];
}

- (BOOL)isKindOfClass:(Class)aClass {
    if (aClass == TMUIThemeVisualEffect.class) return YES;
    return [self.tmui_rawEffect isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    if (aClass == TMUIThemeVisualEffect.class) return YES;
    return [self.tmui_rawEffect isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [self.tmui_rawEffect conformsToProtocol:aProtocol];
}

- (NSUInteger)hash {
    return (NSUInteger)self.themeProvider;
}

- (BOOL)isEqual:(id)object {
    return NO;
}

#pragma mark - <TMUIDynamicEffectProtocol>

- (UIVisualEffect *)tmui_rawEffect {
    TMUIThemeManager *manager = [TMUIThemeManagerCenter themeManagerWithName:self.managerName];
    return self.themeProvider(manager, manager.currentThemeIdentifier, manager.currentTheme).tmui_rawEffect;
}

- (BOOL)tmui_isDynamicEffect {
    return YES;
}

@end

@implementation UIVisualEffect (TMUITheme)

+ (UIVisualEffect *)tmui_effectWithThemeProvider:(UIVisualEffect * _Nonnull (^)(__kindof TMUIThemeManager * _Nonnull, __kindof NSObject<NSCopying> * _Nullable, __kindof NSObject * _Nullable))provider {
    return [UIVisualEffect tmui_effectWithThemeManagerName:TMUIThemeManagerNameDefault provider:provider];
}

+ (UIVisualEffect *)tmui_effectWithThemeManagerName:(__kindof NSObject<NSCopying> *)name provider:(UIVisualEffect * _Nonnull (^)(__kindof TMUIThemeManager * _Nonnull, __kindof NSObject<NSCopying> * _Nullable, __kindof NSObject * _Nullable))provider {
    TMUIThemeVisualEffect *effect = [[TMUIThemeVisualEffect alloc] init];
    effect.managerName = name;
    effect.themeProvider = provider;
    return (UIVisualEffect *)effect;
}

#pragma mark - <TMUIDynamicEffectProtocol>

- (UIVisualEffect *)tmui_rawEffect {
    return self;
}

- (BOOL)tmui_isDynamicEffect {
    return NO;
}

@end
