//
//  TMUIPageWrapperScrollView.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMUIPageWrapperScrollView : UIScrollView

@property (nonatomic, weak) id<UIScrollViewDelegate> t_delegate;

@property (nonatomic, assign) CGFloat lockArea;

- (void)scrollToTop:(BOOL)animated;

@end

//@interface UIScrollView (TMUI_ContainerNotScroll)
//@property (nonatomic, assign) BOOL tmui_containerNotScroll;
//@end

NS_ASSUME_NONNULL_END
