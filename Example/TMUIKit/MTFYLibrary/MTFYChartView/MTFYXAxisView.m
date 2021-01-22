//
//  MTFYXAxisView.m
//  Matafy
//
//  Created by Tiaotiao on 2019/7/31.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYXAxisView.h"
#import "UIView+Extension.h"

#import "DVPlot.h"

// 防止划线在最左侧
#define firstOffsetX  2
// 第一个点直径
#define dot_1R 16
// 其他店直径
#define dot_2R 10

static const NSUInteger travelTopMargin = 15;

/// 点距离边缘的最小边距
static const CGFloat kMinRightLeftMargin = 8.0;
//static const NSUInteger max = 25.0;

@interface MTFYXAxisView ()
/// 图表顶部留白区域
@property (assign, nonatomic) CGFloat topMargin;
/// 记录图表区域的高度
@property (assign, nonatomic) CGFloat chartHeight;
/// 记录坐标轴Label的高度
@property (assign, nonatomic) CGFloat textHeight;
/// 存放坐标轴的label（底部的）
@property (strong, nonatomic) NSMutableArray *titleLabelArray;
/// 记录坐标轴的第一个Label
@property (strong, nonatomic) UILabel *firstLabel;
/// 记录点按钮的集合
@property (strong, nonatomic) NSMutableArray *buttonPointArray;
/// 选中的点
@property (strong, nonatomic) UIButton *selectedPoint;
@property (strong, nonatomic) NSMutableArray *pointButtonArray;
/// 点的坐标数组
@property (nonatomic, strong) NSMutableArray<NSValue *> *pointsArr;
/// 点的Layer
@property (nonatomic, strong) CAShapeLayer *pointLayer;
/// 焦点的背景Layer
@property (nonatomic, strong) CAShapeLayer *pointBgLayer;
/// 焦点的layer
@property (nonatomic, strong) CAShapeLayer *pointFocalLayer;

@end

@implementation MTFYXAxisView

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

-(void)dealloc {
//    NSLog(@"%s", __FUNCTION__);
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        //self.textFont = [UIFont systemFontOfSize:12];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // 只画线，没有填充色
    [self drawLineOnly:rect pointArr:self.config.pointArr];
    
    // 画点
    if (self.config.withPoint) {
        //[self drawPoint:rect pointArr:self.config.pointArr];
        [self configPointLayer:rect pointArr:self.config.pointArr];
        [self drawPointTipText:rect pointArr:self.config.pointArr];
        return;
    }
    
    // 画线，空白处填充
    if (self.config.isChartViewFill) {
        [self drawFill:rect pointArr:self.config.pointArr];
        return;
    }
}

#pragma mark - Public

