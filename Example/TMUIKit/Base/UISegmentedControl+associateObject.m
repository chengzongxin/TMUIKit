//
//  UISegmentedControl+associateObject.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/22.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UISegmentedControl+associateObject.h"

@implementation UISegmentedControl (associateObject)

//- (void (^)(NSInteger))clickBlock
//- (void)setClickBlock:(void (^)(NSInteger))clickBlock

TMUISynthesizeIdCopyProperty(clickBlock, setClickBlock)

@end
