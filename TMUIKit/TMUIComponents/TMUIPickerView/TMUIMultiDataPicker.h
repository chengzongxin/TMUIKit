//
//  TMUIMultiDataPicker.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/4/12.
//

#import <UIKit/UIKit.h>
#import "TMUIPicker.h"
NS_ASSUME_NONNULL_BEGIN

@interface TMUIMultiDataPicker : UIPickerView <TMUIPickerProtocol>

@property (nonatomic, copy) TMUIPickerNumberOfColumnsBlock columnsBlock;
@property (nonatomic, copy) TMUIPickerNumberOfRowInColumnBlock rowsBlock;
@property (nonatomic, copy) TMUIPickerTextForRowBlock textBlock;
@property (nonatomic, copy) TMUIPickerScrollRowBlock scrollBlock;

- (void)setupDefalutRows;

- (NSArray <TMUIPickerIndexPath *>*)selectedIndexPaths;

- (NSArray <NSString *>*)selectedTexts;

@end

NS_ASSUME_NONNULL_END
