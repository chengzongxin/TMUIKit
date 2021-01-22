//
//  UIView+Animate.h
//  Matafy
//
//  Created by Fussa on 2019/4/24.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 显示(退出)动画
typedef NS_ENUM(NSInteger, MTFYViewAnimationType) {
    /// 无动画
    MTFYViewAnimationTypeNone,
    /// 渐显
    MTFYViewAnimationTypeFadeIn,
    /// 渐隐
    MTFYViewAnimationTypeFadeOut,
    /// 逐渐放大, 显示
    MTFYViewAnimationTypeZoomIn,
    /// 逐渐放大, 消失
    MTFYViewAnimationTypeZoomOut,
    /// 从顶部出现
    MTFYViewAnimationTypeTopIn,
    /// 从顶部移除
    MTFYViewAnimationTypeTopOut,
    /// 从底部出现
    MTFYViewAnimationTypeBottomIn,
    /// 从底部移除
    MTFYViewAnimationTypeBottomOut
};


@interface UIView (Animate)

- (void)mtfy_animateWithDuration:(NSTimeInterval)duration animationType:(MTFYViewAnimationType)type completion:(void (^ __nullable)(BOOL finished))completion;


@end

NS_ASSUME_NONNULL_END
