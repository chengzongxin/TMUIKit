//
//  TMUIAppearance.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/5/7.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUIAppearance.h"
#import "TMUICore.h"

@implementation TMUIAppearance

static NSMutableDictionary *appearances;
+ (id)appearanceForClass:(Class)aClass {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!appearances) {
            appearances = NSMutableDictionary.new;
        }
    });
    NSString *className = NSStringFromClass(aClass);
    id appearance = appearances[className];
    if (!appearance) {
        BeginIgnorePerformSelectorLeaksWarning
        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"_%@:%@:", @"appearanceForClass", @"withContainerList"]);
        appearance = [NSClassFromString(@"_UIAppearance") performSelector:selector withObject:aClass withObject:nil];
        appearances[className] = appearance;
        EndIgnorePerformSelectorLeaksWarning
    }
    return appearance;
}

@end

BeginIgnoreClangWarning(-Wincomplete-implementation)
@interface NSObject (TMUIAppearance_Private)
@property(nonatomic, assign) BOOL tmui_applyingAppearance;
+ (instancetype)appearance;
@end

@implementation NSObject (TMUIAppearnace)
TMUISynthesizeBOOLProperty(tmui_applyingAppearance, setTmui_applyingAppearance)

/**
 关于 appearance 要考虑这几点：
 1. 是否产生内存泄漏
 2. 父类的 appearance 能否在子类里生效
 3. 如果某个 property 在 ClassA 里声明为 UI_APPEARANCE_SELECTOR，则在子类 Class B : Class A 里获取该 property 的值将为 nil，这是正常的，系统默认行为如此，系统是在应用 appearance 的时候发现子类的 property 值为 nil 时才会从父类里读取值，在这个阶段才完成继承效果。
 */
- (void)tmui_applyAppearance {
    Class class = self.class;
    if ([class respondsToSelector:@selector(appearance)]) {
        // -[_UIAppearance _applyInvocationsTo:window:] 会调用 _appearanceGuideClass，如果不是 UIView 或者 UIViewController 的子类，需要额外实现这个方法。
        SEL appearanceGuideClassSelector = NSSelectorFromString(@"_appearanceGuideClass");
        if (!class_respondsToSelector(class, appearanceGuideClassSelector)) {
            const char * typeEncoding = method_getTypeEncoding(class_getInstanceMethod(UIView.class, appearanceGuideClassSelector));
            class_addMethod(class, appearanceGuideClassSelector, imp_implementationWithBlock(^Class(void) {
                return nil;
            }), typeEncoding);
        }
        
        self.tmui_applyingAppearance = YES;
        BeginIgnorePerformSelectorLeaksWarning
        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"_%@:%@:", @"applyInvocationsTo", @"window"]);
        [NSClassFromString(@"_UIAppearance") performSelector:selector withObject:self withObject:nil];
        EndIgnorePerformSelectorLeaksWarning
        self.tmui_applyingAppearance = NO;
    }
}

@end
EndIgnoreClangWarning
