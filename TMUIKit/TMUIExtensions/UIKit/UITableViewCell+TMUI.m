//
//  UITableViewCell+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/18.
//

#import "UITableViewCell+TMUI.h"
#import "NSObject+TMUI.h"
#import "UIView+TMUI.h"
#import "UITableView+TMUI.h"
#import "CALayer+TMUI.h"
#import "TMUIHelper.h"
#import "TMUIAssociatedPropertyDefines.h"
#import "TMUIRuntime.h"
#import "TMUIConfigurationMacros.h"
#import "TMUICoreGraphicsDefines.h"
#import "TMUICommonDefines.h"

const UIEdgeInsets TMUITableViewCellSeparatorInsetsNone = {INFINITY, INFINITY, INFINITY, INFINITY};

@interface UITableViewCell ()

@property(nonatomic, strong) CALayer *tmuiTbc_separatorLayer;
@property(nonatomic, strong) CALayer *tmuiTbc_topSeparatorLayer;
@end

@implementation UITableViewCell (TMUI)

TMUISynthesizeNSIntegerProperty(tmui_style, setTmui_style)
TMUISynthesizeIdStrongProperty(tmuiTbc_separatorLayer, setTmuiTbc_separatorLayer)
TMUISynthesizeIdStrongProperty(tmuiTbc_topSeparatorLayer, setTmuiTbc_topSeparatorLayer)
TMUISynthesizeIdCopyProperty(tmui_separatorInsetsBlock, setTmui_separatorInsetsBlock)
TMUISynthesizeIdCopyProperty(tmui_topSeparatorInsetsBlock, setTmui_topSeparatorInsetsBlock)
TMUISynthesizeIdCopyProperty(tmui_setHighlightedBlock, setTmui_setHighlightedBlock)
TMUISynthesizeIdCopyProperty(tmui_setSelectedBlock, setTmui_setSelectedBlock)

//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        OverrideImplementation([UITableViewCell class], @selector(initWithStyle:reuseIdentifier:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
//            return ^UITableViewCell *(UITableViewCell *selfObject, UITableViewCellStyle firstArgv, NSString *secondArgv) {
//                // call super
//                UITableViewCell *(*originSelectorIMP)(id, SEL, UITableViewCellStyle, NSString *);
//                originSelectorIMP = (UITableViewCell *(*)(id, SEL, UITableViewCellStyle, NSString *))originalIMPProvider();
//                UITableViewCell *result = originSelectorIMP(selfObject, originCMD, firstArgv, secondArgv);
//
//                // 系统虽然有私有 API - (UITableViewCellStyle)style; 可以用，但该方法在 init 内得到的永远是 0，只有 init 执行完成后才可以得到正确的值，所以这里只能自己记录
//                result.tmui_style = firstArgv;
////                [selfObject tmui_styledAsTMUITableViewCell];
//                return result;
//            };
//        });
//        ExtendImplementationOfVoidMethodWithTwoArguments([UITableViewCell class], @selector(setHighlighted:animated:), BOOL, BOOL, ^(UITableViewCell *selfObject, BOOL highlighted, BOOL animated) {
//            if (selfObject.tmui_setHighlightedBlock) {
//                selfObject.tmui_setHighlightedBlock(highlighted, animated);
//            }
//        });
//
//        ExtendImplementationOfVoidMethodWithTwoArguments([UITableViewCell class], @selector(setSelected:animated:), BOOL, BOOL, ^(UITableViewCell *selfObject, BOOL selected, BOOL animated) {
//            if (selfObject.tmui_setSelectedBlock) {
//                selfObject.tmui_setSelectedBlock(selected, animated);
//            }
//        });
//
//        // 修复 iOS 13.0 UIButton 作为 cell.accessoryView 时布局错误的问题
//        // https://github.com/Tencent/TMUI_iOS/issues/693
//        if (@available(iOS 13.0, *)) {
//            if (@available(iOS 13.1, *)) {
//            } else {
//                ExtendImplementationOfVoidMethodWithoutArguments([UITableViewCell class], @selector(layoutSubviews), ^(UITableViewCell *selfObject) {
//                    if ([selfObject.accessoryView isKindOfClass:[UIButton class]]) {
//                        CGFloat defaultRightMargin = 15 + SafeAreaInsetsConstantForDeviceWithNotch.right;
//                        selfObject.accessoryView.left = selfObject.width - defaultRightMargin - selfObject.accessoryView.width;
//                        selfObject.accessoryView.top = CGRectGetMinYVerticallyCenterInParentRect(selfObject.frame, selfObject.accessoryView.frame);;
//                        selfObject.contentView.right = selfObject.accessoryView.left;
//                    }
//                });
//            }
//        }
//    });
//}

