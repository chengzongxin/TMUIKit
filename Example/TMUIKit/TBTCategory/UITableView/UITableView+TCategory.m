//
//  UITableView+TCategory.m
//  TBasicLib
//
//  Created by kevin.huang on 14-8-13.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import "UITableView+TCategory.h"

@implementation UITableView (TCategory)

- (NSUInteger)indexOfIndexPath:(NSIndexPath *)indexPath {
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

- (NSIndexPath *)indexPathOfIndex:(NSUInteger)index {
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
