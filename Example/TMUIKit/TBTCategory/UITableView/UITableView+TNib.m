//
//  UITableView+THKNib.m
//  Housekeeper_ipad
//
//  Created by to on 15-4-28.
//  Copyright (c) 2015年 to. All rights reserved.
//

#import "UITableView+TNib.h"

@implementation UITableView (TNib)

- (void)registerNibClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(cellClass) bundle:[NSBundle bundleForClass:cellClass]];
    [self registerNib:nib forCellReuseIdentifier:identifier];
}

- (void)registerNibIdentifierNSStringFromClass:(Class)cellClass {
    [self registerNibClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

@end