static char kAssociatedObjectKey_cellPosition;
- (void)setTmui_cellPosition:(TMUITableViewCellPosition)tmui_cellPosition {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_cellPosition, @(tmui_cellPosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    BOOL shouldShowSeparatorInTableView = self.tmui_tableView && self.tmui_tableView.separatorStyle != UITableViewCellSeparatorStyleNone;
    if (shouldShowSeparatorInTableView) {
        [self tmuiTbc_createSeparatorLayerIfNeeded];
        [self tmuiTbc_createTopSeparatorLayerIfNeeded];
    }
}

- (TMUITableViewCellPosition)tmui_cellPosition {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_cellPosition)) integerValue];
}

- (void)tmuiTbc_swizzleLayoutSubviews {
    [TMUIHelper executeBlock:^{
        ExtendImplementationOfVoidMethodWithoutArguments(self.class, @selector(layoutSubviews), ^(UITableViewCell *cell) {
            if (cell.tmuiTbc_separatorLayer && !cell.tmuiTbc_separatorLayer.hidden) {
                UIEdgeInsets insets = cell.tmui_separatorInsetsBlock(cell.tmui_tableView, cell);
                CGRect frame = CGRectZero;
                if (!UIEdgeInsetsEqualToEdgeInsets(insets, TMUITableViewCellSeparatorInsetsNone)) {
                    CGFloat height = PixelOne;
                    frame = CGRectMake(insets.left, CGRectGetHeight(cell.bounds) - height + insets.top - insets.bottom, MAX(0, CGRectGetWidth(cell.bounds) - UIEdgeInsetsGetHorizontalValue(insets)), height);
                }
                cell.tmuiTbc_separatorLayer.frame = frame;
            }
            
            if (cell.tmuiTbc_topSeparatorLayer && !cell.tmuiTbc_topSeparatorLayer.hidden) {
                UIEdgeInsets insets = cell.tmui_topSeparatorInsetsBlock(cell.tmui_tableView, cell);
                CGRect frame = CGRectZero;
                if (!UIEdgeInsetsEqualToEdgeInsets(insets, TMUITableViewCellSeparatorInsetsNone)) {
                    CGFloat height = PixelOne;
                    frame = CGRectMake(insets.left, insets.top - insets.bottom, MAX(0, CGRectGetWidth(cell.bounds) - UIEdgeInsetsGetHorizontalValue(insets)), height);
                }
                cell.tmuiTbc_topSeparatorLayer.frame = frame;
            }
        });
    } oncePerIdentifier:[NSString stringWithFormat:@"UITableViewCell %@-%@", NSStringFromClass(self.class), NSStringFromSelector(@selector(layoutSubviews))]];
}

- (BOOL)tmuiTbc_customizedSeparator {
    return !!self.tmui_separatorInsetsBlock;
}

- (BOOL)tmuiTbc_customizedTopSeparator {
    return !!self.tmui_topSeparatorInsetsBlock;
}

- (void)tmuiTbc_createSeparatorLayerIfNeeded {
    if (![self tmuiTbc_customizedSeparator]) {
        self.tmuiTbc_separatorLayer.hidden = YES;
        return;
    }
    
    BOOL shouldShowSeparator = !UIEdgeInsetsEqualToEdgeInsets(self.tmui_separatorInsetsBlock(self.tmui_tableView, self), TMUITableViewCellSeparatorInsetsNone);
    if (shouldShowSeparator) {
        if (!self.tmuiTbc_separatorLayer) {
            [self tmuiTbc_swizzleLayoutSubviews];
            self.tmuiTbc_separatorLayer = [CALayer layer];
            [self.tmuiTbc_separatorLayer tmui_removeDefaultAnimations];
            [self.layer addSublayer:self.tmuiTbc_separatorLayer];
        }
        self.tmuiTbc_separatorLayer.backgroundColor = self.tmui_tableView.separatorColor.CGColor;
        self.tmuiTbc_separatorLayer.hidden = NO;
    } else {
        if (self.tmuiTbc_separatorLayer) {
            self.tmuiTbc_separatorLayer.hidden = YES;
        }
    }
}