- (void)drawTravel {
    self.hidden = NO;
    self.backgroundColor = self.config.backColor;
    // 移除先前存在的所有视图
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    // 移除数组内所有的Label元素
    [self.titleLabelArray removeAllObjects];
    [self.pointButtonArray removeAllObjects];
    
    // 点间距
    CGFloat pointGap = [self fetchPointGap:self.config.pointArr];
    // 左右边距
    CGFloat leftMargin = [self fetchLeftMargin];
    
    // 添加坐标轴Label
    for (int i = 0; i < self.config.pointArr.count; i++) {
        MTFYChartPointModel *point = self.config.pointArr[i];
        NSString *title = point.xTitle;
        if([title includeChinese] && title.length > 4) {
            title = [NSString stringWithFormat:@"%@...",[title substringToIndex:2]];
        }

        if (![title includeChinese] && title.length > 6) {
            title = [NSString stringWithFormat:@"%@...",[title substringToIndex:5]];
        }
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.font = self.config.textFont;
        label.textColor = self.config.textColor;

        NSDictionary *attr = @{NSFontAttributeName : self.config.textFont};
        CGSize labelSize = [title sizeWithAttributes:attr];

        BOOL isFirst = i == 0;
        BOOL isLast = i == self.config.pointArr.count - 1;
        
        CGFloat temp = 5;
        if (isFirst) {
            label.x = kMinRightLeftMargin - temp;
        } else if (isLast) {
            label.x = self.width - labelSize.width - kMinRightLeftMargin + temp;
        } else {
            label.x = i * pointGap + leftMargin - labelSize.width / 2;
        }
        
        label.y = self.height - labelSize.height;
        label.width = labelSize.width;
        label.height = labelSize.height;
        if (i == 0) {
            self.firstLabel = label;
        }

        [self.titleLabelArray addObject:label];
        [self addSubview:label];
    }
    
    

    // 添加坐标轴
    NSDictionary *attribute = @{NSFontAttributeName : self.config.textFont};
    CGSize textSize = [@"x" sizeWithAttributes:attribute];

    self.textHeight = 0;

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = self.config.axisColor;
    view.height = 1;
    view.width = self.width + 200;
    view.x = -200;
    view.y = self.height - textSize.height - self.config.xAxisTextGap;
    [self addSubview:view];

    // 计算横向分割线位置
    self.topMargin = travelTopMargin;
    self.chartHeight = self.height - self.textHeight - self.config.xAxisTextGap - self.topMargin;
    CGFloat separateHeight = 1;
    CGFloat separateMargin = (self.height - self.topMargin - self.textHeight - self.config.xAxisTextGap - self.config.numberOfYAxisElements * separateHeight) / self.config.numberOfYAxisElements;

    // 画横向分割线
    if (self.config.isShowSeparate) {
        for (int i = 0; i < self.config.numberOfYAxisElements; i++) {
            UIView *separate = [[UIView alloc] init];
            separate.x = 0;
            separate.width = self.width;
            separate.height = separateHeight;
            separate.y = view.y - (i + 1) * (separateMargin + separate.height);
            separate.backgroundColor = self.config.separateColor;
            [self addSubview:separate];
        }
    }


    // 如果Label的文字有重叠，那么隐藏
//    for (int i = 0; i < self.titleLabelArray.count; i++) {
//        UILabel *label = self.titleLabelArray[i];
//
//        CGFloat maxX = CGRectGetMaxX(self.firstLabel.frame);
//
//        if (self.config.isShowTailAndHead == NO) {
//            if (i != 0) {
//                if ((maxX + 3) > label.x) {
//                    label.hidden = YES;
//                } else {
//                    label.hidden = NO;
//                    self.firstLabel = label;
//                }
//            } else {
//                if (self.firstLabel.x < 0) {
//                    self.firstLabel.x = 0;
//                }
//            }
//        } else {
//            if (i > 0 && i < self.titleLabelArray.count - 1) {
//                label.hidden = YES;
//            } else if (i == 0) {
//                if (self.firstLabel.x < 0) {
//                    self.firstLabel.x = 0;
//                }
//            } else {
//                if (CGRectGetMaxX(label.frame) > self.width) {
//                    label.x = self.width - label.width;
//                }
//            }
//        }
//    }
    
    [self setNeedsDisplay];
}

- (void)reset {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }

    [self removeFocalPointLayer];
    [self removePointLayer];
    
    self.hidden = YES;
}

#pragma mark - Event Respone

- (void)pointDidClicked:(UIButton *)button {
    self.selectedPoint.selected = NO;
    UIButton *pointButton = self.pointButtonArray[(NSUInteger) button.tag];
    pointButton.selected = YES;
    self.selectedPoint = pointButton;
    
    if ([self.delegate respondsToSelector:@selector(xAxisView:didClickButtonAtIndex:)]) {
        [self.delegate xAxisView:self didClickButtonAtIndex:button.tag];
    }
}

#pragma mark - Delegate

