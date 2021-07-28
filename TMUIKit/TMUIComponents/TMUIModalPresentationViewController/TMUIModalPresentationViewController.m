//
//  TMUIModalPresentationViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/5/7.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUIModalPresentationViewController.h"
#import "TMUIAppearance.h"
#import "TMUICore.h"
#import "UIView+TMUI.h"
#import "TMUIHelper.h"
#import "TMUIConfigurationMacros.h"
#import "TMUICommonDefines.h"
@interface UIViewController ()

@property(nonatomic, weak, readwrite) TMUIModalPresentationViewController *tmui_modalPresentationViewController;
@end

@implementation TMUIModalPresentationViewController (UIAppearance)

+ (instancetype)appearance {
    return [TMUIAppearance appearanceForClass:self];
}

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self initAppearance];
    });
}

+ (void)initAppearance {
    TMUIModalPresentationViewController *appearance = TMUIModalPresentationViewController.appearance;
    appearance.animationStyle = TMUIModalPresentationAnimationStyleFade;
    appearance.contentViewMargins = UIEdgeInsetsMake(20, 20, 20, 20);
    appearance.maximumContentViewWidth = CGFLOAT_MAX;
}

@end

@interface TMUIModalPresentationViewController ()

@property(nonatomic, strong) TMUIModalPresentationWindow *containerWindow;
@property(nonatomic, weak) UIWindow *previousKeyWindow;

@property(nonatomic, assign, readwrite, getter=isVisible) BOOL visible;

@property(nonatomic, assign) BOOL appearAnimated;
@property(nonatomic, copy) void (^appearCompletionBlock)(BOOL finished);

@property(nonatomic, assign) BOOL disappearAnimated;
@property(nonatomic, copy) void (^disappearCompletionBlock)(BOOL finished);

/// 标志 modal 本身以 present 的形式显示之后，又再继续 present 了一个子界面后从子界面回来时触发的 viewWillAppear:
@property(nonatomic, assign) BOOL viewWillAppearByPresentedViewController;

/// 标志是否已经走过一次viewWillDisappear了，用于hideInView的情况
@property(nonatomic, assign) BOOL hasAlreadyViewWillDisappear;

/// 如果用 showInView 的方式显示浮层，则在浮层所在的父界面被 pop（或 push 到下一个界面）时，会自动触发 viewWillDisappear:，导致浮层被隐藏，为了保证走到 viewWillDisappear: 一定是手动调用 hide 的，就加了这个标志位
/// https://github.com/Tencent/TMUI_iOS/issues/639
@property(nonatomic, assign) BOOL willHideInView;

@property(nonatomic, strong) UITapGestureRecognizer *dimmingViewTapGestureRecognizer;
//@property(nonatomic, strong) TMUIKeyboardManager *keyboardManager;
@property(nonatomic, assign) CGFloat keyboardHeight;
@property(nonatomic, assign) BOOL avoidKeyboardLayout;
@end

@implementation TMUIModalPresentationViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self didInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    [self tmui_applyAppearance];
    
    self.onlyRespondsToKeyboardEventFromDescendantViews = YES;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.modalPresentationStyle = UIModalPresentationCustom;
    
    // 这一段是给以 present 方式显示的浮层用的，其他方式显示的浮层，会在 supportedInterfaceOrientations 里实时获取支持的设备方向
    UIViewController *visibleViewController = [TMUIHelper visibleViewController];
    if (visibleViewController) {
        self.supportedOrientationMask = visibleViewController.supportedInterfaceOrientations;
    } else {
        self.supportedOrientationMask = SupportedOrientationMask;
    }
    
//    self.keyboardManager = [[TMUIKeyboardManager alloc] initWithDelegate:self];
    [self initDefaultDimmingViewWithoutAddToView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.contentViewController) {
        // 在 IB 里设置了 contentViewController 的话，通过这个调用去触发 contentView 的更新
        self.contentViewController = self.contentViewController;
    }
}

