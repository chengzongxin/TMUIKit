//
//  UICollectionView+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (TMUI)
- (void)registerNibClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

// 标签是NSStringFromClass([TCPIntroTableViewCell class]
- (void)registerNibIdentifierNSStringFromClass:(Class)cellClass;

- (void)t_registerNibClass:(Class)cellClass forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;

- (void)t_registerNibIdentifierNSStringFromClass:(Class)aClass forSupplementaryViewOfKind:(NSString *)kind;

@end

NS_ASSUME_NONNULL_END
