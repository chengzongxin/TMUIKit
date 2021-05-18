//
//  ViewController.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//


NS_INLINE CGFloat kTNavigationBarHeight(){
    static CGFloat navHeight = 0;
    if (navHeight > 0) {
        return navHeight;
    }
    navHeight = 64;
    if (@available(iOS 11.0, *)) {
        CGFloat top = UIApplication.sharedApplication.windows.firstObject.safeAreaInsets.top;
        navHeight = top > 0 ? UIApplication.sharedApplication.windows.firstObject.safeAreaInsets.top + 44 : 64;
    }
    return navHeight;
}

#import "TMUIPageViewController.h"
#import "Masonry.h"

@interface TMUIPageViewController () <UIScrollViewDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate>

// component
@property (nonatomic, strong) TMUIPageBGScrollView *contentView;
@property (nonatomic, strong) UIView *tabSegmentControl;
@property (nonatomic, strong) UIScrollView *contentScrollView;

// delegate
@property (nonatomic, strong) NSArray <UIViewController *>*childVCs;
@property (nonatomic, strong) NSArray <NSString *>*titles;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, assign) CGFloat sliderBarHeight;

// private
@property (nonatomic, assign, readwrite) NSInteger currentIndex;
@property (nonatomic, strong) UIViewController *preVC;
@property (nonatomic, strong) UIViewController *toVC;

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
    self.currentIndex = 0;
    self.dataSource = self;
    self.delegate = self;
}

- (void)clear{
    [self initial];
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView removeFromSuperview];
    _contentView = nil;
    _headerView = nil;
    _tabSegmentControl = nil;
    _contentScrollView = nil;
    _childVCs = nil;
    _titles = nil;
    _headerView = nil;
    _preVC = nil;
    _toVC = nil;
    _headerHeight = 0;
    _sliderBarHeight = 0;
}

- (void)reloadData{
    [self clear];
    
    [self fetchDataSource];
    
    [self addSubviews];
    
    [self makeConstraints];
    
    [self addChildViewAtIndex:self.currentIndex animate:NO];
}

- (void)fetchDataSource{
    self.childVCs = [self childViewControllers];
    self.titles = [self titlesForChildViewControllers];
    
    if ([self.dataSource respondsToSelector:@selector(viewForHeader)]) {
        self.headerView = [self.dataSource viewForHeader];
    }
    
    if ([self.dataSource respondsToSelector:@selector(heightForHeader)]) {
        self.headerHeight = [self.dataSource heightForHeader];
    }
    
    if ([self respondsToSelector:@selector(heightForSliderBar)]) {
        self.sliderBarHeight = [self.dataSource heightForSliderBar];
    }
    
    if ([self.dataSource respondsToSelector:@selector(viewForTabSegmentControl)]) {
        self.tabSegmentControl = [self.dataSource viewForTabSegmentControl];
    }
    
    if (self.sliderBarHeight == 0) {
        self.sliderBarHeight = 44;
    }
}

// 子视图布局
- (void)addSubviews {
    [self.view insertSubview:self.contentView atIndex:0];
    [self.contentView addSubview:self.headerView];
    [self.contentView addSubview:self.tabSegmentControl];
    [self.contentView addSubview:self.contentScrollView];
}

// 设置约束
- (void)makeConstraints{
    UIEdgeInsets contentInset = UIEdgeInsetsMake(self.headerHeight+self.sliderBarHeight, 0, 0, 0);
    self.contentView.contentInset = contentInset;
    if (contentInset.top > self.view.bounds.size.height) {
        // 当contentInset.top很高的时候，scrollview会自动滚动，这里需要重新定位到顶部
        self.contentView.contentOffset = CGPointMake(0, -contentInset.top);
    }
    self.contentView.contentSize = self.view.bounds.size;
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.mas_equalTo(-self.headerHeight-self.sliderBarHeight);
        make.height.mas_equalTo(self.headerHeight);
        make.width.mas_equalTo(self.view.bounds.size.width);
    }];
    
    [self.tabSegmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.headerView.mas_bottom);
        make.height.mas_equalTo(self.sliderBarHeight);
        make.width.mas_equalTo(self.view.bounds.size.width);
    }];
    
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabSegmentControl.mas_bottom).priorityHigh();
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(self.view.bounds.size.height-kTNavigationBarHeight()-self.sliderBarHeight);
    }];
    
    [self.view layoutIfNeeded];
}

