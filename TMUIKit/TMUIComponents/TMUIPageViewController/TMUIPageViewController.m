//
//  ViewController.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//



#import "TMUIPageViewController.h"
#import "TMUICore.h"
#import "TMUIExtensions.h"
#import "TMUIMultipleDelegates.h"
#import "Masonry.h"

static NSString *const kParentVC = @"kParentVC";

@interface UIViewController (TMUIPageViewControllerRefreshProtocolImp)
@end


@implementation UIViewController (TMUIPageViewControllerRefreshProtocolImp)

/// 使用协议分类的形式添加默认实现，子类停止刷新会回调这里
- (void)pageViewControllerEndRefreshing{
    TMUIPageViewController *pvc = (TMUIPageViewController *)[self tmui_getBoundObjectForKey:kParentVC];
    if ([pvc respondsToSelector:@selector(endRefreshing)]) {
        [pvc endRefreshing];
    }
}

@end


@interface _TMUIPageHeaderVisualEffectView : UIVisualEffectView
@end
@implementation _TMUIPageHeaderVisualEffectView
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{return NO;}
@end

//static const CGFloat kSliderBarHeight = 44;
static const CGFloat kSliderBarStartX = 0;


@interface TMUIPageViewController () <UIScrollViewDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate>

// component
@property (nonatomic, strong) _TMUIPageHeaderVisualEffectView *effectView;
@property (nonatomic, strong) TMUIPageWrapperScrollView *wrapperView;
@property (nonatomic, strong) TMUIPageContentScrollView *contentView;
@property (nonatomic, strong) TMUISegmentControl *slideBar;
@property (nonatomic, strong) UIColor *sliderBarOriginBgColor;
// delegate
@property (nonatomic, strong) NSArray <UIViewController *> *childVCs;
@property (nonatomic, strong) NSArray <NSString *> *childTitles;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) CGFloat navBarHeight;
@property (nonatomic, assign) CGFloat sliderBarHeight;

// private
@property (nonatomic, assign, readwrite) NSInteger currentIndex;
@property (nonatomic, strong) UIViewController *preVC;
@property (nonatomic, strong) UIViewController *toVC;

@property (nonatomic, assign) BOOL isUseSystemNavBar;
@property (nonatomic, weak) UIViewController<TMUIPageChildVCRefreshProtocol> *refreshDelegate;
@property (nonatomic, strong) id<TMUIPageRefreshHeaderComponent> refreshHeader;

@end

@implementation TMUIPageViewController

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

// MARK: TODO ,crash
//- (void)dealloc{
//    [self clear];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initial];
}

- (void)initial{
    [self clear];
    // 设置透明后，self.view是屏幕高度，这里要设置为NO。以免分页组件出问题
    self.navigationController.navigationBar.translucent = NO;
    self.dataSource = self;
    self.delegate = self;
}

- (void)clear{
    [self.contentView tmui_removeAllSubviews];
    [self.wrapperView tmui_removeAllSubviews];
    [self.wrapperView removeFromSuperview];
    _wrapperView = nil;
    _headerView = nil;
    _slideBar = nil;
    _contentView = nil;
    _childVCs = nil;
    _childTitles = nil;
    _preVC = nil;
    _toVC = nil;
    _headerHeight = 0;
    _sliderBarHeight = 0;
    self.currentIndex = 0;
    self.dataSource = nil;
    self.delegate = nil;
}

- (void)reloadData{
    [self initial];
    
    [self fetchDataSource];
    
    [self addSubviews];
    
    [self makeConstraints];
    
    [self addChildViewAtIndex:self.currentIndex animate:NO];
}