#pragma mark - Private
//
//- (void)drawPoint:(CGRect)rect pointArr:(NSArray<MTFYChartPointModel *> *)pointArr
//{
//    if (pointArr.count != self.pointsArr.count) {
//        return;
//    }
//
//    for (int i = 0; i < pointArr.count; i++) {
//        MTFYChartPointModel *pointModel = pointArr[i];
//        //NSNumber *valueNum = pointArr[i];
//        CGFloat itemValue = pointModel.value;
//        itemValue = itemValue < 0 ? 0 : itemValue;
//
//        NSString *title = [self decimalWithFormat:@"0.00" floatV:ceil(itemValue)];
//
//        // 判断title的值，整数或者小数
//        if (![self mtfy_isPureFloat:title]) {
//            title = [NSString stringWithFormat:@"%.0f", title.floatValue];
//        }
//
//        CGPoint point = CGPointMake (0 ,0);
//        if (i < self.pointsArr.count) {
//            point = [self.pointsArr[i] CGPointValue];;
//        }
//
//        // 添加point处的Label
//        if (self.config.isShowPointLabel) {
//            //[self addLabelWithTitle:title atLocation:point andTag:i];
//        }
//
//        BOOL isNeedBig = pointModel.isMin || pointModel.isMax;
//        CGFloat buttonW = dot_2R;
//        NSString *buttonImgStr = @"圆点";
//        if (isNeedBig) {
//            buttonW = dot_1R;
//            buttonImgStr = @"圆2";
//        }
//
//        UIButton *button = [[UIButton alloc] init];
//        button.tag = i;
//        button.layer.masksToBounds = YES;
//        button.userInteractionEnabled = self.config.isPointUserInteractionEnabled;
//        [button addTarget:self action:@selector(pointDidClicked:) forControlEvents:UIControlEventTouchUpInside];
//        button.backgroundColor = [UIColor clearColor];
//        [button setBackgroundImage:[UIImage imageNamed:buttonImgStr] forState:UIControlStateNormal];
//        button.layer.cornerRadius = buttonW * 0.5;
//        button.frame = CGRectMake(point.x - buttonW * 0.5, point.y - buttonW * 0.5, buttonW, buttonW);
//
//        [self.pointButtonArray addObject:button];
//        if (button.userInteractionEnabled) {
//            if (i == 0) {
//                [self pointDidClicked:button];
//            }
//        }
//
//        [self addSubview:button];
//    }
//}

/**
 * 画点
 */
- (void)configPointLayer:(CGRect)rect pointArr:(NSArray<MTFYChartPointModel *> *)pointArr {
    [self removeFocalPointLayer];
    [self removePointLayer];
    
    if (!self.pointLayer.superlayer) {
        CGMutablePathRef pointPath = CGPathCreateMutable();
        CGMutablePathRef pointBgPath = CGPathCreateMutable();
        CGMutablePathRef pointFocalPath = CGPathCreateMutable();

        for (NSUInteger i = 0; i < pointArr.count; i++) {
            MTFYChartPointModel *pointModel = pointArr[i];

            CGPoint point = CGPointMake (0 ,0);
            if (i < self.pointsArr.count) {
                point = [self.pointsArr[i] CGPointValue];;
            }

            if (pointModel.isFocal) {
                CGFloat bgRadius = self.config.focalPointRadius;
                CGPathMoveToPoint(pointBgPath, NULL, point.x + bgRadius, point.y);
                CGPathAddArc(pointBgPath, NULL, point.x, point.y, bgRadius, 0, 2 * M_PI, NO);

                CGFloat radius = self.config.pointRadius;
                CGPathMoveToPoint(pointFocalPath, NULL, point.x + radius, point.y);
                CGPathAddArc(pointFocalPath, NULL, point.x, point.y, radius, 0, 2 * M_PI, NO);
            } else {
                CGFloat radius = self.config.pointRadius;
                CGPathMoveToPoint(pointPath, NULL, point.x + radius, point.y);
                CGPathAddArc(pointPath, NULL, point.x, point.y, radius, 0, 2 * M_PI, NO);
            }
        }
        
        self.pointLayer.strokeColor = self.config.lineColor.CGColor;
        self.pointLayer.fillColor = self.config.pointFillColor.CGColor;
        self.pointLayer.lineWidth = self.config.pointLineWidth;
        self.pointLayer.backgroundColor = [UIColor clearColor].CGColor;
        self.pointLayer.frame = CGRectInset(self.bounds, 0, 0);
        self.pointLayer.path = pointPath;

        self.pointFocalLayer.strokeColor = self.config.focalPointColor.CGColor;
        self.pointFocalLayer.fillColor = self.config.focalPointFillColor.CGColor;
        self.pointFocalLayer.lineWidth = self.config.pointLineWidth;
        self.pointFocalLayer.backgroundColor = [UIColor clearColor].CGColor;
        self.pointFocalLayer.frame = CGRectInset(self.bounds, 0, 0);
        self.pointFocalLayer.path = pointFocalPath;

        self.pointBgLayer.strokeColor = self.config.focalPointBGColor.CGColor;
        self.pointBgLayer.fillColor = self.config.focalPointFillColor.CGColor;
        self.pointBgLayer.lineWidth = self.config.focalPointLineWidth;
        self.pointBgLayer.backgroundColor = [UIColor clearColor].CGColor;
        self.pointBgLayer.frame = CGRectInset(self.bounds, 0, 0);
        self.pointBgLayer.path = pointBgPath;
        
        CGPathRelease(pointPath);
        CGPathRelease(pointBgPath);
        CGPathRelease(pointFocalPath);
    }
    
    [self.layer addSublayer:self.pointBgLayer];
    [self.layer addSublayer:self.pointLayer];
    [self.layer addSublayer:self.pointFocalLayer];
}

