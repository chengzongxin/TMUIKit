//
//  UIViewController+Base.h
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/10.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Base)

@property (nonatomic, copy) NSString *demoInstructions;

- (void)popLastViewController;

@end

NS_ASSUME_NONNULL_END
