//
//  UIBarItem+TMUIBadge.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/29.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UIBarItem+TMUIBadge.h"
#import "TMUICore.h"
#import "UIView+TMUIBadge.h"
#import "UIBarItem+TMUI.h"

@implementation UIBarItem (TMUIBadge)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 保证配置表里的默认值正确被设置
        ExtendImplementationOfNonVoidMethodWithoutArguments([UIBarItem class], @selector(init), __kindof UIBarItem *, ^__kindof UIBarItem *(UIBarItem *selfObject, __kindof UIBarItem *originReturnValue) {
            [selfObject tmuibaritem_didInitialize];
            return originReturnValue;
        });
        
        ExtendImplementationOfNonVoidMethodWithSingleArgument([UIBarItem class], @selector(initWithCoder:), NSCoder *, __kindof UIBarItem *, ^__kindof UIBarItem *(UIBarItem *selfObject, NSCoder *firstArgv, __kindof UIBarItem *originReturnValue) {
            [selfObject tmuibaritem_didInitialize];
            return originReturnValue;
        });
        
        // UITabBarButton 在 layoutSubviews 时每次都重新让 imageView 和 label addSubview:，这会导致我们用 tmui_layoutSubviewsBlock 时产生持续的重复调用（但又不死循环，因为每次都在下一次 runloop 执行，而且奇怪的是如果不放到下一次 runloop，反而不会重复调用），所以这里 hack 地屏蔽 addSubview: 操作
        OverrideImplementation(NSClassFromString([NSString stringWithFormat:@"%@%@", @"UITab", @"BarButton"]), @selector(addSubview:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIView *selfObject, UIView *firstArgv) {
                
                if (firstArgv.superview == selfObject) {
                    return;
                }
                
                // call super
                IMP originalIMP = originalIMPProvider();
                void (*originSelectorIMP)(id, SEL, UIView *);
                originSelectorIMP = (void (*)(id, SEL, UIView *))originalIMP;
                originSelectorIMP(selfObject, originCMD, firstArgv);
            };
        });
    });
}

- (void)tmuibaritem_didInitialize {
    if (TMUICMIActivated) {
        self.tmui_badgeBackgroundColor = BadgeBackgroundColor;
        self.tmui_badgeTextColor = BadgeTextColor;
        self.tmui_badgeFont = BadgeFont;
        self.tmui_badgeContentEdgeInsets = BadgeContentEdgeInsets;
        self.tmui_badgeOffset = BadgeOffset;
        self.tmui_badgeOffsetLandscape = BadgeOffsetLandscape;
        
        self.tmui_updatesIndicatorColor = UpdatesIndicatorColor;
        self.tmui_updatesIndicatorSize = UpdatesIndicatorSize;
        self.tmui_updatesIndicatorOffset = UpdatesIndicatorOffset;
        self.tmui_updatesIndicatorOffsetLandscape = UpdatesIndicatorOffsetLandscape;
        
        BeginIgnoreDeprecatedWarning
        self.tmui_badgeCenterOffset = BadgeCenterOffset;
        self.tmui_badgeCenterOffsetLandscape = BadgeCenterOffsetLandscape;
        self.tmui_updatesIndicatorCenterOffset = UpdatesIndicatorCenterOffset;
        self.tmui_updatesIndicatorCenterOffsetLandscape = UpdatesIndicatorCenterOffsetLandscape;
        EndIgnoreClangWarning
    }
}

#pragma mark - Badge

static char kAssociatedObjectKey_badgeInteger;
- (void)setTmui_badgeInteger:(NSUInteger)tmui_badgeInteger {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_badgeInteger, @(tmui_badgeInteger), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_badgeString = tmui_badgeInteger > 0 ? [NSString stringWithFormat:@"%@", @(tmui_badgeInteger)] : nil;
}

- (NSUInteger)tmui_badgeInteger {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_badgeInteger)) unsignedIntegerValue];
}

static char kAssociatedObjectKey_badgeString;
- (void)setTmui_badgeString:(NSString *)tmui_badgeString {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_badgeString, tmui_badgeString, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (tmui_badgeString.length) {
        [self updateViewDidSetBlockIfNeeded];
    }
    self.tmui_view.tmui_badgeString = tmui_badgeString;
}

- (NSString *)tmui_badgeString {
    return (NSString *)objc_getAssociatedObject(self, &kAssociatedObjectKey_badgeString);
}

static char kAssociatedObjectKey_badgeBackgroundColor;
- (void)setTmui_badgeBackgroundColor:(UIColor *)tmui_badgeBackgroundColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_badgeBackgroundColor, tmui_badgeBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_view.tmui_badgeBackgroundColor = tmui_badgeBackgroundColor;
}

- (UIColor *)tmui_badgeBackgroundColor {
    return (UIColor *)objc_getAssociatedObject(self, &kAssociatedObjectKey_badgeBackgroundColor);
}

static char kAssociatedObjectKey_badgeTextColor;
- (void)setTmui_badgeTextColor:(UIColor *)tmui_badgeTextColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_badgeTextColor, tmui_badgeTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_view.tmui_badgeTextColor = tmui_badgeTextColor;
}

