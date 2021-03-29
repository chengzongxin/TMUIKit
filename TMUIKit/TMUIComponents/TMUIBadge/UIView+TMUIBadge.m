//
//  UIView+TMUIBadge.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/29.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UIView+TMUIBadge.h"
#import "TMUICore.h"
#import "TMUILabel.h"
#import "UIView+TMUI.h"
#import "UITabBarItem+TMUI.h"

@protocol _TMUIBadgeViewProtocol <NSObject>

@required

@property(nonatomic, assign) CGPoint offset;
@property(nonatomic, assign) CGPoint offsetLandscape;
@property(nonatomic, assign) CGPoint centerOffset;
@property(nonatomic, assign) CGPoint centerOffsetLandscape;

@end

@interface _TMUIBadgeLabel : TMUILabel <_TMUIBadgeViewProtocol>
@end

@interface _TMUIUpdatesIndicatorView : UIView <_TMUIBadgeViewProtocol>
@end

@interface UIView ()

@property(nonatomic, strong, readwrite) _TMUIBadgeLabel *tmui_badgeLabel;
@property(nonatomic, strong, readwrite) _TMUIUpdatesIndicatorView *tmui_updatesIndicatorView;
@property(nullable, nonatomic, strong) void (^tmuibdg_layoutSubviewsBlock)(__kindof UIView *view);
@end

@implementation UIView (TMUIBadge)

TMUISynthesizeIdStrongProperty(tmuibdg_layoutSubviewsBlock, setTmuibdg_layoutSubviewsBlock)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 保证配置表里的默认值正确被设置
        ExtendImplementationOfNonVoidMethodWithSingleArgument([UIView class], @selector(initWithFrame:), CGRect, UIView *, ^UIView *(UIView *selfObject, CGRect firstArgv, UIView *originReturnValue) {
            [selfObject tmuibdg_didInitialize];
            return originReturnValue;
        });
        
        ExtendImplementationOfNonVoidMethodWithSingleArgument([UIView class], @selector(initWithCoder:), NSCoder *, UIView *, ^UIView *(UIView *selfObject, NSCoder *firstArgv, UIView *originReturnValue) {
            [selfObject tmuibdg_didInitialize];
            return originReturnValue;
        });
        
        OverrideImplementation([UIView class], @selector(setTmui_layoutSubviewsBlock:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIView *selfObject, void (^firstArgv)(__kindof UIView *aView)) {
                
                if (firstArgv && selfObject.tmuibdg_layoutSubviewsBlock && firstArgv != selfObject.tmuibdg_layoutSubviewsBlock) {
                    firstArgv = ^void(__kindof UIView *aaView) {
                        firstArgv(aaView);
                        aaView.tmuibdg_layoutSubviewsBlock(aaView);
                    };
                }
                
                // call super
                void (*originSelectorIMP)(id, SEL, void (^firstArgv)(__kindof UIView *aView));
                originSelectorIMP = (void (*)(id, SEL, void (^firstArgv)(__kindof UIView *aView)))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, firstArgv);
            };
        });
    });
}

- (void)tmuibdg_didInitialize {
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
        EndIgnoreDeprecatedWarning
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
        if (!self.tmui_badgeLabel) {
            self.tmui_badgeLabel = [[_TMUIBadgeLabel alloc] init];
            self.tmui_badgeLabel.clipsToBounds = YES;
            self.tmui_badgeLabel.textAlignment = NSTextAlignmentCenter;
            self.tmui_badgeLabel.backgroundColor = self.tmui_badgeBackgroundColor;
            self.tmui_badgeLabel.textColor = self.tmui_badgeTextColor;
            self.tmui_badgeLabel.font = self.tmui_badgeFont;
            self.tmui_badgeLabel.contentEdgeInsets = self.tmui_badgeContentEdgeInsets;
            self.tmui_badgeLabel.offset = self.tmui_badgeOffset;
            self.tmui_badgeLabel.offsetLandscape = self.tmui_badgeOffsetLandscape;
            BeginIgnoreDeprecatedWarning
            self.tmui_badgeLabel.centerOffset = self.tmui_badgeCenterOffset;
            self.tmui_badgeLabel.centerOffsetLandscape = self.tmui_badgeCenterOffsetLandscape;
            EndIgnoreDeprecatedWarning
            [self addSubview:self.tmui_badgeLabel];
            
            [self updateLayoutSubviewsBlockIfNeeded];
        }
        self.tmui_badgeLabel.text = tmui_badgeString;
        self.tmui_badgeLabel.hidden = NO;
        [self setNeedsUpdateBadgeLabelLayout];
        self.clipsToBounds = NO;
    } else {
        self.tmui_badgeLabel.hidden = YES;
    }
}

