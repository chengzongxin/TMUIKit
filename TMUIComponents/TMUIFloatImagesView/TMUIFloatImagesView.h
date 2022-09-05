//
//  THKFloatImagesView.h
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/11/30.
//  Copyright © 2021 binxun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMUIFloatImagesViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TMUIFloatImagesView : UIView

- (instancetype)initWithMaxWidth:(CGFloat)maxWidth NS_DESIGNATED_INITIALIZER;

/// 外部调用bindViewModel，内部会自动计算size，布局cell
@property (nonatomic, strong, readonly) TMUIFloatImagesViewModel *viewModel;

/// 实现加载数据
@property (nonatomic, copy) void (^loadImage)(UIImageView *imageView,TMUIFloatImageModel *model);

/// 实现点击回调
@property (nonatomic, copy) void (^clickImage)(NSInteger index,NSArray<NSIndexPath *> *visibleIndexPaths,NSArray <UIImageView *> *visibleImageViews);

- (UIImageView *)imageViewAtIndex:(NSInteger)index;


// 不使用下面方法
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)bindViewModel:(TMUIFloatImagesViewModel *)viewModel;

+ (CGFloat)imagesViewHeightFor:(TMUIFloatImagesViewModel *)viewModel maxWidth:(CGFloat)width;

@end


NS_ASSUME_NONNULL_END
