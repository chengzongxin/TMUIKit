//
//  TMUIFoldLabel.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/3/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TMUIFoldLabelType) {
    TMUIFoldLabelType_ShowUnFold                         = 0,         /// 显示展开
    TMUIFoldLabelType_ShowFoldAndUnfold                  = 1 << 0,    /// 显示展开和折叠
};

@class TMUIFoldLabel;
typedef void(^TMUIFoldLabelClickFold)(BOOL isFold,TMUIFoldLabel *label);
typedef void(^TMUIFoldLabelClickText)(BOOL isFold,TMUIFoldLabel *label);

/*
 传入原始富文本，会根据所传进来的设置，生成对应的展开、收起文本
 点击展开、收起，会自动更新内部UI，无需外部操作，外部需要根据回调更新数据源，以备下次显示使用（在列表中时需要）
 */
@interface TMUIFoldLabel : UILabel
/// 最大宽度
@property (nonatomic, assign) CGFloat maxWidth;
/// 展开文本颜色
@property (nonatomic, strong) UIColor *foldColor;
/// 点击展开、收起回调
@property (nonatomic, copy) TMUIFoldLabelClickFold clickFold;
/// 点击文本回调
@property (nonatomic, copy) TMUIFoldLabelClickText clickText;
/// 展开按钮显示方式
@property (nonatomic, assign) TMUIFoldLabelType type;
/// 当前是展开还是收起，一般不设置这个，会影响初始状态，只在列表中需要设置同步这个状态（因为列表有回收利用机制）
@property (nonatomic, assign) BOOL isFold;
/// 是否点击展开自动刷新内容，当在列表中不需要刷新，因为会从新调cellForRow，从新生成再设置文本
@property (nonatomic, assign) BOOL isAutoRefreshContentWhenClickFold;
/// 文本尺寸
+ (CGSize)sizeForAttr:(NSAttributedString *)attr line:(NSInteger)line width:(CGFloat)width;
/// 文本尺寸
- (CGSize)sizeForFits;

@end

NS_ASSUME_NONNULL_END
