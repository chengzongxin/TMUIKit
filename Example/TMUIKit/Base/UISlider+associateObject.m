//
//  UISlider+associateObject.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/22.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UISlider+associateObject.h"

@implementation UISlider (associateObject)

//- (void (^)(float))slideBlock
//- (void)setSlideBlock:(void (^)(float))slideBlock

TMUISynthesizeIdCopyProperty(slideBlock, setSlideBlock)

@end
