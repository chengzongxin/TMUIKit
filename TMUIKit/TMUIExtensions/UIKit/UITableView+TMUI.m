//
//  UITableView+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import "UITableView+TMUI.h"
#import "TMUICore.h"
#import "UIScrollView+TMUI.h"
#import "NSObject+TMUI.h"
//#import "CALayer+TMUI.h"
#import "UIView+TMUI.h"
#import "TMUIConfigurationMacros.h"

const NSUInteger kFloatValuePrecision = 4;// 统一一个小数点运算精度

@interface UITableView ()
@property(nonatomic, assign, readwrite) UITableViewStyle tmui_style;
@end


@implementation UITableView (TMUI)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        OverrideImplementation([UITableView class], @selector(initWithFrame:style:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^UITableView *(UITableView *selfObject, CGRect firstArgv, UITableViewStyle secondArgv) {

                if (@available(iOS 13.0, *)) {
                    // iOS 13 tmui_style 的 getter 直接返回 tableView.style，所以这里不需要给 tmui_style 赋值
                } else {
                    selfObject.tmui_style = secondArgv;
                    if (secondArgv == TMUITableViewStyleInsetGrouped) {
                        secondArgv = UITableViewStyleGrouped;
                    }
                }

                // call super
                UITableView *(*originSelectorIMP)(id, SEL, CGRect, UITableViewStyle);
                originSelectorIMP = (UITableView * (*)(id, SEL, CGRect, UITableViewStyle))originalIMPProvider();
                UITableView *result = originSelectorIMP(selfObject, originCMD, firstArgv, secondArgv);

                // iOS 11 之后 estimatedRowHeight 如果值为 UITableViewAutomaticDimension，estimate 效果也会生效（iOS 11 以前要 > 0 才会生效）。
                // 而当使用 estimate 效果时，会导致 contentSize 之类的计算不准确，所以这里给一个途径让项目可以方便地控制 UITableView（不包含子类，例如 UIPickerTableView）的 estimatedRowHeight 效果的开关，至于 TMUITableView 会在自己内部 init 时调用
                // https://github.com/Tencent/TMUI_iOS/issues/313
                if (TMUICMIActivated && [NSStringFromClass(selfObject.class) isEqualToString:@"UITableView"]) {
                    [selfObject _tmui_configEstimatedRowHeight];
                }

                return result;
            };
        });

        OverrideImplementation([UITableView class], @selector(sizeThatFits:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^CGSize(UITableView *selfObject, CGSize size) {
                [selfObject alertEstimatedHeightUsageIfDetected];

                // call super
                CGSize (*originSelectorIMP)(id, SEL, CGSize);
                originSelectorIMP = (CGSize (*)(id, SEL, CGSize))originalIMPProvider();
                CGSize result = originSelectorIMP(selfObject, originCMD, size);

                return result;
            };
        });

        OverrideImplementation([UITableView class], @selector(scrollToRowAtIndexPath:atScrollPosition:animated:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UITableView *selfObject, NSIndexPath *indexPath, UITableViewScrollPosition scrollPosition, BOOL animated) {

                if (!indexPath) {
                    return;
                }

                BOOL isIndexPathLegal = YES;
                NSInteger numberOfSections = [selfObject numberOfSections];
                if (indexPath.section < 0 || indexPath.section >= numberOfSections) {
                    isIndexPathLegal = NO;
                } else if (indexPath.row != NSNotFound) {
                    NSInteger rows = [selfObject numberOfRowsInSection:indexPath.section];
                    isIndexPathLegal = indexPath.row >= 0 && indexPath.row < rows;
                }
                if (!isIndexPathLegal) {
                    NSLog(@"UITableView (TMUI) %@ - target indexPath : %@ ，不合法的indexPath。\n%@", selfObject, indexPath, [NSThread callStackSymbols]);
                    if (TMUICMIActivated && !ShouldPrintTMUIWarnLogToConsole) {
                        NSAssert(NO, @"出现不合法的indexPath");
                    }
                    return;
                }

                // call super
                void (*originSelectorIMP)(id, SEL, NSIndexPath *, UITableViewScrollPosition, BOOL);
                originSelectorIMP = (void (*)(id, SEL, NSIndexPath *, UITableViewScrollPosition, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, indexPath, scrollPosition, animated);
            };
        });
    });
}