- (void)tmuiTbc_createTopSeparatorLayerIfNeeded {
    if (![self tmuiTbc_customizedTopSeparator]) {
        self.tmuiTbc_topSeparatorLayer.hidden = YES;
        return;
    }
    
    BOOL shouldShowSeparator = !UIEdgeInsetsEqualToEdgeInsets(self.tmui_topSeparatorInsetsBlock(self.tmui_tableView, self), TMUITableViewCellSeparatorInsetsNone);
    if (shouldShowSeparator) {
        if (!self.tmuiTbc_topSeparatorLayer) {
            [self tmuiTbc_swizzleLayoutSubviews];
            self.tmuiTbc_topSeparatorLayer = [CALayer layer];
            [self.tmuiTbc_topSeparatorLayer tmui_removeDefaultAnimations];
            [self.layer addSublayer:self.tmuiTbc_topSeparatorLayer];
        }
        self.tmuiTbc_topSeparatorLayer.backgroundColor = self.tmui_tableView.separatorColor.CGColor;
        self.tmuiTbc_topSeparatorLayer.hidden = NO;
    } else {
        if (self.tmuiTbc_topSeparatorLayer) {
            self.tmuiTbc_topSeparatorLayer.hidden = YES;
        }
    }
}

- (UITableView *)tmui_tableView {
    return [self valueForKey:@"tableView"];
}

static char kAssociatedObjectKey_selectedBackgroundColor;
- (void)setTmui_selectedBackgroundColor:(UIColor *)tmui_selectedBackgroundColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_selectedBackgroundColor, tmui_selectedBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (tmui_selectedBackgroundColor) {
        // 系统默认的 selectedBackgroundView 是 UITableViewCellSelectedBackground，无法修改自定义背景色，所以改为用普通的 UIView
        if ([NSStringFromClass(self.selectedBackgroundView.class) hasPrefix:@"UITableViewCell"]) {
            self.selectedBackgroundView = [[UIView alloc] init];
        }
        self.selectedBackgroundView.backgroundColor = tmui_selectedBackgroundColor;
    }
}

- (UIColor *)tmui_selectedBackgroundColor {
    return (UIColor *)objc_getAssociatedObject(self, &kAssociatedObjectKey_selectedBackgroundColor);
}

- (UIView *)tmui_accessoryView {
    if (self.editing) {
        if (self.editingAccessoryView) {
            return self.editingAccessoryView;
        }
        return [self tmui_valueForKey:@"_editingAccessoryView"];
    }
    if (self.accessoryView) {
        return self.accessoryView;
    }
    
    // UITableViewCellAccessoryDetailDisclosureButton 在 iOS 13 及以上是分开的两个 accessoryView，以 NSSet 的形式存在这个私有接口里。而 iOS 12 及以下是以一个 UITableViewCellDetailDisclosureView 的 UIControl 存在。
    if (@available(iOS 13.0, *)) {
        NSSet<UIView *> *accessoryViews = [self tmui_valueForKey:@"_existingSystemAccessoryViews"];
        if ([accessoryViews isKindOfClass:NSSet.class] && accessoryViews.count) {
            UIView *leftView = nil;
            for (UIView *accessoryView in accessoryViews) {
                if (!leftView) {
                    leftView = accessoryView;
                    continue;
                }
                if (CGRectGetMinX(accessoryView.frame) < CGRectGetMinX(leftView.frame)) {
                    leftView = accessoryView;
                }
            }
            return leftView;
        }
        return nil;
    }
    return [self tmui_valueForKey:@"_accessoryView"];
}

@end

@implementation UITableViewCell (TMUI_Styled)