- (void)dealloc {
    self.containerWindow = nil;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    // 屏蔽对childViewController的生命周期函数的自动调用，改为手动控制
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.dimmingView && !self.dimmingView.superview) {
        [self.view addSubview:self.dimmingView];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.dimmingView.frame = self.view.bounds;
    
    CGRect contentViewFrame = [self contentViewFrameForShowing];
    if (self.layoutBlock) {
        self.layoutBlock(self.view.bounds, self.keyboardHeight, contentViewFrame);
    } else {
        self.contentView.tmui_frameApplyTransform = contentViewFrame;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.visible = YES;// present 模式没有入口 show 方法，只能加在这里
    
    if (self.shownInWindowMode) {
        // 只有使用showWithAnimated:completion:显示出来的浮层，才需要修改之前就记住的animated的值
        animated = self.appearAnimated;
    }
    
    if (self.contentViewController) {
        [self.contentViewController beginAppearanceTransition:YES animated:animated];
    }
    
    // 如果是因为 present 了新的界面再从那边回来，导致走到 viewWillAppear，则后面那些升起浮层的操作都可以不用做了，因为浮层从来没被降下去过
    self.viewWillAppearByPresentedViewController = [self isShowingPresentedViewController];
    if (self.viewWillAppearByPresentedViewController) {
        return;
    }
    
    if (self.isShownInWindowMode) {
        [TMUIHelper dimmedApplicationWindow];
    }
    
    void (^didShownCompletion)(BOOL finished) = ^(BOOL finished) {
        if (self.contentViewController) {
            [self.contentViewController endAppearanceTransition];
        }
        
        if (self.appearCompletionBlock) {
            self.appearCompletionBlock(finished);
            self.appearCompletionBlock = nil;
        }
        
        self.appearAnimated = NO;
    };
    
    if (animated) {
        [self.view addSubview:self.contentView];
        [self.view layoutIfNeeded];
        
        CGRect contentViewFrame = [self contentViewFrameForShowing];
        if (self.showingAnimation) {
            // 使用自定义的动画
            if (self.layoutBlock) {
                self.layoutBlock(self.view.bounds, self.keyboardHeight, contentViewFrame);
                contentViewFrame = self.contentView.frame;
            }
            self.showingAnimation(self.dimmingView, self.view.bounds, self.keyboardHeight, contentViewFrame, didShownCompletion);
        } else {
            self.contentView.frame = contentViewFrame;
            [self.contentView setNeedsLayout];
            [self.contentView layoutIfNeeded];
            
            [self showingAnimationWithCompletion:didShownCompletion];
        }
    } else {
        CGRect contentViewFrame = [self contentViewFrameForShowing];
        self.contentView.frame = contentViewFrame;
        [self.view addSubview:self.contentView];
        didShownCompletion(YES);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.viewWillAppearByPresentedViewController) {
        if (self.contentViewController) {
            [self.contentViewController endAppearanceTransition];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.hasAlreadyViewWillDisappear) {
        return;
    }
    
    /// 如果用 showInView 的方式显示浮层，则在浮层所在的父界面被 pop（或 push 到下一个界面）时，会自动触发 viewWillDisappear:，导致浮层被隐藏，为了保证走到 viewWillDisappear: 一定是手动调用 hide 的，就用 willHideInView 来区分。
    /// https://github.com/Tencent/TMUI_iOS/issues/639
    if (self.shownInSubviewMode && !self.willHideInView) {
        return;
    }
    
    [super viewWillDisappear:animated];
    
    if (self.shownInWindowMode) {
        animated = self.disappearAnimated;
    }
    
    BOOL willDisappearByPresentedViewController = [self isShowingPresentedViewController];
    
    if (!willDisappearByPresentedViewController) {
        if ([self.delegate respondsToSelector:@selector(willHideModalPresentationViewController:)]) {
            [self.delegate willHideModalPresentationViewController:self];
        }
    }
    
    // 先更新标志位再 endEditing，保证键盘降下时不触发 updateLayout，从而避免影响 hidingAnimation 的动画
    self.avoidKeyboardLayout = YES;
    [self.view endEditing:YES];
    
    if (self.contentViewController) {
        [self.contentViewController beginAppearanceTransition:NO animated:animated];
    }
    
    // 如果是因为 present 了新的界面导致走到 willDisappear，则后面那些降下浮层的操作都可以不用做了
    if (willDisappearByPresentedViewController) {
        return;
    }
    
    if (self.isShownInWindowMode) {
        [TMUIHelper resetDimmedApplicationWindow];
    }
    
    void (^didHiddenCompletion)(BOOL finished) = ^(BOOL finished) {
        
        if (self.shownInWindowMode) {
            // 恢复 keyWindow 之前做一下检查，避免这个问题 https://github.com/Tencent/TMUI_iOS/issues/90
            if (UIApplication.sharedApplication.keyWindow == self.containerWindow) {
                if (self.previousKeyWindow.hidden) {
                    // 保护了这个 issue 记录的情况，避免主 window 丢失 keyWindow https://github.com/Tencent/TMUI_iOS/issues/315
                    [UIApplication.sharedApplication.delegate.window makeKeyWindow];
                } else {
                    [self.previousKeyWindow makeKeyWindow];
                }
            }
            self.containerWindow.hidden = YES;
            self.containerWindow.rootViewController = nil;
            self.previousKeyWindow = nil;
            [self endAppearanceTransition];
        }
        
        if (self.shownInSubviewMode) {
            self.willHideInView = NO;
            
            [self.view removeFromSuperview];
            
            // removeFromSuperview 在 animated:YES 时会触发第二次viewWillDisappear:，所以要搭配self.hasAlreadyViewWillDisappear使用
            // animated:NO 不会触发
            if (animated) {
                self.hasAlreadyViewWillDisappear = NO;
            }
        }
        
        [self.contentView removeFromSuperview];
        if (self.contentViewController) {
            [self.contentViewController endAppearanceTransition];
        }
        
        self.visible = NO;
        self.avoidKeyboardLayout = NO;
        
        if ([self.delegate respondsToSelector:@selector(didHideModalPresentationViewController:)]) {
            [self.delegate didHideModalPresentationViewController:self];
        }
        
        if (self.disappearCompletionBlock) {
            self.disappearCompletionBlock(YES);
            self.disappearCompletionBlock = nil;
        }
        
        self.disappearAnimated = NO;
    };
    
    if (animated) {
        if (self.hidingAnimation) {
            self.hidingAnimation(self.dimmingView, self.view.bounds, self.keyboardHeight, didHiddenCompletion);
        } else {
            [self hidingAnimationWithCompletion:didHiddenCompletion];
        }
    } else {
        didHiddenCompletion(YES);
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    BOOL willDisappearByPresentedViewController = [self isShowingPresentedViewController];
    if (willDisappearByPresentedViewController) {
        if (self.contentViewController) {
            [self.contentViewController endAppearanceTransition];
        }
    }
}

- (void)updateLayout {
    if ([self isViewLoaded]) {
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
}

#pragma mark - Dimming View

- (void)setDimmingView:(UIView *)dimmingView {
    if (![self isViewLoaded]) {
        _dimmingView = dimmingView;
    } else {
        [self.view insertSubview:dimmingView belowSubview:_dimmingView];
        [_dimmingView removeFromSuperview];
        _dimmingView = dimmingView;
        [self.view setNeedsLayout];
    }
    [self addTapGestureRecognizerToDimmingViewIfNeeded];
}

- (void)initDefaultDimmingViewWithoutAddToView {
    if (!self.dimmingView) {
        _dimmingView = [[UIView alloc] init];
        self.dimmingView.backgroundColor = UIColorMask;
        [self addTapGestureRecognizerToDimmingViewIfNeeded];
        if ([self isViewLoaded]) {
            [self.view addSubview:self.dimmingView];
        }
    }
}

// 要考虑用户可能创建了自己的dimmingView，则tap手势也要重新添加上去
- (void)addTapGestureRecognizerToDimmingViewIfNeeded {
    if (!self.dimmingView) {
        return;
    }
    
    if (self.dimmingViewTapGestureRecognizer.view == self.dimmingView) {
        return;
    }
    
    if (!self.dimmingViewTapGestureRecognizer) {
        self.dimmingViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDimmingViewTapGestureRecognizer:)];
    }
    [self.dimmingView addGestureRecognizer:self.dimmingViewTapGestureRecognizer];
    self.dimmingView.userInteractionEnabled = YES;// UIImageView默认userInteractionEnabled为NO，为了兼容UIImageView，这里必须主动设置为YES
}

- (void)handleDimmingViewTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (self.modal) {
        return;
    }
    
    if (self.shownInWindowMode) {
        __weak __typeof(self)weakSelf = self;
        [self hideWithAnimated:YES completion:^(BOOL finished) {
            if (weakSelf.didHideByDimmingViewTappedBlock) {
                weakSelf.didHideByDimmingViewTappedBlock();
            }
        } sender:tapGestureRecognizer];
    } else if (self.shownInPresentedMode) {
        // 这里仅屏蔽点击遮罩时的 dismiss，如果是代码手动调用 dismiss 的，在 UIViewController(TMUIModalPresentationViewController) 里会通过重写 dismiss 方法来屏蔽。
        // 为什么不能统一交给 UIViewController(TMUIModalPresentationViewController) 里屏蔽，是因为点击遮罩触发的 dismiss 要调用 willHideByDimmingViewTappedBlock，而 UIViewController 那边不知道此次 dismiss 是否由点击遮罩触发的，所以分开两边写。
        if ([self.delegate respondsToSelector:@selector(shouldHideModalPresentationViewController:)] && ![self.delegate shouldHideModalPresentationViewController:self]) {
            return;
        }
        if (self.willHideByDimmingViewTappedBlock) {
            self.willHideByDimmingViewTappedBlock();
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.didHideByDimmingViewTappedBlock) {
                self.didHideByDimmingViewTappedBlock();
            }
        }];
    } else if (self.shownInSubviewMode) {
        __weak __typeof(self)weakSelf = self;
        [self hideInView:self.view.superview animated:YES completion:^(BOOL finished) {
            if (weakSelf.didHideByDimmingViewTappedBlock) {
                weakSelf.didHideByDimmingViewTappedBlock();
            }
        } sender:tapGestureRecognizer];
    }
}

