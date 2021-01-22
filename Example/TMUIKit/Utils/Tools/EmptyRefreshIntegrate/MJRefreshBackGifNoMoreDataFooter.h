//
//  MJRefreshBackGifNoMoreDataFooter.h
//  Matafy
//
//  Created by Jason on 2018/11/24.
//  Copyright © 2018 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefreshBackStateFooter.h"

@interface MJRefreshBackGifNoMoreDataFooter : MJRefreshBackStateFooter

@property (weak, nonatomic, readonly) UIImageView *gifView;

/** 设置state状态下的动画图片images 动画持续时间duration*/
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state;
- (void)setImages:(NSArray *)images forState:(MJRefreshState)state;

@end


