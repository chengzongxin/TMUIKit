//
//  TDPickerViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2022/4/12.
//  Copyright © 2022 chengzongxin. All rights reserved.
//

#import "TDPickerViewController.h"

@interface TDPickerViewController ()
@property (strong, nonatomic) NSDateFormatter * dateFormatter;
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
    } numberOfColumnsBlock:^NSInteger{
        return [self provinces].count;
    } numberOfRowsBlock:^NSInteger(NSInteger columnIndex, NSInteger curSelectedColumn1Row) {
        return [self citiesInProvinceIndex:columnIndex].count;
    } textForRowBlock:^NSString * _Nullable(NSInteger columnIndex, NSInteger rowIndex, NSInteger curSelectedColumn1Row) {
        return [self citiesInProvinceIndex:columnIndex][rowIndex];
    } selectRowBlock:^(NSArray<NSIndexPath *> * _Nonnull indexPaths, NSArray<NSString *> * _Nonnull texts) {
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
    } numberOfColumnsBlock:^NSInteger{
        return 2;
    } numberOfRowsBlock:^NSInteger(NSInteger columnIndex, NSInteger curSelectedColumn1Row) {
        if (columnIndex == 0) {
            return provinces.count;
        }else{
            return [self citiesInProvinceIndex:curSelectedColumn1Row].count;
        }
    } textForRowBlock:^NSString * _Nullable(NSInteger columnIndex, NSInteger rowIndex, NSInteger curSelectedColumn1Row) {
        if (columnIndex == 0) {
            return provinces[rowIndex];
        }else{
            return [self citiesInProvinceIndex:curSelectedColumn1Row][rowIndex];
        }
    } selectRowBlock:^(NSArray<NSIndexPath *> * _Nonnull indexPaths, NSArray<NSString *> * _Nonnull texts) {
        NSLog(@"%@====%@",indexPaths,texts);
        TMUITipsText([texts componentsJoinedByString:@"-"]);
    }];
    
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

@end