#pragma mark - ContentView

- (void)setContentViewController:(UIViewController<TMUIModalPresentationContentViewControllerProtocol> *)contentViewController {
    if (![contentViewController isEqual:_contentViewController]) {
        _contentViewController.tmui_modalPresentationViewController = nil;
    }
    contentViewController.tmui_modalPresentationViewController = self;
    _contentViewController = contentViewController;
    self.contentView = contentViewController.view;
}

#pragma mark - Showing and Hiding

- (void)showingAnimationWithCompletion:(void (^)(BOOL))completion {
    if (self.animationStyle == TMUIModalPresentationAnimationStyleFade) {
        self.dimmingView.alpha = 0.0;
        self.contentView.alpha = 0.0;
        [UIView animateWithDuration:.2 delay:0.0 options:TMUIViewAnimationOptionsCurveOut animations:^{
            self.dimmingView.alpha = 1.0;
            self.contentView.alpha = 1.0;
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
        
    } else if (self.animationStyle == TMUIModalPresentationAnimationStylePopup) {
        self.dimmingView.alpha = 0.0;
        self.contentView.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:.3 delay:0.0 options:TMUIViewAnimationOptionsCurveOut animations:^{
            self.dimmingView.alpha = 1.0;
            self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            self.contentView.transform = CGAffineTransformIdentity;
            if (completion) {
                completion(finished);
            }
        }];
        
    } else if (self.animationStyle == TMUIModalPresentationAnimationStyleSlide) {
        self.dimmingView.alpha = 0.0;
        self.contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.view.bounds) - CGRectGetMinY(self.contentView.frame));
        [UIView animateWithDuration:.3 delay:0.0 options:TMUIViewAnimationOptionsCurveOut animations:^{
            self.dimmingView.alpha = 1.0;
            self.contentView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    }
}

- (void)showWithAnimated:(BOOL)animated completion:(void (^)(BOOL))completion {
    if (self.visible) return;
    self.visible = YES;
    
    // makeKeyAndVisible 导致的 viewWillAppear: 必定 animated 是 NO 的，所以这里用额外的变量保存这个 animated 的值
    self.appearAnimated = animated;
    self.appearCompletionBlock = completion;
    self.previousKeyWindow = UIApplication.sharedApplication.keyWindow;
    if (!self.containerWindow) {
        self.containerWindow = [[TMUIModalPresentationWindow alloc] init];
        self.containerWindow.windowLevel = UIWindowLevelTMUIAlertView;
        self.containerWindow.backgroundColor = UIColorClear;// 避免横竖屏旋转时出现黑色
//        [self updateContainerWindowStatusBarCapture];
    }
    self.containerWindow.rootViewController = self;
    [self.containerWindow makeKeyAndVisible];
}

- (void)hidingAnimationWithCompletion:(void (^)(BOOL))completion {
    if (self.animationStyle == TMUIModalPresentationAnimationStyleFade) {
        [UIView animateWithDuration:.2 delay:0.0 options:TMUIViewAnimationOptionsCurveOut animations:^{
            self.dimmingView.alpha = 0.0;
            self.contentView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (completion) {
                self.dimmingView.alpha = 1.0;
                self.contentView.alpha = 1.0;
                completion(finished);
            }
        }];
    } else if (self.animationStyle == TMUIModalPresentationAnimationStylePopup) {
        [UIView animateWithDuration:.3 delay:0.0 options:TMUIViewAnimationOptionsCurveOut animations:^{
            self.dimmingView.alpha = 0.0;
            self.contentView.transform = CGAffineTransformMakeScale(0.0, 0.0);
        } completion:^(BOOL finished) {
            if (completion) {
                self.dimmingView.alpha = 1.0;
                self.contentView.transform = CGAffineTransformIdentity;
                completion(finished);
            }
        }];
    } else if (self.animationStyle == TMUIModalPresentationAnimationStyleSlide) {
        [UIView animateWithDuration:.3 delay:0.0 options:TMUIViewAnimationOptionsCurveOut animations:^{
            self.dimmingView.alpha = 0.0;
            self.contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.view.bounds) - CGRectGetMinY(self.contentView.frame));
        } completion:^(BOOL finished) {
            if (completion) {
                self.dimmingView.alpha = 1.0;
                self.contentView.transform = CGAffineTransformIdentity;
                completion(finished);
            }
        }];
    }
}

