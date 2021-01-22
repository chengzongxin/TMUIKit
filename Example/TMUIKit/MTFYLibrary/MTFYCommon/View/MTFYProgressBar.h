//
//  MTFYProgressBar.h
//  Matafy
//
//  Created by Fussa on 2020/1/7.
//  Copyright © 2020 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKProgressLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface MTFYProgressBar : UIView

/** 进度条显示风格 */
@property (nonatomic, assign) DKProgressStyle progressStyle;
/** 进度条颜色，默认主题色 */
@property (nonatomic, strong) UIColor *progressColor;

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color;

/// 进度条开始加载
- (void)progressAnimationStart;

/// 进度条加载完成
- (void)progressAnimationCompletion;


@end

NS_ASSUME_NONNULL_END
