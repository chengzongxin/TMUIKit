//
//  TMUIFilterView.h
//  Demo
//
//  Created by Joe.cheng on 2022/2/25.
//

#import <UIKit/UIKit.h>
#import "TMUIFilterModel.h"
#import "TMUIFilterCell.h"

typedef void(^TMUIFilterViewSelectBlock)(NSArray <NSIndexPath *>* _Nullable indexPaths,NSArray <TMUIFilterCell *> *_Nullable cells);

NS_ASSUME_NONNULL_BEGIN

@interface TMUIFilterView : UIControl

#pragma mark - datas 数据源
@property (nonatomic, copy) NSArray <TMUIFilterModel *> *models;

#pragma mark - config UI配置
@property (nonatomic, strong) NSArray *sections;
/// 选中背景颜色
@property (nonatomic, strong) UIColor *selectColor;
/// 多选模式
@property (nonatomic, assign) BOOL isMultiSelect;
/// 列数，一行有几列，如果设为0，则不进行列数排列，采用流式排列所有选择菜单
@property (nonatomic, assign) NSInteger column;
/// 禁用动画效果
@property (nonatomic, assign) BOOL disableAnimate;
/// 距离顶部距离
@property (nonatomic, assign) CGFloat topInset;
/// 是否允许多选
@property (nonatomic, assign) BOOL allowsMultipleSelection;
/// 是否允许反选，默认YES
@property (nonatomic, assign) BOOL allowsUnSelection;
/// 选择回调
@property (nonatomic, copy) TMUIFilterViewSelectBlock selectBlock;

- (void)show;
- (void)dismiss;
- (void)dismissWithoutAnimate;

- (BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
