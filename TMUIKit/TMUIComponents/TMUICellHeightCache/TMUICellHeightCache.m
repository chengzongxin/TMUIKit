//
//  TMUICellHeightCache.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/27.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUICellHeightCache.h"
#import "TMUITableViewProtocols.h"
#import <TMUICore/TMUICore.h>
#import <TMUIExtensions/UIScrollView+TMUI.h>
#import <TMUIExtensions/UITableView+TMUI.h>
#import <TMUIExtensions/UIView+TMUI.h>
//#import "NSNumber+TMUI.h"

const CGFloat kTMUICellHeightInvalidCache = -1;

@interface TMUICellHeightCache ()

@property(nonatomic, strong) NSMutableDictionary<id<NSCopying>, NSNumber *> *cachedHeights;
@end

@implementation TMUICellHeightCache

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cachedHeights = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (BOOL)existsHeightForKey:(id<NSCopying>)key {
    NSNumber *number = self.cachedHeights[key];
    return number && ![number isEqualToNumber:@(kTMUICellHeightInvalidCache)];
}

- (void)cacheHeight:(CGFloat)height byKey:(id<NSCopying>)key {
    self.cachedHeights[key] = @(height);
}

- (CGFloat)heightForKey:(id<NSCopying>)key {
    return self.cachedHeights[key].doubleValue;
}

- (void)invalidateHeightForKey:(id<NSCopying>)key {
    [self.cachedHeights removeObjectForKey:key];
}

- (void)invalidateAllHeightCache {
    [self.cachedHeights removeAllObjects];
}

@end

@interface TMUICellHeightIndexPathCache ()

@property(nonatomic, strong) NSMutableArray<NSMutableArray<NSNumber *> *> *cachedHeights;
@end

@implementation TMUICellHeightIndexPathCache

- (instancetype)init {
    self = [super init];
    if (self) {
        self.automaticallyInvalidateEnabled = YES;
        self.cachedHeights = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)existsHeightAtIndexPath:(NSIndexPath *)indexPath {
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    NSNumber *number = self.cachedHeights[indexPath.section][indexPath.row];
    return number && ![number isEqualToNumber:@(kTMUICellHeightInvalidCache)];
}

- (void)cacheHeight:(CGFloat)height byIndexPath:(NSIndexPath *)indexPath {
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    self.cachedHeights[indexPath.section][indexPath.row] = @(height);
}

- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath {
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    return self.cachedHeights[indexPath.section][indexPath.row].doubleValue;
}

- (void)invalidateHeightInSection:(NSInteger)section {
    [self buildSectionsIfNeeded:section];
    [self.cachedHeights[section] removeAllObjects];
}

- (void)invalidateHeightAtIndexPath:(NSIndexPath *)indexPath {
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    self.cachedHeights[indexPath.section][indexPath.row] = @(kTMUICellHeightInvalidCache);
}

- (void)invalidateAllHeightCache {
    [self.cachedHeights enumerateObjectsUsingBlock:^(NSMutableArray<NSNumber *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeAllObjects];
    }];
}

- (void)buildCachesAtIndexPathsIfNeeded:(NSArray<NSIndexPath *> *)indexPaths {
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        [self buildSectionsIfNeeded:indexPath.section];
        [self buildRowsIfNeeded:indexPath.row inExistSection:indexPath.section];
    }];
}

- (void)buildSectionsIfNeeded:(NSInteger)targetSection {
    for (NSInteger section = 0; section <= targetSection; ++section) {
        if (section >= self.cachedHeights.count) {
            [self.cachedHeights addObject:[[NSMutableArray alloc] init]];
        }
    }
}

- (void)buildRowsIfNeeded:(NSInteger)targetRow inExistSection:(NSInteger)section {
    NSMutableArray<NSNumber *> *heightsInSection = self.cachedHeights[section];
    for (NSInteger row = 0; row <= targetRow; ++row) {
        if (row >= heightsInSection.count) {
            [heightsInSection addObject:@(kTMUICellHeightInvalidCache)];
        }
    }
}

@end

#pragma mark - UITableView Height Cache

/// ====================== 计算动态cell高度相关 =======================

@interface UITableView ()

/// key 为 tableView 的内容宽度，value 为该宽度下对应的缓存容器，从而保证 tableView 宽度变化时缓存也会跟着刷新
@property(nonatomic, strong) NSMutableDictionary<NSNumber *, TMUICellHeightCache *> *tmuiTableCache_allKeyedHeightCaches;
@property(nonatomic, strong) NSMutableDictionary<NSNumber *, TMUICellHeightIndexPathCache *> *tmuiTableCache_allIndexPathHeightCaches;
@end

