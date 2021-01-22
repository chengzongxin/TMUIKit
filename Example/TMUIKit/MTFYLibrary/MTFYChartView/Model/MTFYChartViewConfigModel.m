//
//  MTFYChartViewConfigModel.m
//  Matafy
//
//  Created by Tiaotiao on 2019/7/31.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYChartViewConfigModel.h"

@implementation MTFYChartViewConfigModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

/// 初始化某些属性值
- (void)commonInit
{
   
    self.xAxisTextGap = 10;
    self.yAxisTextGap = 10;
    self.axisColor = [UIColor blackColor];
    self.textColor = [UIColor blackColor];
    self.textFont = [UIFont systemFontOfSize:12];
    self.numberOfYAxisElements = 5;
    self.percent = NO;
    self.showSeparate = NO;
    self.showPointLabel = YES;
    self.backColor = [UIColor clearColor];
    self.pointUserInteractionEnabled = YES;
    self.index = -1;
    self.pointTopLabelColor = [UIColor blackColor];
    
    self.textBackgroundColor = [UIColor clearColor];
    self.lineWidth = 2.0;
    self.fillColor = [UIColor whiteColor];
    self.pointFillColor = [UIColor whiteColor];
    self.tipColor = [UIColor mtfyLightGrayColor8A98AD];
    self.tipFont = [UIFont pingFangSCRegular:11];
    self.pointRadius = 4;
    self.focalPointRadius = 7;
    self.focalPointFillColor = [UIColor whiteColor];
    self.lineColor = [UIColor mtfyGreenColor09B3B3];
    self.pointColor = [UIColor mtfyGreenColor09B3B3];
    self.focalPointColor = [UIColor mtfyGreenColor09B3B3];
    self.focalPointLabelFont = [UIFont pingFangSCRegular:11];
    self.focalPointLabelColor = [UIColor mtfyLightGrayColor8A98AD];
    self.pointLineWidth = 2.0;
    self.focalPointLineWidth = 2.0;
}



#pragma mark - Supperclass
#pragma mark - NSObject

@end


@implementation MTFYChartPointModel

MJExtensionCodingImplementation

@end
