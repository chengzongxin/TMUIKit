//
//  UIViewController+TTableViewSeparator.h
//  HouseKeeper
//
//  Created by to on 15-3-24.
//  Copyright (c) 2015年 binxun. All rights reserved.
//

/**
 *  表格分割线处理,在控制器中添加willDisplayCell代理，若有特殊需要重写此方法
 */
#import <UIKit/UIKit.h>

@interface UIViewController (TTableViewSeparator)

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath*)indexPath;

@end
