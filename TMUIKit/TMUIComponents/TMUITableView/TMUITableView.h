//
//  TMUITableView.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/18.
//

#import <UIKit/UIKit.h>
#import "TMUITableViewProtocols.h"
#import "TMUITableViewCell.h"
#import "TMUITableViewHeaderFooterView.h"
#import "TMUIDynamicHeightTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMUITableView : UITableView

@property(nonatomic, weak) id<TMUITableViewDelegate> delegate;
@property(nonatomic, weak) id<TMUITableViewDataSource> dataSource;

@end

NS_ASSUME_NONNULL_END
