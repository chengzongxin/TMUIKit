//
//  CAAnimation+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/13.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAAnimation (TMUI)

@property(nonatomic, copy) void (^tmui_animationDidStartBlock)(__kindof CAAnimation *aAnimation);
@property(nonatomic, copy) void (^tmui_animationDidStopBlock)(__kindof CAAnimation *aAnimation, BOOL finished);
@end

NS_ASSUME_NONNULL_END
