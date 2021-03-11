//
//  TMUICoreViewController6.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/11.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUICoreViewController6.h"

@interface TMUICoreViewController6 ()<UITextFieldDelegate,UIScrollViewDelegate>

@end

@implementation TMUICoreViewController6


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bgColor(@"white");
    
    id l1 = Label.str(self.demoInstructions).styles(h1);
    
    id l2 = Label.str(@"设置xxx.tmui_multipleDelegatesEnabled = YES;\n自定义delegate需要tmui_registerDelegateSelector，\n此demo中，滚动scrollView和输入textField将会在VC和TMAppDelegate同时回调").styles(body);
    
    UITextField *tf = TextField.fixWH(300,44).hint(@"input content callback two place").roundStyle;
    [tf tmui_setPlaceholderColor:UIColor.tmui_randomColor font:Fnt(15)];
    tf.tmui_multipleDelegatesEnabled = YES;
    tf.delegate = self;   // VC
    tf.delegate = (id<UITextFieldDelegate>)UIApplication.sharedApplication.delegate;  // AppDelegate
//    VerStack(l1,l2,tf,CUISpring).embedIn(self.view, NavigationContentTop + 20,20,0).gap(20);

    UIScrollView *scrollView = (UIScrollView *)[UIScrollView new].embedIn(self.view);
    scrollView.tmui_multipleDelegatesEnabled = YES;
    scrollView.delegate = self;  // VC
    scrollView.delegate = (id<UIScrollViewDelegate>)UIApplication.sharedApplication.delegate;  // AppDelegate
    
    id v1 = View.bgColor(@"white").fixWH(100,1000);
    
    VerStack(l1,l2,tf,v1).gap(10).embedIn(scrollView,20,20,20);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    Log(self);
    Log(scrollView.contentOffset);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    Log(self);
    Log(string);
    return YES;
}

@end