- (UIColor *)tmui_badgeTextColor {
    return (UIColor *)objc_getAssociatedObject(self, &kAssociatedObjectKey_badgeTextColor);
}

static char kAssociatedObjectKey_badgeFont;
- (void)setTmui_badgeFont:(UIFont *)tmui_badgeFont {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_badgeFont, tmui_badgeFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_view.tmui_badgeFont = tmui_badgeFont;
}

- (UIFont *)tmui_badgeFont {
    return (UIFont *)objc_getAssociatedObject(self, &kAssociatedObjectKey_badgeFont);
}

static char kAssociatedObjectKey_badgeContentEdgeInsets;
- (void)setTmui_badgeContentEdgeInsets:(UIEdgeInsets)tmui_badgeContentEdgeInsets {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_badgeContentEdgeInsets, [NSValue valueWithUIEdgeInsets:tmui_badgeContentEdgeInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_view.tmui_badgeContentEdgeInsets = tmui_badgeContentEdgeInsets;
}

- (UIEdgeInsets)tmui_badgeContentEdgeInsets {
    return [((NSValue *)objc_getAssociatedObject(self, &kAssociatedObjectKey_badgeContentEdgeInsets)) UIEdgeInsetsValue];
}

static char kAssociatedObjectKey_badgeOffset;
- (void)setTmui_badgeOffset:(CGPoint)tmui_badgeOffset {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_badgeOffset, @(tmui_badgeOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_view.tmui_badgeOffset = tmui_badgeOffset;
}

- (CGPoint)tmui_badgeOffset {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_badgeOffset)) CGPointValue];
}

static char kAssociatedObjectKey_badgeOffsetLandscape;
- (void)setTmui_badgeOffsetLandscape:(CGPoint)tmui_badgeOffsetLandscape {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_badgeOffsetLandscape, @(tmui_badgeOffsetLandscape), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_view.tmui_badgeOffsetLandscape = tmui_badgeOffsetLandscape;
}

- (CGPoint)tmui_badgeOffsetLandscape {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_badgeOffsetLandscape)) CGPointValue];
}

BeginIgnoreDeprecatedWarning
BeginIgnoreClangWarning(-Wdeprecated-implementations)

static char kAssociatedObjectKey_badgeCenterOffset;
- (void)setTmui_badgeCenterOffset:(CGPoint)tmui_badgeCenterOffset {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_badgeCenterOffset, [NSValue valueWithCGPoint:tmui_badgeCenterOffset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_view.tmui_badgeCenterOffset = tmui_badgeCenterOffset;
}

- (CGPoint)tmui_badgeCenterOffset {
    return [((NSValue *)objc_getAssociatedObject(self, &kAssociatedObjectKey_badgeCenterOffset)) CGPointValue];
}

static char kAssociatedObjectKey_badgeCenterOffsetLandscape;
- (void)setTmui_badgeCenterOffsetLandscape:(CGPoint)tmui_badgeCenterOffsetLandscape {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_badgeCenterOffsetLandscape, [NSValue valueWithCGPoint:tmui_badgeCenterOffsetLandscape], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_view.tmui_badgeCenterOffsetLandscape = tmui_badgeCenterOffsetLandscape;
}

- (CGPoint)tmui_badgeCenterOffsetLandscape {
    return [((NSValue *)objc_getAssociatedObject(self, &kAssociatedObjectKey_badgeCenterOffsetLandscape)) CGPointValue];
}

EndIgnoreClangWarning
EndIgnoreDeprecatedWarning

- (TMUILabel *)tmui_badgeLabel {
    return self.tmui_view.tmui_badgeLabel;
}

#pragma mark - UpdatesIndicator

static char kAssociatedObjectKey_shouldShowUpdatesIndicator;
- (void)setTmui_shouldShowUpdatesIndicator:(BOOL)tmui_shouldShowUpdatesIndicator {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_shouldShowUpdatesIndicator, @(tmui_shouldShowUpdatesIndicator), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (tmui_shouldShowUpdatesIndicator) {
        [self updateViewDidSetBlockIfNeeded];
    }
    self.tmui_view.tmui_shouldShowUpdatesIndicator = tmui_shouldShowUpdatesIndicator;
}

- (BOOL)tmui_shouldShowUpdatesIndicator {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_shouldShowUpdatesIndicator)) boolValue];
}

static char kAssociatedObjectKey_updatesIndicatorColor;
- (void)setTmui_updatesIndicatorColor:(UIColor *)tmui_updatesIndicatorColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorColor, tmui_updatesIndicatorColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_view.tmui_updatesIndicatorColor = tmui_updatesIndicatorColor;
}

- (UIColor *)tmui_updatesIndicatorColor {
    return (UIColor *)objc_getAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorColor);
}

