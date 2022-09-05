//
//  TMUIPicker.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/4/13.
//

#import <UIKit/UIKit.h>
#import "TMUIPickerView.h"
NS_ASSUME_NONNULL_BEGIN


@protocol TMUIPickerProtocol <NSObject>

@optional

- (instancetype)initWithConfig:(TMUIPickerViewConfig *)config;

- (void)didInitializePicker;



- (NSArray <TMUIPickerIndexPath *>*)selectedIndexPaths;
- (NSArray <NSString *>*)selectedTexts;


- (NSDate *)selectedDate;

@end

@interface TMUIPicker : UIView
///// 综合方法  时间+多列
//- (instancetype)initDataPickerWithType:(TMUIPickerViewConfig *)config
//                  numberOfColumnsBlock:(TMUIPickerNumberOfColumnsBlock)columnsBlock
//                     numberOfRowsBlock:(TMMUIPickerNumberOfRowInColumnBlock)rowsBlock
//                       textForRowBlock:(TMUIPickerTextForRowBlock)textBlock
//                        selectRowBlock:(TMUIPickerSelectRowBlock)selectBlock
//                       selectDateBlock:(TMUIPickerSelectDateBlock)selectDateBlock;

/// 时间选择
- (instancetype)initDatePickerWithType:(TMUIPickerViewConfig *)config;

/// 多列级联
- (instancetype)initDataPickerWithType:(TMUIPickerViewConfig *)config
                  numberOfColumnsBlock:(TMUIPickerNumberOfColumnsBlock)columnsBlock
                     numberOfRowsBlock:(TMMUIPickerNumberOfRowInColumnBlock)rowsBlock
                       textForRowBlock:(TMUIPickerTextForRowBlock)textBlock;


- (NSArray <TMUIPickerIndexPath *>*)selectedIndexPaths;
- (NSArray <NSString *>*)selectedTexts;
- (NSDate *)selectedDate;

@end

NS_ASSUME_NONNULL_END
