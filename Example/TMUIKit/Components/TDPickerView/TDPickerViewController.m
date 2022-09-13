//
//  TDPickerViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2022/4/12.
//  Copyright © 2022 chengzongxin. All rights reserved.
//

#import "TDPickerViewController.h"

@interface THKDateModel :NSObject

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, copy) NSString* value;
@property (nonatomic, copy) NSArray<THKDateModel*>* childs;

@end

@implementation THKDateModel
@end

@interface TDPickerViewController ()
@property (strong, nonatomic) NSDateFormatter * dateFormatter;

@property (nonatomic, assign) NSInteger monthIndex;
@property (nonatomic, assign) NSInteger dayIndex;
@property (nonatomic, assign) NSInteger hourIndex;
@property (nonatomic, assign) NSInteger minuteIndex;
@property (nonatomic, copy) NSArray<THKDateModel*>* monthArray;

@end

@implementation TDPickerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bgColor(UIColor.whiteColor);
    
    id s1 = TMUIExampleConfiguration.sharedInstance.body;
    
    id l1 = Label.str(@"TMUIPickerView 单列选择器").styles(s1);
    id b1 = Button.str(@"城市选择").styles(button).fixWH(300,44).onClick(SEL_STRING(showSingleColumnPicker));
    
    id l2 = Label.str(@"TMUIPickerView 多列选择 ").styles(s1);
    id b2 = Button.str(@"多列城市选择").styles(button).fixWH(300,44).onClick(SEL_STRING(showMultiColumnPicker));
    
    id l3 = Label.str(@"TMUIPickerView 多列选择,有级联效果concatenation ").styles(s1);
    id b3 = Button.str(@"两列城市选择-级联效果").styles(button).fixWH(300,44).onClick(SEL_STRING(showConcatenationMultiPicker));
    
    id l4 = Label.str(@"TMUIPickerView 时间选择器,包含3种样式 (系统产生数据，需要设定最小最大日期)").styles(s1).lineGap(3);
    id b4_1 = Button.str(@"时-分-AM/PM").styles(button).fixWH(100,44).onClick(^{[self showDatePicker:0];}).multiline.fnt(12);
    id b4_2 = Button.str(@"月-日-年").styles(button).fixWH(100,44).onClick(^{[self showDatePicker:1];}).multiline.fnt(12);
    id b4_3 = Button.str(@"星期-月-日-时-分-AM/PM").styles(button).fixWH(100,44).onClick(^{[self showDatePicker:2];}).multiline.fnt(12);
    id b4_4 = Button.str(@"分-秒").styles(button).fixWH(100,44).onClick(^{[self showDatePicker:3];}).multiline.fnt(12);
    id b4_5 = Button.str(@"年-月-日").styles(button).fixWH(100,44).onClick(^{[self showDatePicker:4];}).multiline.fnt(12);
    id b4_6 = Button.str(@"年-月").styles(button).fixWH(100,44).onClick(^{[self showDatePicker:5];}).multiline.fnt(12);
    
    id l5 = Label.str(@"TMUIPickerView 自定义样式时间选择器").styles(s1);
    id b5 = Button.str(@"多项时间选择器").styles(button).fixWH(300,44).onClick(SEL_STRING(showMultiDatePicker));
    
    VerStack(l1,
             b1,
             @40,
             l2,
             b2,
             @40,
             l3,
             b3,
             @40,
             l4,
             HorStack(b4_1,b4_2,b4_3).gap(20),
             HorStack(b4_4,b4_5,b4_6).gap(20),
             @40,
             l5,
             b5,
             CUISpring)
    .gap(15)
    .embedIn(self.view,NavigationContentTop+20,20,0);
    
}

- (void)showSingleColumnPicker{
    [TMUIPickerView showSinglePickerWithConfigBlock:^(TMUIPickerViewConfig * _Nonnull config) {
        config.title = @"单个城市选择";
        config.defautRows = @[[TMUIPickerIndexPath indexPathForRow:3 inComponent:0]];
    } texts:[self provinces] selectBlock:^(NSInteger idx, NSString * _Nonnull text) {
        TMUITipsText(text);
    }];
}

