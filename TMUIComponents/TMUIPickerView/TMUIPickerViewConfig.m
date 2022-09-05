//
//  TMUIPickerViewConfig.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/4/13.
//

#import "TMUIPickerViewConfig.h"

@interface TMUIPickerIndexPath ()
// Returns the index at position 0.
@property (nonatomic, readwrite) NSInteger component;
// Returns the index at position 1.
@property (nonatomic, readwrite) NSInteger row;

@end

@implementation TMUIPickerIndexPath

+ (instancetype)indexPathForRow:(NSInteger)row inComponent:(NSInteger)component{
    TMUIPickerIndexPath *indexPath = [[TMUIPickerIndexPath alloc] init];
    indexPath.row = row;
    indexPath.component = component;
    return indexPath;
}

+ (instancetype)indexPathForRow:(NSInteger)row inSection:(NSInteger)section{
    return [self indexPathForRow:row inComponent:section];
}

+ (instancetype)indexPathForItem:(NSInteger)item inSection:(NSInteger)section{
    return [self indexPathForRow:item inComponent:section];
}

@end


@implementation TMUIMultiDatePickerResult

@end

@implementation TMUIPickerViewConfig

+ (instancetype)defaltConfig{
    TMUIPickerViewConfig *config = [[TMUIPickerViewConfig alloc] init];
    config.type = TMUIPickerViewType_MultiColumn;
    config.autoDismissWhenTapBackground = YES;
    config.date = NSDate.date;
    return config;
}

@end