- (void)hideWithAnimated:(BOOL)animated completion:(void (^)(BOOL))completion {
    [self hideWithAnimated:animated completion:completion sender:nil];
}

- (void)hideWithAnimated:(BOOL)animated completion:(void (^)(BOOL))completion sender:(id)sender {
    if (!self.visible) return;
    
    self.disappearAnimated = animated;
    self.disappearCompletionBlock = completion;
    
    BOOL shouldHide = YES;
    if ([self.delegate respondsToSelector:@selector(shouldHideModalPresentationViewController:)]) {
        shouldHide = [self.delegate shouldHideModalPresentationViewController:self];
    }
    if (!shouldHide) {
        return;
    }
    
    if (sender == self.dimmingViewTapGestureRecognizer) {
        if (self.willHideByDimmingViewTappedBlock) {
            self.willHideByDimmingViewTappedBlock();
        }
    }
    
    // window模式下，通过手动触发viewWillDisappear:来做界面消失的逻辑
    if (self.shownInWindowMode) {
        [self beginAppearanceTransition:NO animated:animated];
    }
}

- (void)showInView:(UIView *)view animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    if (self.visible) return;
    self.visible = YES;
    
    self.appearCompletionBlock = completion;
    [self loadViewIfNeeded];
    [self beginAppearanceTransition:YES animated:animated];
    [view addSubview:self.view];
    [self endAppearanceTransition];
}

