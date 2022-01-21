//
//  UIBarButtonItemTMUIViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/5/17.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UIBarButtonItemTMUIViewController.h"

@interface UIBarButtonItemTMUIViewController ()

@end

@implementation UIBarButtonItemTMUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Null passed to a callee that requires a non-null argument
    BeginIgnoreClangWarning(-Wnonnull)
    UIImage *img = [UIImage tmui_imageWithShape:TMUIImageShapeCheckmark size:CGSizeMake(20, 15) tintColor:UIColor.td_tintColor];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem tmui_itemWithImage:img target:nil action:nil];
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem tmui_itemWithTitle:@"xxxxx" titleColorStyle:UIBarButtonItem_TMUIColorStyleWhite target:nil action:nil];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    EndIgnoreClangWarning
}



@end