- (void)removePointLayer {
    if (self.pointLayer.superlayer != nil) {
        [self.pointLayer removeFromSuperlayer];
    }
}

- (void)removeFocalPointLayer {
    if (self.pointBgLayer.superlayer != nil) {
        [self.pointBgLayer removeFromSuperlayer];
    }
    if (self.pointFocalLayer.superlayer != nil) {
        [self.pointFocalLayer removeFromSuperlayer];
    }
}


/**
 * 画线，空白处填充
 */
- (void)drawFill:(CGRect)rect pointArr:(NSArray<MTFYChartPointModel *> *)pointArr {
    // 最大
    CGFloat maxValue = self.config.ponitMax;
    // 最小
    CGFloat minValue = self.config.ponitMin;
    // 差
    NSInteger minusValue = maxValue - minValue;
    NSInteger valueX = minValue;
    
    CGFloat a = 80.0 / minusValue;
    CGFloat b = a * (valueX - minValue);
    CGFloat c = b + 20;
    
    if (minusValue == 0) {
        c = 20;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    CGPoint start = CGPointMake(kMinRightLeftMargin+(kMinRightLeftMargin * 0.5), self.chartHeight - c / self.config.yAxisMaxValue * self.chartHeight + self.topMargin+ dot_2R * 0.5);
    
    [path moveToPoint:start];
    
    for (int i = 0; i < pointArr.count; i++) {
        MTFYChartPointModel *point = pointArr[i];
        CGFloat itemValue = point.value;
        itemValue = itemValue < 0 ? 0 : itemValue;
        
        CGPoint center = CGPointMake((i+1)*self.config.pointGap+kMinRightLeftMargin, self.chartHeight - c / self.config.yAxisMaxValue * self.chartHeight + self.topMargin+ dot_2R * 0.5);
        
        if (self.config.yAxisMaxValue * self.chartHeight == 0) {
            center = CGPointMake((i+1) * self.config.pointGap, self.chartHeight + self.topMargin);
        }
        
        [path addLineToPoint:center];
    }
    
    CGPoint end = CGPointMake(pointArr.count * self.config.pointGap, self.height - self.config.xAxisTextGap - self.textHeight);
    
    [path addLineToPoint:end];

    //[[plot.lineColor colorWithAlphaComponent:0.35] set];
    [self.config.lineColor set];
    // 将路径添加到图形上下文
    CGContextAddPath(ctx, path.CGPath);
    // 渲染
    CGContextFillPath(ctx);
}


/**
 * 画线
 */
- (void)drawLineOnly:(CGRect)rect pointArr:(NSArray<MTFYChartPointModel *> *)pointArr {
    // 最大
//    CGFloat maxValue = self.config.ponitMax;
    // 最小
    CGFloat minValue = self.config.ponitMin;
    // 差
//    NSInteger minusValue = (NSInteger) (maxValue - minValue);
    NSInteger minusValue = (NSInteger)(self.config.yAxisMaxValue - minValue);
    if (minusValue < 0) {
        minusValue = 0;
    }

    NSMutableArray *pointArray = [NSMutableArray array];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGFloat pointCenterX = 0, pointCenterY = 0;

    // 左边距
    CGFloat left = [self fetchLeftMargin];
    // 点间距
    CGFloat pointGap = [self fetchPointGap:pointArr];

    NSDictionary *attribute = @{NSFontAttributeName : self.config.textFont};
    CGSize textSize = [@"x" sizeWithAttributes:attribute];
    // 获取最小值的点半径
    CGFloat minPointR = [self fetchMinPointR:pointArr];
    CGFloat minPointBottom = textSize.height + self.config.xAxisTextGap + minPointR;
//    CGFloat leftTop = self.config.yAxisMaxValue - minValue;
    CGFloat yHeight = self.chartHeight - minPointBottom;
    CGFloat yMinus = minusValue == 0 ? 0 : yHeight / minusValue;
    
    for (NSUInteger i = 0; i < pointArr.count; i++) {
        MTFYChartPointModel *pointModel = pointArr[i];
        CGFloat value = pointModel.value;
        // 先前tiaotiao的写法
//        CGFloat a = minusValue <= 0 ? 0 : (leftTop) / minusValue;
//        CGFloat b = a * (value - minValue);
//        CGFloat c = b + minPointBottom;
//        if (minusValue == 0) {
//            c = minPointBottom;
//        }
//
//        pointCenterX = left +(i) * pointGap + 0;
//        pointCenterY = self.chartHeight - c / self.config.yAxisMaxValue * self.chartHeight + self.topMargin;// + dot_2R * 0.5;
        
        pointCenterX = left + (i) * pointGap + 0;
        pointCenterY = self.chartHeight - (value - minValue) * yMinus;

        CGPoint point = CGPointMake(pointCenterX, pointCenterY);
        if (self.config.yAxisMaxValue * self.chartHeight == 0) {
//            point = CGPointMake((i+1)*pointGap, self.chartHeight + self.topMargin);
            point = CGPointMake((i+1)*pointGap, self.chartHeight);
        }
        
        [pointArray addObject:[NSValue valueWithCGPoint:point]];

        if (i == 0) {
            [path moveToPoint:point];
        } else {
            [path addLineToPoint:point];
        }
    }
    
    self.pointsArr = pointArray;
    [self drawLineGradient:rect pointArray:pointArray];
    
    [self.config.lineColor set];
    // 将路径添加到图形上下文
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetLineWidth(ctx, self.config.lineWidth);
    // 渲染
    CGContextStrokePath(ctx);
}



/**
 * 线性渐变色
 */
- (void)drawLineGradient:(CGRect)rect pointArray:(NSArray *)pointArray{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //使用RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGFloat locations[] = {0, 1.0};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
                                                        (__bridge CFArrayRef)self.config.gradientColors,
                                                        locations);

    /*绘制线性渐变
     context:图形上下文
     gradient:渐变色
     startPoint:起始位置
     endPoint:终止位置
     options:绘制方式,kCGGradientDrawsBeforeStartLocation开始位置之前就进行绘制，到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，到结束点之后继续填充
     */

    CGFloat startPointY = self.topMargin;
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, startPointY), CGPointMake(0, self.height), kCGGradientDrawsAfterEndLocation);

    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
    
    CGPoint firstPoint = [pointArray.firstObject CGPointValue];
    CGPoint lastPoint = [pointArray.lastObject CGPointValue];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, firstPoint.x, firstPoint.y);
    
    for (int i = 1; i < pointArray.count; i ++) {
        CGPoint point = [pointArray[i] CGPointValue];
        CGPathAddLineToPoint(path, NULL, point.x, point.y);
    }
    
    //CGFloat padding = dot_2R / 2;
    CGFloat padding = 0;
    CGPathAddLineToPoint(path, NULL, lastPoint.x + padding, lastPoint.y + padding);
    CGPathAddLineToPoint(path, NULL, lastPoint.x + padding, rect.size.height);
    CGPathAddLineToPoint(path, NULL, rect.size.width, rect.size.height);
    CGPathAddLineToPoint(path, NULL, rect.size.width, 0);
    CGPathAddLineToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, 0, rect.size.height);
    CGPathAddLineToPoint(path, NULL, firstPoint.x, rect.size.height);
    CGPathAddLineToPoint(path, NULL, firstPoint.x,firstPoint.y);
    
    [[UIColor clearColor] set];
    [self.config.fillColor setFill];

    CGContextSetLineWidth(context, self.config.lineWidth);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
}

