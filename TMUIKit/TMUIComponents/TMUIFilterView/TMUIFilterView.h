//
//  TMUIFilterView.h
//  Demo
//
//  Created by Joe.cheng on 2022/2/25.
//

#import <UIKit/UIKit.h>
#import "TMUICustomCornerRadiusView.h"
#import "TMUIFilterModel.h"
#import "TMUIFilterCell.h"

@class TMUIFilterView;

typedef void(^TMUIFilterViewSelectBlock)(NSArray <NSIndexPath *>* _Nullable indexPaths,NSArray <TMUIFilterItemModel *> *_Nullable models);

typedef void(^TMUIFilterViewDismissBlock)(TMUIFilterView * _Nullable filterView);

NS_ASSUME_NONNULL_BEGIN

@interface TMUIFilterView : UIControl

#pragma mark - property 属性成员

@property (nonatomic, strong, readonly) TMUICustomCornerRadiusView *contentView;

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

#pragma mark - datas 数据源
/// 最好在所有的配置都设置完成后再设置数据源，因为设置数据源后就会刷新列表
@property (nonatomic, copy) NSArray <TMUIFilterModel *> *models;

#pragma mark - config 数据驱动配置，修改后会影响筛选菜单UI布局
/// 多选模式，一般传了多个section，会默认启动多选模式  example : models = @[fiterModel1,fireterModel2];
@property (nonatomic, assign) BOOL isMultiSelect;
/// 列数，一行有几列, 如果设为0，则不进行列数排列，采用流式排列所有选择菜单
@property (nonatomic, assign) NSInteger column;
/// 从哪个view中弹出，设置sourceView或者topInset都可以，选其一
@property (nonatomic, weak) __kindof UIView *sourceView;
/// 距离顶部距离
@property (nonatomic, assign) CGFloat topInset;
/// 虽然传了多组item，但是不是多组数据，只有header头部，在装修首页的综合搜索中使用
@property (nonatomic, assign) BOOL isForceSingleList;
/// 是否允许多选
@property (nonatomic, assign) BOOL allowsMultipleSelection;
/// 最大高度，用于比较长的列表，底部工具栏固定在最下方
@property (nonatomic, assign) CGFloat maxHeight;

#pragma mark - config UI配置
/// 影响contentView的内容缩进
@property (nonatomic, assign) UIEdgeInsets contentInset;
/// 选中背景颜色
@property (nonatomic, strong) UIColor *selectColor;
/// 动画时长，默认0.3, 设置为0时禁用动画效果
@property (nonatomic, assign) float animateDuration;
/// 是否允许反选，默认NO
@property (nonatomic, assign) BOOL allowsUnSelection;
/// 是否自动执行dismiss，默认YES
@property (nonatomic, assign) BOOL isAutoDismiss;

#pragma mark - 交互回调处理
/// 选择回调
@property (nonatomic, copy) TMUIFilterViewSelectBlock selectBlock;
/// 点击背景消失回调
@property (nonatomic, copy) TMUIFilterViewDismissBlock dismissBlock;

#pragma mark - 接口方法
/// 内容高度
- (CGFloat)contentLimitHeight;

- (void)show;
- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view animate:(BOOL)animate;

- (void)dismiss;
- (void)dismiss:(BOOL)animate;

- (BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
