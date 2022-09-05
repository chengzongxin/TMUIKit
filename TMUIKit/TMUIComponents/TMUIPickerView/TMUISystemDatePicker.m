//
//  TMUISystemDatePicker.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/4/15.
//

#import "TMUISystemDatePicker.h"

@implementation TMUISystemDatePicker

- (instancetype)initWithConfig:(TMUIPickerViewConfig *)config{
    self = [super init];
    if (self) {
        // iOS 14系统下 UIDatePicker 出现问题及解决方案
        // 选择器不居中，需要设置style https://zhuanlan.zhihu.com/p/390043895
        if (@available(iOS 13.4, *)) {
            self.preferredDatePickerStyle = UIDatePickerStyleWheels;
        } else {

        }
        self.date = config.date;
        self.datePickerMode = (UIDatePickerMode)config.datePickerMode;
        self.minimumDate = config.minimumDate;
        self.maximumDate = config.maximumDate;
        self.minuteInterval = config.minuteInterval ?: 1;
    }
    return self;
}

- (void)didInitializePicker{
    
}

- (NSDate *)selectedDate{
    return self.date;
}

@end
