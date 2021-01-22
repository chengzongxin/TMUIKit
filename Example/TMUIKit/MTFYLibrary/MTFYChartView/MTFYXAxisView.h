//
//  MTFYXAxisView.h
//  Matafy
//
//  Created by Tiaotiao on 2019/7/31.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+AttributeText.h"
#import "MTFYChartViewConfigModel.h"

@class MTFYXAxisView;
@class PointTipView;


@protocol MTFYXAxisViewDelegate <NSObject>

@optional
- (void)xAxisView:(MTFYXAxisView *)xAxisView didClickButtonAtIndex:(NSInteger)index;

@end


@interface MTFYXAxisView : UIView

@property (nonatomic, weak) id<MTFYXAxisViewDelegate> delegate;
/// 配置模型
@property (nonatomic, strong) MTFYChartViewConfigModel *config;

- (void)drawTravel;

- (void)reset;

@end



@interface PointTipView : UIView

@property (nonatomic, strong) UILabel *priceLbl;

@property (nonatomic, strong) UILabel *typeLbl;


- (void)updateData:(NSString *)priceStr type:(NSString *)fromTypeStr;

@end


