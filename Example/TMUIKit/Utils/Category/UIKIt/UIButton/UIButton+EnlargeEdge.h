//
//  UIButton+EnlargeEdge.h
//  FWD
//
//  Created by Hello_Aaron on 14-4-30.
//  Copyright (c) 2014年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

//ios 扩大uibutton的响应区域

@interface UIButton (EnlargeEdge)
- (void)setEnlargeEdge:(CGFloat) size;
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
@end
