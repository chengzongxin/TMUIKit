//
//  TMUICycleView.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/1/27.
//


static CGFloat const kPageControlBottom = 20;
static CGFloat const kCycleViewMaxCountMultiple = 1000;

#import "TMUICycleView.h"
#import "TMUITimer.h"
#import <Masonry/Masonry.h>

@interface TMUICycleViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation TMUICycleViewCell

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self.contentView addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
//        _imageView.layer.cornerRadius = 2;
//        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}


@end

@interface TMUICycleView () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

// UICollectionView当前的Row
@property (nonatomic, assign) NSInteger currentNumberOfItem;
// 轮播图的页数
// (numbers * kBannerViewMaxCountMultiple) 等于
// UICollectionView 的 numberOfItemsInSection:0
@property (nonatomic, assign) NSInteger numbers;

@property (nonatomic, strong) TMUITimer *timer;

@property (nonatomic, strong) TMUIPageControl *pageControl;

@property (nonatomic, assign) BOOL isAutoScrolling;

@end

@implementation TMUICycleView


- (void)dealloc {
    [self removeTimer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfigs];
        [self setupSubviews];
    }
    return self;
}

- (void)setupConfigs {
    self.numbers = 0;
    
    [self addTimer];
    [self addObservers];
}

- (void)setupSubviews {
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
    self.flowLayout.itemSize = self.bounds.size;
    
    CGFloat y = self.bounds.size.height - 5.0 - kPageControlBottom;
    _pageControl.frame = CGRectMake(0, y, self.bounds.size.width, 5.0);
}

- (void)addObservers {
    
    // 后台进前台通知 UIApplicationDidBecomeActiveNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    // 进入后台通知 UIApplicationDidEnterBackgroundNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)addTimer {
    __weak __typeof(self)weakSelf = self;
    self.timer = [[TMUITimer alloc] initWithInterval:5 block:^{
        [weakSelf timerScheduledAction];
    }];
    
    self.isAutoScrolling = YES;
}

- (void)removeTimer {
    [self.timer removeTimer];
}

#pragma mark - Public

- (void)resumeTimer {
    if (self.isAutoScrolling) {
        return;
    }
    
    [self.timer resumeTimer];
    self.isAutoScrolling = YES;
}

- (void)pauseTimer {
    if (!self.isAutoScrolling) {
        return;
    }
    
    [self.timer pauseTimer];
    
    self.isAutoScrolling = NO;
}

- (void)setDatas:(NSArray *)datas{
    _datas = datas;
    
    [self reloadData];
}

- (void)reloadData {
    self.numbers = self.datas.count;
    self.pageControl.numberOfPages = self.numbers;
    self.pageControl.currentPage = 0;
    
    [self.collectionView reloadData];
    
    if (self.numbers == 0) {
        self.pageControl.hidden = YES;
        [self removeTimer];
        return;
    }
    
    // 只有一张的时候,隐藏PageControl, 禁止滚动, 移除定时器
    if (self.numbers == 1) {
        self.pageControl.hidden = YES;
        self.collectionView.scrollEnabled = NO;
        [self removeTimer];
    } else {
        self.pageControl.hidden = NO;
        self.collectionView.scrollEnabled = YES;
    }
    
    self.currentNumberOfItem = self.numbers * (kCycleViewMaxCountMultiple / 2);
        
    if (self.currentNumberOfItem >= [self.collectionView numberOfItemsInSection:0]) {
        return;
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{

        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentNumberOfItem inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionNone
                                            animated:NO];
    });
    
//    [self.collectionView setContentOffset:CGPointMake(self.currentNumberOfItem * self.frame.size.width, 0) animated:NO];
}

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index {
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (__kindof UICollectionViewCell *)cellForItemAtCurrentIndex {
    return [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentNumberOfItem inSection:0]];
}

#pragma mark - Private

// 定时器回调方法
- (void)timerScheduledAction {
    if (!self) {
        return;
    }
    NSInteger toIndex = self.currentNumberOfItem + 1;
    
    if (toIndex < 0 || toIndex >= [self.collectionView numberOfItemsInSection:0]) {
        return;
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:YES];
//    [self.collectionView setContentOffset:CGPointMake(toIndex * self.width, 0) animated:YES];
}

// 后台进前台通知
// UIApplicationDidBecomeActiveNotification
- (void)didBecomeActive {
    [self resumeTimer];
}

// 进入后台通知
// UIApplicationDidEnterBackgroundNotification
- (void)didEnterBackground {
    [self pauseTimer];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (self.numbers * kCycleViewMaxCountMultiple);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TMUICycleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TMUICycleViewCell class])
                                                                           forIndexPath:indexPath];
    NSInteger idx = indexPath.item % self.numbers;
    !_configCell?:_configCell(cell,self.datas[idx]);
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TMUICycleViewCell *cell = (TMUICycleViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSInteger idx = indexPath.item % self.numbers;
    !_selectCell?:_selectCell(cell,self.datas[idx]);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.numbers == 0) return;
    
    CGFloat pageWidth = scrollView.frame.size.width;
    if (pageWidth == 0) {
        return;
    }
    NSInteger currentNumberOfItem = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    // 还没布局，layoutsubview 会到这里，会更新current，需要在这里返回，以免初始化滚动到中间不执行
    if (currentNumberOfItem == 0) {
        return;
    }
    
    if (currentNumberOfItem == self.currentNumberOfItem) {
        return;
    }
    
    self.currentNumberOfItem = currentNumberOfItem;
    
    NSInteger index = self.currentNumberOfItem % self.numbers;
    self.pageControl.currentPage = index;
    
    !_scrollCell?:_scrollCell(self,index);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}

#pragma mark - lazy

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[TMUICycleViewCell class]
            forCellWithReuseIdentifier:NSStringFromClass([TMUICycleViewCell class])];
    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = self.bounds.size;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
    }
    return _flowLayout;
}

- (TMUIPageControl *)pageControl {
    if (!_pageControl) {
        CGFloat y = self.bounds.size.height - 5.0 - kPageControlBottom;
        _pageControl = [[TMUIPageControl alloc] initWithFrame:CGRectMake(0, y, self.bounds.size.width, 3.0)];
        _pageControl.currentIndicatorSize = CGSizeMake(3.0, 3.0);
        _pageControl.indicatorSize = CGSizeMake(3.0, 3.0);
        _pageControl.indicatorInset = 6.0;
    }
    return _pageControl;
}


@end
