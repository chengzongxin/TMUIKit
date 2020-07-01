//
//  TMEmptyView.h
//  Masonry
//
//  Created by nigel.ning on 2020/6/29.
//

#import <UIKit/UIKit.h>
#import "TMEmptyDefine.h"
#import "TMEmptyContentItemProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 空态提示视图
 */
@interface TMEmptyView : UIView

#pragma mark - 对外的显示空态视图的接口| 若重复多次调用show方法则每次都会先移除旧的空态视图(若有),再重新添加新的空态页视图

#pragma mark - 以下几个为便捷方法，外部仅需指定对应type，内部会自行读取合适的占位图、标题、子描述串进行展示

/** 通常情况下用此方法即可
 @note 通常情况下margin给UIEdgeInsetsZero即可，当外部视图层级复杂，需要空态视图整体显示的区域距离上下左右需要保留一定的距离时可指定margin为其它适合值
 @note 此方法内部会根据传入的类型去自动读取相关的占位图及显示的标题及子描述文案
 @note 通常情况下clickBlock在网络错误类型的情况下根据实际情况决定是否赋值
*/
+ (instancetype)showEmptyInView:(UIView *)view
                     safeMargin:(UIEdgeInsets)margin
                    contentType:(TMEmptyContentType)contentType
                     clickBlock:(void(^_Nullable)(void))block;

/// 为了方便不同场景使用时能仅关注所需的参数，这里将上述方法拆解成几个缺省参数的便捷方法

/**margin缺省为UIEdgeInsetsZero，点击block缺省为nil*/
+ (instancetype)showEmptyInView:(UIView *)view
                    contentType:(TMEmptyContentType)contentType;

/**margin缺省为UIEdgeInsetsZero*/
+ (instancetype)showEmptyInView:(UIView *)view
                    contentType:(TMEmptyContentType)contentType
                     clickBlock:(void(^_Nullable)(void))block;


#pragma mark - 以下几个为扩展支持更多自定义数据的方法，外部可指定类型以确定读取合适的占位图，以及可修改默认的相关文案数据

/**外部可通过configContentBlock对默认的相关显示文案进行修改
 @warning configContentBlock里若直接修改clickEmptyBlock 回调，则会覆盖clickBlock的赋值处理逻辑
 */
+ (instancetype)showEmptyInView:(UIView *)view
                     safeMargin:(UIEdgeInsets)margin
                    contentType:(TMEmptyContentType)contentType
             configContentBlock:(void(^_Nullable)(NSObject<TMEmptyContentItemProtocol> *content))configContentBlock
                     clickBlock:(void(^_Nullable)(void))block;

/**
 一些特定场景需要定制时使用此方法|
 @note 此方法为完全自定义方法
 @note 通常情况下margin给UIEdgeInsetsZero即可，当外部视图层级复杂，需要空态视图整体显示的区域距离上下左右需要保留一定的距离时可指定margin为其它适合值
 @note 相关contentItem对象可直接使用 TMEmptyContentItem
 @note 此方法所有显示的元素及可能的点击回调均需要在contentItem对象属性里进行自定义赋值
 */
+ (instancetype)showEmptyInView:(UIView *)view
                     safeMargin:(UIEdgeInsets)margin
                withContentItem:(NSObject<TMEmptyContentItemProtocol> *)contentItem;

#pragma mark - 移除空态提示视图
/**
 将当前空态视图从其父视图上移除
 */
- (void)remove;

@end

/**方便TMEmptyView的父视图获取当前空态页视图对象，若有则返回对应视图对象，若无则返回nil*/
@interface UIView(TMEmptyView)

/**外部仅在需要的时候关注此值的读取即可，相关赋值逻辑在TMEmptyView的内部处理逻辑会赋值
@note 若当前有空态页提示视图在显示中则有值否则为nil
 */
@property (nonatomic, nullable, weak)TMEmptyView *tmui_emptyView;

@end

NS_ASSUME_NONNULL_END
