//
//  TMUIAlertViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/24.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUIAlertViewController.h"


@interface TMUIAlertViewController ()
@property (strong, nonatomic) NSDateFormatter * dateFormatter;
@end

@implementation TMUIAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bgColor(UIColor.whiteColor);
    
    id s1 = TMUIExampleConfiguration.sharedInstance.body;
    
    id l1 = Label.str(@"\nTMCityPicker 自定义城市选择 (数据需要自己构造)").styles(s1);
    id b1 = Button.str(@"城市选择").styles(button).fixWH(300,44).onClick(SEL_STRING(showCityPicker));
    
    id l2 = Label.str(@"\nTMCityPicker 自定义日期选择 (数据需要自己构造)").styles(s1);
    id b2 = Button.str(@"日期选择").styles(button).fixWH(300,44).onClick(SEL_STRING(showDatePicker));
    
    id l3 = Label.str(@"\nTMDatePicker 时间选择器,包含3种样式 (系统产生数据，需要设定最小最大日期)").styles(s1).lineGap(3);
    id b3 = Button.str(@"年-月-日").styles(button).fixWH(100,44).onClick(^{[self showDatePicker2:0];}).multiline.fnt(12);
    id b4 = Button.str(@"时-分-秒").styles(button).fixWH(100,44).onClick(^{[self showDatePicker2:1];}).multiline.fnt(12);
    id b5 = Button.str(@"年-月-日-时-分-秒").styles(button).fixWH(100,44).onClick(^{[self showDatePicker2:2];}).multiline.fnt(12);
    
    id l4 = Label.str(@"\nTMMultiDataPicker 多列选择器，多列之间没有联动效果").styles(s1);
    id b6 = Button.str(@"多列选择器").styles(button).fixWH(300,44).onClick(SEL_STRING(showMultiDatePicker));
    
    id l5 = Label.str(@"\nTMNormalPicker 普通选择器，适用于比较简单的场景").styles(s1);
    id b7 = Button.str(@"单列选择器").styles(button).fixWH(300,44).onClick(SEL_STRING(showNormalPicker));
    
    id l6 = Label.str(@"\nTDatePicker 也在项目中使用").styles(s1);
    
    VerStack(l1,
             b1,
             l2,
             b2,
             l3,
             HorStack(b3,b4,b5).gap(10),
             l4,
             b6,
             l5,
             b7,
             l6,
             CUISpring)
    .gap(15)
    .embedIn(self.view,NavigationContentTop+20,20,0);
    
}

/// MARK: demo 1
- (void)showCityPicker{
//    [TMCityPicker showPickerWithTitle:@"选择城市" provinceItemListBlock:^NSArray * _Nonnull{
//        return [self provinces];
//    } cityItemListAtProvinceBlock:^NSArray * _Nonnull(id  _Nonnull provinceItem, NSInteger provinceIndex) {
//        return [self citiesInProvinceIndex:provinceIndex];
//    } fetchShowStringForProvinceItem:^NSString * _Nonnull(id  _Nonnull provinceItem, NSInteger provinceIndex) {
//        return provinceItem;
//    } fetchShowStringForCityItem:^NSString * _Nonnull(id  _Nonnull cityItem, NSInteger cityIndex, id  _Nonnull inProvinceItem, NSInteger provinceIndex) {
//        return cityItem;
//    } finishSelectBlock:^(id  _Nonnull selectedProvinceItem, NSInteger selectedProvinceIndex, id  _Nonnull selectedCityItem, NSInteger selectedCityIndex) {
//        TMUITipsText(selectedCityItem);
//    } curProvinceItemIndex:0 curCityItemIndex:0 fromViewController:self];
    
    float h = 297 + tmui_safeAreaBottomInset();
    UIDatePicker *timerPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, TMUI_SCREEN_HEIGHT- h, TMUI_SCREEN_WIDTH, h)];
    timerPicker.datePickerMode = UIDatePickerModeDateAndTime;
    timerPicker.minuteInterval = 10;
    [self.view addSubview:timerPicker];
//    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, TMUI_SCREEN_HEIGHT, TMUI_SCREEN_WIDTH, h)];
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


/// MARK: demo 2
- (void)showDatePicker{
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy年";
    NSString * currentYear = [self.dateFormatter stringFromDate:[NSDate date]];
    NSArray * yearsArray = [self years];
    NSInteger yearIndex = [yearsArray indexOfObject:currentYear];
    NSInteger monthIndex = [[NSDate date] tmui_month] - 1;
    [TMCityPicker showPickerWithTitle:@"选择时间" provinceItemListBlock:^NSArray * _Nonnull{
        return yearsArray;
    } cityItemListAtProvinceBlock:^NSArray * _Nonnull(id  _Nonnull provinceItem, NSInteger provinceIndex) {
        return [self monthForYearIndex:provinceIndex total:yearsArray.count];
    } fetchShowStringForProvinceItem:^NSString * _Nonnull(id  _Nonnull provinceItem, NSInteger provinceIndex) {
        return provinceItem;
    } fetchShowStringForCityItem:^NSString * _Nonnull(id  _Nonnull cityItem, NSInteger cityIndex, id  _Nonnull inProvinceItem, NSInteger provinceIndex) {
        return cityItem;
    } finishSelectBlock:^(id  _Nonnull selectedProvinceItem, NSInteger selectedProvinceIndex, id  _Nonnull selectedCityItem, NSInteger selectedCityIndex) {
        NSString * dateStr = [NSString stringWithFormat:@"%@%@1日", selectedProvinceItem, selectedCityItem];
        self.dateFormatter.dateFormat = @"yyyy年M月d日";
        NSDate * selectedDate = [self.dateFormatter dateFromString:dateStr];
        [self updatePickBtnTitleWithDate:selectedDate];
    } curProvinceItemIndex:yearIndex curCityItemIndex:monthIndex fromViewController:self];
}


