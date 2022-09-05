//
//  UICollectionViewCell+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/4/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionViewCell (TMUI)

/// 设置 cell 点击时的背景色，如果没有 selectedBackgroundView 会创建一个。
/// @warning 请勿再使用 self.selectedBackgroundView.backgroundColor 修改，因为 TMUITheme 里会重新应用 tmui_selectedBackgroundColor，会覆盖 self.selectedBackgroundView.backgroundColor 的效果。
@property(nonatomic, strong, nullable) UIColor *tmui_selectedBackgroundColor;
@end

NS_ASSUME_NONNULL_END
