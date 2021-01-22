//
//  UIView+Animate.m
//  Matafy
//
//  Created by Fussa on 2019/4/24.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "UIView+Animate.h"

@implementation UIView (Animate)
- (void)mtfy_animateWithDuration:(NSTimeInterval)duration animationType:(MTFYViewAnimationType)type completion:(void (^)(BOOL))completion {
    switch (type) {
        case MTFYViewAnimationTypeNone: {
            if (completion) {
                completion(YES);
            }
            break;
        }
        case MTFYViewAnimationTypeFadeIn: {
            CGFloat originAlpha = self.alpha;
            self.alpha = 0;
            [UIView animateWithDuration:duration animations:^{
                self.alpha = originAlpha;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion(finished);
                }
            }];
            break;
        }
        case MTFYViewAnimationTypeFadeOut: {
            [UIView animateWithDuration:duration animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion(finished);
                }
            }];
            break;
        }
        case MTFYViewAnimationTypeZoomIn: {
            self.transform = CGAffineTransformMakeScale(0, 0);
            [UIView animateWithDuration:duration animations:^{
                self.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                if (completion) {
                    completion(finished);
                }
            }];
            break;
        }
        case MTFYViewAnimationTypeZoomOut: {
            [UIView animateWithDuration:duration animations:^{
                self.transform = CGAffineTransformMakeScale(1.5, 1.5);
                self.alpha = 0;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion(finished);
                }
            }];
            break;
        }
        case MTFYViewAnimationTypeTopIn: {
            CGRect orginFrame = self.frame;
            self.frame = CGRectMake(orginFrame.origin.x, -orginFrame.size.height, orginFrame.size.width, orginFrame.size.height);
            [UIView animateWithDuration:duration animations:^{
                self.frame = orginFrame;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion(finished);
                }
            }];
            break;
        }
        case MTFYViewAnimationTypeTopOut: {
            CGRect orginFrame = self.frame;
            [UIView animateWithDuration:duration animations:^{
                self.frame = CGRectMake(orginFrame.origin.x, -orginFrame.size.height, orginFrame.size.width, orginFrame.size.height);
            } completion:^(BOOL finished) {
                if (completion) {
                    completion(finished);
                }
            }];
            break;
        }
        case MTFYViewAnimationTypeBottomIn: {
            CGRect orginFrame = self.frame;
            self.frame = CGRectMake(orginFrame.origin.x, [UIScreen mainScreen].bounds.size.height, orginFrame.size.width, orginFrame.size.height);
            [UIView animateWithDuration:duration animations:^{
                self.frame = orginFrame;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion(finished);
                }
            }];
            break;
        }
        case MTFYViewAnimationTypeBottomOut: {
            CGRect orginFrame = self.frame;
            [UIView animateWithDuration:duration animations:^{
                self.frame = CGRectMake(orginFrame.origin.x, [UIScreen mainScreen].bounds.size.height, orginFrame.size.width, orginFrame.size.height);
            } completion:^(BOOL finished) {
                if (completion) {
                    completion(finished);
                }
            }];
            break;
        }
    }
}
@end
