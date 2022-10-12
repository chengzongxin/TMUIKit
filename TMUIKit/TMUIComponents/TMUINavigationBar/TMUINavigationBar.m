//
//  TMUINavigationBar.m
//  Demo
//
//  Created by Joe.cheng on 2022/4/7.
//

#import "TMUINavigationBar.h"
#import <Masonry/Masonry.h>
//#import "TMUIExtensions.h"
//#import "TMUIComponents.h"
#import "TMUICore.h"
#import "UIView+TMUI.h"
#import "UIButton+TMUI.h"
#import "UIImage+TMUI.h"
#import "UIViewController+TMUI.h"
#import "TMUINavigationStackView.h"
#import "TMUINavigationBarApprance.h"
#import "TMUIAppearance.h"

CGFloat const kTMUINavBarMargin = 5;
CGFloat const kTMUINavBarBtnW = 44.0;
CGFloat const kTMUINavBarBtnH = 44.0;


@interface UIView (LayoutCheck)
/// 外部设置了size
- (BOOL)isExistSizeLayout;
- (void)isExistLayout:(NSLayoutConstraint *)constraint;
@end

@interface TMUINavigationBar ()

@property (nonatomic, strong) TMUINavigationBarApprance *apprance;

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIView *contentView;
/// 阴影线条
@property (nonatomic, strong) UIView *shadowView;
/// 左边按钮容器
@property (nonatomic, strong) TMUINavigationStackView *leftStackView;
/// 右边按钮容器
@property (nonatomic, strong) TMUINavigationStackView *rightStackView;

@property (nonatomic, assign) UIStatusBarStyle preferredStatusBarStyle;

@property (nonatomic, assign) BOOL hasApplyAppearence;

@end


/// 左中右都是view容器类型，左右是stackview，适合自适应填充内容，只需要外部提供宽高即可
/// 默认左边是返回、isBackBtn = YES，也可以设置自定义类型，addLeftViews:  添加一个或多个View
/// 右边可选类型，有搜索、分享、设置等，也可以设置自定义类型，addRightViews:  添加一个或多个View
/// titleView可以由外部直接设置，如果是titleView，则左右边距是leftStack和rightStack，如果是title，则居中，取leftStack或者rightStack最大宽度作为左右约束
@implementation TMUINavigationBar


+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setDefaultAppearance];
    });
}

+ (void)setDefaultAppearance {
    TMUINavigationBar *appearance = [TMUINavigationBar appearance];
    // 应用外观时会走到这里，然后调用applyStyle设置属性，注意需要所有成员不为nil，否则应用失效
    appearance.titleViewInset = UIEdgeInsetsMake(0, kTMUINavBarBtnW+kTMUINavBarMargin, 0, kTMUINavBarBtnW+kTMUINavBarMargin);
//    appearance.titleViewEdgeInsetWhenHiddenEdgeButton = UIEdgeInsetsMake(0, 20, 0, 20);
    [appearance applyStyle:TMUINavigationBarStyle_Light];
    
}

- (void)applyStyle:(TMUINavigationBarStyle)style{
    if (self.hasApplyAppearence) {
        // init 应用后，在view渲染的时候就不重复应用，避免覆盖后面修改了配置
        return;
    }
    [self setBarStyle:style];
    self.hasApplyAppearence = YES;
}

