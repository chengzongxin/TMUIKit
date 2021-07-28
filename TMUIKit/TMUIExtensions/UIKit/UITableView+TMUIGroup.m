//
//  UITableView+TMUIGroup.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/7/27.
//

#import "UITableView+TMUIGroup.h"
#import "TMUIBasicDefines.h"
#import "TMUIRuntime.h"
#import "TMUIAssociatedPropertyDefines.h"
#import "TMUICommonDefines.h"
#import "CALayer+TMUI.h"
#import "UIView+TMUI.h"
#import "TMUIHelper.h"
@implementation UITableView (TMUIGroup)

@end

@interface UITableViewCell (TMUI_Private)

@property(nonatomic, assign, readwrite) TMUITableViewCellPosition tmui_cellPosition;

@end

const UITableViewStyle TMUITableViewStyleInsetGrouped = UITableViewStyleGrouped + 1;

@implementation UITableView (TMUI_InsetGrouped)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        OverrideImplementation([UITableView class], NSSelectorFromString(@"_configureCellForDisplay:forIndexPath:"), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UITableView *selfObject, UITableViewCell *cell, NSIndexPath *indexPath) {
                
                // call super，-[UITableViewDelegate tableView:willDisplayCell:forRowAtIndexPath:] 比这个还晚，所以不用担心触发 delegate
                void (*originSelectorIMP)(id, SEL, UITableViewCell *, NSIndexPath *);
                originSelectorIMP = (void (*)(id, SEL, UITableViewCell *, NSIndexPath *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, cell, indexPath);
                
                // UITableViewCell(TMUI) 内会根据 cellPosition 调整 separator 的布局，所以先在这里赋值以供那边使用
                TMUITableViewCellPosition position = [selfObject tmui_positionForRowAtIndexPath:indexPath];
                cell.tmui_cellPosition = position;
                
                if (selfObject.tmui_style == TMUITableViewStyleInsetGrouped) {
                    TMUICornerMask mask = TMUILayerAllCorner;
                    CGFloat cornerRadius = selfObject.tmui_insetGroupedCornerRadius;
                    switch (position) {
                        case TMUITableViewCellPositionFirstInSection:
                            mask = TMUILayerMinXMinYCorner|TMUILayerMaxXMinYCorner;
                            break;
                        case TMUITableViewCellPositionLastInSection:
                            mask = TMUILayerMinXMaxYCorner|TMUILayerMaxXMaxYCorner;
                            break;
                        case TMUITableViewCellPositionMiddleInSection:
                        case TMUITableViewCellPositionNone:
                            cornerRadius = 0;
                            break;
                        default:
                            break;
                    }
                    if (@available(iOS 13.0, *)) {
                    } else {
                        cell.layer.tmui_maskedCorners = mask;
                        cell.layer.masksToBounds = YES;
                    }
                    cell.layer.cornerRadius = cornerRadius;
                }
            };
        });
        
        if (@available(iOS 13.0, *)) {
            OverrideImplementation([UITableView class], @selector(layoutMargins), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^UIEdgeInsets(UITableView *selfObject) {
                    // call super
                    UIEdgeInsets (*originSelectorIMP)(id, SEL);
                    originSelectorIMP = (UIEdgeInsets (*)(id, SEL))originalIMPProvider();
                    UIEdgeInsets result = originSelectorIMP(selfObject, originCMD);
                    
                    if (selfObject.tmui_style == TMUITableViewStyleInsetGrouped) {
                        result.left = selfObject.tmui_safeAreaInsets.left + selfObject.tmui_insetGroupedHorizontalInset;
                        result.right = selfObject.tmui_safeAreaInsets.right + selfObject.tmui_insetGroupedHorizontalInset;
                    }
                    
                    return result;
                };
            });
        }
    });
}

static char kAssociatedObjectKey_style;
- (void)setTmui_style:(UITableViewStyle)tmui_style {
    if (@available(iOS 13.0, *)) {
    } else {
        objc_setAssociatedObject(self, &kAssociatedObjectKey_style, @(tmui_style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (UITableViewStyle)tmui_style {
    if (@available(iOS 13.0, *)) {
        return self.style;
    }
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_style)) integerValue];
}

static char kAssociatedObjectKey_insetGroupedCornerRadius;
- (void)setTmui_insetGroupedCornerRadius:(CGFloat)tmui_insetGroupedCornerRadius {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_insetGroupedCornerRadius, @(tmui_insetGroupedCornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.tmui_style == TMUITableViewStyleInsetGrouped && self.indexPathsForVisibleRows.count) {
        [self reloadData];
    }
}

- (CGFloat)tmui_insetGroupedCornerRadius {
    NSNumber *associatedValue = (NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_insetGroupedCornerRadius);
    if (!associatedValue) {
        // 从来没设置过（包括业务主动设置或者通过 UIAppearance 方式设置），则用 iOS 13 系统默认值
        // 不在 UITableView init 时设置是因为那样会使 UIAppearance 失效
        return 10;
    }
    return associatedValue.doubleValue;
}

static char kAssociatedObjectKey_insetGroupedHorizontalInset;
- (void)setTmui_insetGroupedHorizontalInset:(CGFloat)tmui_insetGroupedHorizontalInset {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_insetGroupedHorizontalInset, @(tmui_insetGroupedHorizontalInset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.tmui_style == TMUITableViewStyleInsetGrouped && self.indexPathsForVisibleRows.count) {
        [self reloadData];
    }
}

- (CGFloat)tmui_insetGroupedHorizontalInset {
    NSNumber *associatedValue = (NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_insetGroupedHorizontalInset);
    if (!associatedValue) {
        // 从来没设置过（包括业务主动设置或者通过 UIAppearance 方式设置），则用 iOS 13 系统默认值
        // 不在 UITableView init 时设置是因为那样会使 UIAppearance 失效
        return PreferredValueForVisualDevice(20, 15);
    }
    return associatedValue.doubleValue;
}

@end
