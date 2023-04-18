//
//  TMUICustomDatePicker.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/4/12.
//

#import "TMUICustomDatePicker.h"
#import <TMUICore/TMUICommonDefines.h>
#import <TMUICore/TMUIKitDefines.h>
#import <TMUIExtensions/TMUIExtensions.h>

@interface TMUICustomDatePicker ()

@property (nonatomic, strong)NSArray<NSNumber*> *years;
@property (nonatomic, strong)NSArray<NSNumber*> *days;

@property (nonatomic, strong)NSCalendar *calendar;
@property (nonatomic, strong)NSDateFormatter *dateFormatter;
@end

@implementation TMUICustomDatePicker

- (instancetype)initWithConfig:(TMUIPickerViewConfig *)config{
    self = [super init];
    if (self) {
        _datePickerMode = (TMUIDatePickerMode)config.datePickerMode;
        _minimumDate = config.minimumDate;
        _maximumDate = config.maximumDate;
        _minuteInterval = config.minuteInterval ?: 1;
        _date = config.date;
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)didInitializePicker{
    [self reloadUIWithAnimate:NO];
}


- (void)setDate:(NSDate *)date{
    _date = date;
    [self reloadUIWithAnimate:NO];
}

// if animated is YES, animate the wheels of time to display the new date
- (void)setDate:(NSDate *)date animated:(BOOL)animated{
    _date = date;
    [self reloadUIWithAnimate:animated];
}

- (void)setDatePickerMode:(TMUIDatePickerMode)datePickerMode{
    _datePickerMode = datePickerMode;
    [self reloadUIWithAnimate:NO];
}


- (void)reloadUIWithAnimate:(BOOL)animate{
    self.years = [self getYears];
    self.days = [self getDaysInMonth:_date];
    
    NSDateComponents* componentsThis = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:_date?:[NSDate date]]; //  这里兜底一个现在时间，否则会有错误提示
    NSInteger rowIndex0 = [self.years count]-1;
    for (NSInteger i = self.years.count - 1; i >= 0; --i) {
        if ([self.years[i] intValue] == componentsThis.year) {
            rowIndex0 = i;
            break;
        }
    }

    [self reloadAllComponents];
    
    if (rowIndex0>=0 && rowIndex0 < [self numberOfRowsInComponent:0]) {
        [self selectRow:rowIndex0 inComponent:0 animated:NO];
        [self reloadComponent:0];
    } else {
        //self.hidden = YES;
        return;
    }
    
    NSInteger rowIndex1 = componentsThis.month-1;
    if (rowIndex1>=0 && self.numberOfComponents > 1 && rowIndex1 < [self numberOfRowsInComponent:1]) {
        [self selectRow:rowIndex1 inComponent:1 animated:NO];
        [self reloadComponent:1];
    }
    
    if (self.datePickerMode == TMUIDatePickerMode_YearMonthDay) {
        NSInteger rowIndex2 = componentsThis.day-1;
        if (rowIndex2>=0 && self.numberOfComponents > 2 && rowIndex2 < [self numberOfRowsInComponent:2]) {
            [self selectRow:rowIndex2 inComponent:2 animated:NO];
            [self reloadComponent:2];
        }
    }
}


