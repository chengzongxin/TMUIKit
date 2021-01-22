//
//  MTFYChartViewConfigModel.h
//  Matafy
//
//  Created by Tiaotiao on 2019/7/31.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MTFYChartPointModel;

NS_ASSUME_NONNULL_BEGIN

@interface MTFYChartViewConfigModel : NSObject
/// 文字大小
@property (strong, nonatomic) UIFont *textFont;

/// 文字背景色
@property (nonatomic, strong) UIColor *textBackgroundColor;

/// 文字颜色
@property (strong, nonatomic) UIColor *textColor;

/// x轴文字与坐标轴间隙
@property (assign, nonatomic) CGFloat xAxisTextGap;

/// 坐标轴颜色
@property (strong, nonatomic) UIColor *axisColor;

/// x轴的文字集合
@property (strong, nonatomic) NSArray *xAxisTitleArray;

/// 点与点之间的间距(默认是表格宽度按点数平分宽度)
@property (assign, nonatomic) CGFloat pointGap;

/// y轴文字与坐标轴间隙
@property (assign, nonatomic) CGFloat yAxisTextGap;

/// y轴的最大值
@property (assign, nonatomic) CGFloat yAxisMaxValue;

/// y轴分为几段(默认5)
@property (assign, nonatomic) int numberOfYAxisElements;

/// y轴与左侧的间距
@property (assign, nonatomic) CGFloat yAxisViewWidth;

/// y轴数值是否添加百分号
@property (assign, nonatomic, getter=isPercent) BOOL percent;

/// 是否显示点Label
@property (assign, nonatomic, getter=isShowPointLabel) BOOL showPointLabel;

/// 存放plot的数组
@property (strong, nonatomic) NSMutableArray *plots;

/// 是否显示横向分割线
@property (assign, nonatomic, getter=isShowSeparate) BOOL showSeparate;

/// 横向分割线的颜色
@property (strong, nonatomic) UIColor *separateColor;

/// 视图的背景颜色
@property (strong, nonatomic) UIColor *backColor;

/// 点是否允许点击
@property (assign, nonatomic, getter=isPointUserInteractionEnabled) BOOL pointUserInteractionEnabled;

/// 定位时的索引值
@property (assign, nonatomic) NSInteger index;

/// 折线点显示 label颜色
@property (nonatomic,strong) UIColor *pointTopLabelColor;

/// 点击是否允许缩放
@property (nonatomic,assign) BOOL  isScal;

/// 横坐标平是否只显示首尾Label
@property (nonatomic, assign, getter=isShowTailAndHead) BOOL showTailAndHead;

/// 点最大值
@property (nonatomic, assign) CGFloat ponitMax;

/// 点最小值
@property (nonatomic, assign) CGFloat ponitMin;

/// 点数据数组
@property (nonatomic, strong) NSArray<MTFYChartPointModel *> *pointArr;

/// 线的颜色
@property (nonatomic, strong) UIColor *lineColor;

/// 线宽
@property (nonatomic, assign) CGFloat lineWidth;

/// 点的线宽
@property (nonatomic, assign) CGFloat pointLineWidth;

/// 点的颜色
@property (strong, nonatomic) UIColor *pointColor;

/// 焦点的颜色
@property (nonatomic, strong) UIColor *focalPointColor;

/// 焦点的背景颜色
@property (nonatomic, strong) UIColor *focalPointBGColor;

/// 焦点的填充色
@property (nonatomic, strong) UIColor *focalPointFillColor;

/// 焦点的外圈半径
@property (nonatomic, assign) CGFloat focalPointRadius;

/// 焦点的外圈线宽
@property (nonatomic, assign) CGFloat focalPointLineWidth;

/// 焦点的文字大小
@property (nonatomic, strong) UIFont *focalPointLabelFont;

/// 焦点的文字颜色
@property (nonatomic, strong) UIColor *focalPointLabelColor;

/// 选中的点的颜色
@property (strong, nonatomic) UIColor *pointSelectedColor;

/// 点的填充颜色
@property (nonatomic, strong) UIColor *pointFillColor;

/// 是否将颜色充满图表
@property (assign, nonatomic, getter=isChartViewFill) BOOL chartViewFill;

/// 显示点
@property (assign, nonatomic) BOOL withPoint;

/// 渐变颜色数组
@property (nonatomic, strong) NSArray *gradientColors;

/// 渐变以外地方的填充色
@property (nullable, nonatomic, strong) UIColor *fillColor;

/// 显示最大最小label文字
@property (nonatomic, assign) BOOL showMaxMinPointTip;

/// 点上的文字颜色
@property (nonatomic, strong) UIColor *tipColor;

/// 点上的文字
@property (nonatomic, strong) UIFont *tipFont;

/// 点的半径
@property (nonatomic, assign) CGFloat pointRadius;




@end

@interface MTFYChartPointModel : NSObject<NSCoding>

/// 点的原始值
@property (nonatomic, assign) CGFloat oriValue;

/// 修改后的点位置的值
@property (nonatomic, assign) CGFloat value;

/// 是否是最大值
@property (nonatomic, assign) BOOL isMax;

/// 是否是最小值
@property (nonatomic, assign) BOOL isMin;

/// 突出显示
@property (nonatomic, assign) BOOL isFocal;

/// 点对应的X轴上的文字
@property (nullable, nonatomic, copy) NSString *xTitle;

/// 点上要显示的文字
@property (nullable, nonatomic, copy) NSString *pointTitle;

/// 车类型（这里定义一个专门记录车类型的字段）
@property (nullable, nonatomic, copy) NSString *carTypeName;
@property (nullable, nonatomic, copy) NSString *carTypeCode;

@property (nonatomic, assign) BOOL isThird;

@end

NS_ASSUME_NONNULL_END
