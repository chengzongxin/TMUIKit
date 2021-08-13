//
//  TMUIPageContentScrollView.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/7/20.
//

#import "TMUIPageContentScrollView.h"

@implementation TMUIPageContentScrollView

// 优化快速滑动时，会左右翻页的问题,开启后，滑动不会走到父类
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    //  UIScrollViewPanGestureRecognizer 私有类
    if ([gestureRecognizer respondsToSelector:@selector(velocityInView:)]) {
        CGPoint point = [gestureRecognizer velocityInView:self];
        if (fabs(point.y) > fabs(point.x)) {
            // 上下滑动比较多，禁止此次左右滑动事件
            return NO;
        }
    }
    return YES;
}
@end
