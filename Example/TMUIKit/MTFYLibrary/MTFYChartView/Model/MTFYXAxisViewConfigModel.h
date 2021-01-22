//
//  MTFYXAxisViewConfigModel.h
//  Matafy
//
//  Created by Tiaotiao on 2019/7/31.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DVXAxisViewType) {
    DVXAxisViewTypeDefault,                 // 默认 app index
    DVXAxisViewTypeTravel                   // 出行 index
};

@interface MTFYXAxisViewConfigModel : NSObject

/**
 *  文字大小
 */
@property (nonatomic, strong) UIFont *textFont;
/**
 *  文字颜色
 */
@property (nonatomic, strong) UIColor *textColor;
/**
 *  x轴文字与坐标轴间隙
 */
@property (nonatomic, assign) CGFloat xAxisTextGap;
/**
 *  坐标轴颜色
 */
@property (nonatomic, strong) UIColor *axisColor;
/**
 *  坐标点数组
 */
@property (nonatomic, strong) NSArray *plots;
/**
 *  点与点之间的间距
 */
@property (nonatomic, assign) CGFloat pointGap;
/**
 *  x轴的文字集合
 */
@property (nonatomic, strong) NSArray *xAxisTitleArray;
/**
 *  y轴分为几段
 */
@property (nonatomic, assign) int numberOfYAxisElements;
/**
 *  是否显示横向分割线
 */
@property (nonatomic, assign, getter=isShowSeparate) BOOL showSeparate;
/**
 *  横向分割线的颜色
 */
@property (nonatomic, strong) UIColor *separateColor;
/**
 *  y轴的最大值
 */
@property (nonatomic, assign) CGFloat yAxisMaxValue;
/**
 *  是否将颜色充满图表
 */
//@property (assign, nonatomic, getter=isChartViewFill) BOOL chartViewFill;
/**
 *  是否显示点Label
 */
@property (nonatomic, assign, getter=isShowPointLabel) BOOL showPointLabel;
/**
 *  视图的背景颜色
 */
@property (nonatomic, strong) UIColor *backColor;
/**
 *  横坐标平是否只显示首尾Label
 */
@property (nonatomic, assign, getter=isShowTailAndHead) BOOL showTailAndHead;
/**
 *  pointLabel是否添加百分号
 */
@property (nonatomic, assign, getter=isPercent) BOOL percent;
/**
 *  点是否允许点击
 */
@property (nonatomic, assign, getter=isPointUserInteractionEnabled) BOOL pointUserInteractionEnabled;

// 折线点显示 label颜色
@property (nonatomic, strong) UIColor *pointTopLabelColor;

@property (nonatomic, assign) DVXAxisViewType viewType;

@end
