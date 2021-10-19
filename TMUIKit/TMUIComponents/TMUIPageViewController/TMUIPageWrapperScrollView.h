//
//  TMUIPageWrapperScrollView.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMUIPageWrapperScrollView : UIScrollView
/// 代理
@property (nonatomic, weak) id<UIScrollViewDelegate> t_delegate;
/// 头部固定区域
@property (nonatomic, assign) CGFloat lockArea;
/// 是否头部固定
@property (nonatomic, assign, readonly, getter=isPin) BOOL pin;
/// 滑动到顶部
- (void)scrollToTop:(BOOL)animated;

@end

@interface UIScrollView (TMUI_PageComponent)

/// 滑动某一个scrollView时，禁止Wrapper联动滑动，通常在子VC中有弹窗类scrollView时，需要禁止弹窗scrollView的联动Wrapper，或者有包多层scrollView时使用
@property (nonatomic, assign) BOOL tmui_isWarpperNotScroll;
/// 是否包含刷新头部
@property (nonatomic, assign) BOOL tmui_isAddRefreshControl;
/// Wrapper顶部坐标
@property (nonatomic, assign, readonly) CGPoint tmui_scrollViewTopPoint;

@end

NS_ASSUME_NONNULL_END