- (void)tmui_setSeparatorInset:(UIEdgeInsets)edge{
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:edge];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:edge];
    }
}

// 防止 release 版本滚动到不合法的 indexPath 会 crash
- (void)tmui_scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    if (!indexPath) {
        return;
    }
    
    BOOL isIndexPathLegal = YES;
    NSInteger numberOfSections = [self numberOfSections];
    if (indexPath.section >= numberOfSections) {
        isIndexPathLegal = NO;
    } else if (indexPath.row != NSNotFound) {
        NSInteger rows = [self numberOfRowsInSection:indexPath.section];
        isIndexPathLegal = indexPath.row < rows;
    }
    if (!isIndexPathLegal) {
        NSLog(@"UITableView (TMUI) %@ - target indexPath : %@ ，不合法的indexPath。\n%@", self, indexPath, [NSThread callStackSymbols]);
        if (TMUICMIActivated && !ShouldPrintTMUIWarnLogToConsole) {
            NSAssert(NO, @"出现不合法的indexPath");
        }
    } else {
        [self tmui_scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    }
}

- (void)tmui_styledAsTMUITableView {
    
    if (!TMUICMIActivated) return;
    
    [self _tmui_configEstimatedRowHeight];
    
    self.backgroundColor = PreferredValueForTableViewStyle(self.tmui_style, TableViewBackgroundColor, TableViewGroupedBackgroundColor, TableViewInsetGroupedBackgroundColor);
    self.separatorColor = PreferredValueForTableViewStyle(self.tmui_style, TableViewSeparatorColor, TableViewGroupedSeparatorColor, TableViewInsetGroupedSeparatorColor);
    
    // 去掉空白的cell
    if (self.tmui_style == UITableViewStylePlain) {
        self.tableFooterView = [[UIView alloc] init];
    }
    
    self.backgroundView = [[UIView alloc] init]; // 设置一个空的 backgroundView，去掉系统自带的，以使 backgroundColor 生效（系统在 tableHeaderView 为 UISearchBar 时会自动设置一层背景灰色，导致背景色看不到。只有使用了自定义 backgroundView 才能屏蔽系统这个行为）
    
    self.sectionIndexColor = TableSectionIndexColor;
    self.sectionIndexTrackingBackgroundColor = TableSectionIndexTrackingBackgroundColor;
    self.sectionIndexBackgroundColor = TableSectionIndexBackgroundColor;
    
    self.tmui_insetGroupedCornerRadius = TableViewInsetGroupedCornerRadius;
    self.tmui_insetGroupedHorizontalInset = TableViewInsetGroupedHorizontalInset;
}

- (void)_tmui_configEstimatedRowHeight {
    if (TableViewEstimatedHeightEnabled) {
        self.estimatedRowHeight = TableViewCellNormalHeight;
        self.rowHeight = UITableViewAutomaticDimension;
        
        self.estimatedSectionHeaderHeight = UITableViewAutomaticDimension;
        self.sectionHeaderHeight = UITableViewAutomaticDimension;
        
        // 另外 iOS 10 及以下 estimatedSectionFooterHeight 如果为大于 0 的值，则无法触发 footerView 的 self-sizing，应该是系统的 bug，另外 iOS 10 及以下 estimatedSectionFooterHeight 的默认值也是 0 而非文档中描述的 UITableViewAutomaticDimension。
        if (@available(iOS 11.0, *)) {
            self.estimatedSectionFooterHeight = UITableViewAutomaticDimension;
        } else {
            self.estimatedSectionFooterHeight = 0;
        }
        self.sectionFooterHeight = UITableViewAutomaticDimension;
    } else {
        self.estimatedRowHeight = 0;
        self.rowHeight = TableViewCellNormalHeight;
        
        self.estimatedSectionHeaderHeight = 0;
        self.sectionHeaderHeight = UITableViewAutomaticDimension;
        
        self.estimatedSectionFooterHeight = 0;
        self.sectionFooterHeight = UITableViewAutomaticDimension;
    }
}

