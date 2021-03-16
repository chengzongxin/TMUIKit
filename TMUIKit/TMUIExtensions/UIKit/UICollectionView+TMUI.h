//
//  UICollectionView+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (TMUI)


/**
 *  清除所有已选中的item的选中状态
 */
- (void)tmui_clearsSelection;

/**
 *  重新`reloadData`，同时保持`reloadData`前item的选中状态
 */
- (void)tmui_reloadDataKeepingSelection;

/**
 *  获取某个view在collectionView内对应的indexPath
 *
 *  例如某个view是某个cell里的subview，在这个view的点击事件回调方法里，就能通过`tmui_indexPathForItemAtView:`获取被点击的view所处的cell的indexPath
 *
 *  @warning 注意返回的indexPath有可能为nil，要做保护。
 */
- (NSIndexPath *)tmui_indexPathForItemAtView:(id)sender;

/**
 *  判断当前 indexPath 的 item 是否为可视的 item
 */
- (BOOL)tmui_itemVisibleAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  对系统的 indexPathsForVisibleItems 进行了排序后的结果
 */
- (NSArray<NSIndexPath *> *)tmui_indexPathsForVisibleItems;

/**
 *  获取可视区域内第一个cell的indexPath。
 *
 *  为什么需要这个方法是因为系统的indexPathsForVisibleItems方法返回的数组成员是无序排列的，所以不能直接通过firstObject拿到第一个cell。
 *
 *  @warning 若可视区域为CGRectZero，则返回nil
 */
- (NSIndexPath *)tmui_indexPathForFirstVisibleCell;


@end


@interface UICollectionView (TMUI_RegisterCell)

- (void)tmui_registerNibClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

// 标签是NSStringFromClass([TCPIntroTableViewCell class]
- (void)tmui_registerNibIdentifierNSStringFromClass:(Class)cellClass;

- (void)tmui_registerNibClass:(Class)cellClass forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;

- (void)tmui_registerNibIdentifierNSStringFromClass:(Class)aClass forSupplementaryViewOfKind:(NSString *)kind;

@end

NS_ASSUME_NONNULL_END