#pragma mark - picker delegate & datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.datePickerMode == TMUIDatePickerMode_Year) {
        return 1;
    }
    return self.datePickerMode == TMUIDatePickerMode_YearMonth ? 2 : 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.years.count;
    }else if (component == 1) {
        return (self.years.count == 0 || self.days.count == 0)?0:12;
    }else if (component == 2) {
        return self.days.count;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 42;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *lbl = (UILabel *)view;
    if (![lbl isKindOfClass:UILabel.class]) {
        lbl = [[UILabel alloc] init];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = UIColorHexString(@"0x333333");
        lbl.font = UIFont(18);
    }
    
    NSString *text = @"";
    if (component == 0) {
        text = [NSString stringWithFormat:@"%d年", [self.years[row] intValue]];
    }else if (component == 1) {
        text = [NSString stringWithFormat:@"%02d月", (int)(row+1)];
    }else if (component == 2) {
        text = [NSString stringWithFormat:@"%d日", [self.days[row] intValue]];
    }
    
    lbl.text = text;
    
    return lbl;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    NSInteger day = 1;
//    NSInteger yearIndex = [pickerView selectedRowInComponent:0];
//    yearIndex = MAX(0, yearIndex);
//    NSInteger year = [self.years[yearIndex] intValue];
//    NSInteger monthIndex = [pickerView selectedRowInComponent:1];
//    monthIndex = MAX(0, monthIndex);
//    NSInteger month = monthIndex+1;
    
    NSInteger day = 1;
    NSInteger month = 1;
    if ([pickerView numberOfComponents] == 0) {
        return;
    }
    NSInteger yearIndex = [pickerView selectedRowInComponent:0];
    yearIndex = MAX(0, yearIndex);
    NSInteger year = [self.years[yearIndex] intValue];
    BOOL hasMonth = self.datePickerMode == TMUIDatePickerMode_YearMonthDay || self.datePickerMode == TMUIDatePickerMode_YearMonth;
    if (hasMonth) {
        NSInteger monthIndex = [pickerView selectedRowInComponent:1];
        monthIndex = MAX(0, monthIndex);
        month = monthIndex+1;
    }
    
    BOOL needReloadMonthComponent = NO;
    NSDateComponents* componentsMin = nil;
    if (self.minimumDate) {
        //选择不能早于设定的最小值
        componentsMin = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.minimumDate];
        int tYear = [self.years[yearIndex] intValue];
        tYear = MAX((int)componentsMin.year, tYear);
        year = tYear;
        
        if (year == componentsMin.year) {
            //若最小值年与选择相同则判断月是否早于最小值对应的月份
            if (hasMonth && month < componentsMin.month) {
                needReloadMonthComponent = YES;
                month = componentsMin.month;
                [pickerView selectRow:(month-1) inComponent:1 animated:YES];
            }
        }
    }
    
    NSDateComponents* componentsMax = nil;
    if (self.maximumDate) {
        componentsMax = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.maximumDate];
        int tYear = [self.years[yearIndex] intValue];
        tYear = MIN((int)componentsMax.year, tYear);
        year = tYear;
        
        if (year == componentsMax.year) {
            if (hasMonth && month > componentsMax.month) {
                needReloadMonthComponent = YES;
                month = componentsMax.month;
                [pickerView selectRow:(month-1) inComponent:1 animated:YES];
            }
        }
    }
    
    if (self.datePickerMode == TMUIDatePickerMode_YearMonthDay) {
        NSInteger dayIndex = [pickerView selectedRowInComponent:2];
        dayIndex = MAX(0, dayIndex);
        day = [self.days[dayIndex] intValue];
        
        NSDate *date = [self convertToDateDay:1 month:month year:year];
        NSArray<NSNumber*> *days = [self getDaysInMonth:date];
        self.days = days;
        [pickerView reloadComponent:2];
        int toNewDay = -1;
        if (day > self.days.count) {
            day = [[self.days lastObject] intValue];
            toNewDay = (int)day;
        }
        if (componentsMin &&
            year == componentsMin.year &&
            month == componentsMin.month &&
            day < componentsMin.day) {
            toNewDay = (int)componentsMin.day;
            day = toNewDay;
        }
        if (componentsMax &&
            year == componentsMax.year &&
            month == componentsMax.month &&
            day > componentsMax.day) {
            toNewDay = (int)componentsMax.day;
            day = toNewDay;
        }
        if (toNewDay > 0) {
            [pickerView selectRow:(toNewDay-1) inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
        }
    }
    
    NSDate *date = [self convertToDateDay:day month:month year:year];
    _date = date;
    if (self.changedDelegate && [self.changedDelegate respondsToSelector:@selector(datePickerDidChanged:)]) {
        [self.changedDelegate datePickerDidChanged:self];
    }
    
    //普通状态及选中状态颜色需要刷新
    [pickerView reloadComponent:component];
    
    if (needReloadMonthComponent) {
        if (component != 1) {
            [pickerView reloadComponent:1];
        }
    }
}


#pragma mark - Public

- (NSDate *)selectedDate{
    return self.date;
}

#pragma mark - Private


- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}

- (NSMutableArray<NSNumber*>*)getYears {
    NSMutableArray *years = [NSMutableArray array];
    NSInteger yearMin = 1971;
    
    if (self.minimumDate) {
        NSDate *maxDate = self.maximumDate ? self.maximumDate : [NSDate date];
        if (NSOrderedDescending == [self.minimumDate compare:maxDate]) {
            self.minimumDate = nil;
        }
    }
    if (self.minimumDate) {
        NSDateComponents* componentsMin = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.minimumDate];
        yearMin = [componentsMin year];
    }
    
    NSInteger yearMax = 0;
    NSDateComponents* componentsMax = nil;
    
    if (self.maximumDate) {
        componentsMax = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.maximumDate];
        yearMax = [componentsMax year];
    } else {
        componentsMax = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
        yearMax = [componentsMax year];
    }
    
    for (NSInteger i = yearMin; i <= yearMax; i++) {
        [years addObject:@(i)];
    }
    
    return years;
}

- (NSMutableArray<NSNumber*>*)getDaysInMonth:(NSDate*)date {
    if (date == nil) date = [NSDate date];
    NSRange daysRange = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSMutableArray *days = [NSMutableArray array];
    for (int i = 1; i <= daysRange.length; i++) {
        [days addObject:@(i)];
    }
    return days;
}

- (NSDate*)convertToDateDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year{
//    day = MAX(day, 1);
//    NSDateFormatter *dateFormatter = self.dateFormatter;
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    if (self.datePickerMode == TMUIDatePickerMode_YearMonth) {
//        day = 1;
//    }
//    NSString *dateString = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)year, (long)month, (long)day];
//    return [dateFormatter dateFromString:dateString];
    
    day = MAX(day, 1);
    day = MIN(day, 31);
    month = MAX(month, 1);
    month = MIN(month, 12);
    NSDateFormatter *dateFormatter = self.dateFormatter;
    //[dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = nil;
    if (self.datePickerMode == TMUIDatePickerMode_YearMonthDay) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        dateString = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)year, (long)month, (long)day];
    } else if (self.datePickerMode == TMUIDatePickerMode_YearMonth) {
        [dateFormatter setDateFormat:@"yyyy-MM"];
        dateString = [NSString stringWithFormat:@"%ld-%ld", (long)year, (long)month];
    } else if (self.datePickerMode == TMUIDatePickerMode_Year) {
        [dateFormatter setDateFormat:@"yyyy"];
        dateString = [NSString stringWithFormat:@"%ld", (long)year];
    }
    //NSString *dateString = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)year, (long)month, (long)day];
    return [dateFormatter dateFromString:dateString];
}

@end
