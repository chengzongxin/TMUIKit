//
//  UIViewController+TTableViewSeparator.m
//  HouseKeeper
//
//  Created by to on 15-3-24.
//  Copyright (c) 2015年 binxun. All rights reserved.
//

#import "UIViewController+TTableViewSeparator.h"

@implementation UIViewController (TTableViewSeparator)

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath*)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:tableView.separatorInset];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:tableView.separatorInset];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:tableView.separatorInset];
    }
}

@end
