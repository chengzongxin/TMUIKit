//
//  MTFYProgressBar.m
//  Matafy
//
//  Created by Fussa on 2020/1/7.
//  Copyright © 2020 com.upintech. All rights reserved.
//

#import "MTFYProgressBar.h"

#define kDefaultColor X16Color(@"#00C3CE")

@interface MTFYProgressBar()

@property (nonatomic, strong) DKProgressLayer *progressLayer;

@end


@implementation MTFYProgressBar

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color {
    self = [self initWithFrame:frame];
    if (self) {
        self.progressColor = color;
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    [self.layer addSublayer:self.progressLayer];
}


/// 进度条开始加载
- (void)progressAnimationStart {
    [self.progressLayer progressAnimationStart];
}

/// 进度条加载完成
- (void)progressAnimationCompletion {
    [self.progressLayer progressAnimationCompletion];
}

#pragma mark - Setter && Getter
- (DKProgressLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [[DKProgressLayer alloc] initWithFrame:self.layer.bounds];
    }
    return _progressLayer;
}

- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    self.progressLayer.progressColor = progressColor;
}

- (void)setProgressStyle:(DKProgressStyle)progressStyle {
    _progressStyle = progressStyle;
    if (!self.progressColor) {
        self.progressColor = kDefaultColor;
    }
    self.progressLayer.progressStyle = progressStyle;
}

#pragma mark - dealloc
- (void)dealloc {

}

@end