static char kAssociatedObjectKey_updatesIndicatorSize;
- (void)setTmui_updatesIndicatorSize:(CGSize)tmui_updatesIndicatorSize {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorSize, [NSValue valueWithCGSize:tmui_updatesIndicatorSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_view.tmui_updatesIndicatorSize = tmui_updatesIndicatorSize;
}

- (CGSize)tmui_updatesIndicatorSize {
    return [((NSValue *)objc_getAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorSize)) CGSizeValue];
}

static char kAssociatedObjectKey_updatesIndicatorOffset;
- (void)setTmui_updatesIndicatorOffset:(CGPoint)tmui_updatesIndicatorOffset {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorOffset, @(tmui_updatesIndicatorOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_view.tmui_updatesIndicatorOffset = tmui_updatesIndicatorOffset;
}

- (CGPoint)tmui_updatesIndicatorOffset {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorOffset)) CGPointValue];
}

static char kAssociatedObjectKey_updatesIndicatorOffsetLandscape;
- (void)setTmui_updatesIndicatorOffsetLandscape:(CGPoint)tmui_updatesIndicatorOffsetLandscape {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorOffsetLandscape, @(tmui_updatesIndicatorOffsetLandscape), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_view.tmui_updatesIndicatorOffsetLandscape = tmui_updatesIndicatorOffsetLandscape;
}

- (CGPoint)tmui_updatesIndicatorOffsetLandscape {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorOffsetLandscape)) CGPointValue];
}

BeginIgnoreDeprecatedWarning
BeginIgnoreClangWarning(-Wdeprecated-implementations)

static char kAssociatedObjectKey_updatesIndicatorCenterOffset;
- (void)setTmui_updatesIndicatorCenterOffset:(CGPoint)tmui_updatesIndicatorCenterOffset {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorCenterOffset, [NSValue valueWithCGPoint:tmui_updatesIndicatorCenterOffset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_view.tmui_updatesIndicatorCenterOffset = tmui_updatesIndicatorCenterOffset;
}

- (CGPoint)tmui_updatesIndicatorCenterOffset {
    return [((NSValue *)objc_getAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorCenterOffset)) CGPointValue];
}

static char kAssociatedObjectKey_updatesIndicatorCenterOffsetLandscape;
- (void)setTmui_updatesIndicatorCenterOffsetLandscape:(CGPoint)tmui_updatesIndicatorCenterOffsetLandscape {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorCenterOffsetLandscape, [NSValue valueWithCGPoint:tmui_updatesIndicatorCenterOffsetLandscape], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_view.tmui_updatesIndicatorCenterOffsetLandscape = tmui_updatesIndicatorCenterOffsetLandscape;
}

- (CGPoint)tmui_updatesIndicatorCenterOffsetLandscape {
    return [((NSValue *)objc_getAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorCenterOffsetLandscape)) CGPointValue];
}

EndIgnoreClangWarning
EndIgnoreDeprecatedWarning

- (UIView *)tmui_updatesIndicatorView {
    return self.tmui_view.tmui_updatesIndicatorView;
}

#pragma mark - Common

- (void)updateViewDidSetBlockIfNeeded {
    if (!self.tmui_viewDidSetBlock) {
        self.tmui_viewDidSetBlock = ^(__kindof UIBarItem * _Nonnull item, UIView * _Nullable view) {
            view.tmui_badgeBackgroundColor = item.tmui_badgeBackgroundColor;
            view.tmui_badgeTextColor = item.tmui_badgeTextColor;
            view.tmui_badgeFont = item.tmui_badgeFont;
            view.tmui_badgeContentEdgeInsets = item.tmui_badgeContentEdgeInsets;
            view.tmui_badgeOffset = item.tmui_badgeOffset;
            view.tmui_badgeOffsetLandscape = item.tmui_badgeOffsetLandscape;
            
            view.tmui_updatesIndicatorColor = item.tmui_updatesIndicatorColor;
            view.tmui_updatesIndicatorSize = item.tmui_updatesIndicatorSize;
            view.tmui_updatesIndicatorOffset = item.tmui_updatesIndicatorOffset;
            view.tmui_updatesIndicatorOffsetLandscape = item.tmui_updatesIndicatorOffsetLandscape;
            
            BeginIgnoreDeprecatedWarning
            view.tmui_badgeCenterOffset = item.tmui_badgeCenterOffset;
            view.tmui_badgeCenterOffsetLandscape = item.tmui_badgeCenterOffsetLandscape;
            view.tmui_updatesIndicatorCenterOffset = item.tmui_updatesIndicatorCenterOffset;
            view.tmui_updatesIndicatorCenterOffsetLandscape = item.tmui_updatesIndicatorCenterOffsetLandscape;
            EndIgnoreDeprecatedWarning
            
            view.tmui_badgeString = item.tmui_badgeString;
            view.tmui_shouldShowUpdatesIndicator = item.tmui_shouldShowUpdatesIndicator;
        };
        
        // 为 tmui_viewDidSetBlock 赋值前 item 已经 set 完 view，则手动触发一次
        if (self.tmui_view) {
            self.tmui_viewDidSetBlock(self, self.tmui_view);
        }
    }
}

@end