@implementation UITableView (TMUIKeyedHeightCache)

TMUISynthesizeIdStrongProperty(tmuiTableCache_allKeyedHeightCaches, setTmuiTableCache_allKeyedHeightCaches)

- (TMUICellHeightCache *)tmui_keyedHeightCache {
    if (!self.tmuiTableCache_allKeyedHeightCaches) {
        self.tmuiTableCache_allKeyedHeightCaches = [[NSMutableDictionary alloc] init];
    }
    CGFloat contentWidth = self.tmui_validContentWidth;
    TMUICellHeightCache *cache = self.tmuiTableCache_allKeyedHeightCaches[@(contentWidth)];
    if (!cache) {
        cache = [[TMUICellHeightCache alloc] init];
        self.tmuiTableCache_allKeyedHeightCaches[@(contentWidth)] = cache;
    }
    return cache;
}

- (void)tmui_invalidateHeightForKey:(id<NSCopying>)aKey {
    [self.tmuiTableCache_allKeyedHeightCaches enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, TMUICellHeightCache * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj invalidateHeightForKey:aKey];
    }];
}

@end

@implementation UITableView (TMUICellHeightIndexPathCache)

TMUISynthesizeIdStrongProperty(tmuiTableCache_allIndexPathHeightCaches, setTmuiTableCache_allIndexPathHeightCaches)
TMUISynthesizeBOOLProperty(tmui_invalidateIndexPathHeightCachedAutomatically, setTmui_invalidateIndexPathHeightCachedAutomatically)

- (TMUICellHeightIndexPathCache *)tmui_indexPathHeightCache {
    if (!self.tmuiTableCache_allIndexPathHeightCaches) {
        self.tmuiTableCache_allIndexPathHeightCaches = [[NSMutableDictionary alloc] init];
    }
    CGFloat contentWidth = self.tmui_validContentWidth;
    TMUICellHeightIndexPathCache *cache = self.tmuiTableCache_allIndexPathHeightCaches[@(contentWidth)];
    if (!cache) {
        cache = [[TMUICellHeightIndexPathCache alloc] init];
        self.tmuiTableCache_allIndexPathHeightCaches[@(contentWidth)] = cache;
    }
    return cache;
}

- (void)tmui_invalidateHeightAtIndexPath:(NSIndexPath *)indexPath {
    [self.tmuiTableCache_allIndexPathHeightCaches enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, TMUICellHeightIndexPathCache * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj invalidateHeightAtIndexPath:indexPath];
    }];
}

@end

@implementation UITableView (TMUIIndexPathHeightCacheInvalidation)

- (void)tmui_reloadDataWithoutInvalidateIndexPathHeightCache {
    [self tmuiTableCache_reloadData];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selectors[] = {
            @selector(initWithFrame:style:),
            @selector(initWithCoder:),
            @selector(reloadData),
            @selector(insertSections:withRowAnimation:),
            @selector(deleteSections:withRowAnimation:),
            @selector(reloadSections:withRowAnimation:),
            @selector(moveSection:toSection:),
            @selector(insertRowsAtIndexPaths:withRowAnimation:),
            @selector(deleteRowsAtIndexPaths:withRowAnimation:),
            @selector(reloadRowsAtIndexPaths:withRowAnimation:),
            @selector(moveRowAtIndexPath:toIndexPath:)
        };
        for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
            SEL originalSelector = selectors[index];
            SEL swizzledSelector = NSSelectorFromString([@"tmuiTableCache_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
            ExchangeImplementations([self class], originalSelector, swizzledSelector);
        }
    });
}

- (instancetype)tmuiTableCache_initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    [self tmuiTableCache_initWithFrame:frame style:style];
    [self tmuiTableCache_didInitialize];
    return self;
}

- (instancetype)tmuiTableCache_initWithCoder:(NSCoder *)aDecoder {
    [self tmuiTableCache_initWithCoder:aDecoder];
    [self tmuiTableCache_didInitialize];
    return self;
}

- (void)tmuiTableCache_didInitialize {
    self.tmui_invalidateIndexPathHeightCachedAutomatically = YES;
}

