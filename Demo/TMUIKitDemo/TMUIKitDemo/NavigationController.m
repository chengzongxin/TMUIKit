//
//  NavigationController.m
//  TMUIKitDemo
//
//  Created by nigel.ning on 2020/4/15.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (BOOL)shouldAutorotate {
    return [[self theTopVc] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self theTopVc] supportedInterfaceOrientations];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[self theTopVc] preferredStatusBarStyle];
}

- (UIViewController *)theTopVc {
    UIViewController *topVc = [self presentedViewControllerOfViewController:self];
    if (!topVc) {
        topVc = [self presentedViewControllerOfViewController:self.topViewController];        
    }

    return topVc;
}

- (UIViewController *_Nullable)presentedViewControllerOfViewController:(UIViewController *)vc {
    UIViewController *topVc = nil;
    
    if (vc.presentedViewController) {
        topVc = vc;
        do {
            topVc = topVc.presentedViewController;
        }while (topVc.presentedViewController);
    }
        
    return topVc;
}

@end
