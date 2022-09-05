//
//  TMUINavigationBarApprance.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/5/23.
//

#import <Foundation/Foundation.h>
#import "TMUINavigationBarDefineType.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMUINavigationBarApprance : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIImage *backBtnImg;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIImage *shareImg;
@property (nonatomic, strong) UIImage *searchImg;


+ (instancetype)appranceWithBarStyle:(TMUINavigationBarStyle)barStyle;

@end

NS_ASSUME_NONNULL_END
