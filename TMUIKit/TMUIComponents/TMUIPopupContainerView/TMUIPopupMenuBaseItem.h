//
//  TMUIPopupMenuBaseItem.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/4/24.
//

#import <UIKit/UIKit.h>
#import "TMUIPopupMenuItemProtocol.h"

NS_ASSUME_NONNULL_BEGIN
/**
 用于 TMUIPopupMenuView 的 item 基类，便于自定义各种类型的 item。若有 subview 请直接添加到 self 上，自身大小的计算请写到 sizeThatFits:，布局写到 layoutSubviews。
 */
@interface TMUIPopupMenuBaseItem : UIView<TMUIPopupMenuItemProtocol>

@end

NS_ASSUME_NONNULL_END
