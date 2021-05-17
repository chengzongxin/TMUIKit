//
//  ViewController.h
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import <UIKit/UIKit.h>
@class THKViewController;
@class TMUIPageViewController;
#import "TMUIPageBGScrollView.h"

@protocol TMUIPageViewControllerDataSource <NSObject>

@required
/// 返回所有的子VC
- (NSArray <UIViewController *> *)childViewControllers;
/// 返回子VC标题
- (NSArray <NSString *> *)titlesForChildViewControllers;

- (UIView *)viewForTabSegmentControl;

@optional
/// 固定头部的高度
- (CGFloat)heightForHeader;
/// 固定头部的View
- (UIView *)viewForHeader;
/// 滑动tab的高度
- (CGFloat)heightForSliderBar;

@end

@protocol TMPageViewControllerDelegate <NSObject>
/// 子VC滑动回调事件
- (void)pageViewControllerDidScrolFrom:(NSInteger)fromVC to:(NSInteger)toVC;
/// scrollView滑动回调事件
- (void)pageViewControllerDidScroll:(UIScrollView *)scrollView;

@end

@interface TMUIPageViewController : UIViewController <TMUIPageViewControllerDataSource,TMPageViewControllerDelegate>
/// 数据源方法，默认Self
@property (nonatomic, weak) id<TMUIPageViewControllerDataSource> dataSource;
/// 代理方法，默认Self
@property (nonatomic, weak) id<TMPageViewControllerDelegate> delegate;
/// 当前被选中的indexVC
@property (nonatomic, assign, readonly) NSInteger currentIndex;

@property (nonatomic, assign) NSInteger selectedIndex;

/* 组件视图*/
/// 总的背景ScrollView
@property (nonatomic, strong, readonly) TMUIPageBGScrollView *contentView;
/// 滑动tab
//@property (nonatomic, strong, readonly) THKSegmentControl *slideBar;
/// 承载子VC的view的scrollView
@property (nonatomic, strong, readonly) UIScrollView *contentScrollView;
/// 刷新数据源，会初始化所有属性和子视图，重新调代理方法渲染界面
- (void)reloadData;
/// 滑动到某一个子VC
- (void)scrollToVC:(UIViewController *)vc;
/// 滑动到某一个index
- (void)scrollToIndex:(NSInteger)index;

@end