- (NSIndexPath *)tmui_indexPathForRowAtView:(UIView *)view {
    if (!view || !view.superview) {
        return nil;
    }
    
    if ([view isKindOfClass:[UITableViewCell class]] && ([NSStringFromClass(view.superview.class) isEqualToString:@"UITableViewWrapperView"] ? view.superview.superview : view.superview) == self) {
        // iOS 11 下，cell.superview 是 UITableView，iOS 11 以前，cell.superview 是 UITableViewWrapperView
        return [self indexPathForCell:(UITableViewCell *)view];
    }
    
    return [self tmui_indexPathForRowAtView:view.superview];
}

- (NSInteger)tmui_indexForSectionHeaderAtView:(UIView *)view {
    [self alertEstimatedHeightUsageIfDetected];
    
    if (!view || ![view isKindOfClass:[UIView class]]) {
        return -1;
    }
    
    CGPoint origin = [self convertPoint:view.frame.origin fromView:view.superview];
    origin = CGPointToFixed(origin, kFloatValuePrecision);// 避免一些浮点数精度问题导致的计算错误
    
    NSInteger low = 0;
    NSInteger high = [self numberOfSections];
    while (low <= high) {
        NSInteger mid = low + ((high-low) >> 1);
        CGRect rectForSection = [self rectForSection:mid];
        rectForSection = CGRectToFixed(rectForSection, kFloatValuePrecision);
        if (CGRectContainsPoint(rectForSection, origin)) {
            UITableViewHeaderFooterView *headerView = [self headerViewForSection:mid];
            if (headerView && [view isDescendantOfView:headerView]) {
                return mid;
            } else {
                return -1;
            }
        } else if (rectForSection.origin.y < origin.y) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
    }
    return -1;
}

- (NSArray<NSNumber *> *)tmui_indexForVisibleSectionHeaders {
    NSArray<NSIndexPath *> *visibleCellIndexPaths = [self indexPathsForVisibleRows];
    NSMutableArray<NSNumber *> *visibleSections = [[NSMutableArray alloc] init];
    NSMutableArray<NSNumber *> *result = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < visibleCellIndexPaths.count; i++) {
        if (visibleSections.count == 0 || visibleCellIndexPaths[i].section != visibleSections.lastObject.integerValue) {
            [visibleSections addObject:@(visibleCellIndexPaths[i].section)];
        }
    }
    for (NSInteger i = 0; i < visibleSections.count; i++) {
        NSInteger section = visibleSections[i].integerValue;
        if ([self tmui_isHeaderVisibleForSection:section]) {
            [result addObject:visibleSections[i]];
        }
    }
    if (result.count == 0) {
        result = nil;
    }
    return result;
}

- (NSInteger)tmui_indexOfPinnedSectionHeader {
    NSArray<NSNumber *> *visibleSectionIndex = [self tmui_indexForVisibleSectionHeaders];
    for (NSInteger i = 0; i < visibleSectionIndex.count; i++) {
        NSInteger section = visibleSectionIndex[i].integerValue;
        if ([self tmui_isHeaderPinnedForSection:section]) {
            return section;
        } else {
            continue;
        }
    }
    return -1;
}

