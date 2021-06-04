//
//  UICollectionView+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import "UICollectionView+TMUI.h"
#import "TMUIRuntime.h"

@implementation UICollectionView (TMUI)


//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        // 防止 release 版本滚动到不合法的 indexPath 会 crash
//        OverrideImplementation([UICollectionView class], @selector(scrollToItemAtIndexPath:atScrollPosition:animated:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
//            return ^(UICollectionView *selfObject, NSIndexPath *indexPath, UICollectionViewScrollPosition scrollPosition, BOOL animated) {
//                BOOL isIndexPathLegal = YES;
//                NSInteger numberOfSections = [selfObject numberOfSections];
//                if (indexPath.section >= numberOfSections) {
//                    isIndexPathLegal = NO;
//                } else {
//                    NSInteger items = [selfObject numberOfItemsInSection:indexPath.section];
//                    if (indexPath.item >= items) {
//                        isIndexPathLegal = NO;
//                    }
//                }
//                if (!isIndexPathLegal) {
//                    NSLog(@"UICollectionView (QMUI) %@ - target indexPath : %@ ，不合法的indexPath。\n%@", selfObject, indexPath, [NSThread callStackSymbols]);
//                    NSAssert(NO, @"出现不合法的indexPath");
//                    return;
//                }
//                
//                // call super
//                void (*originSelectorIMP)(id, SEL, NSIndexPath *, UICollectionViewScrollPosition, BOOL);
//                originSelectorIMP = (void (*)(id, SEL, NSIndexPath *, UICollectionViewScrollPosition, BOOL))originalIMPProvider();
//                originSelectorIMP(selfObject, originCMD, indexPath, scrollPosition, animated);
//            };
//        });
//    });
//}

- (void)tmui_clearsSelection {
    NSArray *selectedItemIndexPaths = [self indexPathsForSelectedItems];
    for (NSIndexPath *indexPath in selectedItemIndexPaths) {
        [self deselectItemAtIndexPath:indexPath animated:YES];
    }
}

- (void)tmui_reloadDataKeepingSelection {
    NSArray *selectedIndexPaths = [self indexPathsForSelectedItems];
    [self reloadData];
    for (NSIndexPath *indexPath in selectedIndexPaths) {
        [self selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

/// 递归找到view在哪个cell里，不存在则返回nil
- (UICollectionViewCell *)parentCellForView:(UIView *)view {
    if (!view.superview) {
        return nil;
    }
    
    if ([view.superview isKindOfClass:[UICollectionViewCell class]]) {
        return (UICollectionViewCell *)view.superview;
    }
    
    return [self parentCellForView:view.superview];
}

- (NSIndexPath *)tmui_indexPathForItemAtView:(id)sender {
    if (sender && [sender isKindOfClass:[UIView class]]) {
        UIView *view = (UIView *)sender;
        UICollectionViewCell *parentCell = [self parentCellForView:view];
        if (parentCell) {
            return [self indexPathForCell:parentCell];
        }
    }
    
    return nil;
}

- (BOOL)tmui_itemVisibleAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *visibleItemIndexPaths = self.indexPathsForVisibleItems;
    for (NSIndexPath *visibleIndexPath in visibleItemIndexPaths) {
        if ([indexPath isEqual:visibleIndexPath]) {
            return YES;
        }
    }
    return NO;
}

- (NSArray<NSIndexPath *> *)tmui_indexPathsForVisibleItems {
    NSArray<NSIndexPath *> *visibleItems = [self indexPathsForVisibleItems];
    NSSortDescriptor *sectionSorter = [[NSSortDescriptor alloc] initWithKey:@"section" ascending:YES];
    NSSortDescriptor *rowSorter = [[NSSortDescriptor alloc] initWithKey:@"item" ascending:YES];
    visibleItems = [visibleItems sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sectionSorter, rowSorter, nil]];
    return visibleItems;
}

- (NSIndexPath *)tmui_indexPathForFirstVisibleCell {
    NSArray *visibleIndexPaths = [self tmui_indexPathsForVisibleItems];
    if (!visibleIndexPaths || visibleIndexPaths.count <= 0) {
        return nil;
    }
    
    return visibleIndexPaths.firstObject;
}


@end


@implementation UICollectionView (TMUI_RegisterCell)


- (void)tmui_registerNibClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(cellClass) bundle:[NSBundle bundleForClass:cellClass]];
    [self registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (void)tmui_registerNibIdentifierNSStringFromClass:(Class)cellClass {
    [self tmui_registerNibClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)tmui_registerNibClass:(Class)cellClass forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(cellClass) bundle:[NSBundle bundleForClass:cellClass]];
    [self registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
}

- (void)tmui_registerNibIdentifierNSStringFromClass:(Class)aClass forSupplementaryViewOfKind:(NSString *)kind {
    [self tmui_registerNibClass:aClass forSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(aClass)];
}

@end