- (void)addChildViewAtIndex:(NSInteger)index animate:(BOOL)animate{
    if (self.childVCs.count == 0 || self.childVCs.count != self.titles.count) {
        return;
    }
    
    if (self.currentIndex == index && self.contentScrollView.subviews.count) {
        return;
    }
    
    if (labs(index - self.currentIndex) > 1) animate = NO;
    
    UIViewController *childVC = self.childVCs[index];
    if (childVC.isViewLoaded) {
        [childVC beginAppearanceTransition:YES animated:YES];
        CGFloat x = index * [UIScreen mainScreen].bounds.size.width;
        [self.contentScrollView setContentOffset:CGPointMake(x, 0) animated:animate];
        [childVC endAppearanceTransition];
        
        if (self.currentIndex != index) {
            UIViewController *preVC = self.childVCs[self.currentIndex];
            [preVC viewWillDisappear:YES];
            [preVC viewDidDisappear:YES];
        }
        
    }else{
        CGFloat x = index * [UIScreen mainScreen].bounds.size.width;
        childVC.view.frame = CGRectMake(x, 0, [UIScreen mainScreen].bounds.size.width , self.contentScrollView.bounds.size.height);
        [childVC beginAppearanceTransition:YES animated:YES];
        [self.contentScrollView addSubview:childVC.view];
        self.contentScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * self.childVCs.count, 0);
        [self addChildViewController:childVC];
        [self.contentScrollView setContentOffset:CGPointMake(x, 0) animated:animate];
        [childVC endAppearanceTransition];
    }
    
    if ([self.delegate respondsToSelector:@selector(pageViewControllerDidScrolFrom:to:)]) {
        [self.delegate pageViewControllerDidScrolFrom:self.currentIndex to:index];
    }
    
    self.currentIndex = index;
}

#pragma mark - Public

- (void)scrollToVC:(UIViewController *)vc{
    if (![vc isKindOfClass:[UIViewController class]]) return;
    
    NSUInteger index = [self indexOfViewController:vc];
    [self addChildViewAtIndex:index animate:NO];
}

- (void)scrollToIndex:(NSInteger)index{
    [self addChildViewAtIndex:index animate:YES];
}

#pragma mark - Event Respone
//- (void)btnClick:(THKSegmentControl *)control{
//    NSUInteger index = control.selectedIndex;
//    UIPageViewControllerNavigationDirection direction;
//    if (index > self.currentIndex) {
//        direction = UIPageViewControllerNavigationDirectionForward;
//    } else {
//        direction = UIPageViewControllerNavigationDirectionReverse;
//    }
//
//    CGFloat x = index * [UIScreen mainScreen].bounds.size.width;
//
//    BOOL animate = abs((int)(index - self.currentIndex)) > 1 ? NO : YES;
//    [self.contentScrollView setContentOffset:CGPointMake(x, 0) animated:animate];
//
////    [self.pageViewController setViewControllers:@[self.childVCs[index]] direction:direction animated:YES completion:nil];
//    [self addChildViewAtIndex:index animate:animate];
//}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
//    _selectedIndex = selectedIndex;
    UIPageViewControllerNavigationDirection direction;
    if (selectedIndex > self.currentIndex) {
        direction = UIPageViewControllerNavigationDirectionForward;
    } else {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
    CGFloat x = selectedIndex * [UIScreen mainScreen].bounds.size.width;
    
    BOOL animate = abs((int)(index - self.currentIndex)) > 1 ? NO : YES;
    [self.contentScrollView setContentOffset:CGPointMake(x, 0) animated:animate];
    
//    [self.pageViewController setViewControllers:@[self.childVCs[index]] direction:direction animated:YES completion:nil];
    [self addChildViewAtIndex:selectedIndex animate:animate];
}

- (NSInteger)selectedIndex{
    return self.currentIndex;
}

#pragma mark - Delegate
#pragma mark ==========外部代理方法 给子类实现==========
- (NSArray<__kindof UIViewController *> *)childViewControllers{
    NSAssert(0, @"childViewControllers 方法未实现");
    return nil;
}

- (NSArray<NSString *> *)titlesForChildViewControllers{
    NSAssert(0, @"titlesForChildViewControllers 方法未实现");
    return nil;
}

- (CGFloat)heightForHeader{
    self.contentView.bounces = NO;
    return 0;
}

- (UIView *)viewForHeader{return UIView.new;}

- (UIView *)viewForTabSegmentControl {return UIView.new;}


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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(pageViewControllerDidScroll:)]) {
        [self.delegate pageViewControllerDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.contentScrollView) {
        // 获取当前角标
        NSInteger i = scrollView.contentOffset.x / UIScreen.mainScreen.bounds.size.width;
        
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




#pragma mark - Getters and Setters
- (TMUIPageBGScrollView *)contentView {
    if (_contentView == nil) {
        _contentView = [[TMUIPageBGScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.lockArea = kTNavigationBarHeight()+self.sliderBarHeight;
        //        _contentView.otherDelegate = self;
        _contentView.t_delegate = self;
    }
    return _contentView;
}

- (UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        // 创建contentScrollView
        _contentScrollView = [[UIScrollView alloc] init];
        // 分页
        _contentScrollView.pagingEnabled = YES;
        // 弹簧
        _contentScrollView.bounces = YES;
        // 指示器
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        
        // 设置代理.目的:监听内容滚动视图 什么时候滚动完成
        _contentScrollView.delegate = self;
        _contentScrollView.tag = 888;
    }
    return _contentScrollView;
}

#pragma mark - Supperclass

#pragma mark - NSObject

@end