- (BOOL)tmui_isHeaderPinnedForSection:(NSInteger)section {
    if (self.tmui_style != UITableViewStylePlain) return NO;
    if (section >= [self numberOfSections]) return NO;
    
    // 系统这两个接口获取到的 rect 是在 contentSize 里的 rect，而不是实际看到的 rect
    CGRect rectForSection = [self rectForSection:section];
    CGRect rectForHeader = [self rectForHeaderInSection:section];
    BOOL isSectionScrollIntoContentInsetTop = self.contentOffset.y + self.tmui_contentInset.top > CGRectGetMinY(rectForSection);// 表示这个 section 已经往上滚动，超过 contentInset.top 那条线了
    BOOL isSectionStayInContentInsetTop = self.contentOffset.y + self.tmui_contentInset.top <= CGRectGetMaxY(rectForSection) - CGRectGetHeight(rectForHeader);// 表示这个 section 还没被完全滚走
    BOOL isPinned = isSectionScrollIntoContentInsetTop && isSectionStayInContentInsetTop;
    return isPinned;
}

- (BOOL)tmui_isHeaderVisibleForSection:(NSInteger)section {
    if (self.tmui_style != UITableViewStylePlain) return NO;
    if (section >= [self numberOfSections]) return NO;
    
    // 不存在 header 就不用判断
    CGRect rectForSectionHeader = [self rectForHeaderInSection:section];
    if (CGRectGetHeight(rectForSectionHeader) <= 0) return NO;
    
    // 系统这个接口获取到的 rect 是在 contentSize 里的 rect，而不是实际看到的 rect
    CGRect rectForSection = [self rectForSection:section];
    BOOL isSectionScrollIntoBounds = CGRectGetMinY(rectForSection) < self.contentOffset.y + CGRectGetHeight(self.bounds);
    BOOL isSectionStayInContentInsetTop = self.contentOffset.y + self.tmui_contentInset.top < CGRectGetMaxY(rectForSection);// 表示这个 section 还没被完全滚走
    BOOL isVisible = isSectionScrollIntoBounds && isSectionStayInContentInsetTop;
    return isVisible;
}

- (TMUITableViewCellPosition)tmui_positionForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger numberOfRowsInSection = [self.dataSource tableView:self numberOfRowsInSection:indexPath.section];
    if (numberOfRowsInSection == 1) {
        return TMUITableViewCellPositionSingleInSection;
    }
    if (indexPath.row == 0) {
        return TMUITableViewCellPositionFirstInSection;
    }
    if (indexPath.row == numberOfRowsInSection - 1) {
        return TMUITableViewCellPositionLastInSection;
    }
    return TMUITableViewCellPositionMiddleInSection;
}

- (BOOL)tmui_cellVisibleAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<NSIndexPath *> *visibleCellIndexPaths = self.indexPathsForVisibleRows;
    for (NSIndexPath *visibleIndexPath in visibleCellIndexPaths) {
        if ([indexPath isEqual:visibleIndexPath]) {
            return YES;
        }
    }
    return NO;
}

