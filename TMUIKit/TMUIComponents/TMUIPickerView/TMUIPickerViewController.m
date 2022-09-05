//
//  TMUIPickerViewController.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/4/13.
//

#import "TMUIPickerViewController.h"
#import "UIView+TMUI.h"

@interface TMUIPickerViewController ()
@property (nonatomic, weak)UIViewController *pVc;
@end

@implementation TMUIPickerViewController

#pragma mark - 状态条样式跟弹出前的vc保持一致
- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.pVc preferredStatusBarStyle];
}
- (BOOL)prefersStatusBarHidden {
    return [self.pVc prefersStatusBarHidden];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



+ (void)showFromViewController:(UIViewController *)fromVc
               loadContentView:(void(^)(__kindof UIViewController *toShowVc))block
                  didShowBlock:(void(^_Nullable)(void))didShowBlock {
    NSAssert(fromVc, @"fromVc can not be nil");
    NSAssert(block, @"loadContentView block can not be nil");
    
    UIViewController *pVC = fromVc;
    if (pVC.tabBarController) {
        pVC = pVC.tabBarController;
    }else if ([pVC isKindOfClass:[UINavigationController class]]) {
        
    }else if (pVC.navigationController) {
        pVC = pVC.navigationController;
    }
    while (pVC.presentedViewController) {
        pVC = pVC.presentedViewController;
    }
    
    if([pVC isKindOfClass:[UIAlertController class]]){
        return;
    }
    
    TMUIPickerViewController *toShowVc = [[TMUIPickerViewController alloc] init];
    toShowVc.pVc = fromVc;
    toShowVc.view.frame = [UIScreen mainScreen].bounds;
    toShowVc.view.backgroundColor = [UIColor clearColor];
    toShowVc.view.clipsToBounds = YES;
    block(toShowVc);
    
    toShowVc.definesPresentationContext = YES;
    toShowVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [pVC presentViewController:toShowVc animated:NO completion:^{
        //alpha渐变显示
        if (didShowBlock){
            didShowBlock();
        }
    }];
}

+ (void)hiddenContentView:(UIView *)contentView didHiddenBlock:(void(^_Nullable)(void))didHiddenBlock {
    NSAssert(contentView, @"contentView can not be nil");
    UIViewController *vc = contentView.tmui_viewController;
    NSAssert(vc != nil, @"contentview.viewController can not be nil");
    NSAssert([vc isKindOfClass:[TMUIPickerViewController class]], @"content.tmui_viewController must be kind of class: TMContentAlertContainerViewController, you must use [TMContentAlertContainerViewController TMContentAlertContainerViewController:loadContentView:didShowBlock] method to make contentView show");
    
    if (contentView &&
        vc &&
        [vc isKindOfClass:[TMUIPickerViewController class]]) {
        [vc dismissViewControllerAnimated:NO completion:didHiddenBlock];
    }
}

@end
