//
//  UIScrollView+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (TMUI)

/// 判断UIScrollView是否已经处于顶部（当UIScrollView内容不够多不可滚动时，也认为是在顶部）
@property(nonatomic, assign, readonly) BOOL tmui_alreadyAtTop;

/// 判断UIScrollView是否已经处于底部（当UIScrollView内容不够多不可滚动时，也认为是在底部）
@property(nonatomic, assign, readonly) BOOL tmui_alreadyAtBottom;

/// UIScrollView 的真正 inset，在 iOS11 以后需要用到 adjustedContentInset 而在 iOS11 以前只需要用 contentInset
@property(nonatomic, assign, readonly) UIEdgeInsets tmui_contentInset;

/**
 UIScrollView 默认的 contentInset，会自动将 contentInset 和 scrollIndicatorInsets 都设置为这个值并且调用一次 tmui_scrollToTopUponContentInsetTopChange 设置默认的 contentOffset，一般用于 UIScrollViewContentInsetAdjustmentNever 的列表。
 @warning 如果 scrollView 被添加到某个 viewController 上，则只有在 viewController viewDidAppear 之前（不包含 viewDidAppear）设置这个属性才会自动滚到顶部，如果在 viewDidAppear 之后才添加到 viewController 上，则只有第一次设置 tmui_initialContentInset 时才会滚动到顶部。这样做的目的是为了避免在 scrollView 已经显示出来并滚动到列表中间后，由于某些原因，contentInset 发生了中间值的变动（也即一开始是正确的值，中间变成错误的值，再变回正确的值），此时列表会突然跳到顶部的问题。
 */
@property(nonatomic, assign) UIEdgeInsets tmui_initialContentInset;

/**
 * 判断当前的scrollView内容是否足够滚动
 * @warning 避免与<i>scrollEnabled</i>混淆
 */
- (BOOL)tmui_canScroll;

/**
 * 不管当前scrollView是否可滚动，直接将其滚动到最顶部
 * @param force 是否无视[self tmui_canScroll]而强制滚动
 * @param animated 是否用动画表现
 */
- (void)tmui_scrollToTopForce:(BOOL)force animated:(BOOL)animated;

/**
 * 等同于[self tmui_scrollToTopForce:NO animated:animated]
 */
- (void)tmui_scrollToTopAnimated:(BOOL)animated;

/// 等同于[self tmui_scrollToTopAnimated:NO]
- (void)tmui_scrollToTop;

/**
 滚到列表顶部，但如果 contentInset.top 与上一次相同则不会执行滚动操作，通常用于 UIScrollViewContentInsetAdjustmentNever 的 scrollView 设置完业务的 contentInset 后将列表滚到顶部。
 */
- (void)tmui_scrollToTopUponContentInsetTopChange;

/**
 * 如果当前的scrollView可滚动，则将其滚动到最底部
 * @param animated 是否用动画表现
 * @see [UIScrollView tmui_canScroll]
 */
- (void)tmui_scrollToBottomAnimated:(BOOL)animated;

/// 等同于[self tmui_scrollToBottomAnimated:NO]
- (void)tmui_scrollToBottom;

// 立即停止滚动，用于那种手指已经离开屏幕但列表还在滚动的情况。
- (void)tmui_stopDeceleratingIfNeeded;

/**
 以动画的形式修改 contentInset

 @param contentInset 要修改为的 contentInset
 @param animated 是否要使用动画修改
 */
- (void)tmui_setContentInset:(UIEdgeInsets)contentInset animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