- (void)hideInView:(UIView *)view animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    [self hideInView:view animated:animated completion:completion sender:nil];
}

- (void)hideInView:(UIView *)view animated:(BOOL)animated completion:(void (^)(BOOL))completion sender:(id)sender {
    if (!self.visible) return;
    
    BOOL shouldHide = YES;
    if ([self.delegate respondsToSelector:@selector(shouldHideModalPresentationViewController:)]) {
        shouldHide = [self.delegate shouldHideModalPresentationViewController:self];
    }
    if (!shouldHide) {
        return;
    }
    
    self.willHideInView = YES;
    
    if (sender == self.dimmingViewTapGestureRecognizer) {
        if (self.willHideByDimmingViewTappedBlock) {
            self.willHideByDimmingViewTappedBlock();
        }
    }
    
    self.disappearCompletionBlock = completion;
    [self beginAppearanceTransition:NO animated:animated];
    if (animated) {
        self.hasAlreadyViewWillDisappear = YES;
    }
    [self endAppearanceTransition];
}

- (CGRect)contentViewFrameForShowing {
    CGSize contentViewContainerSize = CGSizeMake(CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(self.contentViewMargins), CGRectGetHeight(self.view.bounds) - self.keyboardHeight - UIEdgeInsetsGetVerticalValue(self.contentViewMargins));
    CGSize contentViewLimitSize = CGSizeMake(fmin(self.maximumContentViewWidth, contentViewContainerSize.width), contentViewContainerSize.height);
    CGSize contentViewSize = CGSizeZero;
    if ([self.contentViewController respondsToSelector:@selector(preferredContentSizeInModalPresentationViewController:keyboardHeight:limitSize:)]) {
        contentViewSize = [self.contentViewController preferredContentSizeInModalPresentationViewController:self keyboardHeight:self.keyboardHeight limitSize:contentViewLimitSize];
    } else {
        contentViewSize = [self.contentView sizeThatFits:contentViewLimitSize];
    }
    contentViewSize.width = fmin(contentViewLimitSize.width, contentViewSize.width);
    contentViewSize.height = fmin(contentViewLimitSize.height, contentViewSize.height);
    CGRect contentViewFrame = CGRectMake(CGFloatGetCenter(contentViewContainerSize.width, contentViewSize.width) + self.contentViewMargins.left, CGFloatGetCenter(contentViewContainerSize.height, contentViewSize.height) + self.contentViewMargins.top, contentViewSize.width, contentViewSize.height);
    return contentViewFrame;
}

