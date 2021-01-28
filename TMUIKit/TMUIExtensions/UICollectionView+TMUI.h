//
//  UICollectionView+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (TMUI)
- (void)tmui_registerNibClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

// 标签是NSStringFromClass([TCPIntroTableViewCell class]
- (void)tmui_registerNibIdentifierNSStringFromClass:(Class)cellClass;

- (void)tmui_registerNibClass:(Class)cellClass forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;

- (void)tmui_registerNibIdentifierNSStringFromClass:(Class)aClass forSupplementaryViewOfKind:(NSString *)kind;

@end

NS_ASSUME_NONNULL_END
