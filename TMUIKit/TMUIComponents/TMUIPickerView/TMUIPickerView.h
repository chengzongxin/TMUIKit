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

typedef void (^TMUIPickerConfigBlock)(TMUIPickerViewConfig *config);
typedef NSInteger (^TMUIPickerNumberOfColumnsBlock)(void);
typedef NSInteger (^TMMUIPickerNumberOfRowInColumnBlock)(NSInteger columnIndex, NSInteger curSelectedColumn1Row);
typedef NSString *_Nullable(^TMUIPickerTextForRowBlock)(NSInteger columnIndex, NSInteger rowIndex, NSInteger curSelectedColumn1Row);
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
                numberOfRowsBlock:(TMMUIPickerNumberOfRowInColumnBlock)rowsBlock
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

- (instancetype)initDataPickerWithConfigBlock:(TMUIPickerConfigBlock)configBlock
                         numberOfColumnsBlock:(TMUIPickerNumberOfColumnsBlock)columnsBlock
                            numberOfRowsBlock:(TMMUIPickerNumberOfRowInColumnBlock)rowsBlock
                              textForRowBlock:(TMUIPickerTextForRowBlock)textBlock
                               selectRowBlock:(TMUIPickerSelectRowBlock)selectBlock;

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
