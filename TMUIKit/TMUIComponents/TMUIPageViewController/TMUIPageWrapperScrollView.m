//
//  TMUIPageWrapperScrollView.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/10/15.
//

#import "TMUIPageWrapperScrollView.h"
#import "UIView+TMUI.h"
#import "TMUICore.h"

@interface TMUIPageWrapperScrollView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    __weak UIScrollView *_currentScrollView;
    BOOL _isObserving;
}

@property (nonatomic, assign, readwrite) BOOL pin;

@property (nonatomic, strong) NSMutableArray<UIScrollView *> *observedViews;

@end


@implementation TMUIPageWrapperScrollView

- (NSMutableArray *)observedViews {
    if (!_observedViews) {
        _observedViews = [NSMutableArray array];
    }
    return _observedViews;
}

static void * const kTMUIScrollViewContentOffsetKVOContext = (void*)&kTMUIScrollViewContentOffsetKVOContext;



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        self.delegate = self;
        self.showsVerticalScrollIndicator = NO;
        self.directionalLockEnabled = YES;
        self.bounces = YES;

        [self addObserver:self
               forKeyPath:NSStringFromSelector(@selector(contentOffset))
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:kTMUIScrollViewContentOffsetKVOContext];
        _isObserving = YES;
    }
    return self;
}


- (void)scrollToTop:(BOOL)animated{
    _pin = NO;
    [self setContentOffset:self.tmui_scrollViewTopPoint animated:animated];
}


- (void)addObserverToView:(UIScrollView *)scrollView{
    // 必须要设置不调整缩进，否则头部缩进了，下拉时会自动往下偏移
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        scrollView.tmui_viewController.automaticallyAdjustsScrollViewInsets = NO;
    }
    if ([scrollView isKindOfClass:UICollectionView.class] && scrollView.alwaysBounceVertical == NO) {
        // UICollectionView数据不足时是默认不能滑动的，这就不能实现刷新或加载更多数据的功能，需要开启。
        scrollView.alwaysBounceVertical = YES;
        
    }
    
    [scrollView addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(contentOffset))
                    options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                    context:kTMUIScrollViewContentOffsetKVOContext];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == kTMUIScrollViewContentOffsetKVOContext && [keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
        
        CGPoint new = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        CGPoint old = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
        CGFloat diff = old.y - new.y;
        
        
        if (diff == 0.0 || !_isObserving) { return ;}
        
        BOOL isContentOffset = NO;
        
        if (_currentScrollView) {
            isContentOffset = _currentScrollView.contentOffset.y > -_currentScrollView.contentInset.top; // 子scroll有offset
        }
        
        if (object == self) {
            _pin = (new.y >= -_lockArea) || (old.y == -_lockArea && isContentOffset);
        }
        
//        NSLog(@"=========== KVO event begin===========");
//        NSLog(@"ScrollView      : %@",[object class]);
//        NSLog(@"Observing       : %d",_isObserving);
//        NSLog(@"ContentOffset   : old[%.0f],new[%.0f],Offset[%.0f],Inset[%.0f]",old.y,new.y,self.contentOffset.y,self.contentInset.top);
//        NSLog(@"lock            : %d",_lock);
//        NSLog(@"=========== KVO event end===========");
        
        if (_pin) {
            // 头部固定后，锁定不允许头部继续往上滑动
            if (object == self) {
                [self scrollView:self setContentOffset:CGPointMake(0, -_lockArea)];
            }else{
//                [self scrollView:_currentScrollView setContentOffset:new];
            }
        }else{
            if (object == self) {
                // 当子scrollView包含下拉刷新头部组件，自身不往下滑动
                if (_currentScrollView.tmui_isAddRefreshControl) {
                    // 当包含有
                    if (new.y < -self.contentInset.top) {
                        new.y = -self.contentInset.top;
                    }
                    [self scrollView:self setContentOffset:new];
                }else{
//                    [self scrollView:self setContentOffset:new];
                }
            }else{
                if (_currentScrollView.tmui_isAddRefreshControl) {
                    // 当子scrollView包含下拉刷新头部组件，子scrollView可以继续往下滑动
//                    [self scrollView:_currentScrollView setContentOffset:new];
                }else{
                    [self scrollView:_currentScrollView setContentOffset:_currentScrollView.tmui_scrollViewTopPoint];
                }
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)scrollView:(UIScrollView*)scrollView setContentOffset:(CGPoint)offset {
    _isObserving = NO;
    scrollView.contentOffset = offset;
    _isObserving = YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    UIScrollView *scrollView = (UIScrollView *)otherGestureRecognizer.view;
    
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
    
    if (scrollView.tmui_isWarpperNotScroll) {
        return NO;
    }

    BOOL shouldScroll = scrollView != self;
    
    if (shouldScroll) {
        [self addObservedView:scrollView];
        _currentScrollView = scrollView;
//        scrollView.bounces = NO;  // 是否禁止内部scrollView下拉回弹效果
    }

    return shouldScroll;
}

- (void)addObservedView:(UIScrollView *)scrollView{
    if (![self.observedViews containsObject:scrollView]) {
        [self.observedViews addObject:scrollView];
        [self addObserverToView:scrollView];
    }
}


- (void)dealloc{
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) context:kTMUIScrollViewContentOffsetKVOContext];
    [self removeObservedViews];
}


- (void)removeObservedViews{
    for (UIScrollView *scrollView in self.observedViews) {
        [self removeObserverFromView:scrollView];
    }
    [self.observedViews removeAllObjects];
}

- (void) removeObserverFromView:(UIScrollView *)scrollView{
    @try {
        [scrollView removeObserver:self
                        forKeyPath:NSStringFromSelector(@selector(contentOffset))
                           context:kTMUIScrollViewContentOffsetKVOContext];
    }
    @catch (NSException *exception) {}
}


- (BOOL)isPin{
    return _pin;
}

@end


@implementation UIScrollView (TMUI_PageComponent)
TMUISynthesizeBOOLProperty(tmui_isWarpperNotScroll, setTmui_isWarpperNotScroll);
TMUISynthesizeBOOLProperty(tmui_isAddRefreshControl, setTmui_isAddRefreshControl);
- (CGPoint)tmui_scrollViewTopPoint{
    return CGPointMake(self.contentOffset.x, -self.contentInset.top);
}
@end
