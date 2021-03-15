//
//  CAAnimation+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/13.
//

#import "CAAnimation+TMUI.h"
#import "TMUIRuntime.h"
#import "TMUIMultipleDelegates.h"

@interface _TMUICAAnimationDelegator : NSObject<CAAnimationDelegate>

@end

@implementation CAAnimation (TMUI)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ExtendImplementationOfNonVoidMethodWithSingleArgument([CAAnimation class], @selector(copyWithZone:), NSZone *, id, ^id(CAAnimation *selfObject, NSZone *firstArgv, id originReturnValue) {
            CAAnimation *animation = (CAAnimation *)originReturnValue;
            animation.tmui_multipleDelegatesEnabled = selfObject.tmui_multipleDelegatesEnabled;
            animation.tmui_animationDidStartBlock = selfObject.tmui_animationDidStartBlock;
            animation.tmui_animationDidStopBlock = selfObject.tmui_animationDidStopBlock;
            return animation;
        });
    });
}

- (void)enabledDelegateBlocks {
    self.tmui_multipleDelegatesEnabled = YES;
    BOOL shouldSetDelegator = !self.delegate;
    if (!shouldSetDelegator && [self.delegate isKindOfClass:[TMUIMultipleDelegates class]]) {
        TMUIMultipleDelegates *delegates = (TMUIMultipleDelegates *)self.delegate;
        NSPointerArray *array = delegates.delegates;
        for (NSUInteger i = 0; i < array.count; i++) {
            if ([((NSObject *)[array pointerAtIndex:i]) isKindOfClass:[_TMUICAAnimationDelegator class]]) {
                shouldSetDelegator = NO;
                break;
            }
        }
    }
    if (shouldSetDelegator) {
        self.delegate = [[_TMUICAAnimationDelegator alloc] init];// delegate is a strong property, it can retain _TMUICAAnimationDelegator
    }
}

static char kAssociatedObjectKey_animationDidStartBlock;
- (void)setTmui_animationDidStartBlock:(void (^)(__kindof CAAnimation *))tmui_animationDidStartBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_animationDidStartBlock, tmui_animationDidStartBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (tmui_animationDidStartBlock) {
        [self enabledDelegateBlocks];
    }
}

- (void (^)(__kindof CAAnimation *))tmui_animationDidStartBlock {
    return (void (^)(__kindof CAAnimation *))objc_getAssociatedObject(self, &kAssociatedObjectKey_animationDidStartBlock);
}

static char kAssociatedObjectKey_animationDidStopBlock;
- (void)setTmui_animationDidStopBlock:(void (^)(__kindof CAAnimation *, BOOL))tmui_animationDidStopBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_animationDidStopBlock, tmui_animationDidStopBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (tmui_animationDidStopBlock) {
        [self enabledDelegateBlocks];
    }
}

- (void (^)(__kindof CAAnimation *, BOOL))tmui_animationDidStopBlock {
    return (void (^)(__kindof CAAnimation *, BOOL))objc_getAssociatedObject(self, &kAssociatedObjectKey_animationDidStopBlock);
}

@end

@implementation _TMUICAAnimationDelegator

- (void)animationDidStart:(CAAnimation *)anim {
    if (anim.tmui_animationDidStartBlock) {
        anim.tmui_animationDidStartBlock(anim);
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim.tmui_animationDidStopBlock) {
        anim.tmui_animationDidStopBlock(anim, flag);
    }
}

@end

