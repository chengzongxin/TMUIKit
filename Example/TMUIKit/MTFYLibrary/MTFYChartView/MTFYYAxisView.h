//
//  MTFYYAxisView.h
//  Matafy
//
//  Created by Tiaotiao on 2019/7/31.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTFYChartViewConfigModel.h"

@interface MTFYYAxisView : UIView

@property (nonatomic, strong) MTFYChartViewConfigModel *config;

- (void)draw;

- (void)reset;

@end

