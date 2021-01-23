//
//  TMComponentsViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/19.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMComponentsViewController.h"

@interface TMComponentsViewController ()

@end

@implementation TMComponentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [TMToast toast:@"123123"];
    
//    AUInputBox *inputBox = [AUInputBox inputboxWithOriginY:startY inputboxType:AUInputBoxTypeNone];
//    inputBox.titleLabel.text = @"提示文本";
//    inputBox.textField.placeholder = @"请按提示输入";
//    [self.view addSubview:inputBox];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [TMToast toastScore:123 content:@"333"];
    
//    TMContentAlert *alert = [[TMContentAlert alloc] init];
//    [TMContentAlert showFromViewController:self loadContentView:^(__kindof UIViewController * _Nonnull toShowVc) {
//        NSLog(@"dd");
//        } didShowBlock:^{
//            NSLog(@"ee");
//            [TMContentAlert hiddenContentView:self.view didHiddenBlock:nil];
//        }];
//    NSLog(@"%@",alert);
}

@end
