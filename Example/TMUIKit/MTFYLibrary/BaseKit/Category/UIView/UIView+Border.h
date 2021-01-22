//
//  UIView+Border.h
//  MU
//
//  Created by Fussa on 2020/3/1.
//  Copyright © 2020 Matafy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE

@interface UIView (Border)

@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat corderRadius;
@property (nonatomic) IBInspectable UIColor *borderColor;

@end

NS_ASSUME_NONNULL_END
