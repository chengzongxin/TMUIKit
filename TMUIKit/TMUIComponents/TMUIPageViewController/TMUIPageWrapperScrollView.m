//
//  TMUIPageWrapperScrollView.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/10/15.
//

#import "TMUIPageWrapperScrollView.h"
#import "UIView+TMUI.h"

@interface TMUIPageWrapperScrollView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    __weak UIScrollView *_currentScrollView;
    BOOL _isObserving;
    BOOL _lock;
}


@property (nonatomic, strong) NSMutableArray<UIScrollView *> *observedViews;

@end


@implementation TMUIPageWrapperScrollView

- (NSMutableArray *)observedViews {
    if (!_observedViews) {
        _observedViews = [NSMutableArray array];
    }
    return _observedViews;
}

static void * const kTMUIScrollViewKVOContext = (void*)&kTMUIScrollViewKVOContext;

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
                  context:kTMUIScrollViewKVOContext];
        _isObserving = YES;
    }
    return self;
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) context:kTMUIScrollViewKVOContext];
    [self removeObservedViews];
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
                    context:kTMUIScrollViewKVOContext];

//    _lock = (scrollView.contentOffset.y >= -scrollView.contentInset.top);
    //NSLog(@"addObserverToView scrollView.contentOffset.y=%f",scrollView.contentOffset.y);
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
                           context:kTMUIScrollViewKVOContext];
    }
    @catch (NSException *exception) {}
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == kTMUIScrollViewKVOContext && [keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
        
        CGPoint new = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        CGPoint old = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
        CGFloat diff = old.y - new.y;
        
        
        if (diff == 0.0 || !_isObserving) { return ;}
        
        BOOL isContentOffset = NO;
        
        if (_currentScrollView) {
            isContentOffset = _currentScrollView.contentOffset.y > -_currentScrollView.contentInset.top; // 子scroll有offset
        }
//        if (object == self && _currentScrollView) {
//            _lock = new.y >= -_lockArea;
//        }
        if (object == self) {
        }
        
        if (object == self) {
    
            _lock = (new.y + diff >= -_lockArea) && _currentScrollView;
        }
        
//        NSLog(@"=========== KVO event begin===========");
//        NSLog(@"ScrollView      : %@",[object class]);
//        NSLog(@"Observing       : %d",_isObserving);
//        NSLog(@"ContentOffset   : old[%.0f],new[%.0f],Offset[%.0f],Inset[%.0f]",old.y,new.y,self.contentOffset.y,self.contentInset.top);
//        NSLog(@"lock            : %d",lock);
//        NSLog(@"=========== KVO event end===========");
        
        
        if (object == self) {
            if (_lock) {
                if (isContentOffset) {
                    [self scrollView:self setContentOffset:CGPointMake(0, -_lockArea)];
                }else{
                    [self scrollView:self setContentOffset:new];
                }
            }else{
                [self scrollView:self setContentOffset:new];
            }
        } else {
            if (_lock) {
                [self scrollView:_currentScrollView setContentOffset:new];
//                [self scrollView:self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y - diff)];
            }else{
                if (isContentOffset) {
                    [self scrollView:_currentScrollView setContentOffset:CGPointZero];
//                    [self scrollView:self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y - diff)];
                }else{
                    [self scrollView:_currentScrollView setContentOffset:new];
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

    BOOL shouldScroll = scrollView != self && [scrollView isKindOfClass:[UIScrollView class]];

    if (shouldScroll) {
        [self addObservedView:scrollView];
        _currentScrollView = scrollView;
//        scrollView.bounces = NO;  // 是否禁止内部scrollView下拉回弹效果
    }

    return shouldScroll;
}

- (void)addObservedView:(UIScrollView *)scrollView{
//    if (scrollView.tmui_containerNotScroll) {
//        return;
//    }
    if (![self.observedViews containsObject:scrollView]) {
        [self.observedViews addObject:scrollView];
        [self addObserverToView:scrollView];
    }
}

@end
