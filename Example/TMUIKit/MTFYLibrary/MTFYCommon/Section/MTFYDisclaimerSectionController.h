//
//  MTFYDisclaimerSectionController.h
//  Matafy
//
//  Created by Fussa on 2019/12/25.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYBaseIGListSectionController.h"
#import "MTFYBaseIGListCollectionCell.h"
#import "IGListDiffable.h"


NS_ASSUME_NONNULL_BEGIN
@class MTFYDisclaimerCollectionViewCell;
@class MTFYDisclaimerModel;

@interface MTFYDisclaimerSectionController : MTFYBaseIGListSectionController

@end

@interface MTFYDisclaimerCollectionViewCell : MTFYBaseIGListCollectionCell

@end

@interface MTFYDisclaimerModel : NSObject<IGListDiffable>

@property(nonatomic, copy) NSString *title;

/** 不设置则使用默认 **/
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) BOOL customInset;
@property (nonatomic, assign) UIEdgeInsets insets;
@property(nonatomic, assign) NSTextAlignment textAlignment;

@end

NS_ASSUME_NONNULL_END
