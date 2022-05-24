//
//  TMUINavigationStackView.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/5/23.
//

#import "TMUINavigationStackView.h"

@implementation TMUINavigationStackView


- (instancetype)init{
    if (self = [super init]) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize{
    self.userInteractionEnabled = YES;
    self.alignment = UIStackViewAlignmentCenter;
    self.axis = UILayoutConstraintAxisHorizontal;
    self.distribution = UIStackViewDistributionFill;
    self.spacing = 10;
}


- (void)removeAllArrangeViews{
    [self.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}
@end