- (void)tmuiTableCache_reloadData {
    if (self.tmui_invalidateIndexPathHeightCachedAutomatically) {
        [self.tmuiTableCache_allIndexPathHeightCaches removeAllObjects];
    }
    [self tmuiTableCache_reloadData];
}

- (void)tmuiTableCache_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.tmui_invalidateIndexPathHeightCachedAutomatically) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            [self.tmuiTableCache_allIndexPathHeightCaches enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, TMUICellHeightIndexPathCache * _Nonnull obj, BOOL * _Nonnull stop) {
                [obj buildSectionsIfNeeded:section];
                [obj.cachedHeights insertObject:[[NSMutableArray alloc] init] atIndex:section];
            }];
        }];
    }
    [self tmuiTableCache_insertSections:sections withRowAnimation:animation];
}

- (void)tmuiTableCache_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.tmui_invalidateIndexPathHeightCachedAutomatically) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            [self.tmuiTableCache_allIndexPathHeightCaches enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, TMUICellHeightIndexPathCache * _Nonnull obj, BOOL * _Nonnull stop) {
                [obj buildSectionsIfNeeded:section];
                [obj.cachedHeights removeObjectAtIndex:section];
            }];
        }];
    }
    [self tmuiTableCache_deleteSections:sections withRowAnimation:animation];
}

- (void)tmuiTableCache_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.tmui_invalidateIndexPathHeightCachedAutomatically) {
        [sections enumerateIndexesUsingBlock: ^(NSUInteger section, BOOL *stop) {
            [self.tmuiTableCache_allIndexPathHeightCaches enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, TMUICellHeightIndexPathCache * _Nonnull obj, BOOL * _Nonnull stop) {
                [obj buildSectionsIfNeeded:section];
                [obj invalidateHeightInSection:section];
            }];
        }];
    }
    [self tmuiTableCache_reloadSections:sections withRowAnimation:animation];
}

- (void)tmuiTableCache_moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    if (self.tmui_invalidateIndexPathHeightCachedAutomatically) {
        [self.tmuiTableCache_allIndexPathHeightCaches enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, TMUICellHeightIndexPathCache * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj buildSectionsIfNeeded:section];
            [obj buildSectionsIfNeeded:newSection];
            [obj.cachedHeights exchangeObjectAtIndex:section withObjectAtIndex:newSection];
        }];
    }
    [self tmuiTableCache_moveSection:section toSection:newSection];
}

- (void)tmuiTableCache_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.tmui_invalidateIndexPathHeightCachedAutomatically) {
        [self.tmuiTableCache_allIndexPathHeightCaches enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, TMUICellHeightIndexPathCache * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj buildCachesAtIndexPathsIfNeeded:indexPaths];
            [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableArray<NSNumber *> *heightsInSection = obj.cachedHeights[indexPath.section];
                [heightsInSection insertObject:@(kTMUICellHeightInvalidCache) atIndex:indexPath.row];
            }];
        }];
    }
    [self tmuiTableCache_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)tmuiTableCache_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.tmui_invalidateIndexPathHeightCachedAutomatically) {
        [self.tmuiTableCache_allIndexPathHeightCaches enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, TMUICellHeightIndexPathCache * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj buildCachesAtIndexPathsIfNeeded:indexPaths];
            NSMutableDictionary<NSNumber *, NSMutableIndexSet *> *mutableIndexSetsToRemove = [NSMutableDictionary dictionary];
            [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
                NSMutableIndexSet *mutableIndexSet = mutableIndexSetsToRemove[@(indexPath.section)];
                if (!mutableIndexSet) {
                    mutableIndexSet = [NSMutableIndexSet indexSet];
                    mutableIndexSetsToRemove[@(indexPath.section)] = mutableIndexSet;
                }
                [mutableIndexSet addIndex:indexPath.row];
            }];
            [mutableIndexSetsToRemove enumerateKeysAndObjectsUsingBlock:^(NSNumber *aKey, NSIndexSet *indexSet, BOOL *stop) {
                NSMutableArray<NSNumber *> *heightsInSection = obj.cachedHeights[aKey.integerValue];
                [heightsInSection removeObjectsAtIndexes:indexSet];
            }];
        }];
    }
    [self tmuiTableCache_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)tmuiTableCache_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.tmui_invalidateIndexPathHeightCachedAutomatically) {
        [self.tmuiTableCache_allIndexPathHeightCaches enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, TMUICellHeightIndexPathCache * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj buildCachesAtIndexPathsIfNeeded:indexPaths];
            [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
                NSMutableArray<NSNumber *> *heightsInSection = obj.cachedHeights[indexPath.section];
                heightsInSection[indexPath.row] = @(kTMUICellHeightInvalidCache);
            }];
        }];
    }
    [self tmuiTableCache_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)tmuiTableCache_moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (self.tmui_invalidateIndexPathHeightCachedAutomatically) {
        [self.tmuiTableCache_allIndexPathHeightCaches enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, TMUICellHeightIndexPathCache * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj buildCachesAtIndexPathsIfNeeded:@[sourceIndexPath, destinationIndexPath]];
            if (obj.cachedHeights.count > 0 && obj.cachedHeights.count > sourceIndexPath.section && obj.cachedHeights.count > destinationIndexPath.section) {
                NSMutableArray<NSNumber *> *sourceHeightsInSection = obj.cachedHeights[sourceIndexPath.section];
                NSMutableArray<NSNumber *> *destinationHeightsInSection = obj.cachedHeights[destinationIndexPath.section];
                NSNumber *sourceHeight = sourceHeightsInSection[sourceIndexPath.row];
                NSNumber *destinationHeight = destinationHeightsInSection[destinationIndexPath.row];
                sourceHeightsInSection[sourceIndexPath.row] = destinationHeight;
                destinationHeightsInSection[destinationIndexPath.row] = sourceHeight;
            }
        }];
    }
    [self tmuiTableCache_moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}

