//
//  TMUICustomDatePicker.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/4/12.
//

#import <UIKit/UIKit.h>
#import "TMUIPicker.h"
NS_ASSUME_NONNULL_BEGIN

@class TMUICustomDatePicker;
@protocol TMUICustomDatePickerDelegate<NSObject>

- (void)datePickerDidChanged:(TMUICustomDatePicker *_Nonnull)picker;

@end

@interface TMUICustomDatePicker : UIPickerView <UIPickerViewDataSource,UIPickerViewDelegate,TMUIPickerProtocol>

@property (nonatomic) TMUIDatePickerMode datePickerMode; // default is TMUIDatePickerMode_YearMonthDay

@property (nonatomic, strong) NSDate *date;        // default is current date when picker created. Ignored in countdown timer mode. for that mode, picker starts at 0:00
@property (nullable, nonatomic, strong) NSDate *minimumDate; // specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
@property (nullable, nonatomic, strong) NSDate *maximumDate; // default is nil

@property (nonatomic) NSInteger      minuteInterval;    // display minutes wheel with interval. interval must be evenly divided into 60. default is 1. min is 1, max is 30

@property (nonatomic, weak) id<TMUICustomDatePickerDelegate> changedDelegate;

@end

NS_ASSUME_NONNULL_END