- (void)fetchDataSource{
    self.childTitles = [self titlesForChildViewControllers];
    self.childVCs = [self viewControllersForChildViewControllers];
    
    if ([self.dataSource respondsToSelector:@selector(heightForHeader)]) {
        self.headerHeight = [self.dataSource heightForHeader];
    }
    
    if (self.headerHeight && [self.dataSource respondsToSelector:@selector(viewForHeader)]) {
        self.headerView = [self.dataSource viewForHeader];
    }else{
        self.headerView = UIView.new;
    }
    
    if ([self respondsToSelector:@selector(heightForSliderBar)]) {
        self.sliderBarHeight = [self.dataSource heightForSliderBar];
    }
    
    if ([self respondsToSelector:@selector(heightForNavBar)]) {
        self.navBarHeight = [self.dataSource heightForNavBar];
    }else{
        self.isUseSystemNavBar = YES;
    }
    
    if ([self.dataSource respondsToSelector:@selector(segmentControlConfig:)]){
        [self.dataSource segmentControlConfig:self.slideBar];
        self.sliderBarHeight = self.slideBar.frame.size.height;
        self.sliderBarOriginBgColor = self.slideBar.backgroundColor;
    }
    
    // 修复TMUISegmentControl组件曝光埋点,创建slider的时候，曝光block为空，这里重复曝光一下之前未曝光数据,后续滑动slider曝光不受影响
    if (self.slideBar.itemExposeBlock) {
        [self.slideBar.segmentButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.x < self.view.width) {
                self.slideBar.itemExposeBlock(obj, idx);
            }else{
                *stop = YES;
            };
        }];
    }
}

// 子视图布局
- (void)addSubviews {
    [self.view insertSubview:self.wrapperView atIndex:0];
    [self.wrapperView addSubview:self.headerView];
    [self.wrapperView addSubview:self.slideBar];
    [self.wrapperView addSubview:self.contentView];
}

- (CGFloat)contentViewHeight {
    return TMUI_SCREEN_HEIGHT - tmui_navigationBarHeight();
}

- (CGFloat)contentScrollBottomSafeArea {
    return 0;
}
// 设置约束
- (void)makeConstraints{
    if (self.isUseSystemNavBar) {
        self.wrapperView.height = [self contentViewHeight];
    }
    
    [self.wrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIEdgeInsets contentInset = UIEdgeInsetsMake(self.headerHeight+self.sliderBarHeight, 0, 0, 0);
    self.wrapperView.contentInset = contentInset;
    if (contentInset.top > self.view.bounds.size.height) {
        // 当contentInset.top很高的时候，scrollview会自动滚动，这里需要重新定位到顶部
        self.wrapperView.contentOffset = CGPointMake(0, -contentInset.top);
    }
    self.wrapperView.contentSize = self.view.bounds.size;
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wrapperView);
        make.top.mas_equalTo(-self.headerHeight-self.sliderBarHeight);
        make.height.mas_equalTo(self.headerHeight);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    [self.slideBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wrapperView.mas_left).offset(kSliderBarStartX);
        make.top.equalTo(self.headerView.mas_bottom);
        make.height.mas_equalTo(self.sliderBarHeight);
//        make.width.mas_equalTo(self.view.bounds.size.width - kSliderBarStartX);
//        make.right.mas_equalTo(0);
        make.width.mas_equalTo(self.view.mas_width).offset(-kSliderBarStartX);
    }];
    
    
    CGFloat contentScrollHeight = 0;
    if (self.isUseSystemNavBar) {
        contentScrollHeight = [self contentViewHeight] - self.sliderBarHeight - [self contentScrollBottomSafeArea];
    }else{
        contentScrollHeight = self.view.bounds.size.height - [self safeAreaTop] - self.navBarHeight - self.sliderBarHeight - [self contentScrollBottomSafeArea];
    }
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.slideBar.mas_bottom).priorityHigh();
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(contentScrollHeight);
    }];
    
    if (self.isEnableHeaderViewBlurWhenScroll) {
        [self.headerView addSubview:self.effectView];
        // 这里先使用frame达到需求，设置约束会有偶现的bug，这里避免约束存在nil的情况，后续排查问题
        self.effectView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.headerHeight);
//        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.headerView);  // headerView可能为空
//        }];
    }
    
    // 修正slider距离顶部距离
    CGFloat topInset = 0;
    if (self.isUseSystemNavBar) {
        // 有使用系统导航栏时，contentView是加到导航栏下方，上边距离导航栏0
        topInset = 0;
    }else{
        // 没有使用系统导航栏，contentView在最底层，在contentView上面添加状态栏，自定义导航栏
        // @joe.cheng, 在ios11以下的系统 kSafeAreaTopInset() 返回0，此时topInset未包含状态条高度，可能会有问题，这里需要至少增加20高度
        topInset = MAX(20, tmui_safeAreaTopInset()) + self.navBarHeight;
    }
    
    // 设置吸顶区域
    self.wrapperView.lockArea = topInset+self.sliderBarHeight;
    
    [self.view layoutIfNeeded];
}

