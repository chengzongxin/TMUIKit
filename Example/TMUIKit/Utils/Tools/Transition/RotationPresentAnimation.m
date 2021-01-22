//
//  RotationPresentAnimation.m
//  TransitionDemo
//
//  Created by Cheng on 2018/2/7.
//  Copyright © 2018年 Cheng. All rights reserved.
//

#import "RotationPresentAnimation.h"

@implementation RotationPresentAnimation


//在进行切换的时候将调用该方法，我们对于切换时的UIView的设置和动画都在这个方法中完成
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    //1
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //2
    CGRect finalRect = [transitionContext finalFrameForViewController:toVC];
    toVC.view.frame = CGRectOffset(finalRect, 0, [[UIScreen mainScreen]bounds].size.height);
    
    //3
    [[transitionContext containerView]addSubview:toVC.view];
    
    //4
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        toVC.view.frame = finalRect;
    } completion:^(BOOL finished) {
        //5
        [transitionContext completeTransition:YES];
    }];
}

//返回动画的时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5f;
}



@end
