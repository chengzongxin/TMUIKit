//
//  UITableView+TCategory.h
//  TBasicLib
//
//  Created by kevin.huang on 14-8-13.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (TCategory)

//将NSIndexPath转换成index
- (NSUInteger)indexOfIndexPath:(NSIndexPath *)indexPath;
//将index转换成NSIndexPath
- (NSIndexPath *)indexPathOfIndex:(NSUInteger)index;

@end