- (NSString *)tmui_badgeString {
    return (NSString *)objc_getAssociatedObject(self, &kAssociatedObjectKey_badgeString);
}

static char kAssociatedObjectKey_badgeBackgroundColor;
- (void)setTmui_badgeBackgroundColor:(UIColor *)tmui_badgeBackgroundColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_badgeBackgroundColor, tmui_badgeBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_badgeLabel.backgroundColor = tmui_badgeBackgroundColor;
}

- (UIColor *)tmui_badgeBackgroundColor {
    return (UIColor *)objc_getAssociatedObject(self, &kAssociatedObjectKey_badgeBackgroundColor);
}

static char kAssociatedObjectKey_badgeTextColor;
- (void)setTmui_badgeTextColor:(UIColor *)tmui_badgeTextColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_badgeTextColor, tmui_badgeTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_badgeLabel.textColor = tmui_badgeTextColor;
}

- (UIColor *)tmui_badgeTextColor {
    return (UIColor *)objc_getAssociatedObject(self, &kAssociatedObjectKey_badgeTextColor);
}

static char kAssociatedObjectKey_badgeFont;
- (void)setTmui_badgeFont:(UIFont *)tmui_badgeFont {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_badgeFont, tmui_badgeFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.tmui_badgeLabel) {
        self.tmui_badgeLabel.font = tmui_badgeFont;
        [self setNeedsUpdateBadgeLabelLayout];
    }
}

- (UIFont *)tmui_badgeFont {
    return (UIFont *)objc_getAssociatedObject(self, &kAssociatedObjectKey_badgeFont);
}

static char kAssociatedObjectKey_badgeContentEdgeInsets;
- (void)setTmui_badgeContentEdgeInsets:(UIEdgeInsets)tmui_badgeContentEdgeInsets {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_badgeContentEdgeInsets, [NSValue valueWithUIEdgeInsets:tmui_badgeContentEdgeInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.tmui_badgeLabel) {
        self.tmui_badgeLabel.contentEdgeInsets = tmui_badgeContentEdgeInsets;
        [self setNeedsUpdateBadgeLabelLayout];
    }
}

- (UIEdgeInsets)tmui_badgeContentEdgeInsets {
    return [((NSValue *)objc_getAssociatedObject(self, &kAssociatedObjectKey_badgeContentEdgeInsets)) UIEdgeInsetsValue];
}

static char kAssociatedObjectKey_badgeOffset;
- (void)setTmui_badgeOffset:(CGPoint)tmui_badgeOffset {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_badgeOffset, @(tmui_badgeOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_badgeLabel.offset = tmui_badgeOffset;
}

- (CGPoint)tmui_badgeOffset {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_badgeOffset)) CGPointValue];
}

static char kAssociatedObjectKey_badgeOffsetLandscape;
- (void)setTmui_badgeOffsetLandscape:(CGPoint)tmui_badgeOffsetLandscape {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_badgeOffsetLandscape, @(tmui_badgeOffsetLandscape), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_badgeLabel.offsetLandscape = tmui_badgeOffsetLandscape;
}

- (CGPoint)tmui_badgeOffsetLandscape {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_badgeOffsetLandscape)) CGPointValue];
}

BeginIgnoreDeprecatedWarning
BeginIgnoreClangWarning(-Wdeprecated-implementations)

