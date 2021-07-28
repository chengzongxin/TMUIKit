//
//  CAAnimationTMUIViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/13.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "CAAnimationTMUIViewController.h"


@implementation NSString (code_string)
- (void)enumerateCodeStringUsingBlock:(void (^)(NSString *, NSRange))block {
    NSString *pattern = @"\\[?[A-Za-z0-9_.\\(]+\\s?[A-Za-z0-9_:.\\)]+\\]?";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    [regex enumerateMatchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.range.length > 0) {
            if (block) {
                block([self substringWithRange:result.range], result.range);
            }
        }
    }];
}


@end

@interface CAAnimationTMUIViewController ()<CAAnimationDelegate>

@property(nonatomic, strong) CALayer *layer;
@property(nonatomic, strong) TMUIButton *actionButton;
@property(nonatomic, strong) UILabel *tipsLabel;
@end

@implementation CAAnimationTMUIViewController

- (TMUIButton *)generateLightBorderedButton {
    TMUIButton *button = [[TMUIButton alloc] tmui_initWithSize:CGSizeMake(200, 40)];
    button.titleLabel.font = UIFontBoldMake(14);
    button.tintColorAdjustsTitleAndImage = UIColor.tmui_randomColor;
    button.backgroundColor = [UIColor.tmui_randomColor tmui_transitionToColor:UIColor.whiteColor progress:.9];
    button.highlightedBackgroundColor = [UIColor.tmui_randomColor tmui_transitionToColor:UIColor.whiteColor progress:.75];// 高亮时的背景色
    button.layer.borderColor = [button.backgroundColor tmui_transitionToColor:UIColor.tmui_randomColor progress:.5].CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 4;
    button.highlightedBorderColor = [button.backgroundColor tmui_transitionToColor:UIColor.tmui_randomColor progress:.9];// 高亮时的边框颜色
    return button;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.actionButton = [self generateLightBorderedButton];
    [self.actionButton setTitle:@"点击开始动画" forState:UIControlStateNormal];
    [self.actionButton addTarget:self action:@selector(handleActionButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.actionButton];
    
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.numberOfLines = 0;
    NSMutableAttributedString *tips = [[NSMutableAttributedString alloc] initWithString:@"CAAnimation (TMUI) 支持用 block 的形式添加对 animationDidStart 和 animationDidStop 的监听，无需自行设置 delegate，从而避免 CAAnimation.delegate 为 strong 带来的一些内存管理上的麻烦。\n同时你也可以继续使用系统原有的 delegate 方法，互不影响。" attributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: UIColor.tmui_randomColor, NSParagraphStyleAttributeName: [NSMutableParagraphStyle tmui_paragraphStyleWithLineHeight:20]}];
    NSDictionary *codeAttributes = @{NSFontAttributeName: UIFont(12), NSForegroundColorAttributeName: UIColor.tmui_randomColor};
    [tips.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [tips addAttributes:codeAttributes range:codeRange];
    }];
    self.tipsLabel.attributedText = tips;
    [self.view addSubview:self.tipsLabel];
    
    self.layer = [CALayer layer];
    [self.layer tmui_removeDefaultAnimations];
    self.layer.cornerRadius = self.actionButton.layer.cornerRadius;
    self.layer.backgroundColor = UIColor.tmui_randomColor.CGColor;
    [self.view.layer addSublayer:self.layer];
}

- (void)handleActionButtonEvent:(TMUIButton *)button {
    if ([button.currentTitle isEqualToString:@"回到初始状态"]) {
        [self.layer removeAnimationForKey:@"move"];
        [self.actionButton setTitle:@"点击开始动画" forState:UIControlStateNormal];
        return;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D transform = CATransform3DMakeTranslation(CGRectGetWidth(self.view.bounds) - 24 - CGRectGetMaxX(self.layer.frame), 0, 0);
    animation.toValue = [NSValue valueWithCATransform3D:transform];
    animation.duration = 2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.tmui_animationDidStartBlock = ^(__kindof CAAnimation *aAnimation) {
        button.enabled = NO;
        [button setTitle:@"动画中..." forState:UIControlStateNormal];
    };
    animation.tmui_animationDidStopBlock = ^(__kindof CAAnimation *aAnimation, BOOL finished) {
        button.enabled = YES;
        [button setTitle:@"回到初始状态" forState:UIControlStateNormal];
    };
    [self.layer addAnimation:animation forKey:@"move"];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets paddings = UIEdgeInsetsMake(24 + NavigationContentTop, 24 + self.view.tmui_safeAreaInsets.left, 24 + self.view.tmui_safeAreaInsets.bottom, 24 + self.view.tmui_safeAreaInsets.right);
    self.layer.frame = CGRectMake(paddings.left, paddings.top, 64, 64);
    self.actionButton.frame = CGRectMake(paddings.left, CGRectGetMaxY(self.layer.frame) + 24, CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(paddings), CGRectGetHeight(self.actionButton.frame));
    
    
    CGSize size = [self.tipsLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.actionButton.frame), CGFLOAT_MAX)];
    self.tipsLabel.frame = CGRectMake(paddings.left, CGRectGetMaxY(self.actionButton.frame) + 16, CGRectGetWidth(self.actionButton.frame), size.height);
//    self.tipsLabel.contentMode = UIViewContentModeTop;
}


- (void)handleActionButtonEvent1:(TMUIButton *)button {
    if ([button.currentTitle isEqualToString:@"回到初始状态"]) {
        [self.layer removeAnimationForKey:@"move"];
        [self.actionButton setTitle:@"点击开始动画" forState:UIControlStateNormal];
        return;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D transform = CATransform3DMakeTranslation(CGRectGetWidth(self.view.bounds) - 24 - CGRectGetMaxX(self.layer.frame), 0, 0);
    animation.toValue = [NSValue valueWithCATransform3D:transform];
    animation.duration = 2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
//    animation.tmui_animationDidStartBlock = ^(__kindof CAAnimation *aAnimation) {
//        button.enabled = NO;
//        [button setTitle:@"动画中..." forState:UIControlStateNormal];
//    };
//    animation.tmui_animationDidStopBlock = ^(__kindof CAAnimation *aAnimation, BOOL finished) {
//        button.enabled = YES;
//        [button setTitle:@"回到初始状态" forState:UIControlStateNormal];
//    };
    [self.layer addAnimation:animation forKey:@"move"];
}

- (void)animationDidStart:(CAAnimation *)anim{
            self.actionButton.enabled = NO;
            [self.actionButton setTitle:@"动画中..." forState:UIControlStateNormal];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    self.actionButton.enabled = YES;
            [self.actionButton setTitle:@"回到初始状态" forState:UIControlStateNormal];
}


@end
