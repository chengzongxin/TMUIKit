//
//  UITableViewHeaderFooterView+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/4/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewHeaderFooterView (TMUI)
@property(nonatomic, weak, readonly) UITableView *tmui_tableView;
@end
@interface UITableViewHeaderFooterView (TMUI_InsetGrouped)

@end
NS_ASSUME_NONNULL_END