/// MARK: demo 1
- (void)showMultiColumnPicker{
    [TMUIPickerView showPickerWithConfigBlock:^(TMUIPickerViewConfig * _Nonnull config) {
        config.title = @"多个城市选择";
        config.defautRows = @[[TMUIPickerIndexPath indexPathForRow:1 inComponent:0],
                              [TMUIPickerIndexPath indexPathForRow:3 inComponent:1],
                              [TMUIPickerIndexPath indexPathForRow:2 inComponent:2],
                              [TMUIPickerIndexPath indexPathForRow:4 inComponent:3]];
    } numberOfColumnsBlock:^NSInteger(UIPickerView * _Nonnull pickerView) {
        return [self provinces].count;
    } numberOfRowsBlock:^NSInteger(UIPickerView * _Nonnull pickerView, NSInteger columnIndex, NSArray<NSNumber *> * _Nonnull selectRows) {
        return [self citiesInProvinceIndex:columnIndex].count;
    } scrollToRowBlock:^(UIPickerView * _Nonnull pickerView, NSInteger columnIndex, NSInteger rowIndex, NSArray<NSNumber *> * _Nonnull selectRows) {
        
    } textForRowBlock:^NSString * _Nullable(UIPickerView * _Nonnull pickerView, NSInteger columnIndex, NSInteger rowIndex, NSArray<NSNumber *> * _Nonnull selectRows) {
        return [self citiesInProvinceIndex:columnIndex][rowIndex];
    } selectRowBlock:^(NSArray<TMUIPickerIndexPath *> * _Nonnull indexPaths, NSArray<NSString *> * _Nonnull texts) {
        NSLog(@"%@====%@",indexPaths,texts);
        TMUITipsText([texts componentsJoinedByString:@"-"]);
    }];
}

- (NSArray *)provinces{
    return @[@"北京",@"上海",@"广州",@"深圳"];
}

- (NSArray *)citiesInProvinceIndex:(NSInteger)index{
    return [@[@[@"北京1",@"北京2",@"北京3",@"北京4",@"北京5"],
             @[@"上海1",@"上海2",@"上海3",@"上海4",@"上海5"],
             @[@"广州1",@"广州2",@"广州3",@"广州4",@"广州5"],
             @[@"深圳1",@"深圳2",@"深圳3",@"深圳4",@"深圳5"]] objectAtIndex:index];
}

- (void)showConcatenationMultiPicker{
    
    NSArray *provinces = [self provinces];
    [TMUIPickerView showPickerWithConfigBlock:^(TMUIPickerViewConfig * _Nonnull config) {
        config.title = @"城市级联选择";
        config.type = TMUIPickerViewType_MultiColumnConcatenation;
        config.defautRows = @[[TMUIPickerIndexPath indexPathForRow:3 inComponent:0],
                              [TMUIPickerIndexPath indexPathForRow:2 inComponent:1]];
    } numberOfColumnsBlock:^NSInteger(UIPickerView * _Nonnull pickerView) {
        return 2;
    } numberOfRowsBlock:^NSInteger(UIPickerView * _Nonnull pickerView, NSInteger columnIndex, NSArray<NSNumber *> * _Nonnull selectRows) {
        if (columnIndex == 0) {
            return provinces.count;
        }else{
            return [self citiesInProvinceIndex:columnIndex].count;
        }
    } scrollToRowBlock:^(UIPickerView * _Nonnull pickerView, NSInteger columnIndex, NSInteger rowIndex, NSArray<NSNumber *> * _Nonnull selectRows) {
        if (columnIndex == 0) {
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
        }
    } textForRowBlock:^NSString * _Nullable(UIPickerView * _Nonnull pickerView, NSInteger columnIndex, NSInteger rowIndex, NSArray<NSNumber *> * _Nonnull selectRows) {
        if (columnIndex == 0) {
            return provinces[rowIndex];
        }else{
            return [self citiesInProvinceIndex:selectRows.firstObject.intValue][rowIndex];
        }
    } selectRowBlock:^(NSArray<TMUIPickerIndexPath *> * _Nonnull indexPaths, NSArray<NSString *> * _Nonnull texts) {
        NSLog(@"%@====%@",indexPaths,texts);
        TMUITipsText([texts componentsJoinedByString:@"-"]);
    }];
    
    [self showConcatenationMultiPicker1];
}