- (void)setBarStyle:(TMUINavigationBarStyle)barStyle{
    _barStyle = barStyle;
    
    self.apprance = [TMUINavigationBarApprance appranceWithBarStyle:barStyle];
    self.backgroundColor = self.apprance.backgroundColor;
    _backBtn.tmui_image = self.apprance.backBtnImg;
    _titleLbl.textColor = self.apprance.titleColor;
    if (self.rightViewType == TMUINavigationBarRightViewType_Share) {
        _rightBtn.tmui_image = self.apprance.shareImg;
    }else if (self.rightViewType == TMUINavigationBarRightViewType_Search) {
        _rightBtn.tmui_image = self.apprance.searchImg;
    }
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, TMUI_SCREEN_WIDTH, tmui_navigationBarHeight())]) {
        // 背景
        [self addSubview:self.backgroundImageView];
        [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        // 内容容器
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@44);
        }];
        
        // 左容器
        [self.contentView addSubview:self.leftStackView];
        [self.leftStackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kTMUINavBarMargin);
            make.top.bottom.mas_equalTo(0);
        }];
        
        
        // 右容器
        [self.contentView addSubview:self.rightStackView];
        [self.rightStackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kTMUINavBarMargin);
            make.top.bottom.mas_equalTo(0);
        }];
        
        // 阴影线
        [self addSubview:self.shadowView];
        [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        
        // 设置默认显示按钮
        self.shadowView.hidden = YES;
        self.leftViewType = TMUINavigationBarLeftViewType_Back;
        self.rightViewType = TMUINavigationBarRightViewType_None;
        
        // 应用外观资源
        [self tmui_applyAppearance];
        
    }
    return self;
}

- (void)navBackAction:(UIButton *)btn
{
    UIViewController <TMUINavigationBarProtocol>* nexResponder = (UIViewController <TMUINavigationBarProtocol>*)self.tmui_viewController;
    if ([nexResponder respondsToSelector:@selector(navBackAction:)]) {
        [(id)nexResponder navBackAction:btn];
    }
#if DEBUG
    else {
        NSString * msg = [NSString stringWithFormat:@"`%@` does not respondsToSelector `%@`", [nexResponder class], NSStringFromSelector(_cmd)];
        NSAssert(NO, msg);
    }
#endif
}

- (void)navRightAction:(UIButton *)btn
{
    UIViewController <TMUINavigationBarProtocol>* nexResponder = (UIViewController <TMUINavigationBarProtocol>*)self.tmui_viewController;
    if ([nexResponder respondsToSelector:@selector(navRightAction:)]) {
        [(id)nexResponder navRightAction:btn];
    }
#if DEBUG
    else {
        NSString * msg = [NSString stringWithFormat:@"`%@` does not respondsToSelector `%@`", [nexResponder class], NSStringFromSelector(_cmd)];
        NSAssert(NO, msg);
    }
#endif
}


#pragma mark - Public
- (void)setTitle:(NSString *)title{
    _title = title;
    // 创建默认Label
    self.titleLbl.text = title;
    [self addTitleViewToContentView:self.titleLbl];
}

- (void)setAttrTitle:(NSAttributedString *)attrTitle{
    _attrTitle = attrTitle;
   // 创建默认Label
    self.titleLbl.attributedText = attrTitle;
    [self addTitleViewToContentView:self.titleLbl];
}


- (void)setTitleView:(UIView *)titleView{
    [self addTitleViewToContentView:titleView];
}


- (void)setTitleViewInset:(UIEdgeInsets)titleViewInset{
    _titleViewInset = titleViewInset;
    
    [self addTitleViewToContentView:self.titleView];
}

- (void)addTitleViewToContentView:(UIView *)titleView{
    if (_titleView == titleView) {
        // 重复添加，不处理
        return;
    }
    [_titleView removeFromSuperview]; // 移除旧的
    _titleView = titleView;
    
    [_contentView addSubview:titleView];
    // 这里设置下优先级，如果外部设置的size约束，则不会撑开titleView
    
    if ([titleView isExistSizeLayout]) {
        // 如果外部设置了size约束，则只需要居中即可
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_contentView);
        }];
    }else if (!CGSizeIsEmpty(titleView.intrinsicContentSize) && titleView.intrinsicContentSize.width <= SCREEN_WIDTH && titleView.intrinsicContentSize.height <= kTMUINavBarBtnH){
        // 有内置size，会自动调整，则只需要居中即可
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_contentView);
        }];
    }else{
        // 如果外部没设约束，则自动按照titleViewInset缩进填充整个导航栏，
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.titleViewInset);
        }];
    }
}


- (void)setLeftViewType:(TMUINavigationBarLeftViewType)leftViewType{
    _leftViewType = leftViewType;
    
    self.leftStackView.hidden = NO;
    if (leftViewType == TMUINavigationBarLeftViewType_None) {
        [self.leftStackView removeAllArrangeViews];
        self.leftStackView.hidden = YES;
    }else if (leftViewType == TMUINavigationBarLeftViewType_Back){
        [self setLeftViews:self.backBtn,nil];
    }
}

