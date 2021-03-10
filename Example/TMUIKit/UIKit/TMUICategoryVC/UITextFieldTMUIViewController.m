//
//  UITextFieldTMUIViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/3.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UITextFieldTMUIViewController.h"

@interface UITextFieldTMUIViewController ()

@end

@implementation UITextFieldTMUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.bgColor(UIColor.whiteColor);
    
    id a1 = AttStr(AttStr(@"设置最大文本输入长度 20\n").styles(@"h1"),
                   AttStr(@"tmui_maximumTextLength").styles(@"h2"));
                   
    id l1 = Label.str(a1).multiline;
    
    id a2 = AttStr(AttStr(@"设置 placeHolder 颜色和字体\n").styles(@"h1"),
                   AttStr(@"tmui_setPlaceholderColor").styles(@"h2"));
    
    id l2 = Label.str(a2).multiline;
    
    UILabel *l3 = Label.multiline;
    
    UILabel *l4 = Label.multiline;
    
    
    UITextField *t1 = TextField.fixWH(300,44).hint(@"please input").roundStyle;
    t1.tmui_maximumTextLength = 20;
    [t1 tmui_setPlaceholderColor:UIColor.orangeColor font:Fnt(12)];
    t1.tmui_textLimitBlock = ^(NSString * _Nonnull text, UITextField * _Nonnull textField) {
        id a3 = AttStr(@"超过限制").color(@"#FF0000");
        l3.str(a3);
    };
    t1.tmui_textChangeBlock = ^(NSString * _Nonnull text, UITextField * _Nonnull textField) {
        id a3 = AttStr(@"未超过限制").color(@"#000000");;
        l3.str(a3);
        id a4 = AttStr(@"输入文字:",text).styles(@"h2");
        l4.str(a4);
    };
    id scrollView = UIScrollView.new.embedIn(self.view);
    VerStack(CUISpring,l1,l2,t1,l3,l4,CUISpring).embedIn(scrollView,0,20,0,20).gap(20);
}

@end
