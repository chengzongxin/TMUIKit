//
//  UICollectionView+THKNib.h
//  Housekeeper_ipad
//
//  Created by to on 15-4-28.
//  Copyright (c) 2015年 to. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (TNib)

- (void)registerNibClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

// 标签是NSStringFromClass([TCPIntroTableViewCell class]
- (void)registerNibIdentifierNSStringFromClass:(Class)cellClass;

- (void)t_registerNibClass:(Class)cellClass forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;

- (void)t_registerNibIdentifierNSStringFromClass:(Class)aClass forSupplementaryViewOfKind:(NSString *)kind;


@end