/**
 * 画点上的文字
 */
- (void)drawPointTipText:(CGRect)rect pointArr:(NSArray<MTFYChartPointModel *> *)pointArr {
    if (pointArr.count != self.pointsArr.count) {
        return;
    }
    
    for (int i = 0; i < pointArr.count; i++) {
        @autoreleasepool {
            MTFYChartPointModel *pointModel = pointArr[i];
            
            CGPoint point = CGPointMake (0 ,0);
            if (i < self.pointsArr.count) {
                point = [self.pointsArr[i] CGPointValue];;
            }
            
            // 添加point处的提示文字
            if (self.config.isShowPointLabel) {
                BOOL isFirst = i == 0;
                BOOL isLast = i == pointArr.count - 1;

                if (self.config.showMaxMinPointTip && pointModel.isFocal) {
                    [self addPointMaxMinTip:pointModel point:point isFirst:isFirst isLast:isLast];
                } else {
                    @try {
                        [self addPointNormalTip:pointModel point:point isFirst:isFirst isLast:isLast];
                    } @catch (NSException *exception) {
                        NSLog(@"exception = %@", exception);
                        @throw exception;
                    } @finally {
                        // 结果处理
                    };
                }
            }
        }
    }
}

/**
 * 添加突出点的 pointLabe
 */
