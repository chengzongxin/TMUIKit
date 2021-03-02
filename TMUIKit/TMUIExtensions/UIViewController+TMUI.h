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

- (void)tmui_showAlertViewWithTitle:(NSString *)title
                            message:(NSString *)message
                  cancelButtonTitle:(NSString *)cancelButtonTitle
                   buttonIndexBlock:(void(^)(NSInteger buttonIndex))block
                  otherButtonTitles:(NSString *)otherButtonTitles, ...;

/**
 弹出UIAlertController
 
 @param title   标题
 @param message 消息
 @param sure    点击确定按钮
 */
- (void)tmui_showAlertSureWithTitle:(NSString *)title message:(NSString *)message sure:(void (^) (UIAlertAction *action))sure;

/**
 弹出UIAlerController
 
 @param title   标题
 @param message 消息
 @param sure    点击确定
 @param cancel  点击取消
 */
- (void)tmui_showAlertSureAndCancelWithTitle:(NSString *)title message:(NSString *)message sure:(void (^) (UIAlertAction *action))sure cancel:(void (^) (UIAlertAction *action))cancel;


/**
 弹出UIAlertController
 
 @param actionOneTitle 标题
 @param handlerOne     点击标题的事件
 */
- (void)tmui_showSheetOneaction:(NSString *)actionOneTitle handlerOne:(void(^)(UIAlertAction *action))handlerOne;

/**
 弹出UIAlerController
 
 @param actionOneTitle 第一标题
 @param actionTwoTitle 第二个标题
 @param handlerOne     第一个标题点击事件
 @param handlerTwo     第二个标题点击事件
 */
- (void)tmui_showSheetTwoaction:(NSString *)actionOneTitle actionTwo:(NSString *)actionTwoTitle handlerOne:(void(^)(UIAlertAction *action))handlerOne handlerTwo:(void (^) (UIAlertAction *action))handlerTwo;

@end

NS_ASSUME_NONNULL_END
