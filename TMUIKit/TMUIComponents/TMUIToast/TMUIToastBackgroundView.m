//
//  TMUIToastBackgroundView.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/1/19.
//

#import "TMUIToastBackgroundView.h"
#import "TMUICore.h"

@interface TMUIToastBackgroundView ()

@end

@implementation TMUIToastBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.allowsGroupOpacity = NO;
        self.backgroundColor = self.styleColor;
        self.layer.cornerRadius = self.cornerRadius;
        
    }
    return self;
}

- (void)setShouldBlurBackgroundView:(BOOL)shouldBlurBackgroundView {
    _shouldBlurBackgroundView = shouldBlurBackgroundView;
    if (shouldBlurBackgroundView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        self.effectView.layer.cornerRadius = self.cornerRadius;
        self.effectView.layer.masksToBounds = YES;
        [self addSubview:self.effectView];
    } else {
        if (self.effectView) {
            [self.effectView removeFromSuperview];
            _effectView = nil;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.effectView) {
        self.effectView.frame = self.bounds;
    }
}

#pragma mark - UIAppearance

- (void)setStyleColor:(UIColor *)styleColor {
    _styleColor = styleColor;
    self.backgroundColor = styleColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    if (self.effectView) {
        self.effectView.layer.cornerRadius = cornerRadius;
    }
}

@end


@interface TMUIToastBackgroundView (UIAppearance)

@end

@implementation TMUIToastBackgroundView (UIAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setDefaultAppearance];
    });
}

+ (void)setDefaultAppearance {
    TMUIToastBackgroundView *appearance = [TMUIToastBackgroundView appearance];
    appearance.styleColor = UIColorMakeWithRGBA(0, 0, 0, 0.8);
    appearance.cornerRadius = 10.0;
}

@end