- (void)addPointMaxMinTip:(MTFYChartPointModel *)pointModel
                    point:(CGPoint)point
                  isFirst:(BOOL)isFirst
                   isLast:(BOOL)isLast
{
    PointTipView *pointTipView = [[PointTipView alloc]initWithFrame:CGRectZero];
    pointTipView.backgroundColor = [UIColor redColor];
    [self addSubview:pointTipView];
    
    NSUInteger maxTypeStrLength = 4;
    NSString *typeStr = pointModel.pointTitle;
    if (typeStr.length > maxTypeStrLength) {
        typeStr = [typeStr substringToIndex:maxTypeStrLength];
    }
    
    CGFloat maxTypeStrW = 45.0, minTypeStrW = 32.0;
    CGFloat typeStrW = [typeStr mtfy_widthWithFont:pointTipView.typeLbl.font] + 5.0;
    typeStrW = typeStrW > maxTypeStrW ? maxTypeStrW : typeStrW;
    typeStrW = typeStrW < minTypeStrW ? minTypeStrW : typeStrW;

    // 点的最大半径
    CGFloat maxR = [self fetchMaxR];
    // 点边距
    CGFloat margin = (maxR && maxR < kMinRightLeftMargin) ? kMinRightLeftMargin : maxR;

    CGFloat w = typeStrW;
    CGFloat minusX = w * 0.5;
    if (isFirst) {
        minusX = margin;
    } else if (isLast) {
        minusX = w - margin - 1;
    }

    pointTipView.x = point.x - (minusX);
    pointTipView.y = point.y - (maxR + 4.0) - w;
    pointTipView.width = w;
    pointTipView.height = w;

    CGFloat price = pointModel.value;
    NSString *priceStr = [NSString stringWithFormat:@"%.0lf", price];
    NSString *priceAllStr = [NSString stringWithFormat:@"%@%@", [MTFYUnitTool mtfy_priceUnitSymbol], priceStr];

    [pointTipView updateData:priceAllStr type:typeStr];
    pointTipView.backgroundColor = [UIColor redColor];
}


