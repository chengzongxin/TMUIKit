//
//  UITableView+THKNib.h
//  Housekeeper_ipad
//
//  Created by to on 15-4-28.
//  Copyright (c) 2015年 to. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (TNib)

- (void)registerNibClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

// 标签是NSStringFromClass([TCPIntroTableViewCell class]
- (void)registerNibIdentifierNSStringFromClass:(Class)cellClass;

@end