- (void)addChildViewAtIndex:(NSInteger)index animate:(BOOL)animate{
    if (self.childVCs.count == 0 || self.childVCs.count != self.childTitles.count) {
        return;
    }
    
    UIViewController *childVC = self.childVCs[index];
    if (childVC.view.superview && self.currentIndex == index && self.contentView.subviews.count) {
        return;
    }
    
    [self.slideBar setSelectedIndex:index animated:animate];
    
    
    // 从当前页面切换到其他页，需要调用当前页面生命周期
    if (self.currentIndex != index) {
        UIViewController *preVC = self.childVCs[self.currentIndex];
        [preVC beginAppearanceTransition:NO animated:YES];
        [preVC endAppearanceTransition];
    }
    
    if (childVC.isViewLoaded && childVC.view.superview) {
        // 已加载过，调用生命周期方法
        [childVC beginAppearanceTransition:YES animated:YES];
        CGFloat x = index * self.view.bounds.size.width;
        [self.contentView setContentOffset:CGPointMake(x, 0) animated:animate];
        [childVC endAppearanceTransition];
    }else{
        // 未加载，需要添加后，再调用生命周期
        CGFloat x = index * self.view.bounds.size.width;
        childVC.view.frame = CGRectMake(x, 0, self.view.bounds.size.width , self.contentView.bounds.size.height);
        [childVC beginAppearanceTransition:YES animated:YES];
        [self.contentView addSubview:childVC.view];
        self.contentView.contentSize = CGSizeMake(self.view.bounds.size.width * self.childVCs.count, 0);
        [self addChildViewController:childVC];
        [self.contentView setContentOffset:CGPointMake(x, 0) animated:animate];
        [childVC endAppearanceTransition];
    }
    
    if ([self.delegate respondsToSelector:@selector(pageContentViewControllerDidScrolFrom:to:)]) {
        [self.delegate pageContentViewControllerDidScrolFrom:self.currentIndex to:index];
    }
    
    self.currentIndex = index;
}

#pragma mark - Public

- (void)scrollTo:(UIViewController *)vc{
    if (![vc isKindOfClass:[UIViewController class]]) return;
    
    NSUInteger index = [self indexOfViewController:vc];
    [self addChildViewAtIndex:index animate:NO];
}

- (void)scrollToIndex:(NSInteger)index animate:(BOOL)animate{
    if (index > self.childVCs.count - 1) {
        return;
    }
    [self addChildViewAtIndex:index animate:animate];
}

- (void)scrollToTopAnimate:(BOOL)animate{
    [self.wrapperView setContentOffset:CGPointMake(self.wrapperView.contentOffset.x, 0) animated:animate];
}

//- (void)addRefreshWithBlock:(dispatch_block_t)freshBlock{
//    TMUIRefreshHeaderView *headerView = [TMUIRefreshHeaderView new];
//    // 刘海屏需要在header上面显示
//    CGFloat inset = self.contentView.contentInset.top - [self safeAreaTop] - self.navBarHeight + 3; // 微调
//    [self.contentView addRefreshHeader:headerView refreshingBlock:freshBlock];
//    self.contentView.header.headerInset = inset;
//    // 使代理有多个回调对象
//    self.tmui_multipleDelegatesEnabled = YES;
//    [self.childVCs enumerateObjectsUsingBlock:^(UIViewController<TMUIPageChildVCRefreshProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        self.refreshDelegate = obj;
//    }];
//}

- (void)addRefreshHeader:(id<TMUIPageRefreshHeaderComponent>)header addAction:(void (^)(UIScrollView *))addAction{
    // 刘海屏需要在header上面显示
    self.refreshHeader = header;
    CGFloat inset = self.wrapperView.contentInset.top - [self safeAreaTop] - self.navBarHeight + 3; // 微调
//    [self.contentView addRefreshHeader:header refreshingBlock:freshBlock];
    addAction(self.wrapperView);
    header.headerInset = inset;
    // 使代理有多个回调对象
    self.tmui_multipleDelegatesEnabled = YES;
    [self.childVCs enumerateObjectsUsingBlock:^(UIViewController<TMUIPageChildVCRefreshProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        self.refreshDelegate = obj;
    }];
}


- (void)childVCsBeginRefresh{
    [self childVCsBeginRefresh:NO];
}

