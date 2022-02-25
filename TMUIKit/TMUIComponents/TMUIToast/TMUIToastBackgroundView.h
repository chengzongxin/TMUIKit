//
//  TMUIToastBackgroundView.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/1/19.
//

#import <UIKit/UIKit.h>

@interface TMUIToastBackgroundView : UIView

/**
 * 是否需要磨砂，默认NO。仅支持iOS8及以上版本。可以通过修改`styleColor`来控制磨砂的效果。
 */
@property(nonatomic, assign) BOOL shouldBlurBackgroundView;

@property(nullable, nonatomic, strong, readonly) UIVisualEffectView *effectView;

/**
 * 如果不设置磨砂，则styleColor直接作为`TMUIToastBackgroundView`的backgroundColor；如果需要磨砂，则会新增加一个`UIVisualEffectView`放在`TMUIToastBackgroundView`上面。
 */
@property(nullable, nonatomic, strong) UIColor *styleColor UI_APPEARANCE_SELECTOR;

/**
 * 设置圆角。
 */
@property(nonatomic, assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

@end
