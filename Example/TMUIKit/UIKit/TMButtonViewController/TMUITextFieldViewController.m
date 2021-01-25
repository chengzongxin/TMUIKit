//
//  TMTextFieldViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/23.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUITextFieldViewController.h"

@interface TMUITextFieldViewController ()

@end

@implementation TMUITextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *prompt = @"快速设置 placeholderColor，textInsets，限制最大输入长度（超过限制时代理回调）";
    UILabel *promptLabel = [[UILabel alloc] tmui_initWithFont:UIFont(15) textColor:UIColor.tmui_randomColor];
    promptLabel.text = prompt;
    [self.view addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(tmui_navigationBarHeight()+20);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(44);
    }];
    
    
    TMUITextField *textField = [[TMUITextField alloc] init];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"please input string";
    textField.placeholderColor = UIColor.tmui_randomColor;
    [textField tmui_setPlaceholderFont:UIFont(20)];
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(promptLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(44);
    }];
    
    textField.maximumTextLength = 10;
    
    NSLog(@"%f",tmui_safeAreaTopInset());
    NSLog(@"%f",tmui_safeAreaBottomInset());
    NSLog(@"%f",tmui_navigationBarHeight());
    NSLog(@"%f",tmui_tabbarHeight());
}

@end