- (void)childVCsBeginRefresh:(BOOL)forceAll{
    [self performChildVCSelector:@selector(childViewControllerBeginRefreshing) para:nil forceAll:YES];
}

- (void)childVCsBeginRefreshWithPara:(NSDictionary *)para forceAll:(BOOL)forceAll{
    [self performChildVCSelector:@selector(childViewControllerBeginRefreshingWithPara:) para:para forceAll:forceAll];
}

- (void)endRefreshing{
    [self.refreshHeader endRefreshing];
}


- (void)tabbarDidRepeatSelect{
    if (self.wrapperView.contentOffset.y > -self.wrapperView.contentInset.top) {
        // 需要子类先滑动到顶部，才能滚动scrollView
        [self performChildVCSelector:@selector(childViewControllerTabbarDidRepeatSelect) para:nil forceAll:NO];
//        [self.contentView setContentOffset:CGPointMake(0, -self.contentView.contentInset.top) animated:NO];
        [self.wrapperView tmui_scrollToTopAnimated:YES];
    }else{
        [self.refreshHeader beginRefreshing];
    }
}

- (void)performChildVCSelector:(SEL)selector para:(NSDictionary *)para forceAll:(BOOL)forceAll{
    // 这里要使用self.childVCs  ，使用系统的self.childViewControllers返回的子VC实例对象有问题，需要进步一排查
    [self.childVCs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([vc isViewLoaded] && [vc respondsToSelector:selector]) {
            // childVC 加载后，才会调用刷新协议的方法，以免引起内部有懒加载逻辑，调用view的初始化引起问题,原则上只加载正在显示的VC
            if (forceAll || idx == self.currentIndex) {
                [vc tmui_bindObjectWeakly:self forKey:kParentVC];
//                [vc performSelector:selector];
                // 调用协议方法
                IMP imp = [vc methodForSelector:selector];
                
                if (para) {
                    void (*func)(id, SEL, id) = (void *)imp;
                    func(vc, selector, para);
                }else{
                    void (*func)(id, SEL) = (void *)imp;
                    func(vc, selector);
                }
                
            }
        }
    }];
}

#pragma mark - Event Respone
- (void)btnClick:(TMUISegmentControl *)control{
    NSUInteger index = control.selectedIndex;
    UIPageViewControllerNavigationDirection direction;
    if (index > self.currentIndex) {
        direction = UIPageViewControllerNavigationDirectionForward;
    } else {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
    BOOL animate = abs((int)(index - self.currentIndex)) > 1 ? NO : YES;
    
    [self addChildViewAtIndex:index animate:animate];
}


#pragma mark - Delegate
#pragma mark ==========外部代理方法 给子类实现==========
- (NSArray<__kindof UIViewController *> *)viewControllersForChildViewControllers{
    NSAssert(0, @"childViewControllers 方法未实现");
    return nil;
}

- (NSArray<NSString *> *)titlesForChildViewControllers{
    NSAssert(0, @"titlesForChildViewControllers 方法未实现");
    return nil;
}

- (CGFloat)heightForHeader{
    self.wrapperView.bounces = NO;
    return 0;
}

- (UIView *)viewForHeader{
    return UIView.new;
}

- (void)pageContentViewControllerDidScrolFrom:(NSInteger)fromVC to:(NSInteger)toVC {}

- (void)pageContentViewControllerDidScroll:(UIScrollView *)scrollView {}


#pragma mark ==========内部代理方法 PageVCDelegate==========
//这个方法是返回前一个页面,如果返回为nil,那么UIPageViewController就会认为当前页面是第一个页面不可以向前滚动或翻页

#pragma mark 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法,自动来维护次序
    // 不用我们去操心每个ViewController的顺序问题
    self.currentIndex = index;
    return [self viewControllerAtIndex:index];
}

