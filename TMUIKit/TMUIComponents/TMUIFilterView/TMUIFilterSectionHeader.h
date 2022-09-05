//
//  TMUIFilterSectionHeader.h
//  Demo
//
//  Created by Joe.cheng on 2022/3/30.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "TMUICore.h"
#import "TMUIExtensions.h"
#import "TMUIComponents.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMUIFilterSectionHeader : UICollectionReusableView

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *subtitle;

- (void)setSelected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