static char kAssociatedObjectKey_badgeCenterOffset;
- (void)setTmui_badgeCenterOffset:(CGPoint)tmui_badgeCenterOffset {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_badgeCenterOffset, [NSValue valueWithCGPoint:tmui_badgeCenterOffset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_badgeLabel.centerOffset = tmui_badgeCenterOffset;
}

- (CGPoint)tmui_badgeCenterOffset {
    return [((NSValue *)objc_getAssociatedObject(self, &kAssociatedObjectKey_badgeCenterOffset)) CGPointValue];
}

static char kAssociatedObjectKey_badgeCenterOffsetLandscape;
- (void)setTmui_badgeCenterOffsetLandscape:(CGPoint)tmui_badgeCenterOffsetLandscape {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_badgeCenterOffsetLandscape, [NSValue valueWithCGPoint:tmui_badgeCenterOffsetLandscape], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_badgeLabel.centerOffsetLandscape = tmui_badgeCenterOffsetLandscape;
}

- (CGPoint)tmui_badgeCenterOffsetLandscape {
    return [((NSValue *)objc_getAssociatedObject(self, &kAssociatedObjectKey_badgeCenterOffsetLandscape)) CGPointValue];
}

EndIgnoreClangWarning
EndIgnoreDeprecatedWarning

static char kAssociatedObjectKey_badgeLabel;
- (void)setTmui_badgeLabel:(UILabel *)tmui_badgeLabel {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_badgeLabel, tmui_badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (_TMUIBadgeLabel *)tmui_badgeLabel {
    return (_TMUIBadgeLabel *)objc_getAssociatedObject(self, &kAssociatedObjectKey_badgeLabel);
}

- (void)setNeedsUpdateBadgeLabelLayout {
    if (self.tmui_badgeString.length) {
        [self setNeedsLayout];
    }
}

#pragma mark - UpdatesIndicator

static char kAssociatedObjectKey_shouldShowUpdatesIndicator;
- (void)setTmui_shouldShowUpdatesIndicator:(BOOL)tmui_shouldShowUpdatesIndicator {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_shouldShowUpdatesIndicator, @(tmui_shouldShowUpdatesIndicator), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (tmui_shouldShowUpdatesIndicator) {
        if (!self.tmui_updatesIndicatorView) {
            self.tmui_updatesIndicatorView = [[_TMUIUpdatesIndicatorView alloc] tmui_initWithSize:self.tmui_updatesIndicatorSize];
            self.tmui_updatesIndicatorView.layer.cornerRadius = CGRectGetHeight(self.tmui_updatesIndicatorView.bounds) / 2;
            self.tmui_updatesIndicatorView.backgroundColor = self.tmui_updatesIndicatorColor;
            self.tmui_updatesIndicatorView.offset = self.tmui_updatesIndicatorOffset;
            self.tmui_updatesIndicatorView.offsetLandscape = self.tmui_updatesIndicatorOffsetLandscape;
            BeginIgnoreDeprecatedWarning
            self.tmui_updatesIndicatorView.centerOffset = self.tmui_updatesIndicatorCenterOffset;
            self.tmui_updatesIndicatorView.centerOffsetLandscape = self.tmui_updatesIndicatorCenterOffsetLandscape;
            EndIgnoreDeprecatedWarning
            [self addSubview:self.tmui_updatesIndicatorView];
            [self updateLayoutSubviewsBlockIfNeeded];
        }
        [self setNeedsUpdateIndicatorLayout];
        self.clipsToBounds = NO;
        self.tmui_updatesIndicatorView.hidden = NO;
    } else {
        self.tmui_updatesIndicatorView.hidden = YES;
    }
}

- (BOOL)tmui_shouldShowUpdatesIndicator {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_shouldShowUpdatesIndicator)) boolValue];
}

static char kAssociatedObjectKey_updatesIndicatorColor;
- (void)setTmui_updatesIndicatorColor:(UIColor *)tmui_updatesIndicatorColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorColor, tmui_updatesIndicatorColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.tmui_updatesIndicatorView.backgroundColor = tmui_updatesIndicatorColor;
}

