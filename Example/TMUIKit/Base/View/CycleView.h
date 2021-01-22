//
//  CycleView.h
//  Matafy
//
//  Created by Joe on 2020/4/14.
//  Copyright © 2020 com.upintech. All rights reserved.
//  轮播图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CycleView : UIView
// 图片数组
@property (copy, nonatomic) NSArray <NSString *> *imageUrls;
// 点击回调
@property (nonatomic,copy) void (^tapItem)(NSInteger index);
// 点击放大，默认不启用
@property (assign, nonatomic) BOOL tapScaleEnable;

@end

NS_ASSUME_NONNULL_END
