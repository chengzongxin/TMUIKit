//
//  UIViewController+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, TMUIViewControllerVisibleState) {
    TMUIViewControllerUnknow        = 1 << 0,   // 初始化完成但尚未触发 viewDidLoad
    TMUIViewControllerViewDidLoad   = 1 << 1,   // 触发了 viewDidLoad
    TMUIViewControllerWillAppear    = 1 << 2,   // 触发了 viewWillAppear
    TMUIViewControllerDidAppear     = 1 << 3,   // 触发了 viewDidAppear
    TMUIViewControllerWillDisappear = 1 << 4,   // 触发了 viewWillDisappear
    TMUIViewControllerDidDisappear  = 1 << 5,   // 触发了 viewDidDisappear
    
    TMUIViewControllerVisible       = TMUIViewControllerWillAppear | TMUIViewControllerDidAppear,// 表示是否处于可视范围，判断时请用 & 运算，例如 tmui_visibleState & TMUIViewControllerVisible
};

@interface UIViewController (TMUI)

@end

NS_ASSUME_NONNULL_END
