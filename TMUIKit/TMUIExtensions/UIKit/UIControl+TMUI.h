//
//  UIControl+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/6/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (TMUI)

/**
 将UIContrl的target-action改为block，便于调用
 
 @param blk 点击回调
 @param event 事件类型
 */
- (void)tmui_addActionBlock:(void (^)(NSInteger tag))blk
           forControlEvents:(UIControlEvents)event;


/**
 强制触发点击事件
 */
- (void)tmui_action;

@end

NS_ASSUME_NONNULL_END