- (NSInteger)daysfromYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSInteger num_year  = year;
    NSInteger num_month = month;
    
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    switch (num_month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:{
            
            return 31;
        }
        case 4:case 6:case 9:case 11:{
           
            return 30;
        }
        case 2:{
            if (isrunNian) {
               
                return 29;
            }else{
               
                return 28;
            }
        }
        default:
            break;
    }
    return 0;
}
- (void)showConcatenationMultiPicker1{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitMinute;

    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSinceNow:300]];

    NSInteger year = [components year];  //当前的年份

    NSInteger month = [components month];  //当前的月份

    NSInteger day = [components day];  // 当前的天数
    NSInteger hour = [components hour];  // 当前的天数
    NSInteger minute = [components minute];  // 当前的天数

    minute = minute - minute % 5;
    NSMutableArray<THKDateModel*> *monthArray = [[NSMutableArray alloc] initWithCapacity:12];

    NSMutableArray<THKDateModel*> *minuteArray = [[NSMutableArray alloc] initWithCapacity:13];
    for (int m = 0; m < 60; m+=5) {
        THKDateModel *minuteModel = [[THKDateModel alloc] init];
        minuteModel.value = [NSString stringWithFormat:@"%02ld分",(long)m];
        [minuteArray addObject:minuteModel];
    }

    NSMutableArray<THKDateModel*> *hourArray = [[NSMutableArray alloc] initWithCapacity:60];
    for (int h = 0; h <= 23; h++) {
        THKDateModel *model = [[THKDateModel alloc] init];
        model.value = [NSString stringWithFormat:@"%02ld点",(long)h];
        model.childs = minuteArray;
        [hourArray addObject:model];
    }

    for (NSInteger i = month; monthArray.count < 12; i++) {
        if (i > 12) {
            i = 1;
            year++;
        }
        THKDateModel *model = [[THKDateModel alloc] init];
        model.value = [NSString stringWithFormat:@"%02ld月",(long)i];
        model.year = year;
        NSInteger days = [self daysfromYear:year andMonth:i];
        NSMutableArray *dayArray = [[NSMutableArray alloc] initWithCapacity:days];
        
        NSInteger dd = 1;
        if (i == month) {
            dd = day;
        }
        
        for (NSInteger d = dd; d <= days; d++) {
            THKDateModel *dayModel = [[THKDateModel alloc] init];
            dayModel.value = [NSString stringWithFormat:@"%02ld日",(long)d];
            if (i == month && d == day) {
                NSArray<THKDateModel*> *curHours = [hourArray subarrayWithRange:NSMakeRange(hour, hourArray.count - hour)];
                if (curHours.count > 0) {
                    THKDateModel *curHour = curHours.firstObject;
                    
                    NSArray<THKDateModel*> *curMinutes = [curHour.childs subarrayWithRange:NSMakeRange(minute/5, curHour.childs.count - minute/5)];
                    if (curMinutes.count > 0) {
                        curHour.childs = curMinutes;
                    }
                }
                
                dayModel.childs = curHours;
            }else{
                dayModel.childs = hourArray;
            }
            [dayArray addObject:dayModel];
        }
        model.childs = dayArray;
        [monthArray addObject:model];
    }
    self.monthArray = monthArray;
//    [TMUIPickerView showPickerWithConfigBlock:^(TMUIPickerViewConfig * _Nonnull config) {
//        config.title = @"请选择时间";
//        config.type = TMUIPickerViewType_MultiColumnConcatenation;
//        config.defautRows = @[[TMUIPickerIndexPath indexPathForRow:12 inComponent:0],
//                              [TMUIPickerIndexPath indexPathForRow:1 inComponent:0],
//                              [TMUIPickerIndexPath indexPathForRow:1 inComponent:0],
//                              [TMUIPickerIndexPath indexPathForRow:1 inComponent:0]];
//        config.scrollRowBlock = ^(UIPickerView * _Nonnull pickView, NSInteger rowIndex, NSInteger columnIndex) {
//            switch(columnIndex){
//
//                case 0:{
//                    self.monthIndex = rowIndex;
//                    [pickView reloadComponent:1];
//                    [pickView reloadComponent:2];
//                    [pickView reloadComponent:3];
//                }break;
//                case 1:{
//                    self.dayIndex = rowIndex;
//
//                    [pickView reloadComponent:2];
//                    [pickView reloadComponent:3];
//                }break;
//                case 2:{
//                    self.hourIndex = rowIndex;
//                    [pickView reloadComponent:3];
//                }break;
//                case 3:{
//                    self.minuteIndex = rowIndex;
//                }break;
//            }
//        };
//    } numberOfColumnsBlock:^NSInteger{
//        return 4;
//    } numberOfRowsBlock:^NSInteger(NSInteger columnIndex, NSInteger curSelectedColumn1Row) {
//
//        switch(columnIndex){
//
//            case 0:{
//                return 12;
//            }break;
//            case 1:{
//
//                return monthArray[self.monthIndex].childs.count;
//            }break;
//            case 2:{
//                if (self.dayIndex >= monthArray[self.monthIndex].childs.count ) {
//                    self.dayIndex = monthArray[self.monthIndex].childs.count -1;
//                }
//                return monthArray[self.monthIndex].childs[self.dayIndex].childs.count;
//            }break;
//            case 3:{
//
//                if (self.dayIndex >= monthArray[self.monthIndex].childs.count ) {
//                    self.dayIndex = monthArray[self.monthIndex].childs.count -1;
//                }
//                if (self.hourIndex >= monthArray[self.monthIndex].childs[self.dayIndex].childs.count ) {
//                    self.hourIndex = monthArray[self.monthIndex].childs[self.dayIndex].childs.count -1;
//                }
//                return monthArray[self.monthIndex].childs[self.dayIndex].childs[self.hourIndex].childs.count;
//            }break;
//        }
//        return 10;
//    } textForRowBlock:^NSString * _Nullable(NSInteger columnIndex, NSInteger rowIndex, NSInteger curSelectedColumn1Row) {
//
////            NSLog(@"row =======  %d,%d,%d",columnIndex,rowIndex,self.monthIndex);
//        switch(columnIndex){
//            case 0:{
//                return monthArray[rowIndex].value;
//            }break;
//            case 1:{
//                return monthArray[self.monthIndex].childs[rowIndex].value;
//            }break;
//            case 2:{
//                return monthArray[self.monthIndex].childs[self.dayIndex].childs[rowIndex].value;
//            }break;
//            case 3:{
//                return monthArray[self.monthIndex].childs[self.dayIndex].childs[self.hourIndex].childs[rowIndex].value;
//            }break;
//        }
//        return @"";
//    } selectRowBlock:^(NSArray<NSIndexPath *> * _Nonnull indexPaths, NSArray<NSString *> * _Nonnull texts) {
//        NSLog(@"%@====%@",indexPaths,texts);
//        THKDateModel *month = monthArray[self.monthIndex];
//        NSMutableString *value = [[NSMutableString alloc] initWithFormat:@"%ld-",month.year];
//        [value appendString:[texts componentsJoinedByString:@"-"]];
//        NSString *result = [value stringByReplacingOccurrencesOfString:@"月" withString:@""];
//        result = [result stringByReplacingOccurrencesOfString:@"日-" withString:@" "];
//        result = [result stringByReplacingOccurrencesOfString:@"点-" withString:@":"];
//        result = [result stringByReplacingOccurrencesOfString:@"分" withString:@""];
//        TMUITipsText(result);
//    }];

}

