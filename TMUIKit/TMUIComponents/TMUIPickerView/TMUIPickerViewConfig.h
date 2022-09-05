//
//  TMUIPickerViewConfig.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/4/13.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TMUIPickerViewType) {
    TMUIPickerViewType_SingleColumn                         = 0,         /// 单列
    TMUIPickerViewType_MultiColumn                          = 1 << 0,    /// 多列
    TMUIPickerViewType_MultiColumnConcatenation             = 1 << 1,    /// 级联效果
    TMUIPickerViewType_Date                                 = 1 << 2,    /// 日期选择
};


typedef NS_ENUM(NSInteger, TMUIDatePickerMode) {
    TMUIDatePickerMode_Time,           // Displays hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. 6 | 53 | PM)
    TMUIDatePickerMode_Date,           // Displays month, day, and year depending on the locale setting (e.g. November | 15 | 2007)
    TMUIDatePickerMode_DateAndTime,    // Displays date, hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. Wed Nov 15 | 6 | 53 | PM)
    TMUIDatePickerMode_CountDownTimer, // Displays hour and minute (e.g. 1 | 53)
    TMUIDatePickerMode_YearMonthDay,   // Displays year, month, day (2022年 4月 15日)
    TMUIDatePickerMode_YearMonth,      // Displays year, month (2022年 4月)
    TMUIDatePickerMode_Year,  // 暂不支持
};


typedef NS_ENUM(int, TMUIMultiDatePickerViewControllerType) {
    TMUIMultiDatePickerViewControllerType_Month = 0,
    TMUIMultiDatePickerViewControllerType_Day,
};


// This category provides convenience methods to make it easier to use an TMUIPickerIndexPath to represent a component and row/item, for use with TMUIPicker.
@interface TMUIPickerIndexPath : NSObject

+ (instancetype)indexPathForRow:(NSInteger)row inComponent:(NSInteger)component;
+ (instancetype)indexPathForRow:(NSInteger)row inSection:(NSInteger)section;
+ (instancetype)indexPathForItem:(NSInteger)item inSection:(NSInteger)section;

// Returns the index at component 0.
@property (nonatomic, readonly) NSInteger component;
// Returns the index at component 1.
@property (nonatomic, readonly) NSInteger row;

@end


/// 多选择器回调结果数据
@interface TMUIMultiDatePickerResult : NSObject
@property (nonatomic, assign)TMUIMultiDatePickerViewControllerType type;///< 默认为Month
@property (nonatomic, strong)NSDate *monthDate;///< 年月日期值，当type为Month时取此值
@property (nonatomic, strong)NSDate *dayDateBegin;////< 起始日期值,当type为Day时取此值
@property (nonatomic, strong)NSDate *dayDateEnd;///< 结束日期值，当type为Day时取此值
@end



typedef void (^TMUIPickerForScrollRowBlock)(UIPickerView *pickView, NSInteger rowIndex,NSInteger columnIndex);
@interface TMUIPickerViewConfig : NSObject

#pragma mark - 通用方法

+ (instancetype)defaltConfig;

@property (nonatomic, assign) TMUIPickerViewType type;
/// 显示标题
@property (nonatomic, strong) NSString *title;
/// 单击背景空白视图j是否自动消失，默认为YES
@property (nonatomic, assign)BOOL autoDismissWhenTapBackground;

#pragma mark - 多列选择器

/// 默认选择行数
@property (nonatomic, strong) NSArray <TMUIPickerIndexPath *> *defautRows;


#pragma mark - 时间选择器

/// 选择器样式i
@property (nonatomic, assign) TMUIDatePickerMode datePickerMode;
/// 当前显示时间
@property (nonatomic, strong) NSDate *date;
/// 最小显示时间
@property (nullable, nonatomic, strong) NSDate *minimumDate;
/// 最大显示时间
@property (nullable, nonatomic, strong) NSDate *maximumDate;
/// 显示时间时，分钟显示的间隔，必须能把60整除
@property (nonatomic) NSInteger      minuteInterval;

#pragma mark - 多列时间选择器
/// 类型-按月选择 or 按日选择
@property (nonatomic, assign) TMUIMultiDatePickerViewControllerType multiDateType;
/// 月份
@property (nonatomic, strong)NSDate *monthDate;
/// 开始日期
@property (nonatomic, strong)NSDate *dayBeginDate;
/// 结束日期
@property (nonatomic, strong)NSDate *dayEndDate;


@property (nonatomic, copy) TMUIPickerForScrollRowBlock scrollRowBlock;
@end

NS_ASSUME_NONNULL_END