- (UIColor *)tmui_updatesIndicatorColor {
    return (UIColor *)objc_getAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorColor);
}

static char kAssociatedObjectKey_updatesIndicatorSize;
- (void)setTmui_updatesIndicatorSize:(CGSize)tmui_updatesIndicatorSize {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorSize, [NSValue valueWithCGSize:tmui_updatesIndicatorSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.tmui_updatesIndicatorView) {
        self.tmui_updatesIndicatorView.frame = CGRectSetSize(self.tmui_updatesIndicatorView.frame, tmui_updatesIndicatorSize);
        self.tmui_updatesIndicatorView.layer.cornerRadius = tmui_updatesIndicatorSize.height / 2;
        [self setNeedsUpdateIndicatorLayout];
    }
}

- (CGSize)tmui_updatesIndicatorSize {
    return [((NSValue *)objc_getAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorSize)) CGSizeValue];
}

static char kAssociatedObjectKey_updatesIndicatorOffset;
- (void)setTmui_updatesIndicatorOffset:(CGPoint)tmui_updatesIndicatorOffset {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorOffset, @(tmui_updatesIndicatorOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.tmui_updatesIndicatorView) {
        self.tmui_updatesIndicatorView.offset = tmui_updatesIndicatorOffset;
        [self setNeedsUpdateIndicatorLayout];
    }
}

- (CGPoint)tmui_updatesIndicatorOffset {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorOffset)) CGPointValue];
}

static char kAssociatedObjectKey_updatesIndicatorOffsetLandscape;
- (void)setTmui_updatesIndicatorOffsetLandscape:(CGPoint)tmui_updatesIndicatorOffsetLandscape {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorOffsetLandscape, @(tmui_updatesIndicatorOffsetLandscape), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.tmui_updatesIndicatorView) {
        self.tmui_updatesIndicatorView.offsetLandscape = tmui_updatesIndicatorOffsetLandscape;
        [self setNeedsUpdateIndicatorLayout];
    }
}

- (CGPoint)tmui_updatesIndicatorOffsetLandscape {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorOffsetLandscape)) CGPointValue];
}

BeginIgnoreDeprecatedWarning
BeginIgnoreClangWarning(-Wdeprecated-implementations)

static char kAssociatedObjectKey_updatesIndicatorCenterOffset;
- (void)setTmui_updatesIndicatorCenterOffset:(CGPoint)tmui_updatesIndicatorCenterOffset {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorCenterOffset, [NSValue valueWithCGPoint:tmui_updatesIndicatorCenterOffset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.tmui_updatesIndicatorView) {
        self.tmui_updatesIndicatorView.centerOffset = tmui_updatesIndicatorCenterOffset;
        [self setNeedsUpdateIndicatorLayout];
    }
}

- (CGPoint)tmui_updatesIndicatorCenterOffset {
    return [((NSValue *)objc_getAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorCenterOffset)) CGPointValue];
}

static char kAssociatedObjectKey_updatesIndicatorCenterOffsetLandscape;
- (void)setTmui_updatesIndicatorCenterOffsetLandscape:(CGPoint)tmui_updatesIndicatorCenterOffsetLandscape {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorCenterOffsetLandscape, [NSValue valueWithCGPoint:tmui_updatesIndicatorCenterOffsetLandscape], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.tmui_updatesIndicatorView) {
        self.tmui_updatesIndicatorView.centerOffsetLandscape = tmui_updatesIndicatorCenterOffsetLandscape;
        [self setNeedsUpdateIndicatorLayout];
    }
}

- (CGPoint)tmui_updatesIndicatorCenterOffsetLandscape {
    return [((NSValue *)objc_getAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorCenterOffsetLandscape)) CGPointValue];
}

EndIgnoreClangWarning
EndIgnoreDeprecatedWarning

