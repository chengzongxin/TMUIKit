//
//  TMUIPageControl.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/1/28.
//

#import "TMUIPageControl.h"

@interface TMUIPageControl ()
@property (nonatomic, strong) NSMutableArray <UIView *> *dots;
@property (nonatomic, strong) UIView *dotBkgView;

@end

@implementation TMUIPageControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor clearColor];
    
    self.style = TMUIPageControlStyleDot;
    self.alignment = TMUIPageControlAlignmentCenter;
    
    self.dots = [NSMutableArray array];
    
    self.indicatorInset = 5.0;
    
    self.indicatorSize = CGSizeMake(5, 5);
    self.currentIndicatorSize = CGSizeMake(15, 5);
    
    self.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    self.currentTintColor = [UIColor whiteColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self adjustSubviews];
}

- (void)adjustSubviews {
    CGFloat indicatorWidth = (self.numberOfPages - 1) * self.indicatorSize.width;
    CGFloat spaceWidth = (self.numberOfPages - 1) * self.indicatorInset;
    CGFloat width = indicatorWidth + spaceWidth + self.currentIndicatorSize.width;
    
    __block CGFloat x = (self.bounds.size.width - width) / 2;
    if (self.alignment == TMUIPageControlAlignmentLeft) {
        x = 0;
    } else if (self.alignment == TMUIPageControlAlignmentRight) {
        x = self.bounds.size.width - width;
    }
    ///8.11添加 :如果 indicatorInset <= 0, 则添加背景处理
    self.dotBkgView.frame = CGRectMake(x, MAX(0, (self.bounds.size.height - self.indicatorSize.height) / 2.0), width, self.indicatorSize.height);
    self.dotBkgView.backgroundColor = (self.indicatorInset <= 0) ? self.tintColor : [UIColor clearColor];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        for (UIView *dot in self.dots) {
            NSInteger idx = [self.dots indexOfObject:dot];
            CGSize size = (idx == self.currentPage ? self.currentIndicatorSize : self.indicatorSize);
            dot.frame = CGRectMake(x, MAX(0, (self.bounds.size.height - size.height) / 2.0), size.width, size.height);
            dot.backgroundColor = (idx == self.currentPage ? self.currentTintColor : (self.indicatorInset <= 0 ? [UIColor clearColor] : self.tintColor));
            
            if(self.updateStyleBlock){
                self.updateStyleBlock(dot, idx == self.currentPage);
            }
            x += (size.width + self.indicatorInset);
        }
    } completion:nil];
}

- (void)adjustTintColor {
    [self.dots enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = (idx == self.currentPage) ? self.currentTintColor : self.tintColor;
    }];
}

#pragma mark - Setter

- (void)setStyle:(TMUIPageControlStyle)style {
    _style = style;
    [self.dots enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.cornerRadius = (style == TMUIPageControlStyleLine ? 0 : MIN(self.indicatorSize.height, self.indicatorSize.width)/2);
    }];
}

- (void)setAlignment:(TMUIPageControlAlignment)alignment {
    if (alignment == _alignment) {
        return;
    }
    _alignment = alignment;
    [self setNeedsLayout];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    if (_numberOfPages == numberOfPages || numberOfPages < 0) {
        return;
    }
    
    _numberOfPages = numberOfPages;
    
    while (self.dots.count > numberOfPages) {
        UIView *view = [self.dots lastObject];
        [view removeFromSuperview];
        [self.dots removeLastObject];
    }
    
    while (self.dots.count < numberOfPages) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.indicatorSize.width, self.indicatorSize.height)];
        if (self.style == TMUIPageControlStyleDot) {
            view.layer.cornerRadius = MIN(self.indicatorSize.height, self.indicatorSize.width) / 2.0;
        }
        view.backgroundColor = self.tintColor;
        [self.dots addObject:view];
        [self addSubview:view];
    }
    
    [self.dotBkgView removeFromSuperview];
    self.dotBkgView = [[UIView alloc] init];
    self.dotBkgView.backgroundColor = [UIColor clearColor];
    self.dotBkgView.layer.cornerRadius = MIN(self.indicatorSize.height, self.indicatorSize.width) / 2.0;
    [self addSubview:self.dotBkgView];
    
    [self adjustSubviews];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if (_currentPage == currentPage || currentPage > self.numberOfPages || currentPage < 0) {
        return;
    }
    _currentPage = currentPage;
    [self setNeedsLayout];
}

- (void)setIndicatorSize:(CGSize)indicatorSize {
    _indicatorSize = indicatorSize;
    [self setNeedsLayout];
}

- (void)setCurrentIndicatorSize:(CGSize)currentIndicatorSize {
    _currentIndicatorSize = currentIndicatorSize;
    [self setNeedsLayout];
}

- (void)setIndicatorInset:(CGFloat)indicatorInset {
    if (indicatorInset == _indicatorInset) {
        return;
    }
    _indicatorInset = indicatorInset;
    [self setNeedsLayout];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self adjustTintColor];
}

- (void)setCurrentTintColor:(UIColor *)currentTintColor {
    _currentTintColor = currentTintColor;
    [self adjustTintColor];
}

@end
