//
//  TMUINavigationBar.h
//  Demo
//
//  Created by Joe.cheng on 2022/4/7.
//

#import <UIKit/UIKit.h>
#import "TMUINavigationBarDefineType.h"

UIKIT_EXTERN CGFloat const kTMUINavBarMargin;
UIKIT_EXTERN CGFloat const kTMUINavBarBtnW;
UIKIT_EXTERN CGFloat const kTMUINavBarBtnH;

#define kTMUINavigationBarItemSize CGSizeMake(kTMUINavBarBtnW, kTMUINavBarBtnH)

NS_ASSUME_NONNULL_BEGIN

@interface TMUINavigationBar : UIView

#pragma mark - Private Properties (readonly)
/// back button
@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;
/// 内容view
@property (nonatomic, strong, readonly) UIView *contentView;
/// 阴影线条
@property (nonatomic, strong, readonly) UIView *shadowView;
/// title label 使用简单设置标题才会有
@property (nonatomic, strong, readonly) UILabel *titleLbl;
/// back button 使用TMUINavigationBarLeftViewType_Back类型才会有
@property (nonatomic, strong, readonly) UIButton *backBtn;
/// right button 使用TMUINavigationBarRightViewType_Share、等类型才会有
@property (nonatomic, strong, readonly) UIButton *rightBtn;

#pragma mark - Public Method ( Custom bar title & button item )
/// 简单设置标题
@property (nonatomic, strong) NSString *title;
/// 简单设置标题富文本
@property (nonatomic, strong) NSAttributedString *attrTitle;
/// titleView
@property (nonatomic, strong) UIView *titleView;
/// titleView
@property (nonatomic, strong) UIImage *backgroundImage;
/// navigation bar style, defalt Normal is Light  white background, black content
@property (nonatomic, assign) TMUINavigationBarStyle barStyle;
/// 左按钮类型
@property (nonatomic, assign) TMUINavigationBarLeftViewType leftViewType UI_APPEARANCE_SELECTOR;
/// 右按钮类型
@property (nonatomic, assign) TMUINavigationBarRightViewType rightViewType UI_APPEARANCE_SELECTOR;
/// titleView 内容缩进  默认，{4,55,4,55} UIEdgeInsetsMake(4, kTMUINavBarBtnW+kTMUINavBarMargin, 4, kTMUINavBarBtnW+kTMUINavBarMargin);
@property (nonatomic, assign) UIEdgeInsets titleViewInset UI_APPEARANCE_SELECTOR;
/// 添加左边自定义视图
@property (nonatomic, strong) UIView *leftView;
- (void)setLeftView:(UIView *)view size:(CGSize)size;
- (void)setLeftViews:(UIView *)view,...;
/// 添加右边自定义视图
@property (nonatomic, strong) UIView *rightView;
- (void)setRightView:(UIView *)view size:(CGSize)size;
- (void)setRightViews:(UIView *)view,...;

/// navigation bar titleView Inset, defalut {0,20,0,20},titleView距离父视图左右边距,隐藏左右按钮时缩进
//@property (nonatomic, assign) UIEdgeInsets titleViewEdgeInsetWhenHiddenEdgeButton UI_APPEARANCE_SELECTOR;
///// hidden back button
//- (void)setIsBackButtonHidden:(BOOL)isBackButtonHidden animate:(BOOL)animate;
//@property (nonatomic, assign) BOOL isBackButtonHidden UI_APPEARANCE_SELECTOR;
///// hidden right button
//- (void)setIsRightButtonHidden:(BOOL)isRightButtonHidden animate:(BOOL)animate;
//@property (nonatomic, assign) BOOL isRightButtonHidden UI_APPEARANCE_SELECTOR;
#pragma mark - Gradient 渐变方法
/**
 设置导航条在scrollview滚动过程可渐变效果

 @param color 导航条最终颜色
 @param oriTintColor 导航条上的内容变化之前的默认颜色
 @param toTintColor 导航条上的内容可能也需要调整的目标颜色
 @param percent 颜色计算的百分比，颜色的过渡进度百分比，取值【0，1】，<=0 按0， >=1 按1
 @warning 导航条上的内容颜色过渡由oriTintColor和toTintColor联合决定
 @warning 导航条的titleview里仅处理label的textColor颜色变化，若是其它类型子视图则不会变换颜色
 @note 内部会处理使导航条的navigationItem的左右item视图相关imageView颜色渐变
 @note titleview的其它alpha值变化，交给外部控制，此方法内部仅控制相关颜色
 @warning navigationItem的左右item视图只有全icon样式渐变效果才好，若有文字则文字部分的颜色不会渐变
 */
- (void)setNavigationBarColor:(UIColor *)color originTintColor:(UIColor *)oriTintColor toTintColor:(UIColor *)toTintColor gradientPercent:(float)percent;

/// 滚动渐变的时候，是否允许某个view产生渐变效果
@property (nonatomic, copy) BOOL (^canGradient)(UIView *view);

/// 供外界VC访问，根据滑动percent，动态切换状态栏样式
@property (nonatomic, assign, readonly) UIStatusBarStyle preferredStatusBarStyle;

@end

NS_ASSUME_NONNULL_END
