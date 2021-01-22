//
//  PreloadingRefreshAutoFooter.m
//  Matafy
//
//  Created by Joe on 2019/12/11.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "PreloadingRefreshAutoFooter.h"

static int const surplusCount = 2;

@implementation PreloadingRefreshAutoFooter

- (void)prepare{
    [super prepare];
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
//    if ([self.scrollView isKindOfClass:[UITableView class]]) {
//        CGPoint oldPoint= [[change objectForKey:@"old"]CGPointValue];
//        CGPoint newPoint= [[change objectForKey:@"new"]CGPointValue];
//        if (newPoint.y>oldPoint.y) {//向下滑才出发自动刷新
//            UITableView *tableView=(UITableView *)self.scrollView;
//            NSIndexPath *indexPath= [tableView indexPathForRowAtPoint:newPoint];
//            NSInteger rowNum= self.scrollView.mj_totalDataCount;
//            if (rowNum-indexPath.row > 2 &&!tableView.mj_footer.isRefreshing) {
//                [self executeRefreshingCallback];
//
//            }
//        }
//    }
    
    
    if([self.scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.scrollView;
        NSInteger lastSection = tableView.numberOfSections - 1;
        if(lastSection >= 0) {
            NSInteger lastRow = [tableView numberOfRowsInSection:tableView.numberOfSections - 1] - 1;
            if(lastRow >= 0) {
                if(tableView.visibleCells.count > 0) {
                    NSIndexPath *indexPath = [tableView indexPathForCell:tableView.visibleCells.lastObject];
                    if(indexPath.section == lastSection && indexPath.row >= (lastRow - surplusCount)) {
                        if (!self.isRefreshing) {
                            self.state = MJRefreshStateRefreshing;
                            [self beginRefreshing];
                        }
                    }
                }
            }
        }
    }
    if([self.scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self.scrollView;
        NSInteger lastSection = collectionView.numberOfSections - 1;
        if(lastSection >= 0) {
            NSInteger lastRow = [collectionView numberOfItemsInSection:collectionView.numberOfSections - 1] - 1;
            if(lastRow >= 0) {
                if(collectionView.indexPathsForVisibleItems.count > 0) {
                    NSArray *indexPaths = [collectionView indexPathsForVisibleItems];
                    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"row" ascending:YES];
                    NSArray *orderedIndexPaths = [indexPaths sortedArrayUsingDescriptors:@[sort]];
                    NSIndexPath *indexPath = orderedIndexPaths.lastObject;
                    if(indexPath.section == lastSection && indexPath.row >= (lastRow - surplusCount)) {
                        if (!self.isRefreshing) {
                            self.state = MJRefreshStateRefreshing;
                            NSLog(@"%s",__FUNCTION__);
                            [self beginRefreshing];
                        }
                    }
                }
            }
        }
    }
    
}


@end