/// MARK: demo 3,4,5
- (void)showDatePicker:(TMUIDatePickerMode)mode{
//    UIDatePickerMode = 0,       ///< 时-分-AM/PM
//    UIDatePickerMode = 1,       ///< 月-日-年
//    UIDatePickerMode = 2,       ///< 星期-月-日-时-分-AM/PM
    [TMUIPickerView showDatePickerWithConfigBlock:^(TMUIPickerViewConfig * _Nonnull config) {
        config.title = @"时间选择";
        config.datePickerMode = (TMUIDatePickerMode)mode;
        config.minimumDate = [NSDate.date tmui_dateByAddingYears:-3];
        config.maximumDate = [NSDate.date tmui_dateByAddingYears:3];
//        config.date = [NSDate.date tmui_dateByAddingMonths:3];
//        config.minuteInterval = 10;
    } selectDateBlock:^(NSDate * _Nonnull date) {
        [TMUITips showWithText:[date tmui_stringWithISOFormat]];
    }];
}

/// MARK: demo 6
- (void)showMultiDatePicker{
    [TMUIPickerView showMultiDatePickerWithConfigBlock:^(TMUIPickerViewConfig * _Nonnull config) {
        
    } selectDateBlock:^(TMUIMultiDatePickerResult * _Nonnull result) {
        [TMUITips showWithText:[NSString stringWithFormat:@"%d-%@-%@-%@",result.type,result.monthDate,result.dayDateBegin,result.dayDateEnd]];
    }];
}


- (NSArray *)multiColumn:(NSInteger)columnIndex{
    
    switch (columnIndex) {
        case 0:
            return @[@"厨房",@"卧室",@"客厅",@"卫生间"];
            break;
        case 1:
            return @[@"准备开工",@"开工中",@"入住"];
            break;
        case 2:
            return @[@"木质",@"大理石",@"磨砂",@"玻璃"];
            break;
        case 3:
            return @[@"张三",@"李四",@"王五",@"孙六"];
            break;
            
        default:
            break;
    }
    
    NSMutableArray *array = NSMutableArray.array;
    for (int i = 0; i < 5; i++) {
        [array addObject:Str(columnIndex)];
    }
    return array;
}



-(NSArray<THKDateModel*>*)currentDayArray{
    if (self.monthIndex >= self.monthArray.count) {
        self.monthIndex = self.monthArray.count - 1;
    }
    return self.monthArray[self.monthIndex].childs;
}

-(NSArray<THKDateModel*>*)currentHourArray{
    if (self.dayIndex >= [self currentDayArray].count) {
        self.dayIndex = [self currentDayArray].count - 1;
    }
    return [self currentDayArray][self.dayIndex].childs;
}

-(NSArray<THKDateModel*>*)currentMinuteArray{
    if (self.hourIndex >= [self currentHourArray].count) {
        self.hourIndex = [self currentHourArray].count - 1;
    }
    return [self currentHourArray][self.hourIndex].childs;
}

@end