@end

@implementation UITableView (TMUILayoutCell)

- (__kindof UITableViewCell *)templateCellForReuseIdentifier:(NSString *)identifier {
    NSAssert(identifier.length > 0, @"Expect a valid identifier - %@", identifier);
    NSMutableDictionary *templateCellsByIdentifiers = objc_getAssociatedObject(self, _cmd);
    if (!templateCellsByIdentifiers) {
        templateCellsByIdentifiers = @{}.mutableCopy;
        objc_setAssociatedObject(self, _cmd, templateCellsByIdentifiers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    UITableViewCell *templateCell = templateCellsByIdentifiers[identifier];
    if (!templateCell) {
        // 是否有通过dataSource返回的cell
        if ([self.dataSource respondsToSelector:@selector(tmui_tableView:cellWithIdentifier:)] ) {
            id <TMUICellHeightCache_UITableViewDataSource>dataSource = (id<TMUICellHeightCache_UITableViewDataSource>)self.dataSource;
            templateCell = [dataSource tmui_tableView:self cellWithIdentifier:identifier];
        }
        // 没有的话，则需要通过register来注册一个cell，否则会crash
        if (!templateCell) {
            templateCell = [self dequeueReusableCellWithIdentifier:identifier];
            NSAssert(templateCell != nil, @"Cell must be registered to table view for identifier - %@", identifier);
        }
        templateCell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        templateCellsByIdentifiers[identifier] = templateCell;
    }
    return templateCell;
}

- (CGFloat)tmui_heightForCellWithIdentifier:(NSString *)identifier configuration:(void (^)(__kindof UITableViewCell *))configuration {
    CGFloat contentWidth = self.tmui_validContentWidth;
    if (!identifier || contentWidth <= 0) {
        return 0;
    }
    UITableViewCell *cell = [self templateCellForReuseIdentifier:identifier];
    [cell prepareForReuse];
    if (configuration) configuration(cell);
    CGSize fitSize = CGSizeZero;
    if (cell && contentWidth > 0) {
        fitSize = [cell sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    }
    return flat(fitSize.height);
}

// 通过indexPath缓存高度
- (CGFloat)tmui_heightForCellWithIdentifier:(NSString *)identifier cacheByIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(__kindof UITableViewCell *))configuration {
    if (!identifier || !indexPath || self.tmui_validContentWidth <= 0) {
        return 0;
    }
    if ([self.tmui_indexPathHeightCache existsHeightAtIndexPath:indexPath]) {
        return [self.tmui_indexPathHeightCache heightForIndexPath:indexPath];
    }
    CGFloat height = [self tmui_heightForCellWithIdentifier:identifier configuration:configuration];
    [self.tmui_indexPathHeightCache cacheHeight:height byIndexPath:indexPath];
    return height;
}

// 通过key缓存高度
- (CGFloat)tmui_heightForCellWithIdentifier:(NSString *)identifier cacheByKey:(id<NSCopying>)key configuration:(void (^)(__kindof UITableViewCell *))configuration {
    if (!identifier || !key || self.tmui_validContentWidth <= 0) {
        return 0;
    }
    if ([self.tmui_keyedHeightCache existsHeightForKey:key]) {
        return [self.tmui_keyedHeightCache heightForKey:key];
    }
    CGFloat height = [self tmui_heightForCellWithIdentifier:identifier configuration:configuration];
    [self.tmui_keyedHeightCache cacheHeight:height byKey:key];
    return height;
}

- (void)tmui_invalidateAllHeight {
    [self.tmuiTableCache_allKeyedHeightCaches removeAllObjects];
    [self.tmuiTableCache_allIndexPathHeightCaches removeAllObjects];
}

@end

#pragma mark - UICollectionView Height Cache

/// ====================== 计算动态cell高度相关 =======================

@interface UICollectionView ()

/// key 为 UICollectionView 的内容大小（包裹着 CGSize），value 为该大小下对应的缓存容器，从而保证 UICollectionView 大小变化时缓存也会跟着刷新
@property(nonatomic, strong) NSMutableDictionary<NSValue *, TMUICellHeightCache *> *tmuiCollectionCache_allKeyedHeightCaches;
@property(nonatomic, strong) NSMutableDictionary<NSValue *, TMUICellHeightIndexPathCache *> *tmuiCollectionCache_allIndexPathHeightCaches;
@end

@implementation UICollectionView (TMUIKeyedHeightCache)

TMUISynthesizeIdStrongProperty(tmuiCollectionCache_allKeyedHeightCaches, setTmuiCollectionCache_allKeyedHeightCaches)

- (TMUICellHeightCache *)tmui_keyedHeightCache {
    if (!self.tmuiCollectionCache_allKeyedHeightCaches) {
        self.tmuiCollectionCache_allKeyedHeightCaches = [[NSMutableDictionary alloc] init];
    }
    CGSize collectionViewSize = CGSizeMake(CGRectGetWidth(self.bounds) - UIEdgeInsetsGetHorizontalValue(self.tmui_safeAreaInsets), CGRectGetHeight(self.bounds) - UIEdgeInsetsGetVerticalValue(self.tmui_safeAreaInsets));
    TMUICellHeightCache *cache = self.tmuiCollectionCache_allKeyedHeightCaches[[NSValue valueWithCGSize:collectionViewSize]];
    if (!cache) {
        cache = [[TMUICellHeightCache alloc] init];
        self.tmuiCollectionCache_allKeyedHeightCaches[[NSValue valueWithCGSize:collectionViewSize]] = cache;
    }
    return cache;
}

- (void)tmui_invalidateHeightForKey:(id<NSCopying>)aKey {
    [self.tmuiCollectionCache_allKeyedHeightCaches enumerateKeysAndObjectsUsingBlock:^(NSValue * _Nonnull key, TMUICellHeightCache * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj invalidateHeightForKey:aKey];
    }];
}

@end

@implementation UICollectionView (TMUICellHeightIndexPathCache)

TMUISynthesizeBOOLProperty(tmui_invalidateIndexPathHeightCachedAutomatically, setTmui_invalidateIndexPathHeightCachedAutomatically)
TMUISynthesizeIdStrongProperty(tmuiCollectionCache_allIndexPathHeightCaches, setTmuiCollectionCache_allIndexPathHeightCaches)

- (TMUICellHeightIndexPathCache *)tmui_indexPathHeightCache {
    if (!self.tmuiCollectionCache_allIndexPathHeightCaches) {
        self.tmuiCollectionCache_allIndexPathHeightCaches = [[NSMutableDictionary alloc] init];
    }
    CGSize collectionViewSize = CGSizeMake(CGRectGetWidth(self.bounds) - UIEdgeInsetsGetHorizontalValue(self.tmui_safeAreaInsets), CGRectGetHeight(self.bounds) - UIEdgeInsetsGetVerticalValue(self.tmui_safeAreaInsets));
    TMUICellHeightIndexPathCache *cache = self.tmuiCollectionCache_allIndexPathHeightCaches[[NSValue valueWithCGSize:collectionViewSize]];
    if (!cache) {
        cache = [[TMUICellHeightIndexPathCache alloc] init];
        self.tmuiCollectionCache_allIndexPathHeightCaches[[NSValue valueWithCGSize:collectionViewSize]] = cache;
    }
    return cache;
}

- (void)tmui_invalidateHeightAtIndexPath:(NSIndexPath *)indexPath {
    [self.tmuiCollectionCache_allIndexPathHeightCaches enumerateKeysAndObjectsUsingBlock:^(NSValue * _Nonnull key, TMUICellHeightIndexPathCache * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj invalidateHeightAtIndexPath:indexPath];
    }];
}