#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.childVCs count]) {
        return nil;
    }
    self.currentIndex = index;
    return [self viewControllerAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    self.toVC = pendingViewControllers.firstObject;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    self.preVC = previousViewControllers.firstObject;
    
    if (!completed || !self.preVC || !self.toVC || self.preVC == self.toVC) return;
    
    NSInteger preIndex = [self indexOfViewController:self.preVC];
    NSInteger toIndex = [self indexOfViewController:self.toVC];
    
    if ([self respondsToSelector:@selector(pageContentViewControllerDidScrolFrom:to:)]) {
        [self pageContentViewControllerDidScrolFrom:preIndex to:toIndex];
    }
    
    self.slideBar.selectedIndex = toIndex;
    self.currentIndex = toIndex;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.wrapperView) {
        if ([self.delegate respondsToSelector:@selector(pageContentViewControllerDidScroll:)]) {
            [self.delegate pageContentViewControllerDidScroll:scrollView];
        }
        
        if (self.isEnableHeaderViewBlurWhenScroll) {
            CGFloat offset = scrollView.contentOffset.y;
            CGFloat minY = -scrollView.contentInset.top;
            CGFloat maxY = minY + [self heightForHeader] - (self.sliderBarHeight ?: [self safeAreaTop]);
            if (maxY - minY == 0) {
                return;
            }
            CGFloat progress = 0;
            if (offset > minY) {
                progress = fabs((offset - minY)/(maxY - minY));
            }
            
            self.effectView.alpha = progress;
        }
    }else if (scrollView == self.contentView) {
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.contentView) {
        // 获取当前角标
        NSInteger i = scrollView.contentOffset.x / self.view.bounds.size.width;
        
        self.slideBar.selectedIndex = i;
        
        [self addChildViewAtIndex:i animate:NO];
    }
}

#pragma mark - Private

#pragma mark 数组元素值，得到下标值
- (NSUInteger)indexOfViewController:(UIViewController *)viewController {
    return [self.childVCs indexOfObject:viewController];
}

#pragma mark 根据index得到对应的UIViewController
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.childVCs count] == 0) || (index >= [self.childVCs count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    return self.childVCs[index];
}

- (CGFloat)safeAreaTop{
    if (@available(iOS 11.0, *)) {
        // 在系统导航栏下是0
        return self.view.tmui_safeAreaInsets.top;
    }else{
        return 20;
    }
}


#pragma mark - Getters and Setters
- (TMUIPageWrapperScrollView *)wrapperView{
    if (_wrapperView == nil) {
        _wrapperView = [[TMUIPageWrapperScrollView alloc] init];
        _wrapperView.backgroundColor = [self contentViewBackgroundColor];
        _wrapperView.showsHorizontalScrollIndicator = NO;
        _wrapperView.t_delegate = self;
    }
    return _wrapperView;
}

- (UIColor *)contentViewBackgroundColor {
    return [UIColor whiteColor];
}

- (_TMUIPageHeaderVisualEffectView *)effectView{
    if (!_effectView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[_TMUIPageHeaderVisualEffectView alloc] initWithEffect:blur];
        _effectView.tmui_foregroundColor = UIColor.whiteColor;
    }
    return _effectView;
}


- (TMUIPageContentScrollView *)contentView{
    if (!_contentView) {
        // 创建contentScrollView
        _contentView = [[TMUIPageContentScrollView alloc] init];
        // 分页
        _contentView.pagingEnabled = YES;
        // 弹簧
        _contentView.bounces = YES;
        // 指示器
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.showsVerticalScrollIndicator = NO;
        
        // 设置代理.目的:监听内容滚动视图 什么时候滚动完成
        _contentView.delegate = self;
    }
    return _contentView;
}

- (TMUISegmentControl *)slideBar {
    if (!_slideBar) {
        CGRect frame = CGRectMake(kSliderBarStartX, 0, self.view.bounds.size.width - kSliderBarStartX, self.sliderBarHeight);
        _slideBar = [[TMUISegmentControl alloc] initWithFrame:frame titles:self.childTitles];
        _slideBar.backgroundColor = [UIColor whiteColor];
        _slideBar.indicatorView.backgroundColor = UIColorHexString(@"#111111");
        [_slideBar setTitleFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium] forState:UIControlStateNormal];
        [_slideBar setTitleFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium] forState:UIControlStateSelected];
        [_slideBar setTitleColor:UIColorHexString(@"#BABDC6") forState:UIControlStateNormal];
        [_slideBar setTitleColor:UIColorHexString(@"#111111") forState:UIControlStateSelected];
        [_slideBar addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventValueChanged];
        _slideBar.indicatorView.height = 3;
        _slideBar.indicatorView.y -= 3; // 需要放到最后设置
    }
    
    return _slideBar;
}


#pragma mark - Supperclass

#pragma mark - NSObject

@end
