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

- (void)viewDidLoad1 {
    [super viewDidLoad];
    
    UIScrollView *scrollView = (UIScrollView *)[UIScrollView new].embedIn(self.view);
    scrollView.contentSize = self.view.bounds.size;
    id l1 = Label.str(@"此demo中，滚动scrollView和输入textField将会在VC和TMAppDelegate同时回调此demo中，滚动scrollView和输入textField将会在VC和TMAppDelegate同时回调").styles(h1);
    VerStack(l1).gap(10).embedIn(scrollView,20,20,20).fixWidth(self.view.width - 40);
//    VerStack(l1,CUISpring).gap(10).addTo(scrollView).makeCons(^{
//        make.top.left.constants(20);
//        make.width.constants(self.view.width - 40);
//        make.height.constants(self.view.height);
//    });
    
//    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:v1 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-20];
//    [v1 addConstraint:c];
//    c.active = YES;
//    [NSLayoutConstraint activateConstraints:@[c]];
}

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
    // 嵌套在scrollview中的right约束会失效，需要View内部指定width约束
    VerStack(l1,l2,tf,v1).gap(10).embedIn(scrollView,20,20,20).fixWidth(SCREEN_WIDTH - 40);
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