@end

@implementation UICollectionView (TMUIIndexPathHeightCacheInvalidation)

- (void)tmui_reloadDataWithoutInvalidateIndexPathHeightCache {
    [self tmuiCollectionCache_reloadData];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selectors[] = {
            @selector(initWithFrame:collectionViewLayout:),
            @selector(initWithCoder:),
            @selector(reloadData),
            @selector(insertSections:),
            @selector(deleteSections:),
            @selector(reloadSections:),
            @selector(moveSection:toSection:),
            @selector(insertItemsAtIndexPaths:),
            @selector(deleteItemsAtIndexPaths:),
            @selector(reloadItemsAtIndexPaths:),
            @selector(moveItemAtIndexPath:toIndexPath:)
        };
        for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); index++) {
            SEL originalSelector = selectors[index];
            SEL swizzledSelector = NSSelectorFromString([@"tmuiCollectionCache_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
            ExchangeImplementations([self class], originalSelector, swizzledSelector);
        }
    });
}

- (instancetype)tmuiCollectionCache_initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    [self tmuiCollectionCache_initWithFrame:frame collectionViewLayout:layout];
    [self tmuiCollectionCache_didInitialize];
    return self;
}

- (instancetype)tmuiCollectionCache_initWithCoder:(NSCoder *)aDecoder {
    [self tmuiCollectionCache_initWithCoder:aDecoder];
    [self tmuiCollectionCache_didInitialize];
    return self;
}