- (void)tmui_clearsSelection {
    NSArray<NSIndexPath *> *selectedIndexPaths = [self indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in selectedIndexPaths) {
        [self deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)tmui_scrollToRowFittingOffsetY:(CGFloat)offsetY atIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    [self alertEstimatedHeightUsageIfDetected];
    
    if (![self tmui_canScroll]) {
        return;
    }
    
    CGRect rectForRow = [self rectForRowAtIndexPath:indexPath];
    if (CGRectEqualToRect(rectForRow, CGRectZero)) {
        return;
    }
    
    // 如果要滚到的row在列表尾部，则这个row是不可能滚到顶部的（因为列表尾部已经不够空间了），所以要判断一下
    BOOL canScrollRowToTop = CGRectGetMaxY(rectForRow) + CGRectGetHeight(self.frame) - (offsetY + CGRectGetHeight(rectForRow)) <= self.contentSize.height;
    if (canScrollRowToTop) {
        [self setContentOffset:CGPointMake(self.contentOffset.x, CGRectGetMinY(rectForRow) - offsetY) animated:animated];
    } else {
        [self tmui_scrollToBottomAnimated:animated];
    }
}

- (CGFloat)tmui_validContentWidth {
    return CGRectGetWidth(self.bounds) - UIEdgeInsetsGetHorizontalValue(self.tmui_safeAreaInsets) - (self.tmui_style == TMUITableViewStyleInsetGrouped ? self.tmui_insetGroupedHorizontalInset * 2 : 0);
}

- (CGSize)tmui_realContentSize {
    [self alertEstimatedHeightUsageIfDetected];
    
    if (!self.dataSource || !self.delegate) {
        return CGSizeZero;
    }
    
    CGSize contentSize = self.contentSize;
    CGFloat footerViewMaxY = CGRectGetMaxY(self.tableFooterView.frame);
    CGSize realContentSize = CGSizeMake(contentSize.width, footerViewMaxY);
    
    NSInteger lastSection = [self numberOfSections] - 1;
    if (lastSection < 0) {
        // 说明numberOfSetions为0，tableView没有cell，则直接取footerView的底边缘
        return realContentSize;
    }
    
    CGRect lastSectionRect = [self rectForSection:lastSection];
    realContentSize.height = fmax(realContentSize.height, CGRectGetMaxY(lastSectionRect));
    return realContentSize;
}

- (BOOL)tmui_canScroll {
    // 没有高度就不用算了，肯定不可滚动，这里只是做个保护
    if (CGRectGetHeight(self.bounds) <= 0) {
        return NO;
    }
    
    if ([self.tableHeaderView isKindOfClass:[UISearchBar class]]) {
        BOOL canScroll = self.tmui_realContentSize.height + UIEdgeInsetsGetVerticalValue(self.tmui_contentInset) > CGRectGetHeight(self.bounds);
        return canScroll;
    } else {
        return [super tmui_canScroll];
    }
}

- (BOOL)tmui_canScrollToIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath) {
        return NO;
    }
    return indexPath.section < self.numberOfSections && indexPath.row < [self numberOfRowsInSection:indexPath.section];
}

- (NSIndexPath *)tmui_lastIndexPath{
    int section = (int)[self numberOfSections] - 1;
    if (section < 0) {
        return nil;
    }
    int row = (int)[self numberOfRowsInSection:section] - 1;
    if (section < 0 || row < 0) {
        return nil;
    }
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    return lastIndexPath;
}



- (void)alertEstimatedHeightUsageIfDetected {
    BOOL usingEstimatedRowHeight = [self.delegate respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)] || self.estimatedRowHeight > 0;
    BOOL usingEstimatedSectionHeaderHeight = [self.delegate respondsToSelector:@selector(tableView:estimatedHeightForHeaderInSection:)] || self.estimatedSectionHeaderHeight > 0;
    BOOL usingEstimatedSectionFooterHeight = [self.delegate respondsToSelector:@selector(tableView:estimatedHeightForFooterInSection:)] || self.estimatedSectionFooterHeight > 0;
    
    if (usingEstimatedRowHeight || usingEstimatedSectionHeaderHeight || usingEstimatedSectionFooterHeight) {
        [self TMUISymbolicUsingTableViewEstimatedHeightMakeWarning];
    }
}

- (void)TMUISymbolicUsingTableViewEstimatedHeightMakeWarning {
    NSLog(@"UITableView (TMUI) 当开启了 UITableView 的 estimatedRow(SectionHeader / SectionFooter)Height 功能后，不应该手动修改 contentOffset 和 contentSize，也会影响 contentSize、sizeThatFits:、rectForXxx 等方法的计算，请注意确认当前是否存在不合理的业务代码。可添加 '%@' 的 Symbolic Breakpoint 以捕捉此类信息\n%@", NSStringFromSelector(_cmd), [NSThread callStackSymbols]);
}

- (void)tmui_performBatchUpdates:(void (NS_NOESCAPE ^ _Nullable)(void))updates completion:(void (^ _Nullable)(BOOL finished))completion {
    if (@available(iOS 11.0, *)) {
        [self performBatchUpdates:updates completion:completion];
    } else {
        if (!updates && completion) {
            completion(YES);// 私有方法对 updates 为空的情况，不会调用 completion，但 iOS 11 新增的方法是可以的，所以这里对齐新版本的行为
        } else {
            [self tmui_performSelector:NSSelectorFromString([NSString stringWithFormat:@"_%@BatchUpdates:%@:", @"perform", @"completion"]) withArguments:&updates, &completion, nil];
        }
    }
}