- (void)setRightViewType:(TMUINavigationBarRightViewType)rightViewType{
    _rightViewType = rightViewType;
    
    self.rightStackView.hidden = NO;
    if (rightViewType == TMUINavigationBarRightViewType_None) {
        [self.rightStackView removeAllArrangeViews];
        self.rightStackView.hidden = YES;
    }else if (rightViewType == TMUINavigationBarRightViewType_Share){
        self.rightBtn.tmui_image = self.apprance.shareImg;
        [self setRightViews:self.rightBtn,nil];
    }else if (rightViewType == TMUINavigationBarRightViewType_Search){
        self.rightBtn.tmui_image = self.apprance.searchImg;
        [self setRightViews:self.rightBtn,nil];
    }
}


- (void)setLeftView:(UIView *)leftView{
    _leftView = leftView;
    [self setLeftView:leftView size:CGSizeZero];
}

- (void)setRightView:(UIView *)rightView{
    _rightView = rightView;
    [self setRightView:rightView size:CGSizeZero];
}

- (void)setLeftView:(UIView *)view size:(CGSize)size{
    _leftView = view;
    if (!CGSizeIsEmpty(size)) {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(size);
        }];
    }
    [self setLeftViews:view,nil];
}

- (void)setRightView:(UIView *)view size:(CGSize)size{
    _rightView = view;
    if (!CGSizeIsEmpty(size)) {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(size);
        }];
    }
    [self setRightViews:view,nil];
}

- (void)setLeftViews:(UIView *)view, ...{
    [self.leftStackView removeAllArrangeViews];
    self.leftStackView.hidden = NO;
    va_list args;//定义一个指向个数可变的参数列表指针
    va_start(args, view);//得到第一个可变参数地址
    for (UIView *arg = view; arg != nil; arg = va_arg(args, UIView *)) {
        [self.leftStackView addArrangedSubview:arg];
    }
    va_end(args);//置空指针
}

- (void)setRightViews:(UIView *)view, ...{
    [self.rightStackView removeAllArrangeViews];
    self.rightStackView.hidden = NO;
    va_list args;//定义一个指向个数可变的参数列表指针
    va_start(args, view);//得到第一个可变参数地址
    for (UIView *arg = view; arg != nil; arg = va_arg(args, UIView *)) {
        [self.rightStackView addArrangedSubview:arg];
    }
    va_end(args);//置空指针
}



//- (void)setIsBackButtonHidden:(BOOL)isBackButtonHidden{
//    [self setIsBackButtonHidden:isBackButtonHidden animate:NO];
//}
//
//- (void)setIsBackButtonHidden:(BOOL)isBackButtonHidden animate:(BOOL)animate{
//    _isBackButtonHidden = isBackButtonHidden;
//
//    _backBtn.hidden = isBackButtonHidden;
//
//    if (self.titleView) {
//        if (isBackButtonHidden) {
//            [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(@(_titleViewEdgeInsetWhenHiddenEdgeButton.left));
//            }];
//        }else{
//            [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(@(_titleViewInset.left));
//            }];
//        }
//
//        if (animate) {
//            [UIView animateWithDuration:0.2 animations:^{
//                [self layoutIfNeeded];
//            }];
//        }
//    }
//
//}
//
//- (void)setIsRightButtonHidden:(BOOL)isRightButtonHidden{
//    [self setIsRightButtonHidden:isRightButtonHidden animate:NO];
//}
//
//- (void)setIsRightButtonHidden:(BOOL)isRightButtonHidden animate:(BOOL)animate{
//    _isRightButtonHidden = isRightButtonHidden;
//
//    _rightBtn.hidden = isRightButtonHidden;
//
//    if (self.titleView) {
//        if (isRightButtonHidden) {
//            [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(@(-_titleViewEdgeInsetWhenHiddenEdgeButton.right));
//            }];
//        }else{
//            [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(@(-_titleViewInset.right));
//            }];
//        }
//
//        if (animate) {
//            [UIView animateWithDuration:0.2 animations:^{
//                [self layoutIfNeeded];
//            }];
//        }
//    }
//
//}
//
//- (void)setTitleViewEdgeInsetWhenHiddenEdgeButton:(UIEdgeInsets)titleViewEdgeInsetWhenHiddenEdgeButton{
//    _titleViewEdgeInsetWhenHiddenEdgeButton = titleViewEdgeInsetWhenHiddenEdgeButton;
//    // 更新左右布局
//    [self setIsBackButtonHidden:_isBackButtonHidden];
//    [self setIsRightButtonHidden:_isRightButtonHidden];
//}