- (void)tmuiCollectionCache_didInitialize {
    self.tmui_invalidateIndexPathHeightCachedAutomatically = YES;
}

- (void)tmuiCollectionCache_reloadData {
    if (self.tmui_invalidateIndexPathHeightCachedAutomatically) {
        [self.tmuiCollectionCache_allIndexPathHeightCaches removeAllObjects];
    }
    [self tmuiCollectionCache_reloadData];
}

- (void)tmuiCollectionCache_insertSections:(NSIndexSet *)sections {
    if (self.tmui_invalidateIndexPathHeightCachedAutomatically) {
        [self.tmuiCollectionCache_allIndexPathHeightCaches enumerateKeysAndObjectsUsingBlock:^(NSValue * _Nonnull key, TMUICellHeightIndexPathCache * _Nonnull obj, BOOL * _Nonnull stop) {
            [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL * _Nonnull stop) {
                [obj buildSectionsIfNeeded:section];
                [obj.cachedHeights insertObject:[[NSMutableArray alloc] init] atIndex:section];
            }];
        }];
    }
    [self tmuiCollectionCache_insertSections:sections];
}

- (void)tmuiCollectionCache_deleteSections:(NSIndexSet *)sections {
    if (self.tmui_invalidateIndexPathHeightCachedAutomatically) {
        [self.tmuiCollectionCache_allIndexPathHeightCaches enumerateKeysAndObjectsUsingBlock:^(NSValue * _Nonnull key, TMUICellHeightIndexPathCache * _Nonnull obj, BOOL * _Nonnull stop) {
            [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL * _Nonnull stop) {
                [obj buildSectionsIfNeeded:section];
                [obj.cachedHeights removeObjectAtIndex:section];
            }];
        }];
    }
    [self tmuiCollectionCache_deleteSections:sections];
}

- (void)tmuiCollectionCache_reloadSections:(NSIndexSet *)sections {
    if (self.tmui_invalidateIndexPathHeightCachedAutomatically) {
        [self.tmuiCollectionCache_allIndexPathHeightCaches enumerateKeysAndObjectsUsingBlock:^(NSValue * _Nonnull key, TMUICellHeightIndexPathCache * _Nonnull obj, BOOL * _Nonnull stop) {
            [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL * _Nonnull stop) {
                [obj buildSectionsIfNeeded:section];
                [obj.cachedHeights[section] removeAllObjects];
            }];
        }];
    }
    [self tmuiCollectionCache_reloadSections:sections];
}

