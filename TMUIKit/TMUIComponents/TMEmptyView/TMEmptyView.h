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

/** 通常情况下用此方法即可
 @note 通常情况下margin给UIEdgeInsetsZero即可，当外部视图层级复杂，需要空态视图整体显示的区域距离上下左右需要保留一定的距离时可指定margin为其它适合值
*/
+ (instancetype)showEmptyInView:(UIView *)view
                     safeMargin:(UIEdgeInsets)margin
                withContentType:(TMEmptyContentType)contentType
                     clickBlock:(void(^_Nullable)(void))block;

/**
 一些特定场景需要定制时使用此方法
 @note 通常情况下margin给UIEdgeInsetsZero即可，当外部视图层级复杂，需要空态视图整体显示的区域距离上下左右需要保留一定的距离时可指定margin为其它适合值
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
