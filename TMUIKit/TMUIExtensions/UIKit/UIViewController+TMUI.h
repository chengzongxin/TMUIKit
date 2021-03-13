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
// 控制导航栏显示或隐藏
@property (nonatomic, assign) BOOL tmui_navBarHidden;

// 导航控制器中上一个viewcontroller
- (UIViewController*)tmui_previousViewController;
// 导航控制器中下一个viewcontroller
- (UIViewController*)tmui_nextViewController;
// 获取当前最顶层的ViewController
- (UIViewController *)tmui_topViewController;


// 导航栏返回按钮方法
-(void)tmui_navBackAction:(id)sender;

@end



@interface UIViewController (TMUI_Alert)



/**
 * show alert with number of button
 * arguments: string button
 * Usages: [tmui_xxx:title ...cancelButton:@"cancel",buttonBlock:^{(index){ xxx },otherButton:@"button1",@"button2"]
 */
- (void)tmui_showAlertWithTitle:(NSString *)title message:(NSString *)message block:(void (^)(NSInteger))block buttons:(NSString *)buttonTitle, ...;


/**
 * show alert with number of button
 * arguments: string button
 * Usages: [tmui_xxx:title ...cancelButton:@"cancel",buttonBlock:^{(index){ xxx },otherButton:@"button1",@"button2"]
 */
- (void)tmui_showSheetWithTitle:(NSString *)title message:(NSString *)message block:(void (^)(NSInteger))block buttons:(NSString *)buttonTitle, ...;


@end

NS_ASSUME_NONNULL_END