- (NSArray *)years
{
    self.dateFormatter.dateFormat = @"yyyy年";
    int i = 0;
    NSDate * date = [NSDate date];
    NSMutableArray * mutableArray = [NSMutableArray arrayWithCapacity:3];
    while (i++ <= 2) {
        NSString * dateStr = [self.dateFormatter stringFromDate:date];
        [mutableArray insertObject:dateStr atIndex:0];
        date = [date tmui_dateByAddingYears:-1];
    }
    return mutableArray.copy;
}

- (NSArray *)monthForYearIndex:(NSInteger)index total:(NSInteger)count
{
    if (index < count - 1) {
        return @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"];
    }
    else if (index == count - 1) {
        NSMutableArray * mutableArray = [NSMutableArray arrayWithCapacity:12];
        NSInteger month = [[NSDate date] tmui_month];
        do {
            NSString * monthStr = [NSString stringWithFormat:@"%zd月", month];
            [mutableArray insertObject:monthStr atIndex:0];
        } while (--month > 0);
        return mutableArray.copy;
    }
    return nil;
}

- (void)updatePickBtnTitleWithDate:(NSDate *)date
{
    self.dateFormatter.dateFormat = @"yyyy年MM月";
    NSString * dateStr = [self.dateFormatter stringFromDate:date];
//    [self.pickBtn setTitle:dateStr forState:UIControlStateNormal];
    [TMUITips showWithText:dateStr];
}

/// MARK: demo 3,4,5
- (void)showDatePicker2:(TMDatePickerMode)mode{
//    TMDatePickerModeDate = 0,       ///< 年-月-日
//    TMDatePickerModeTime,           ///< 时-分-秒
//    TMDatePickerModeDateAndTime,    ///< 年-月-日-时-分-秒
    [TMDatePicker showPickerWithTitle:@"日期选择样式：".a(mode+1) mode:mode limitMinDate:[NSDate.date tmui_dateByAddingYears:-3] limitMaxDate:NSDate.date currentDate:NSDate.date finishSelectBlock:^(NSDate * _Nonnull selectedDate) {
        [TMUITips showWithText:[selectedDate tmui_stringWithISOFormat]];
    } fromViewController:self];
}

/// MARK: demo 6
- (void)showMultiDatePicker{
    [TMMultiDataPicker showPickerWithTitle:@"多列选择器" numberOfColumnsBlock:^NSInteger{
        return 4;
    } itemListAtColumnBlock:^NSArray * _Nonnull(NSInteger columnIndex) {
        return [self multiColumn:columnIndex];
    } fetchShowStringFromItem:^NSString * _Nonnull(id  _Nonnull item, NSInteger columnIndex, NSInteger rowIndex) {
        return item;
    } finishSelectBlock:^(NSArray * _Nonnull selectedItems, NSArray<NSNumber *> * _Nonnull selectedRowIndexs) {
        NSLog(@"%@,%@",selectedItems,selectedRowIndexs);
//        Str(@"选择了")
         NSString *str1 = [selectedItems tmui_reduce:^id _Nonnull(id  _Nonnull accumulator, id  _Nonnull item) {
             return [NSString stringWithFormat:@"%@-%@", accumulator, item];
         } initial:@""];
        
        NSString *str2 = [selectedRowIndexs tmui_reduce:^id _Nonnull(id  _Nonnull accumulator, id  _Nonnull item) {
            return [NSString stringWithFormat:@"%@-%@", accumulator, item];
        } initial:@""];
        
        [TMUITips showWithText:Str(@"你选择了%@，\n选择了序号%@",str1,str2)];
        
    } curItemRowIndexs:@[@1,@2,@3] fromViewController:self];
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

/// MARK: demo 7
- (void)showNormalPicker{
    [TMNormalPicker showPickerWithTitle:@"单列选择器" itemListBlock:^NSArray * _Nonnull{
        return @[@"李白",@"韩信",@"凯爹",@"露娜",@"典韦",];
    } fetchShowStringFromItem:^NSString * _Nonnull(id  _Nonnull item, NSInteger idx) {
        return item;
    } finishSelectBlock:^(id  _Nonnull item, NSInteger idx) {
        [TMUITips showWithText:Str(@"你选了%@，在第%d行",item,idx)];
    } curItemIndex:2 fromViewController:self];
}

@end