- (BOOL)isShownInWindowMode {
    return !!self.containerWindow;
}

- (BOOL)isShownInPresentedMode {
    return !self.shownInWindowMode && self.presentingViewController && self.presentingViewController.presentedViewController == self;
}

- (BOOL)isShownInSubviewMode {
    return !self.shownInWindowMode && !self.shownInPresentedMode && self.view.superview;
}

- (BOOL)isShowingPresentedViewController {
    return self.shownInPresentedMode && self.presentedViewController && self.presentedViewController.presentingViewController == self;
}

#pragma mark - <TMUIKeyboardManagerDelegate>

//- (void)keyboardWillChangeFrameWithUserInfo:(TMUIKeyboardUserInfo *)keyboardUserInfo {
//    if (self.onlyRespondsToKeyboardEventFromDescendantViews) {
//        UIResponder *firstResponder = keyboardUserInfo.targetResponder;
//        if (!firstResponder || !([firstResponder isKindOfClass:[UIView class]] && [(UIView *)firstResponder isDescendantOfView:self.view])) {
//            return;
//        }
//    }
//    CGFloat keyboardHeight = [keyboardUserInfo heightInView:self.view];
//    if (self.keyboardHeight != keyboardHeight) {
//        self.keyboardHeight = keyboardHeight;
//        if (!self.avoidKeyboardLayout) {
//            [self updateLayout];
//        }
//    }
//}

