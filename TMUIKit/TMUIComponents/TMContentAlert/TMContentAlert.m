//
//  TMContentAlert.m
//  HouseKeeper
//
//  Created by nigel.ning on 2020/4/13.
//  Copyright © 2020 binxun. All rights reserved.
//

#import "TMContentAlert.h"
#import "UIView+TMUIKit.h"

@interface TMContentAlertContainerViewController : UIViewController
@end
@implementation TMContentAlertContainerViewController
- (void)dealloc {
#if DEBUG
    NSLog(@"Dealloc_TMContentAlertContainerViewController");
#endif
}
@end

@implementation TMContentAlert

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
    
    UIViewController *toShowVc = [[TMContentAlertContainerViewController alloc] init];
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
    NSAssert([vc isKindOfClass:[TMContentAlertContainerViewController class]], @"content.tmui_viewController must be kind of class: TMContentAlertContainerViewController, you must use [TMContentAlertContainerViewController TMContentAlertContainerViewController:loadContentView:didShowBlock] method to make contentView show");
    
    if (contentView &&
        vc &&
        [vc isKindOfClass:[TMContentAlertContainerViewController class]]) {
        [vc dismissViewControllerAnimated:NO completion:didHiddenBlock];
    }
}

@end