- (NSUInteger)tmui_indexOfIndexPath:(NSIndexPath *)indexPath {
    if (!self.dataSource) {
        return 0;
    }
    NSUInteger index = 0;
    NSUInteger sectionIndex = indexPath.section;
    
    for (int i=0; i<sectionIndex; i++) {
        NSUInteger sectionRowsCount = [self.dataSource tableView:self numberOfRowsInSection:i];
        index += sectionRowsCount;
    }
    
    index += indexPath.row;
    
    return index;
}

- (NSIndexPath *)tmui_indexPathOfIndex:(NSUInteger)index {
    if (!self.dataSource) {
        return nil;
    }
    NSUInteger sectionIndex = 0;
    while ([self.dataSource tableView:self numberOfRowsInSection:sectionIndex]<=index) {
        index -= [self.dataSource tableView:self numberOfRowsInSection:sectionIndex];
        sectionIndex ++;
    }
    return [NSIndexPath indexPathForRow:index inSection:sectionIndex];
}

@end


@implementation UITableView (TMUI_RegisterCell)

//- (void)tmui_registerCellWithNibName:(NSString *)nibName{
//    [self tmui_registerCellWithNibName:nibName forCellReuseIdentifier:nibName];
//}

- (void)tmui_registerCellWithNibClass:(Class)cellClass{
    [self tmui_registerCellWithNibName:NSStringFromClass(cellClass) identifier:NSStringFromClass(cellClass)];
}

- (void)tmui_registerCellWithNibClass:(Class)cellClass identifier:(NSString *)identifier{
    [self tmui_registerCellWithNibName:NSStringFromClass(cellClass) identifier:identifier];
}

- (void)tmui_registerCellWithNibName:(NSString *)nibName identifier:(NSString *)identifier{
    UINib *nib = [UINib nibWithNibName:nibName bundle:[NSBundle bundleForClass:NSClassFromString(nibName)]];
    [self registerNib:nib forCellReuseIdentifier:identifier];
}

- (void)tmui_registerCellWithClass:(Class)aClass{
    NSString *identifier = NSStringFromClass(aClass);
    [self registerClass:aClass forCellReuseIdentifier:identifier];
}


- (void)tmui_registerSectionHeaderFooterWithNibName:(NSString *)nibName{
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    [self registerNib:nib forHeaderFooterViewReuseIdentifier:nibName];
}

- (void)tmui_registerSectionHeaderFooterWithClass:(Class)aClass{
    [self registerClass:aClass forHeaderFooterViewReuseIdentifier:NSStringFromClass(aClass)];
}



- (UITableViewCell *)tmui_dequeueReusableCellWithIdentifier:(NSString *)identifier
                                         initWithClass:(Class)cellClass
                                                 Style:(UITableViewCellStyle)style {
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[cellClass alloc] initWithStyle:style reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (UITableViewCell *)tmui_dequeueReusableCellWithIdentifier:(NSString *)identifier
                                         initWithClass:(Class)cellClass {
   UITableViewCell *cell = [self tmui_dequeueReusableCellWithIdentifier:identifier
                                                     initWithClass:cellClass
                                                             Style:UITableViewCellStyleDefault];
    return  cell;
}

- (UITableViewCell *)tmui_dequeueReusableCellWithIdentifier:(NSString *)identifier
                                   initWithClassString:(NSString *)classString
                                                 Style:(UITableViewCellStyle)style {
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSClassFromString(classString) alloc] initWithStyle:style reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSAssert(cell!=nil, @"className不存在");
    return cell;
}

- (UITableViewCell *)tmui_dequeueReusableCellWithIdentifier:(NSString *)identifier
                                   initWithClassString:(NSString *)classString {
    UITableViewCell *cell = [self tmui_dequeueReusableCellWithIdentifier:identifier
                                                initWithClassString:classString
                                                              Style:UITableViewCellStyleDefault];
    return cell;
}

@end