/**
 * 添加一般点的 pointLabel
 */
- (void)addPointNormalTip:(MTFYChartPointModel *)pointModel
                    point:(CGPoint)point
                  isFirst:(BOOL)isFirst
                   isLast:(BOOL)isLast
{
    TTLabel *pointTipLbl = [[TTLabel alloc] init];
    pointTipLbl.font = self.config.tipFont;
    pointTipLbl.textColor = self.config.tipColor;
    pointTipLbl.textAlignment = NSTextAlignmentCenter;
    pointTipLbl.verticalAlignment = VerticalAlignmentBottom;
    pointTipLbl.text = @"--";
    pointTipLbl.numberOfLines = 0;

    if (pointModel.isFocal) {
        pointTipLbl.font = self.config.focalPointLabelFont;
        pointTipLbl.textColor = self.config.focalPointLabelColor;
    }
    
    [self addSubview:pointTipLbl];

    NSString *typeStr = [NSString stringWithFormat:@"%@", pointModel.pointTitle];

    if (![NSString isEmpty:typeStr]) {
        pointTipLbl.text = typeStr;
    }
    
    CGFloat typeStrW = [pointTipLbl.text mtfy_widthWithFont:pointTipLbl.font];
    typeStrW = typeStrW > 45.0 ? 45.0 : typeStrW;
    
    CGFloat typeStrH = 35.0;

    // 点的最大半径
    CGFloat maxR = [self fetchMaxR];
    // 点边距
    CGFloat margin = (maxR && maxR < kMinRightLeftMargin) ? kMinRightLeftMargin : maxR;

    CGFloat w = typeStrW;
    CGFloat minusX = w * 0.5;
    minusX = isFirst ? margin : minusX;
    minusX = isLast ? w - margin - 1.0 : minusX;
    
    pointTipLbl.x = point.x - (minusX);
    pointTipLbl.y = point.y - maxR - typeStrH;
    pointTipLbl.width = w;
    pointTipLbl.height = typeStrH;
}

#pragma mark Helper

- (NSString *)decimalWithFormat:(NSString *)format floatV:(float)floatV {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:format];
    return [numberFormatter stringFromNumber:@(floatV)];
}

/// 获取最小值的点半径
- (CGFloat)fetchMinPointR:(NSArray<MTFYChartPointModel *> *)pointArray {
    BOOL isMinFocal = NO;
    for (MTFYChartPointModel *model in pointArray) {
        if (model.isMin) {
            isMinFocal = model.isFocal;
        }
    }
    return isMinFocal ? self.config.pointRadius + self.config.pointLineWidth : self.config.focalPointRadius + self.config.focalPointLineWidth;
}

/// 获取点数据中最大点半径
- (CGFloat)fetchMaxR {
    CGFloat r1 = self.config.focalPointRadius + self.config.focalPointLineWidth * 0.5;
    CGFloat r2 = self.config.pointRadius + self.config.pointLineWidth * 0.5;
    return MAX(r1, r2);
}


/// 获取左边点边距
- (CGFloat)fetchLeftMargin {
//    CGFloat maxR = [self fetchMaxR];
//    return (maxR && maxR < kMinRightLeftMargin) ? kMinRightLeftMargin : maxR;
    return [self fetchMaxR] + kMinRightLeftMargin;
}

/// 获取右点边距
- (CGFloat)fetchRightMargin {
    return [self fetchLeftMargin];
}

