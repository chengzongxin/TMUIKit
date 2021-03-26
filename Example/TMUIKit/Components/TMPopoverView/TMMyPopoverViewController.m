//
//  TMMyPopoverViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/25.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMMyPopoverViewController.h"

@interface TMMyPopoverViewController ()

@end

@implementation TMMyPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Label
    .str(@"helloworddddd")
    .styles(h1)
    .embedIn(self.view)
    .onClick(^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