static char kAssociatedObjectKey_updatesIndicatorView;
- (void)setTmui_updatesIndicatorView:(UIView *)tmui_updatesIndicatorView {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorView, tmui_updatesIndicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (_TMUIUpdatesIndicatorView *)tmui_updatesIndicatorView {
    return (_TMUIUpdatesIndicatorView *)objc_getAssociatedObject(self, &kAssociatedObjectKey_updatesIndicatorView);
}

- (void)setNeedsUpdateIndicatorLayout {
    if (self.tmui_shouldShowUpdatesIndicator) {
        [self setNeedsLayout];
    }
}

#pragma mark - Common

- (void)updateLayoutSubviewsBlockIfNeeded {
    if (!self.tmuibdg_layoutSubviewsBlock) {
        self.tmuibdg_layoutSubviewsBlock = ^(UIView *view) {
            [view tmuibdg_layoutSubviews];
        };
    }
    if (!self.tmui_layoutSubviewsBlock) {
        self.tmui_layoutSubviewsBlock = self.tmuibdg_layoutSubviewsBlock;
    } else if (self.tmui_layoutSubviewsBlock != self.tmuibdg_layoutSubviewsBlock) {
        void (^originalLayoutSubviewsBlock)(__kindof UIView *) = self.tmui_layoutSubviewsBlock;
        self.tmuibdg_layoutSubviewsBlock = ^(__kindof UIView *view) {
            originalLayoutSubviewsBlock(view);
            [view tmuibdg_layoutSubviews];
        };
        self.tmui_layoutSubviewsBlock = self.tmuibdg_layoutSubviewsBlock;
    }
}

- (UIView *)findBarButtonImageViewIfOffsetByTopRight:(BOOL)offsetByTopRight {
    NSString *classString = NSStringFromClass(self.class);
    if ([classString isEqualToString:@"UITabBarButton"]) {
        // 特别的，对于 UITabBarItem，将 imageView 作为参考 view
        UIView *imageView = [UITabBarItem tmui_imageViewInTabBarButton:self];
        return imageView;
    }
    
    // 如果使用 centerOffset 则不特殊处理 UIBarButtonItem，以保持与旧版的逻辑一致
    // TODO: molice 等废弃 tmui_badgeCenterOffset 系列接口后再删除
    if (!offsetByTopRight) return nil;
    
    if (@available(iOS 11.0, *)) {
        if ([classString isEqualToString:@"_UIButtonBarButton"]) {
            for (UIView *subview in self.subviews) {
                if ([subview isKindOfClass:UIButton.class]) {
                    UIView *imageView = ((UIButton *)subview).imageView;
                    if (imageView && !imageView.hidden) {
                        return imageView;
                    }
                }
            }
        }
    } else {
        if ([classString isEqualToString:@"UINavigationButton"]) {
            UIView *imageView = ((UIButton *)self).imageView;
            if (imageView && !imageView.hidden) {
                return imageView;
            }
        }
        if ([classString isEqualToString:@"UIToolbarButton"]) {
            for (UIView *subview in self.subviews) {
                if ([subview isKindOfClass:UIButton.class]) {
                    UIView *imageView = ((UIButton *)subview).imageView;
                    if (imageView && !imageView.hidden) {
                        return imageView;
                    }
                }
            }
        }
    }
    
    return nil;
}
const CGPoint TMUIBadgeInvalidateOffset = {-1000, -1000};
- (void)tmuibdg_layoutSubviews {
    
    void (^layoutBlock)(UIView *view, UIView<_TMUIBadgeViewProtocol> *badgeView) = ^void(UIView *view, UIView<_TMUIBadgeViewProtocol> *badgeView) {
        BOOL offsetByTopRight = !CGPointEqualToPoint(badgeView.offset, TMUIBadgeInvalidateOffset) || !CGPointEqualToPoint(badgeView.offsetLandscape, TMUIBadgeInvalidateOffset);
        CGPoint offset = IS_LANDSCAPE ? (offsetByTopRight ? badgeView.offsetLandscape : badgeView.centerOffsetLandscape) : (offsetByTopRight ? badgeView.offset : badgeView.centerOffset);
        
        UIView *imageView = [view findBarButtonImageViewIfOffsetByTopRight:offsetByTopRight];
        if (imageView) {
            CGRect imageViewFrame = [view convertRect:imageView.frame fromView:imageView.superview];
            if (offsetByTopRight) {
                badgeView.frame = CGRectSetXY(badgeView.frame, CGRectGetMaxX(imageViewFrame) + offset.x, CGRectGetMinY(imageViewFrame) - CGRectGetHeight(badgeView.frame) + offset.y);
            } else {
                badgeView.center = CGPointMake(CGRectGetMidX(imageViewFrame) + offset.x, CGRectGetMidY(imageViewFrame) + offset.y);
            }
        } else {
            if (offsetByTopRight) {
                badgeView.frame = CGRectSetXY(badgeView.frame, CGRectGetWidth(view.bounds) + offset.x, - CGRectGetHeight(badgeView.frame) + offset.y);
            } else {
                badgeView.center = CGPointMake(CGRectGetMidX(view.bounds) + offset.x, CGRectGetMidY(view.bounds) + offset.y);
            }
        }
        [view bringSubviewToFront:badgeView];
    };
    
    if (self.tmui_updatesIndicatorView && !self.tmui_updatesIndicatorView.hidden) {
        layoutBlock(self, self.tmui_updatesIndicatorView);
    }
    if (self.tmui_badgeLabel && !self.tmui_badgeLabel.hidden) {
        [self.tmui_badgeLabel sizeToFit];
        self.tmui_badgeLabel.layer.cornerRadius = MIN(self.tmui_badgeLabel.height / 2, self.tmui_badgeLabel.width / 2);
        layoutBlock(self, self.tmui_badgeLabel);
    }
}

@end

@implementation _TMUIUpdatesIndicatorView

@synthesize offset = _offset, offsetLandscape = _offsetLandscape, centerOffset = _centerOffset, centerOffsetLandscape = _centerOffsetLandscape;

- (void)setOffset:(CGPoint)offset {
    _offset = offset;
    if (!IS_LANDSCAPE) {
        [self.superview setNeedsLayout];
    }
}

- (void)setOffsetLandscape:(CGPoint)offsetLandscape {
    _offsetLandscape = offsetLandscape;
    if (IS_LANDSCAPE) {
        [self.superview setNeedsLayout];
    }
}

- (void)setCenterOffset:(CGPoint)centerOffset {
    _centerOffset = centerOffset;
    if (!IS_LANDSCAPE) {
        [self.superview setNeedsLayout];
    }
}

- (void)setCenterOffsetLandscape:(CGPoint)centerOffsetLandscape {
    _centerOffsetLandscape = centerOffsetLandscape;
    if (IS_LANDSCAPE) {
        [self.superview setNeedsLayout];
    }
}

@end

@implementation _TMUIBadgeLabel

@synthesize offset = _offset, offsetLandscape = _offsetLandscape, centerOffset = _centerOffset, centerOffsetLandscape = _centerOffsetLandscape;

- (void)setOffset:(CGPoint)offset {
    _offset = offset;
    if (!IS_LANDSCAPE) {
        [self.superview setNeedsLayout];
    }
}

- (void)setOffsetLandscape:(CGPoint)offsetLandscape {
    _offsetLandscape = offsetLandscape;
    if (IS_LANDSCAPE) {
        [self.superview setNeedsLayout];
    }
}

- (void)setCenterOffset:(CGPoint)centerOffset {
    _centerOffset = centerOffset;
    if (!IS_LANDSCAPE) {
        [self.superview setNeedsLayout];
    }
}

- (void)setCenterOffsetLandscape:(CGPoint)centerOffsetLandscape {
    _centerOffsetLandscape = centerOffsetLandscape;
    if (IS_LANDSCAPE) {
        [self.superview setNeedsLayout];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize result = [super sizeThatFits:size];
    result = CGSizeMake(MAX(result.width, result.height), result.height);
    return result;
}

@end
