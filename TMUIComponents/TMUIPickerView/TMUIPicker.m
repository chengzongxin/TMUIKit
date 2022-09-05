//
//  TMUIPicker.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/4/13.
//

#import "TMUIPicker.h"
#import "TMUICommonDefines.h"
#import "TMUIKitDefines.h"
#import "TMUIExtensions.h"
#import <Masonry/Masonry.h>
#import "TMUIMultiDataPicker.h"
#import "TMUISystemDatePicker.h"
#import "TMUICustomDatePicker.h"

#define SelectorMapPicker(...) \
if ([self.picker conformsToProtocol:@protocol(TMUIPickerProtocol)] && [self.picker respondsToSelector:_cmd]) {\
    return __VA_ARGS__;\
}\
return nil;

@interface TMUIPicker ()

@property (nonatomic, strong) TMUIPickerViewConfig *config;

@property (nonatomic, strong) UIView <TMUIPickerProtocol> *picker;

@end

@implementation TMUIPicker

- (instancetype)initDatePickerWithType:(TMUIPickerViewConfig *)config{
    self = [super init];
    if (self) {
        self.config = config;
        if (self.config.datePickerMode == TMUIDatePickerMode_YearMonthDay ||
            self.config.datePickerMode == TMUIDatePickerMode_YearMonth ||
            self.config.datePickerMode == TMUIDatePickerMode_Year) {
            self.picker = [[TMUICustomDatePicker alloc] initWithConfig:config];
        }else{
            self.picker = [[TMUISystemDatePicker alloc] initWithConfig:config];
            
        }
        [self didInitalizePicker];
    }
    return self;
}

- (instancetype)initDataPickerWithType:(TMUIPickerViewConfig *)config
                  numberOfColumnsBlock:(TMUIPickerNumberOfColumnsBlock)columnsBlock
                     numberOfRowsBlock:(TMMUIPickerNumberOfRowInColumnBlock)rowsBlock
                       textForRowBlock:(TMUIPickerTextForRowBlock)textBlock{
    self = [super init];
    if (self) {
        self.config = config;
        TMUIMultiDataPicker *picker = [[TMUIMultiDataPicker alloc] initWithConfig:config];
        picker.columnsBlock = columnsBlock;
        picker.rowsBlock = rowsBlock;
        picker.textBlock = textBlock;
        picker.scrollRowBlock = config.scrollRowBlock;
        self.picker = picker;
        [self didInitalizePicker];
    }
    return self;
}

#pragma mark - 初始化
- (void)didInitalizePicker{
    
    [self addSubview:self.picker];
    
    [self.picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.picker didInitializePicker];
}


#pragma mark - 多列选择器

//- (void)didInitalizePicker{
    // 级联效果需要
//    self.curColumn1Row = 0;
//}

//- (void)setupPicker{
//    [self addSubview:self.multiDataPicker];
//
//    [self.multiDataPicker mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
//    }];
////
//    [self.multiDataPicker reloadAllComponents];
//
//    [self.multiDataPicker setupDefalutRows];
//}


#pragma mark - 系统时间选择器

//- (void)didInitalizeDatePicker{
//    if (self.config.datePickerMode == TMUIDatePickerMode_YearMonthDay ||
//        self.config.datePickerMode == TMUIDatePickerMode_YearMonth) {
//        self.customDatePicker.date = self.config.date;
//        self.customDatePicker.datePickerMode = (TMUIDatePickerMode)self.config.datePickerMode;
//        self.customDatePicker.minimumDate = self.config.minimumDate;
//        self.customDatePicker.maximumDate = self.config.maximumDate;
//        self.customDatePicker.minuteInterval = self.config.minuteInterval ?: 1;
//
//        [self addSubview:self.customDatePicker];
//
//        [self.customDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(0);
//        }];
//    }else{
//        self.systemDatePicker.date = self.config.date;
//        self.systemDatePicker.datePickerMode = (UIDatePickerMode)self.config.datePickerMode;
//        self.systemDatePicker.minimumDate = self.config.minimumDate;
//        self.systemDatePicker.maximumDate = self.config.maximumDate;
//        self.systemDatePicker.minuteInterval = self.config.minuteInterval ?: 1;
//
//        [self addSubview:self.systemDatePicker];
//
//        [self.systemDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(0);
//        }];
//    }
//}

//- (void)setupDatePicker{
//}

#pragma mark - 自定义时间选择器


#pragma mark - Public

- (NSArray <TMUIPickerIndexPath *>*)selectedIndexPaths{
    SelectorMapPicker([self.picker selectedIndexPaths]);
}

- (NSArray <NSString *>*)selectedTexts{
    SelectorMapPicker([self.picker selectedTexts]);
}

- (NSDate *)selectedDate{
    SelectorMapPicker([self.picker selectedDate]);
}



//- (TMUISystemDatePicker *)systemDatePicker{
//    if (!_systemDatePicker) {
//        _systemDatePicker = [[TMUISystemDatePicker alloc] initWithFrame:self.bounds];
//        if (@available(iOS 13.4, *)) {
//            _systemDatePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//    return _systemDatePicker;
//}
//
//- (TMUICustomDatePicker *)customDatePicker{
//    if (!_customDatePicker) {
//        _customDatePicker = [[TMUICustomDatePicker alloc] init];
//    }
//    return _customDatePicker;
//}


//- (UIView <TMUIPickerProtocol> *)picker{
//    if (!_picker) {
//        if (self.type == TMUIPickerViewType_Date) {
//            _picker = [[TMUIDatePicker alloc] init];
//        }else{
//            _picker = [[TMUIDataPicker alloc] init];
////            _picker.
//        }
//    }
//    return _picker;
//}

@end