- (void)tmuiCollectionCache_moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    if (self.tmui_invalidateIndexPathHeightCachedAutomatically) {
        [self.tmuiCollectionCache_allIndexPathHeightCaches enumerateKeysAndObjectsUsingBlock:^(NSValue * _Nonnull key, TMUICellHeightIndexPathCache * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj buildSectionsIfNeeded:section];
            [obj buildSectionsIfNeeded:newSection];
            [obj.cachedHeights exchangeObjectAtIndex:section withObjectAtIndex:newSection];
        }];
    }
    [self tmuiCollectionCache_moveSection:section toSection:newSection];
}

- (void)tmuiCollectionCache_insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (self.tmui_invalidateIndexPathHeightCachedAutomatically) {
        [self.tmuiCollectionCache_allIndexPathHeightCaches enumerateKeysAndObjectsUsingBlock:^(NSValue * _Nonnull key, TMUICellHeightIndexPathCache * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj buildCachesAtIndexPathsIfNeeded:indexPaths];
            [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
                NSMutableArray<NSNumber *> *heightsInSection = obj.cachedHeights[indexPath.section];
                [heightsInSection insertObject:@(kTMUICellHeightInvalidCache) atIndex:indexPath.item];
            }];
        }];
    }
    [self tmuiCollectionCache_insertItemsAtIndexPaths:indexPaths];
}

- (void)tmuiCollectionCache_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (self.tmui_invalidateIndexPathHeightCachedAutomatically) {
        [self.tmuiCollectionCache_allIndexPathHeightCaches enumerateKeysAndObjectsUsingBlock:^(NSValue * _Nonnull key, TMUICellHeightIndexPathCache * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj buildCachesAtIndexPathsIfNeeded:indexPaths];
            NSMutableDictionary<NSNumber *, NSMutableIndexSet *> *mutableIndexSetsToRemove = [NSMutableDictionary dictionary];
            [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
                NSMutableIndexSet *mutableIndexSet = mutableIndexSetsToRemove[@(indexPath.section)];
                if (!mutableIndexSet) {
                    mutableIndexSet = [NSMutableIndexSet indexSet];
                    mutableIndexSetsToRemove[@(indexPath.section)] = mutableIndexSet;
                }
                [mutableIndexSet addIndex:indexPath.item];
            }];
            [mutableIndexSetsToRemove enumerateKeysAndObjectsUsingBlock:^(NSNumber *aKey, NSIndexSet *indexSet, BOOL *stop) {
                NSMutableArray<NSNumber *> *heightsInSection = obj.cachedHeights[aKey.integerValue];
                [heightsInSection removeObjectsAtIndexes:indexSet];
            }];
        }];
    }
    [self tmuiCollectionCache_deleteItemsAtIndexPaths:indexPaths];
}

- (void)tmuiCollectionCache_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (self.tmui_invalidateIndexPathHeightCachedAutomatically) {
        [self.tmuiCollectionCache_allIndexPathHeightCaches enumerateKeysAndObjectsUsingBlock:^(NSValue * _Nonnull key, TMUICellHeightIndexPathCache * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj buildCachesAtIndexPathsIfNeeded:indexPaths];
            [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
                NSMutableArray<NSNumber *> *heightsInSection = obj.cachedHeights[indexPath.section];
                heightsInSection[indexPath.item] = @(kTMUICellHeightInvalidCache);
            }];
        }];
    }
    [self tmuiCollectionCache_reloadItemsAtIndexPaths:indexPaths];
}

- (void)tmuiCollectionCache_moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (self.tmui_invalidateIndexPathHeightCachedAutomatically) {
        [self.tmuiCollectionCache_allIndexPathHeightCaches enumerateKeysAndObjectsUsingBlock:^(NSValue * _Nonnull key, TMUICellHeightIndexPathCache * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj buildCachesAtIndexPathsIfNeeded:@[sourceIndexPath, destinationIndexPath]];
            if (obj.cachedHeights.count > 0 && obj.cachedHeights.count > sourceIndexPath.section && obj.cachedHeights.count > destinationIndexPath.section) {
                NSMutableArray<NSNumber *> *sourceHeightsInSection = obj.cachedHeights[sourceIndexPath.section];
                NSMutableArray<NSNumber *> *destinationHeightsInSection = obj.cachedHeights[destinationIndexPath.section];
                NSNumber *sourceHeight = sourceHeightsInSection[sourceIndexPath.item];
                NSNumber *destinationHeight = destinationHeightsInSection[destinationIndexPath.item];
                sourceHeightsInSection[sourceIndexPath.item] = destinationHeight;
                destinationHeightsInSection[destinationIndexPath.item] = sourceHeight;
            }
        }];
    }
    [self tmuiCollectionCache_moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}

