//
//  UIScrollView+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/18.
//

#import "UIScrollView+TMUI.h"
#import "TMUICore.h"
//#import "NSNumber+TMUI.h"
#import "UIView+TMUI.h"
#import "UIViewController+TMUI.h"


@interface UIScrollView ()

@property(nonatomic, assign) CGFloat tmuiscroll_lastInsetTopWhenScrollToTop;
@property(nonatomic, assign) BOOL tmuiscroll_hasSetInitialContentInset;
@end

@implementation UIScrollView (TMUI)

TMUISynthesizeCGFloatProperty(tmuiscroll_lastInsetTopWhenScrollToTop, setTmuiscroll_lastInsetTopWhenScrollToTop)
TMUISynthesizeBOOLProperty(tmuiscroll_hasSetInitialContentInset, setTmuiscroll_hasSetInitialContentInset)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        OverrideImplementation([UIScrollView class], @selector(description), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^NSString *(UIScrollView *selfObject) {
                // call super
                NSString *(*originSelectorIMP)(id, SEL);
                originSelectorIMP = (NSString *(*)(id, SEL))originalIMPProvider();
                NSString *result = originSelectorIMP(selfObject, originCMD);
                
                if (NSThread.isMainThread) {
                    result = ([NSString stringWithFormat:@"%@, contentInset = %@", result, NSStringFromUIEdgeInsets(selfObject.contentInset)]);
                    if (@available(iOS 13.0, *)) {
                        result = result.mutableCopy;
                    }
                }
                return result;
            };
        });
        
//        if (@available(iOS 13.0, *)) {
//            if (AdjustScrollIndicatorInsetsByContentInsetAdjustment) {
//                OverrideImplementation([UIScrollView class], @selector(setContentInsetAdjustmentBehavior:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
//                    return ^(UIScrollView *selfObject, UIScrollViewContentInsetAdjustmentBehavior firstArgv) {
//
//                        // call super
//                        void (*originSelectorIMP)(id, SEL, UIScrollViewContentInsetAdjustmentBehavior);
//                        originSelectorIMP = (void (*)(id, SEL, UIScrollViewContentInsetAdjustmentBehavior))originalIMPProvider();
//                        originSelectorIMP(selfObject, originCMD, firstArgv);
//
//                        if (firstArgv == UIScrollViewContentInsetAdjustmentNever) {
//                            selfObject.automaticallyAdjustsScrollIndicatorInsets = NO;
//                        } else {
//                            selfObject.automaticallyAdjustsScrollIndicatorInsets = YES;
//                        }
//                    };
//                });
//            }
//        }
    });
}

- (BOOL)tmui_alreadyAtTop {
    if (((NSInteger)self.contentOffset.y) == -((NSInteger)self.tmui_contentInset.top)) {
        return YES;
    }
    
    return NO;
}

- (BOOL)tmui_alreadyAtBottom {
    if (!self.tmui_canScroll) {
        return YES;
    }
    
    if (((NSInteger)self.contentOffset.y) == ((NSInteger)self.contentSize.height + self.tmui_contentInset.bottom - CGRectGetHeight(self.bounds))) {
        return YES;
    }
    
    return NO;
}

- (UIEdgeInsets)tmui_contentInset {
    if (@available(iOS 11, *)) {
        return self.adjustedContentInset;
    } else {
        return self.contentInset;
    }
}

static char kAssociatedObjectKey_initialContentInset;
- (void)setTmui_initialContentInset:(UIEdgeInsets)tmui_initialContentInset {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_initialContentInset, [NSValue valueWithUIEdgeInsets:tmui_initialContentInset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.contentInset = tmui_initialContentInset;
    self.scrollIndicatorInsets = tmui_initialContentInset;
    if (!self.tmuiscroll_hasSetInitialContentInset || !self.tmui_viewController
        ) {
        [self tmui_scrollToTopUponContentInsetTopChange];
    }
    self.tmuiscroll_hasSetInitialContentInset = YES;
}

- (UIEdgeInsets)tmui_initialContentInset {
    return [((NSValue *)objc_getAssociatedObject(self, &kAssociatedObjectKey_initialContentInset)) UIEdgeInsetsValue];
}

- (BOOL)tmui_canScroll {
    // 没有高度就不用算了，肯定不可滚动，这里只是做个保护
    if (CGSizeIsEmpty(self.bounds.size)) {
        return NO;
    }
    BOOL canVerticalScroll = self.contentSize.height + UIEdgeInsetsGetVerticalValue(self.tmui_contentInset) > CGRectGetHeight(self.bounds);
    BOOL canHorizontalScoll = self.contentSize.width + UIEdgeInsetsGetHorizontalValue(self.tmui_contentInset) > CGRectGetWidth(self.bounds);
    return canVerticalScroll || canHorizontalScoll;
}

- (void)tmui_scrollToTopForce:(BOOL)force animated:(BOOL)animated {
    if (force || (!force && [self tmui_canScroll])) {
        [self setContentOffset:CGPointMake(-self.tmui_contentInset.left, -self.tmui_contentInset.top) animated:animated];
    }
}

- (void)tmui_scrollToTopAnimated:(BOOL)animated {
    [self tmui_scrollToTopForce:NO animated:animated];
}

- (void)tmui_scrollToTop {
    [self tmui_scrollToTopAnimated:NO];
}

- (void)tmui_scrollToTopUponContentInsetTopChange {
    if (self.tmuiscroll_lastInsetTopWhenScrollToTop != self.contentInset.top) {
        [self tmui_scrollToTop];
        self.tmuiscroll_lastInsetTopWhenScrollToTop = self.contentInset.top;
    }
}

- (void)tmui_scrollToBottomAnimated:(BOOL)animated {
    if ([self tmui_canScroll]) {
        [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentSize.height + self.tmui_contentInset.bottom - CGRectGetHeight(self.bounds)) animated:animated];
    }
}

- (void)tmui_scrollToBottom {
    [self tmui_scrollToBottomAnimated:NO];
}

- (void)tmui_stopDeceleratingIfNeeded {
    if (self.decelerating) {
        [self setContentOffset:self.contentOffset animated:NO];
    }
}

- (void)tmui_setContentInset:(UIEdgeInsets)contentInset animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:.25 delay:0 options:TMUIViewAnimationOptionsCurveOut animations:^{
            self.contentInset = contentInset;
        } completion:nil];
    } else {
        self.contentInset = contentInset;
    }
}

@end
