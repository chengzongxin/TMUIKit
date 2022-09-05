//
//  UINavigationItem+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/1/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationItem (TMUI)
@property(nonatomic, weak, readonly, nullable) UINavigationBar *tmui_navigationBar;
@property(nonatomic, weak, readonly, nullable) UINavigationController *tmui_navigationController;
@property(nonatomic, weak, readonly, nullable) UIViewController *tmui_viewController;
@property(nonatomic, weak, readonly, nullable) UINavigationItem *tmui_previousItem;
@property(nonatomic, weak, readonly, nullable) UINavigationItem *tmui_nextItem;
@end

NS_ASSUME_NONNULL_END
