//
//  UITableViewCell+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/18.
//

#import <UIKit/UIKit.h>
#import "UITableView+TMUI.h"

NS_ASSUME_NONNULL_BEGIN

/// 用于在 @c tmui_separatorInsetsBlock @c tmui_topSeparatorInsetsBlock 里作为”不需要分隔线“的标志返回
extern const UIEdgeInsets TMUITableViewCellSeparatorInsetsNone;

@interface UITableViewCell (TMUI)

/// 获取当前 cell 所在的 tableView，iOS 13 下在 init 时就可以获取到值，而 iOS 12 及以下只能在 cell 被塞给 tableView 后才能获取到值
@property(nonatomic, weak, readonly, nullable) UITableView *tmui_tableView;

/// 获取当前 cell 初始化时用的 style 值
@property(nonatomic, assign, readonly) UITableViewCellStyle tmui_style;

/// cell 在当前 section 里的位置，在 willDisplayCell 时可以使用，cellForRow 里只能自己使用 -[UITableView tmui_positionForRowAtIndexPath:] 获取。
@property(nonatomic, assign, readonly) TMUITableViewCellPosition tmui_cellPosition;

/**
 控制 cell 的分隔线位置，做成 block 的形式是为了方便根据不同的 UITableViewStyle 以及不同的 TMUITableViewCellPosition （通过 cell.tmui_cellPosition 获取）来设置不同的分隔线缩进。分隔线默认是左右撑满整个 cell 的，通过这个 block 返回一个 insets 则会基于整个 cell 的宽度减去 insets 的值得到最终分隔线的布局，如果某些位置不需要分隔线可以返回 TMUITableViewCellSeparatorInsetsNone。
 
 @note 只有在 tableView.separatorStyle != UITableViewCellSeparatorStyleNone 时才会出现分隔线，而分隔线的颜色则由 tableView.separatorColor 控制。创建这个属性的背景是当你希望用 UITableView 系统提供的接口去控制分隔线显隐时，会发现很难调整每个 cell 内的分隔线位置及显示/隐藏逻辑（例如最后一个 cell 不要分隔线），此时你可以用这个属性来达到自定义的目的。当 block 不为空时，内部实际上会创建一条自定义的分隔线来代替系统的，系统自带的分隔线会被隐藏。
 
 @warning 注意分隔线是放在 cell 上的，而 cell.textLabel 等 subviews 是放在 cell.contentView 上的，所以如果分隔线要参照其他 subviews 布局的话，要注意坐标系转换。
 */
@property(nonatomic, copy) UIEdgeInsets (^tmui_separatorInsetsBlock)(__kindof UITableView *tableView, __kindof UITableViewCell *cell);

/**
 控制 cell 的顶部分隔线位置，其他信息参考 @c tmui_separatorInsetsBlock
 */
@property(nonatomic, copy) UIEdgeInsets (^tmui_topSeparatorInsetsBlock)(__kindof UITableView *tableView, __kindof UITableViewCell *cell);

/// 设置 cell 点击时的背景色，如果没有 selectedBackgroundView 会创建一个。
/// @warning 请勿再使用 self.selectedBackgroundView.backgroundColor 修改，因为 TMUITheme 里会重新应用 tmui_selectedBackgroundColor，会覆盖 self.selectedBackgroundView.backgroundColor 的效果。
@property(nonatomic, strong, nullable) UIColor *tmui_selectedBackgroundColor;

/// setHighlighted:animated: 方法的回调 block
@property(nonatomic, copy, nullable) void (^tmui_setHighlightedBlock)(BOOL highlighted, BOOL animated);

/// setSelected:animated: 方法的回调 block
@property(nonatomic, copy, nullable) void (^tmui_setSelectedBlock)(BOOL selected, BOOL animated);

/**
 获取当前 cell 的 accessoryView，优先级分别是：编辑状态下的 editingAccessoryView -> 编辑状态下的系统自己的 accessoryView -> 普通状态下的自定义 accessoryView -> 普通状态下系统自己的 accessoryView。
 @note 对于系统的 UITableViewCellAccessoryDetailDisclosureButton，iOS 12 及以下是一个 UITableViewCellDetailDisclosureView，而 iOS 13 及以上被拆成两个独立的 view，此时 tmui_accessoryView 只能返回布局上更靠左的那个 view。
*/
@property(nonatomic, strong, readonly, nullable) __kindof UIView *tmui_accessoryView;

@end

@interface UITableViewCell (TMUI_Styled)

/// 按照 TMUI 配置表的值来将 cell 设置为全局统一的样式
- (void)tmui_styledAsTMUITableViewCell;

@property(nonatomic, strong, readonly, nullable) UIColor *tmui_styledTextLabelColor;
@property(nonatomic, strong, readonly, nullable) UIColor *tmui_styledDetailTextLabelColor;
@property(nonatomic, strong, readonly, nullable) UIColor *tmui_styledBackgroundColor;
@property(nonatomic, strong, readonly, nullable) UIColor *tmui_styledSelectedBackgroundColor;
@property(nonatomic, strong, readonly, nullable) UIColor *tmui_styledWarningBackgroundColor;
@end

NS_ASSUME_NONNULL_END
    
