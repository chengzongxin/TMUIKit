//
//  TMUIFloatMenuView.h
//  TMUIKit_Example
//
//  Created by 熊熙 on 2022/4/25.
//  Copyright © 2022 chengzongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^dismissCompletion)(void);



typedef enum : NSUInteger {
    TMUILeftTriangle,
    TMUIRightTriangle,
} TMUITriangleDirection;

@protocol TMUIMenuViewDelegate <NSObject>

- (void)MenuItemDidSelected:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath;

@end


typedef void(^OnTapMenuItem)(id sender,NSInteger index);


@interface TMUIMenuItemModel: NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) OnTapMenuItem onTapItemCallback;

@end


@interface TMUIMenuViewConfig : NSObject

/// 每个item的高度
@property (nonatomic, assign) CGFloat rowHeight;

/// TriangleDirection三角位置
@property (nonatomic, assign) TMUITriangleDirection triDirect;

/// 菜单的宽度
@property (nonatomic, assign) CGFloat  menuWidth;

/// 菜单的起始点
@property (nonatomic, assign) CGPoint menuOrigin;

@end


@interface TMUIMenuView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) id<TMUIMenuViewDelegate>delegate;

@property (nonatomic, copy) void(^selectedBlock)(NSInteger index);



/// 初始化方法
/// @param items 菜单项item
/// @param config 菜单配置
- (id)initWithMenuItems:(NSArray<TMUIMenuItemModel *> *)items MenuConfig:(TMUIMenuViewConfig *)config;



/// 弹出菜单视图
/// @param onView 父视图
/// @param fromView 锚点视图
/// @param items 菜单项
+ (void)popupMenuOnView:(UIView *)onView fromView:(UIView *)fromView WithItems:(NSArray<TMUIMenuItemModel *> *)items;

/**
 *  初始化方法
 *
 *  @param titleArray 每个title
 *  @param imageArray 每个title对应的imageName
 *  @param origin     菜单的起始点
 *  @param width      菜单的宽度
 *  @param rowHeight  每个item的高度
 *  @param direct     TriangleDirection三角位置kLeftTriangle左，kRightTriangle右
 */
- (id)initWithTitleArray:(NSArray*)titleArray imageArray:(NSArray*)imageArray origin:(CGPoint)origin width:(CGFloat)width rowHeight:(CGFloat)rowHeight Direct:(TMUITriangleDirection)triDirect;

/**
 *  隐藏
 *
 *  @param completion 隐藏后block
 */
- (void)dismissMenuView:(dismissCompletion)completion;

@end

NS_ASSUME_NONNULL_END