- (void)tmui_styledAsTMUITableViewCell {
    if (!TMUICMIActivated) return;
    
    self.textLabel.font = UIFontMake(16);
    self.textLabel.backgroundColor = UIColorClear;
    UIColor *textLabelColor = self.tmui_styledTextLabelColor;
    if (textLabelColor) {
        self.textLabel.textColor = textLabelColor;
    }
    
    self.detailTextLabel.font = UIFontMake(15);
    self.detailTextLabel.backgroundColor = UIColorClear;
    UIColor *detailLabelColor = self.tmui_styledDetailTextLabelColor;
    if (detailLabelColor) {
        self.detailTextLabel.textColor = detailLabelColor;
    }
    
    UIColor *backgroundColor = self.tmui_styledBackgroundColor;
    if (backgroundColor) {
        self.backgroundColor = backgroundColor;
    }
    
    UIColor *selectedBackgroundColor = self.tmui_styledSelectedBackgroundColor;
    if (selectedBackgroundColor) {
        self.tmui_selectedBackgroundColor = selectedBackgroundColor;
    }
}

- (UIColor *)tmui_styledTextLabelColor {
    return PreferredValueForTableViewStyle(self.tmui_tableView.tmui_style, TableViewCellTitleLabelColor, TableViewGroupedCellTitleLabelColor, TableViewInsetGroupedCellTitleLabelColor);
}

- (UIColor *)tmui_styledDetailTextLabelColor {
    return PreferredValueForTableViewStyle(self.tmui_tableView.tmui_style, TableViewCellDetailLabelColor, TableViewGroupedCellDetailLabelColor, TableViewInsetGroupedCellDetailLabelColor);
}

- (UIColor *)tmui_styledBackgroundColor {
    return PreferredValueForTableViewStyle(self.tmui_tableView.tmui_style, TableViewCellBackgroundColor, TableViewGroupedCellBackgroundColor, TableViewInsetGroupedCellBackgroundColor);
}

- (UIColor *)tmui_styledSelectedBackgroundColor {
    return PreferredValueForTableViewStyle(self.tmui_tableView.tmui_style, TableViewCellSelectedBackgroundColor, TableViewGroupedCellSelectedBackgroundColor, TableViewInsetGroupedCellSelectedBackgroundColor);
}

- (UIColor *)tmui_styledWarningBackgroundColor {
    return PreferredValueForTableViewStyle(self.tmui_tableView.tmui_style, TableViewCellWarningBackgroundColor, TableViewGroupedCellWarningBackgroundColor, TableViewInsetGroupedCellWarningBackgroundColor);
}

@end

