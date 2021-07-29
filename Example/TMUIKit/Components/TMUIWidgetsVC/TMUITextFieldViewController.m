//
//  TMTextFieldViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/23.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUITextFieldViewController.h"

@interface TMUITextFieldViewController ()<TMUITextFieldDelegate>

@end

@implementation TMUITextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Label.str(self.demoInstructions.subReplace(@"、",@"\n")).styles(h1).addTo(self.view).makeCons(^{
        make.top.left.right.constants(NavigationContentTop+20,20,-20);
    });
    
    
    TMUITextField *textField = [[TMUITextField alloc] init];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"please input string";
    [textField tmui_setPlaceholderFont:UIFont(20)];
//    [textField tmui_setPlaceholderColor:UIColor.tmui_randomColor font:UIFont(15)];
    textField.placeholderColor = UIColor.tmui_randomColor;
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(400);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(44);
    }];
    
    textField.maximumTextLength = 10;
    textField.textInsets = UIEdgeInsetsMake(10, 50, 0, 0);
    textField.textAlignment = NSTextAlignmentCenter;
    textField.delegate = self;
    textField.clearButtonPositionAdjustment = UIOffsetMake(-10, 0);
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;;
}

- (void)textField:(TMUITextField *)textField didPreventTextChangeInRange:(NSRange)range replacementString:(NSString *)replacementString{
    Log(textField);
    Log(range);
    Log(replacementString);
    [TMToast toast:replacementString];
}

@end
