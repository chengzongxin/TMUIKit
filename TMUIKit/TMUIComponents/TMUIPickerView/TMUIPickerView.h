//
//  TMUIPickerView.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/4/12.
//

#import <UIKit/UIKit.h>
#import "TMUIPickerViewConfig.h"
//#import "TMUIMultiDatePickerResult.h"
//@class TMUIMultiDatePickerResult;
NS_ASSUME_NONNULL_BEGIN

// 两级
typedef void (^TMUIPickerConfigBlock)(TMUIPickerViewConfig *config);
// 返回多少列
typedef NSInteger (^TMUIPickerNumberOfColumnsBlock)(UIPickerView *pickerView);
// 返回某一列有多少行
typedef NSInteger (^TMUIPickerNumberOfRowInColumnBlock)(UIPickerView *pickerView,NSInteger columnIndex, NSArray <NSNumber *> * _Nullable selectRows);
// 返回某一行的文本内容
typedef NSString *_Nullable(^TMUIPickerTextForRowBlock)(UIPickerView *pickerView,NSInteger columnIndex, NSInteger rowIndex, NSArray <NSNumber *>*selectRows);
// 返回用户滚动某一行回调
typedef void(^TMUIPickerScrollRowBlock)(UIPickerView *pickerView,NSInteger columnIndex, NSInteger rowIndex, NSArray <NSNumber *>*selectRows);

// 确认操作
typedef void (^TMUIPickerSelectRowBlock)(NSArray <TMUIPickerIndexPath *> *indexPaths, NSArray <NSString *> *texts);
typedef void (^TMUIPickerSelectDateBlock)(NSDate *date);
typedef void (^TMUIPickerMultiDateSelectDateBlock)(TMUIMultiDatePickerResult *result);



@interface TMUIPickerView : UIView

/// 多列选择器核心方法  （其中curSelectedColumn1Row字段只对级联选择器有效，其他选择器无视该回调参数即可）
/// @param configBlock 选择器配置block，需要特别配置的在这个block里配置传出来的TMUIPickerViewConfig模型即可
/// @param columnsBlock 选择器需要显示的列数
/// @param rowsBlock 选择器某列需要显示的行数
/// @param textBlock 选择器某行需要显示的文本
/// @param selectBlock 选择器确认回调方法
+ (void)showPickerWithConfigBlock:(TMUIPickerConfigBlock _Nullable)configBlock
             numberOfColumnsBlock:(TMUIPickerNumberOfColumnsBlock)columnsBlock
                numberOfRowsBlock:(TMUIPickerNumberOfRowInColumnBlock)rowsBlock
                 scrollToRowBlock:(TMUIPickerScrollRowBlock)scrollBlock
                  textForRowBlock:(TMUIPickerTextForRowBlock)textBlock
                   selectRowBlock:(TMUIPickerSelectRowBlock)selectBlock;

/// 时间选择器
/// @param configBlock 选择器配置block，需要特别配置的在这个block里配置传出来的TMUIPickerViewConfig模型即可
/// @param selectDateBlock 选择器确认回调方法
+ (void)showDatePickerWithConfigBlock:(TMUIPickerConfigBlock _Nullable)configBlock
                      selectDateBlock:(TMUIPickerSelectDateBlock)selectDateBlock;


+ (void)showMultiDatePickerWithConfigBlock:(TMUIPickerConfigBlock _Nullable)configBlock
                           selectDateBlock:(TMUIPickerMultiDateSelectDateBlock)selectDateBlock;


- (instancetype)initDatePickerWithConfigBlock:(TMUIPickerConfigBlock)configBlock
                              selectDateBlock:(TMUIPickerSelectDateBlock)selectDateBlock;

- (instancetype)initDataPickerWithConfigBlock:(TMUIPickerConfigBlock _Nullable)configBlock
                         numberOfColumnsBlock:(TMUIPickerNumberOfColumnsBlock _Nullable)columnsBlock
                            numberOfRowsBlock:(TMUIPickerNumberOfRowInColumnBlock _Nullable)rowsBlock
                             scrollToRowBlock:(TMUIPickerScrollRowBlock _Nullable)scrollBlock
                              textForRowBlock:(TMUIPickerTextForRowBlock _Nullable)textBlock
                               selectRowBlock:(TMUIPickerSelectRowBlock _Nullable)selectBlock;

@end

@interface TMUIPickerView (TMUIPickerViewAdditions)
/// 专门提供的单列选择器方法
/// @param configBlock 配置block
/// @param texts 显示的文本
/// @param selectBlock 选择回调
+ (void)showSinglePickerWithConfigBlock:(TMUIPickerConfigBlock _Nullable)configBlock
                                  texts:(NSArray <NSString *> *)texts
                            selectBlock:(void (^)(NSInteger idx,NSString *text))selectBlock;

@end

NS_ASSUME_NONNULL_END
