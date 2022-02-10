//
//  TMUISegmentItemCell.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/2/10.
//

#import <UIKit/UIKit.h>
#import "TMUISegmentItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TMUISegmentItemCell : UICollectionViewCell

- (void)updateItem:(TMUISegmentItemModel *)item;

- (void)updateItem:(TMUISegmentItemModel *)item isHomeStyle:(BOOL)isHomeStyle;

@end

NS_ASSUME_NONNULL_END
