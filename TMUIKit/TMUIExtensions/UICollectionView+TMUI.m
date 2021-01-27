//
//  UICollectionView+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import "UICollectionView+TMUI.h"

@implementation UICollectionView (TMUI)

- (void)registerNibClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(cellClass) bundle:[NSBundle bundleForClass:cellClass]];
    [self registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (void)registerNibIdentifierNSStringFromClass:(Class)cellClass {
    [self registerNibClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)t_registerNibClass:(Class)cellClass forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(cellClass) bundle:[NSBundle bundleForClass:cellClass]];
    [self registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
}

- (void)t_registerNibIdentifierNSStringFromClass:(Class)aClass forSupplementaryViewOfKind:(NSString *)kind {
    [self t_registerNibClass:aClass forSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(aClass)];
}

@end