/// 点间距
- (CGFloat)fetchPointGap:(NSArray<MTFYChartPointModel *> *)pointArr {
    // 配置里有值, 则取配置的值
    if (self.config.pointGap) {
        return self.config.pointGap;
    }
    
    // 点边距
    CGFloat margin = [self fetchLeftMargin];
    // 左右边距
    CGFloat left = margin, right = margin;
    // 点间距
    CGFloat pointGap = 0;
    if (pointArr.count > 1) {
        pointGap = (self.width - left - right) / (pointArr.count - 1);
    }
    return pointGap;
}

/// 获取点半径
- (CGFloat)fetchRadiusWithPoint:(MTFYChartPointModel *)point {
    return point.isFocal ? self.config.focalPointRadius : self.config.pointRadius;
}

#pragma mark - Getters and Setters
- (NSMutableArray *)pointButtonArray {
    if (!_pointButtonArray) {
        _pointButtonArray = [NSMutableArray array];
    }
    return _pointButtonArray;
}

- (NSMutableArray *)titleLabelArray {
    if (!_titleLabelArray) {
        _titleLabelArray = [NSMutableArray array];
    }
    return _titleLabelArray;
}

- (NSMutableArray *)buttonPointArray {
    if (!_buttonPointArray) {
        _buttonPointArray = [NSMutableArray array];
    }
    return _buttonPointArray;
}

- (CAShapeLayer *)pointLayer {
    if (!_pointLayer) {
        _pointLayer = [CAShapeLayer layer];
    }
    return _pointLayer;
}

- (CAShapeLayer *)pointBgLayer {
    if (!_pointBgLayer) {
        _pointBgLayer = [CAShapeLayer layer];
    }
    return _pointBgLayer;
}

- (CAShapeLayer *)pointFocalLayer {
    if (!_pointFocalLayer) {
        _pointFocalLayer = [CAShapeLayer layer];
    }
    return _pointFocalLayer;
}


#pragma mark - Supperclass

#pragma mark - NSObject

@end


@interface PointTipView ()


@end


@implementation PointTipView

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.backgroundColor = UIColor.whiteColor;
    self.clipsToBounds = YES;
    
    CGFloat radius = 4.0;
    self.layer.cornerRadius = radius;
    self.layer.borderColor = [UIColor mtfyLightBlueColor16D9D9].CGColor;
    self.layer.borderWidth = 1.0;
 
    [self setupSubView];
}

- (void)setupSubView {
    [self addSubview:self.priceLbl];
    [self addSubview:self.typeLbl];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.5);
    }];
    
    [self.typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceLbl.mas_bottom);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
}

#pragma mark - Public
- (void)updateData:(NSString *)priceStr type:(NSString *)typeStr {
    if (![NSString isEmpty:priceStr]) {
        self.priceLbl.text = priceStr;
        [self.priceLbl mtfy_addAttributesLineOffset:-1.0];
    }
    
    if (![NSString isEmpty:typeStr]) {
        self.typeLbl.text = typeStr;
    }
}

#pragma mark - Event Respone

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Getters and Setters

- (UILabel *)priceLbl {
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc] init];
        _priceLbl.text = @"--";
        _priceLbl.font = [UIFont simplonBPBold:11.0];//MF-YuanHeiNoncommercial-Regular
        _priceLbl.textColor = [UIColor whiteColor];
        _priceLbl.backgroundColor = [UIColor mtfyLightBlueColor16D9D9];
        _priceLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLbl;
}

- (UILabel *)typeLbl {
    if (!_typeLbl) {
        _typeLbl = [[UILabel alloc] init];
        _typeLbl.text = @"--";
        _typeLbl.font = [UIFont pingFangSCRegular:11.0];
        _typeLbl.textColor = [UIColor mtfyLightBlueColor16D9D9];
        _typeLbl.backgroundColor = [UIColor clearColor];
        _typeLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _typeLbl;
}

#pragma mark - Supperclass

#pragma mark - NSObject

@end