@implementation UITableViewCell (TMUI_InsetGrouped)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        OverrideImplementation([UITableViewCell class], NSSelectorFromString(@"_separatorFrame"), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^CGRect(UITableViewCell *selfObject) {
                
                if ([selfObject tmuiTbc_customizedSeparator]) {
                    return CGRectZero;
                }
                
                // iOS 13 自己会控制好 InsetGrouped 时不同 cellPosition 的分隔线显隐，iOS 12 及以下要全部手动处理
                if (@available(iOS 13.0, *)) {
                } else {
                    if (selfObject.tmui_tableView && selfObject.tmui_tableView.tmui_style == TMUITableViewStyleInsetGrouped && (selfObject.tmui_cellPosition & TMUITableViewCellPositionLastInSection) == TMUITableViewCellPositionLastInSection) {
                        return CGRectZero;
                    }
                }
                
                // call super
                CGRect (*originSelectorIMP)(id, SEL);
                originSelectorIMP = (CGRect (*)(id, SEL))originalIMPProvider();
                CGRect result = originSelectorIMP(selfObject, originCMD);
                return result;
            };
        });
        
        OverrideImplementation([UITableViewCell class], NSSelectorFromString(@"_topSeparatorFrame"), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^CGRect(UITableViewCell *selfObject) {
                
                if ([selfObject tmuiTbc_customizedTopSeparator]) {
                    return CGRectZero;
                }
                
                if (@available(iOS 13.0, *)) {
                } else {
                    // iOS 13 系统在 InsetGrouped 时默认就会隐藏顶部分隔线，所以这里只对 iOS 12 及以下处理
                    if (selfObject.tmui_tableView && selfObject.tmui_tableView.tmui_style == TMUITableViewStyleInsetGrouped) {
                        return CGRectZero;
                    }
                }
                
                
                // call super
                CGRect (*originSelectorIMP)(id, SEL);
                originSelectorIMP = (CGRect (*)(id, SEL))originalIMPProvider();
                CGRect result = originSelectorIMP(selfObject, originCMD);
                return result;
            };
        });
        
        // 下方的功能，iOS 13 都交给系统的 InsetGrouped 处理
        if (@available(iOS 13.0, *)) return;
        
        OverrideImplementation([UITableViewCell class], @selector(setFrame:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UITableViewCell *selfObject, CGRect firstArgv) {
                
                UITableView *tableView = selfObject.tmui_tableView;
                if (tableView && tableView.tmui_style == TMUITableViewStyleInsetGrouped) {
                    firstArgv = CGRectMake(tableView.tmui_safeAreaInsets.left + tableView.tmui_insetGroupedHorizontalInset, CGRectGetMinY(firstArgv), CGRectGetWidth(firstArgv) - UIEdgeInsetsGetHorizontalValue(tableView.tmui_safeAreaInsets) - tableView.tmui_insetGroupedHorizontalInset * 2, CGRectGetHeight(firstArgv));
                }
                
                // call super
                void (*originSelectorIMP)(id, SEL, CGRect);
                originSelectorIMP = (void (*)(id, SEL, CGRect))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, firstArgv);
            };
        });
        
        // 将缩进后的宽度传给 cell 的 sizeThatFits:，注意 sizeThatFits: 只有在 tableView 开启 self-sizing 的情况下才会被调用（也即高度被指定为 UITableViewAutomaticDimension）
        // TODO: molice 系统的 UITableViewCell 第一次布局总是得到错误的高度，不知道为什么
        OverrideImplementation([UITableViewCell class], @selector(systemLayoutSizeFittingSize:withHorizontalFittingPriority:verticalFittingPriority:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^CGSize(UITableViewCell *selfObject, CGSize targetSize, UILayoutPriority horizontalFittingPriority, UILayoutPriority verticalFittingPriority) {
                
                UITableView *tableView = selfObject.tmui_tableView;
                if (tableView && tableView.tmui_style == TMUITableViewStyleInsetGrouped) {
                    [TMUIHelper executeBlock:^{
                        OverrideImplementation(selfObject.class, @selector(sizeThatFits:), ^id(__unsafe_unretained Class originClass, SEL cellOriginCMD, IMP (^cellOriginalIMPProvider)(void)) {
                            return ^CGSize(UITableViewCell *cell, CGSize firstArgv) {
                                
                                UITableView *tableView = cell.tmui_tableView;
                                if (tableView && tableView.tmui_style == TMUITableViewStyleInsetGrouped) {
                                    firstArgv.width = firstArgv.width - UIEdgeInsetsGetHorizontalValue(tableView.tmui_safeAreaInsets) - tableView.tmui_insetGroupedHorizontalInset * 2;
                                }
                                
                                // call super
                                CGSize (*originSelectorIMP)(id, SEL, CGSize);
                                originSelectorIMP = (CGSize (*)(id, SEL, CGSize))cellOriginalIMPProvider();
                                CGSize result = originSelectorIMP(cell, cellOriginCMD, firstArgv);
                                return result;
                            };
                        });
                    } oncePerIdentifier:[NSString stringWithFormat:@"InsetGroupedCell %@-%@", NSStringFromClass(selfObject.class), NSStringFromSelector(@selector(sizeThatFits:))]];
                }
                
                // call super
                CGSize (*originSelectorIMP)(id, SEL, CGSize, UILayoutPriority, UILayoutPriority);
                originSelectorIMP = (CGSize (*)(id, SEL, CGSize, UILayoutPriority, UILayoutPriority))originalIMPProvider();
                CGSize result = originSelectorIMP(selfObject, originCMD, targetSize, horizontalFittingPriority, verticalFittingPriority);
                return result;
            };
        });
    });
}

@end
