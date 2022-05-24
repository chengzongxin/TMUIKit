//
//  TMUIMultiDataPicker.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/4/12.
//

#import "TMUIMultiDataPicker.h"
#import "TMUICommonDefines.h"
#import "TMUIKitDefines.h"
#import "TMUIExtensions.h"

@interface TMUIMultiDataPicker ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) TMUIPickerViewConfig *config;

@property (nonatomic, assign) NSInteger curColumn1Row;

@end

@implementation TMUIMultiDataPicker

- (instancetype)initWithConfig:(TMUIPickerViewConfig *)config{
    self = [super init];
    if (self) {
        self.config = config;
    }
    return self;
}

- (void)didInitializePicker{
    // 级联效果需要
    self.curColumn1Row = 0;
    self.dataSource = self;
    self.delegate = self;
    
    [self reloadAllComponents];
    [self setupDefalutRows];
}


- (void)setupDefalutRows{
//    NSAssert(obj.row < rows, @"init idx[%ld] should be less than rows at column[%ld]", initRowIndex, i);
    if (self.config.type == TMUIPickerViewType_MultiColumnConcatenation) {
        TMUIPickerIndexPath *column1Row = [self.config.defautRows tmui_filter:^BOOL(TMUIPickerIndexPath * _Nonnull item) {
            return item.component == 0;
        }].firstObject;
        
        TMUIPickerIndexPath *column2Row = [self.config.defautRows tmui_filter:^BOOL(TMUIPickerIndexPath * _Nonnull item) {
            return item.component == 1;
        }].firstObject;
        
        self.curColumn1Row = column1Row.row;
        [self selectRow:self.curColumn1Row inComponent:0 animated:NO];
        [self reloadComponent:1];
        [self selectRow:column2Row.row inComponent:1 animated:NO];
        
    }else{
        [self.config.defautRows enumerateObjectsUsingBlock:^(TMUIPickerIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSInteger columns = self.columnsBlock();
            NSAssert(obj.component < columns, @"init idx[%ld] should be less than columns at column[%ld]", obj.component,columns);
            NSInteger rows = self.rowsBlock(obj.component,0);
            NSAssert(obj.row < rows, @"init idx[%ld] should be less than rows at column[%ld]", obj.row,rows);
            
            [self selectRow:obj.row inComponent:obj.component animated:NO];
        }];
    }
    
}

#pragma mark - Public

#pragma mark - Delegate
#pragma mark - <UIPickerViewDataSource>
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_columnsBlock) {
        NSInteger colunms = _columnsBlock();
        return colunms;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (_rowsBlock) {
        if (self.config.type == TMUIPickerViewType_MultiColumnConcatenation &&
            component == 1) {
            return _rowsBlock(component,self.curColumn1Row);
        }else{
            return _rowsBlock(component,0);
        }
    }
    return 0;
}

#pragma mark - <UIPickerViewDelegate>

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 42;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *lbl = (UILabel *)view;
    if (![lbl isKindOfClass:UILabel.class]) {
        lbl = [[UILabel alloc] init];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = UIColorHex(333333);
        lbl.font = UIFont(18);
    }
    
    NSString *text = nil;
    if (_textBlock) {
        if (self.config.type == TMUIPickerViewType_MultiColumnConcatenation &&
            component == 1) {
            text = _textBlock(component,row,self.curColumn1Row);
        }else{
            text = _textBlock(component,row,0);
        }
    }
    
    lbl.text = text;
    
    return lbl;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.config.type != TMUIPickerViewType_MultiColumnConcatenation) {
        return;
    }
    
    if (component == 0) {
        self.curColumn1Row = row;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
}



- (NSArray <TMUIPickerIndexPath *>*)selectedIndexPaths{
    NSInteger columns = [self numberOfComponents];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 0; i < columns; i++) {
        NSInteger row = [self selectedRowInComponent:i];
        TMUIPickerIndexPath *indexPath = [TMUIPickerIndexPath indexPathForRow:row inComponent:i];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

- (NSArray <NSString *>*)selectedTexts{
    NSInteger columns = [self numberOfComponents];
    NSMutableArray *texts = [NSMutableArray array];
    for (int i = 0; i < columns; i++) {
        NSInteger row = [self selectedRowInComponent:i];
        
        NSString *text = nil;
        if (self.config.type == TMUIPickerViewType_MultiColumnConcatenation) {
            text = _textBlock(i,row,self.curColumn1Row);
        }else{
            text = _textBlock(i,row,0);
        }
        [texts addObject:text];
    }
    return texts;
}




@end
