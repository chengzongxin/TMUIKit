//
//  NavigationController.m
//  Example
//
//  Created by nigel.ning on 2020/7/22.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}
- (BOOL)prefersStatusBarHidden {
    return self.topViewController.prefersStatusBarHidden;
}

@end