@end

@implementation UICollectionView (TMUILayoutCell)

- (__kindof UICollectionViewCell *)templateCellForReuseIdentifier:(NSString *)identifier cellClass:(Class)cellClass {
    NSAssert(identifier.length > 0, @"Expect a valid identifier - %@", identifier);
    NSAssert([self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]], @"only flow layout accept");
    NSAssert([cellClass isSubclassOfClass:[UICollectionViewCell class]], @"must be uicollection view cell");
    NSMutableDictionary *templateCellsByIdentifiers = objc_getAssociatedObject(self, _cmd);
    if (!templateCellsByIdentifiers) {
        templateCellsByIdentifiers = @{}.mutableCopy;
        objc_setAssociatedObject(self, _cmd, templateCellsByIdentifiers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    UICollectionViewCell *templateCell = templateCellsByIdentifiers[identifier];
    if (!templateCell) {
        // CollecionView 跟 TableView 不太一样，无法通过 dequeueReusableCellWithReuseIdentifier:forIndexPath: 来拿到cell（如果这样做，首先indexPath不知道传什么值，其次是这样做会已知crash，说数组越界），所以只能通过传一个class来通过init方法初始化一个cell，但是也有缓存来复用cell。
        // templateCell = [self dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        templateCell = [[cellClass alloc] initWithFrame:CGRectZero];
        NSAssert(templateCell != nil, @"Cell must be registered to collection view for identifier - %@", identifier);
    }
    templateCell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    templateCellsByIdentifiers[identifier] = templateCell;
    return templateCell;
}

- (CGFloat)tmui_heightForCellWithIdentifier:(NSString *)identifier cellClass:(Class)cellClass itemWidth:(CGFloat)itemWidth configuration:(void (^)(__kindof UICollectionViewCell *cell))configuration {
    if (!identifier || CGRectIsEmpty(self.bounds)) {
        return 0;
    }
    UICollectionViewCell *cell = [self templateCellForReuseIdentifier:identifier cellClass:cellClass];
    [cell prepareForReuse];
    if (configuration) configuration(cell);
    CGSize fitSize = CGSizeZero;
    if (cell && itemWidth > 0) {
        fitSize = [cell sizeThatFits:CGSizeMake(itemWidth, CGFLOAT_MAX)];
    }
    return ceil(fitSize.height);
}

// 通过indexPath缓存高度
- (CGFloat)tmui_heightForCellWithIdentifier:(NSString *)identifier cellClass:(Class)cellClass itemWidth:(CGFloat)itemWidth cacheByIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(__kindof UICollectionViewCell *cell))configuration {
    if (!identifier || !indexPath || CGRectIsEmpty(self.bounds)) {
        return 0;
    }
    if ([self.tmui_indexPathHeightCache existsHeightAtIndexPath:indexPath]) {
        return [self.tmui_indexPathHeightCache heightForIndexPath:indexPath];
    }
    CGFloat height = [self tmui_heightForCellWithIdentifier:identifier cellClass:cellClass itemWidth:itemWidth configuration:configuration];
    [self.tmui_indexPathHeightCache cacheHeight:height byIndexPath:indexPath];
    return height;
}

// 通过key缓存高度
- (CGFloat)tmui_heightForCellWithIdentifier:(NSString *)identifier cellClass:(Class)cellClass itemWidth:(CGFloat)itemWidth cacheByKey:(id<NSCopying>)key configuration:(void (^)(__kindof UICollectionViewCell *cell))configuration {
    if (!identifier || !key || CGRectIsEmpty(self.bounds)) {
        return 0;
    }
    if ([self.tmui_keyedHeightCache existsHeightForKey:key]) {
        return [self.tmui_keyedHeightCache heightForKey:key];
    }
    CGFloat height = [self tmui_heightForCellWithIdentifier:identifier cellClass:cellClass itemWidth:itemWidth configuration:configuration];
    [self.tmui_keyedHeightCache cacheHeight:height byKey:key];
    return height;
}

- (void)tmui_invalidateAllHeight {
    [self.tmuiCollectionCache_allKeyedHeightCaches removeAllObjects];
    [self.tmuiCollectionCache_allIndexPathHeightCaches removeAllObjects];
}

@end
