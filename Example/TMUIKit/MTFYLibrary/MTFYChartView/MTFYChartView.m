//
//  MTFYChartView.m
//  Matafy
//
//  Created by Tiaotiao on 2019/7/31.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYChartView.h"
#import "UIView+Extension.h"

#import "MTFYXAxisView.h"
#import "MTFYYAxisView.h"

@interface MTFYChartView () <MTFYXAxisViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) MTFYXAxisView *xAxisView;
@property (strong, nonatomic) MTFYYAxisView *yAxisView;
@property (assign, nonatomic) CGFloat gap;

@end

@implementation MTFYChartView

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

- (void)dealloc {
//    NSLog(@"%s", __FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // 添加x轴与y轴视图
    MTFYYAxisView *yAxisView = [[MTFYYAxisView alloc] init];
    [self addSubview:yAxisView];
    self.yAxisView = yAxisView;

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;

    MTFYXAxisView *xAxisView = [[MTFYXAxisView alloc] init];
    [scrollView addSubview:xAxisView];
    self.xAxisView = xAxisView;
    self.xAxisView.delegate = self;
    
    
    // 1. 创建一个"轻触手势对象"
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    
    // 点击几次
    tap.numberOfTapsRequired = 2;
    [self.xAxisView addGestureRecognizer:tap];
    
    // 2. 捏合手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    [self.xAxisView addGestureRecognizer:pinch];
}

#pragma mark - Public

+ (instancetype)lineChartView {
    return [[self alloc] init];
}

- (void)drawTravel {
    if (self.config.pointArr.count == 0) return;

    // 设置y轴视图的尺寸
    self.yAxisView.x = 0;
    self.yAxisView.y = 0;
    self.yAxisView.width = self.config.yAxisViewWidth;
    self.yAxisView.height = self.height;
    
    // 设置scrollView的尺寸
    self.scrollView.x = self.yAxisView.width;
    self.scrollView.y = 0;
    self.scrollView.width = self.width - self.scrollView.x;
    self.scrollView.height = self.height;
    
    // 设置x轴视图的尺寸
    self.xAxisView.x = 0;
    self.xAxisView.y = 0;
    self.xAxisView.width = self.scrollView.width;
    self.xAxisView.height = self.scrollView.height;
    
    self.scrollView.contentSize = self.xAxisView.frame.size;
    
    self.gap = self.config.pointGap;
    
    // 给y轴视图传递参数
    self.yAxisView.config = self.config;
    //[self.yAxisView draw];
    
    self.xAxisView.config = self.config;
    [self.xAxisView drawTravel];
    
//    if (self.index < 0) {
//        if (self.index * self.config.pointGap > self.scrollView.width * 0.5) {
//            [self.scrollView setContentOffset:CGPointMake(self.index * self.config.pointGap - self.scrollView.width * 0.5 + self.config.pointGap * 0.8, 0) animated:YES];
//        } else{
//            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        }
//    }
}

- (void)reset {
    //[self.yAxisView draw];
    [self.xAxisView reset];
}

#pragma mark - Event Respone

// 轻触手势监听方法
- (void)tapGesture:(UITapGestureRecognizer *)tap {
    if(!self.config.isScal) {
        return;
    }
    
    self.config.pointGap = self.gap;
    
    if (self.xAxisView.width == self.scrollView.width) {
        [UIView animateWithDuration:0.25 animations:^{
            self.xAxisView.width = self.config.xAxisTitleArray.count * self.gap + 100;
        }];
        
        self.xAxisView.config.showTailAndHead = NO;
        
        self.xAxisView.config.pointGap = self.gap;
        
        self.scrollView.contentSize = CGSizeMake(self.xAxisView.width, 0);
    } else {
        self.xAxisView.config.showTailAndHead = YES;
        
        CGFloat scale = self.scrollView.width / (self.config.xAxisTitleArray.count * self.gap + 100);
        
        self.config.pointGap *= scale;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.xAxisView.width = self.scrollView.width;
        }];
        
        self.xAxisView.config.pointGap = self.config.pointGap;
        
        self.scrollView.contentSize = CGSizeMake(self.xAxisView.width, 0);
    }
}

// 捏合手势监听方法
- (void)pinchGesture:(UIPinchGestureRecognizer *)recognizer
{
    if (recognizer.state == 3) {
        if (self.xAxisView.width <= self.scrollView.width) {
            
            CGFloat scale = self.scrollView.width / self.xAxisView.width;
            
            self.config.pointGap *= scale;
            
            [UIView animateWithDuration:0.25 animations:^{
                self.xAxisView.width = self.scrollView.width;
            }];
            
            self.xAxisView.config.showTailAndHead = YES;
            
            self.xAxisView.config.pointGap = self.config.pointGap;
        } else if (self.xAxisView.width >= self.config.xAxisTitleArray.count * self.gap + 100) {
            [UIView animateWithDuration:0.25 animations:^{
                self.xAxisView.width = self.config.xAxisTitleArray.count * self.gap + 100;
            }];
            
            self.xAxisView.config.showTailAndHead = NO;
            
            self.config.pointGap = self.gap;
            
            self.xAxisView.config.pointGap = self.config.pointGap;
        }
    } else {
        self.xAxisView.width *= recognizer.scale;
        
        self.xAxisView.config.showTailAndHead = NO;
        
        self.config.pointGap *= recognizer.scale;
        self.xAxisView.config.pointGap = self.config.pointGap;
        recognizer.scale = 1.0;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.xAxisView.width, 0);
}

#pragma mark - Delegate

#pragma mark  MTFYXAxisViewDelegate

- (void)xAxisView:(MTFYXAxisView *)xAxisView didClickButtonAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(lineChartView:didClickPointAtIndex:)]) {
        [self.delegate lineChartView:self didClickPointAtIndex:index];
    }
}

#pragma mark  UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"stopTimer" object:@{@"bool":@0}];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"stopTimer" object:@{@"bool":@1}];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"stopTimer" object:@{@"bool":@1}];
}

#pragma mark - Private

#pragma mark - Getters and Setters

//- (NSMutableArray *)plots {
//    if (!_plots) {
//        _plots = [NSMutableArray array];
//    }
//    return _plots;
//}

#pragma mark - Supperclass

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - NSObject


@end