- (void)setBackgroundImage:(UIImage *)backgroundImage{
    self.backgroundImageView.hidden = NO;
    self.backgroundImageView.image = backgroundImage;
}

- (UIImage *)backgroundImage{
    return self.backgroundImageView.image;
}

#pragma mark - v7.3 增加导航条颜色可在scrollview滑动时手动控制渐变效果

/**
 设置导航条的颜色及tintColor(会影响子视图颜色)
 
 @param color 导航条最终颜色
 @param oriTintColor 导航条上的内容变化之前的默认颜色
 @param toTintColor 导航条上的内容可能也需要调整的目标颜色
 @param percent 颜色的过渡进度百分比，取值【0，1】，<=0 按0， >=1 按1
 @warning 此函数调用时内部会将translucent自动赋值为NO
 @warning 导航条上的内容颜色过渡由oriTintColor和toTintColor联合决定
 */

- (void)setNavigationBarColor:(UIColor *)color originTintColor:(UIColor *)oriTintColor toTintColor:(UIColor *)toTintColor gradientPercent:(float)percent
{
    percent = MAX(0, MIN(1, percent));
    self.backgroundColor = percent == 1 ? color : [color colorWithAlphaComponent:percent];

    NSArray *subvs = [self subviews];
    if (subvs.count == 0) {
        return;
    }
    UIColor *currentTintColor = nil;

    if (percent == 0.0) {
        currentTintColor = oriTintColor ? oriTintColor : toTintColor;
    }else if (percent == 1.0) {
        currentTintColor = toTintColor;
    }else {
        if (oriTintColor && toTintColor) {
            //过渡方法1. 从oriTintColor 直接按比例过渡到toTintColor
            CGFloat or = 0,  og = 0, ob = 0, oa = 0;
            CGFloat tr = 0, tg = 0, tb = 0, ta = 0;
            [oriTintColor getRed:&or green:&og blue:&ob alpha:&oa];
            [toTintColor getRed:&tr green:&tg blue:&tb alpha:&ta];
            currentTintColor = [UIColor colorWithRed:or + (tr-or)*percent green:og + (tg-og)*percent blue:ob + (tb-ob)*percent alpha:1];
        }else {
            currentTintColor = [toTintColor colorWithAlphaComponent:percent];
        }
    }
    // 左边
    [self foreachImageViewsIn:_backBtn toTintColor:currentTintColor];
    
    // 右边
    if (_rightBtn && !_rightBtn.isHidden) {
        [self foreachImageViewsIn:_rightBtn toTintColor:currentTintColor];
    }
    // 中间视图
    for (UIView * v in subvs) {
        [self foreachLabelViewsIn:v toTextColor:currentTintColor];
    }
    
    // 动态切换statusBar
    [self setStatusBarStyle:percent];
}

- (void)foreachLabelViewsIn:(UIView *)view toTextColor:(UIColor *)textColor {
    if ([view isKindOfClass:[UILabel class]]) {
        [(UILabel *)view setTextColor:textColor];
    }
    else if ([self isCanGradient:view] && ![view isKindOfClass:NSClassFromString(@"THKFocusButtonView")]) {
        for (UIView *subv in view.subviews) {
            [self foreachLabelViewsIn:subv toTextColor:textColor];
        }
    }
}

- (BOOL)isCanGradient:(UIView *)view{
    if (self.canGradient) {
        return self.canGradient(view);
    }
    return YES;
}

