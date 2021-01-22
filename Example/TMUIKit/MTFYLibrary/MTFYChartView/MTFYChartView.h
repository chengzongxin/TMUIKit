//
//  MTFYChartView.h
//  Matafy
//
//  Created by Tiaotiao on 2019/7/31.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTFYChartViewConfigModel.h"

@class MTFYChartView;

@protocol MTFYChartViewDelegate <NSObject>

@optional

- (void)lineChartView:(MTFYChartView *)lineChartView didClickPointAtIndex:(NSInteger)index;

@end


@interface MTFYChartView : UIView

@property (nonatomic, weak) id<MTFYChartViewDelegate> delegate;

@property (nonatomic, strong) MTFYChartViewConfigModel *config;

/**
 *  快速创建lineChartView的方法
 */
+ (instancetype)lineChartView;

//- (void)draw;

- (void)drawTravel;

- (void)reset;


@end

