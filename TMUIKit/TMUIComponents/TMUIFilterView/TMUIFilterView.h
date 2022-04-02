//
//  TMUIFilterView.h
//  Demo
//
//  Created by Joe.cheng on 2022/2/25.
//

#import <UIKit/UIKit.h>
#import "TMUIFilterModel.h"
#import "TMUIFilterCell.h"

@class TMUIFilterView;

typedef void(^TMUIFilterViewSelectBlock)(NSArray <NSIndexPath *>* _Nullable indexPaths,NSArray <TMUIFilterCell *> *_Nullable cells);

typedef void(^TMUIFilterViewDismissBlock)(TMUIFilterView * _Nullable filterView);

NS_ASSUME_NONNULL_BEGIN

@interface TMUIFilterView : UIControl

#pragma mark - datas 数据源
/// 最好在所有的配置都设置完成后再设置数据源，因为设置数据源后就会刷新列表
@property (nonatomic, copy) NSArray <TMUIFilterModel *> *models;

#pragma mark - config UI配置
@property (nonatomic, strong) NSArray *sections;
/// 选中背景颜色
@property (nonatomic, strong) UIColor *selectColor;
/// 多选模式
@property (nonatomic, assign) BOOL isMultiSelect;
/// 列数，一行有几列，###(如果设为0，则不进行列数排列，采用流式排列所有选择菜单----暂未支持)
@property (nonatomic, assign) NSInteger column;
/// 禁用动画效果
@property (nonatomic, assign) BOOL disableAnimate;
/// 距离顶部距离
@property (nonatomic, assign) CGFloat topInset;
/// 是否允许多选
@property (nonatomic, assign) BOOL allowsMultipleSelection;
/// 虽然传了多组item，但是不是多组数据，只有header头部，在装修首页的综合搜索中使用
@property (nonatomic, assign) BOOL isForceSingleList;
/// 是否允许反选，默认NO
@property (nonatomic, assign) BOOL allowsUnSelection;
/// 是否自动执行dismiss，默认YES
@property (nonatomic, assign) BOOL isAutoDismiss;
/// 最大高度，用于比较长的列表，底部工具栏固定在最下方
@property (nonatomic, assign) CGFloat maxHeight;
/// 选择回调
@property (nonatomic, copy) TMUIFilterViewSelectBlock selectBlock;
/// 点击背景消失回调
@property (nonatomic, copy) TMUIFilterViewDismissBlock dismissBlock;

/// 内容高度
- (CGFloat)contentLimitHeight;

- (void)show;
- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view topInset:(CGFloat)topInset;
- (void)showInView:(UIView *)view topInset:(CGFloat)topInset animate:(BOOL)animate;

- (void)dismiss;
- (void)dismissWithoutAnimate;

- (BOOL)isShow;
@end

NS_ASSUME_NONNULL_END
