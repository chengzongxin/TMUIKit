//
//  PanInteractiveTransition.m
//  TransitionDemo
//
//  Created by Cheng on 2018/2/7.
//  Copyright © 2018年 Cheng. All rights reserved.
//

#import "PanInteractiveTransition.h"

@interface PanInteractiveTransition()
@property (nonatomic, assign) BOOL shouldComplete;
@property (nonatomic,weak) UIViewController *presentedVC;

@end

@implementation PanInteractiveTransition

- (void)panToDismiss:(UIViewController *)viewController{
    self.presentedVC = viewController;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    
    [self.presentedVC.view addGestureRecognizer:panGesture];
}

- (CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

#pragma mark -panGestureAction
- (void)panGestureAction:(UIPanGestureRecognizer *)gesture{
    CGPoint translation = [gesture translationInView:gesture.view];
    NSLog(@"%@",NSStringFromCGPoint(translation));
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            // 1. Mark the interacting flag. Used when supplying it in delegate.
            self.interacting = YES;
            [self.presentedVC dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged: {
            // 2. Calculate the percentage of guesture
            CGFloat fraction = translation.y / ([UIScreen mainScreen].bounds.size.height * 0.6);
            //Limit it between 0 and 1
            fraction = fminf(fmaxf(fraction, 0.0), 1.0);
            NSLog(@"%f",fraction);
            self.shouldComplete = (fraction > 0.5);
            
            [self updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            // 3. Gesture over. Check if the transition should happen or not
            self.interacting = NO;
            if (!self.shouldComplete || gesture.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}

@end