#pragma mark - 屏幕旋转

- (BOOL)shouldAutorotate {
    UIViewController *visibleViewController = [TMUIHelper visibleViewController];
    if (visibleViewController != self && [visibleViewController respondsToSelector:@selector(shouldAutorotate)]) {
        return [visibleViewController shouldAutorotate];
    }
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *visibleViewController = [TMUIHelper visibleViewController];
    if (visibleViewController != self && [visibleViewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
        return [visibleViewController supportedInterfaceOrientations];
    }
    return self.supportedOrientationMask;
}

//- (void)setTmui_prefersStatusBarHiddenBlock:(BOOL (^)(void))tmui_prefersStatusBarHiddenBlock {
//    [super setTmui_prefersStatusBarHiddenBlock:tmui_prefersStatusBarHiddenBlock];
//    [self updateContainerWindowStatusBarCapture];
//}
//
//- (void)setTmui_preferredStatusBarStyleBlock:(UIStatusBarStyle (^)(void))tmui_preferredStatusBarStyleBlock {
//    [super setTmui_preferredStatusBarStyleBlock:tmui_preferredStatusBarStyleBlock];
//    [self updateContainerWindowStatusBarCapture];
//}
//
//- (void)updateContainerWindowStatusBarCapture {
//    if (!self.containerWindow) return;
//    // 当以 window 的方式显示浮层时，状态栏交给 TMUIModalPresentationViewController 控制
//    self.containerWindow.tmui_capturesStatusBarAppearance = self.tmui_prefersStatusBarHiddenBlock || self.tmui_preferredStatusBarStyleBlock;
//    if (self.containerWindow.tmui_capturesStatusBarAppearance) {
//        [self setNeedsStatusBarAppearanceUpdate];
//    }
//}

// 当以 present 方式显示浮层时，状态栏允许由 contentViewController 控制，但 TMUIModalPresentationViewController 的 tmui_prefersStatusBarHiddenBlock/tmui_preferredStatusBarStyleBlock 优先级会更高
- (UIViewController *)childViewControllerForStatusBarHidden {
    if (self.shownInPresentedMode && self.contentViewController) {
        return self.contentViewController;
    }
    return [super childViewControllerForStatusBarHidden];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    if (self.shownInPresentedMode && self.contentViewController) {
        return self.contentViewController;
    }
    return [super childViewControllerForStatusBarStyle];
}

- (UIViewController *)childViewControllerForHomeIndicatorAutoHidden {
    if (self.shownInPresentedMode) {
        return self.contentViewController;
    }
    return [super childViewControllerForHomeIndicatorAutoHidden];
}

@end

@implementation TMUIModalPresentationViewController (Manager)

+ (BOOL)isAnyModalPresentationViewControllerVisible {
    for (UIWindow *window in UIApplication.sharedApplication.windows) {
        if ([window isKindOfClass:[TMUIModalPresentationWindow class]] && !window.hidden) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)hideAllVisibleModalPresentationViewControllerIfCan {
    
    BOOL hideAllFinally = YES;
    
    for (UIWindow *window in UIApplication.sharedApplication.windows) {
        if (![window isKindOfClass:[TMUIModalPresentationWindow class]]) {
            continue;
        }
        
        // 存在modalViewController，但并没有显示出来，所以不用处理
        if (window.hidden) {
            continue;
        }
        
        // 存在window，但不存在modalViewController，则直接把这个window移除
        if (!window.rootViewController) {
            window.hidden = YES;
            continue;
        }
        
        TMUIModalPresentationViewController *modalViewController = (TMUIModalPresentationViewController *)window.rootViewController;
        BOOL canHide = YES;
        if ([modalViewController.delegate respondsToSelector:@selector(shouldHideModalPresentationViewController:)]) {
            canHide = [modalViewController.delegate shouldHideModalPresentationViewController:modalViewController];
        }
        if (canHide) {
            // 如果某些控件的显隐能力是通过 TMUIModalPresentationViewController 实现的，那么隐藏它们时，应该用它们自己的 hide 方法，而不是 TMUIModalPresentationViewController 自带的 hideWithAnimated:completion:
            id<TMUIModalPresentationComponentProtocol> modalPresentationComponent = nil;
            if ([modalViewController.contentViewController conformsToProtocol:@protocol(TMUIModalPresentationComponentProtocol)]) {
                modalPresentationComponent = (id<TMUIModalPresentationComponentProtocol>)modalViewController.contentViewController;
            } else if ([modalViewController.contentView conformsToProtocol:@protocol(TMUIModalPresentationComponentProtocol)]) {
                modalPresentationComponent = (id<TMUIModalPresentationComponentProtocol>)modalViewController.contentView;
            }
            if (modalPresentationComponent) {
                [modalPresentationComponent hideModalPresentationComponent];
            } else {
                [modalViewController hideWithAnimated:NO completion:nil];
            }
        } else {
            // 只要有一个modalViewController正在显示但却无法被隐藏，就返回NO
            hideAllFinally = NO;
        }
    }
    
    return hideAllFinally;
}

@end

@implementation TMUIModalPresentationWindow

- (void)layoutSubviews {
    [super layoutSubviews];
    // 避免来电状态时只 modal 的遮罩只盖住一部分的状态栏
    // 但在 iOS 13 及以后，来电状态下状态栏的高度不会再变化了
    // https://github.com/Tencent/TMUI_iOS/issues/375
    if (@available(iOS 13.0, *)) {
    } else {
        if (self.rootViewController) {
            UIView *rootView = self.rootViewController.view;
            if (CGRectGetMinY(rootView.frame) > 0 && !UIApplication.sharedApplication.statusBarHidden && StatusBarHeight > CGRectGetMinY(rootView.frame)) {
                rootView.frame = self.bounds;
            }
        }
    }

}

@end

@implementation UIViewController (TMUIModalPresentationViewController)

TMUISynthesizeIdWeakProperty(tmui_modalPresentationViewController, setTmui_modalPresentationViewController)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // present 方式显示的 modal，通过拦截 dismiss 方法来实现 shouldHide 的 delegate。注意以 window 方式显示的 modal，在 window.rootViewController = nil 时系统默认也会调用 dismiss，此时要通过 isShownInPresentedMode 区分开。
        OverrideImplementation([UIViewController class], @selector(dismissViewControllerAnimated:completion:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIViewController *selfObject, BOOL firstArgv, id secondArgv) {
                
                TMUIModalPresentationViewController *modal = nil;
                if ([selfObject.presentedViewController isKindOfClass:TMUIModalPresentationViewController.class]) {
                    modal = (TMUIModalPresentationViewController *)selfObject.presentedViewController;
                } else if ([selfObject isKindOfClass:TMUIModalPresentationViewController.class] && !selfObject.presentedViewController && selfObject.presentingViewController.presentedViewController == selfObject) {
                    modal = (TMUIModalPresentationViewController *)selfObject;
                }
                if ([modal.delegate respondsToSelector:@selector(shouldHideModalPresentationViewController:)] && modal.isShownInPresentedMode) {
                    BOOL shouldHide = [modal.delegate shouldHideModalPresentationViewController:modal];
                    if (!shouldHide) {
                        return;
                    }
                }
                
                // call super
                void (*originSelectorIMP)(id, SEL, BOOL, id);
                originSelectorIMP = (void (*)(id, SEL, BOOL, id))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, firstArgv, secondArgv);
            };
        });
    });
}

@end
