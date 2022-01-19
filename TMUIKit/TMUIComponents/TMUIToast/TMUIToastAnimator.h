//
//  TMUIToastAnimator.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/1/19.
//

#import <Foundation/Foundation.h>

@class TMUIToastView;

/**
 * `TMUIToastAnimatorDelegate`是所有`TMUIToastAnimator`或者其子类必须遵循的协议，是整个动画过程实现的地方。
 */
@protocol TMUIToastAnimatorDelegate <NSObject>

@required

- (void)showWithCompletion:(void (^)(BOOL finished))completion;
- (void)hideWithCompletion:(void (^)(BOOL finished))completion;
- (BOOL)isShowing;
- (BOOL)isAnimating;
@end

typedef NS_ENUM(NSInteger, TMUIToastAnimationType) {
    TMUIToastAnimationTypeFade      = 0,
    TMUIToastAnimationTypeZoom,
    TMUIToastAnimationTypeSlide
};

/**
 * `TMUIToastAnimator`可以让你通过实现一些协议来自定义ToastView显示和隐藏的动画。你可以继承`TMUIToastAnimator`，然后实现`TMUIToastAnimatorDelegate`中的方法，即可实现自定义的动画。TMUIToastAnimator默认也提供了几种type的动画：1、TMUIToastAnimationTypeFade；2、TMUIToastAnimationTypeZoom；3、TMUIToastAnimationTypeSlide；
 */
@interface TMUIToastAnimator : NSObject <TMUIToastAnimatorDelegate>

/**
 * 初始化方法，请务必使用这个方法来初始化。
 *
 * @param toastView 要使用这个animator的TMUIToastView实例。
 */
- (instancetype)initWithToastView:(TMUIToastView *)toastView NS_DESIGNATED_INITIALIZER;

/**
 * 获取初始化传进来的TMUIToastView。
 */
@property(nonatomic, weak, readonly) TMUIToastView *toastView;

/**
 * 指定TMUIToastAnimator做动画的类型type。此功能暂时未实现，目前所有动画类型都是TMUIToastAnimationTypeFade。
 */
@property(nonatomic, assign) TMUIToastAnimationType animationType;

@end
