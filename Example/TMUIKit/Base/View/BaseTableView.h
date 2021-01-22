//
//  BaseTableView.h
//  TableViewNoContentView
//
//  Created by  on 2017/4/26.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableView : UITableView

// 无数据占位图点击的回调函数
@property (copy,nonatomic) void(^noContentViewTapedBlock)(void);

/**
 展示无数据占位图

 @param emptyViewType 无数据占位图的类型
 NoContentTypeNetwork  /// 无网络
 NoContentTypeOrder    /// 无数据
 */


/* code  by ares
- (void)showEmptyViewWithType:(NSInteger)emptyViewType;
 */
- (void)showEmptyViewWithImage:(NSString *)imageString title:(NSString *)title desc:(NSString *)desc;

/* 移除无数据占位图 */
- (void)removeEmptyView;

@end
