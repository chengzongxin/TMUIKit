//
//  UISlider+associateObject.h
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/22.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISlider (associateObject)

@property(nonatomic, copy) void (^slideBlock)(float);

@end

NS_ASSUME_NONNULL_END