- (void)foreachImageViewsIn:(UIView *)view toTintColor:(UIColor *)tintColor {
    if ([view isKindOfClass:[UILabel class]]) {
        [self foreachLabelViewsIn:view toTextColor:tintColor];
        return;
    }
    if ([view isKindOfClass:[UIImageView class]]) {
        UIImageView *imgV = (UIImageView*)view;
        imgV.tintColor = tintColor;
        if (tintColor) {
            imgV.image = [imgV.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }else {
            imgV.image = [imgV.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }else {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            UIImage *img = [btn imageForState:UIControlStateNormal];
            if (img) {
                img = [img tmui_imageWithTintColor:tintColor];
                [btn setImage:img forState:UIControlStateNormal];
            }
        }else {
            for (UIView *subv in view.subviews) {
                [self foreachImageViewsIn:subv toTintColor:tintColor];
            }
        }
    }
}

- (void)setStatusBarStyle:(float)percent{
    UIViewController *vc = self.superview.tmui_viewController;
    if ([vc isKindOfClass:UIViewController.class] && [self aIsMethodOverride:vc.class selector:@selector(preferredStatusBarStyle)]) {
        if (percent >= 0.5) {
            if (@available(iOS 13.0, *)) {
                self.preferredStatusBarStyle = UIStatusBarStyleDarkContent;
            } else {
                // Fallback on earlier versions
                self.preferredStatusBarStyle = UIStatusBarStyleDefault;
            }
        }else{
            self.preferredStatusBarStyle = UIStatusBarStyleLightContent;
        }
        [vc setNeedsStatusBarAppearanceUpdate];
    }
}

/// 判断一个类是否重写suerper方法
- (BOOL)aIsMethodOverride:(Class)cls selector:(SEL)sel {
    IMP clsIMP = class_getMethodImplementation(cls, sel);
    IMP superClsIMP = class_getMethodImplementation([cls superclass], sel);
    return clsIMP != superClsIMP;
}


#pragma mark - lazy getter

- (UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.hidden = YES;
    }
    return _backgroundImageView;
}

- (TMUINavigationStackView *)leftStackView{
    if (!_leftStackView) {
        _leftStackView = [[TMUINavigationStackView alloc] init];
    }
    return _leftStackView;
}

- (TMUINavigationStackView *)rightStackView{
    if (!_rightStackView) {
        _rightStackView = [[TMUINavigationStackView alloc] init];
    }
    return _rightStackView;
}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = UIColorSeparator;
    }
    return _shadowView;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn addTarget:self action:@selector(navBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(kTMUINavigationBarItemSize);
        }];
    }
    return _backBtn;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn addTarget:self action:@selector(navRightAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(kTMUINavigationBarItemSize);
        }];
    }
    return _rightBtn;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}


- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = UIFontMedium(18);
        _titleLbl.textColor = TMUIColorHex(333333);
        _titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}

@end




@implementation UIView (LayoutCheck)

- (void)isExistLayout:(NSLayoutConstraint *)constraint{
    NSLog(@"%@",constraint.firstItem);
    NSLog(@"%ld",(long)constraint.firstAttribute);
    NSLog(@"%@",constraint.secondItem);
    NSLog(@"%ld",(long)constraint.secondAttribute);
    
    
    NSLog(@"%ld",(long)constraint.relation);
    NSLog(@"%f",constraint.constant);
    
    NSLog(@"%d",constraint.isActive);
    
}

- (BOOL)isExistSizeLayout{
    __block BOOL isExistW = NO;
    __block BOOL isExistH = NO;
    [self.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isLayoutEffect:obj attr:NSLayoutAttributeWidth]) {
            isExistW = YES;
        }
        if ([self isLayoutEffect:obj attr:NSLayoutAttributeHeight]) {
            isExistH = YES;
        }
    }];
    
    return isExistW && isExistH;
}

- (BOOL)isLayoutEffect:(NSLayoutConstraint *)layoutCons attr:(NSLayoutAttribute)attr{
    if (layoutCons.firstAttribute == attr && layoutCons.active == YES) {
        return YES;
    }else{
        return NO;
    }
}

@end
