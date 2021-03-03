//
//  UIViewControllerTMUIViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/2.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UIViewControllerTMUIViewController.h"

@interface UIViewControllerTMUIViewController ()

@end

@implementation UIViewControllerTMUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bgColor(UIColor.whiteColor);
    
    id s1 = Style().fnt(14).color(Color(@"black"));
    id s2 = Style().fnt(12).color(Color(@"gray"));
    id s3 = Style().fnt(14).color(@"white").borderRadius(10).bgColor(Color(@"random")).fixWH(300, 44);

    id a1 = AttStr(AttStr(@"tmui_topViewController:\n").styles(s1),
                   AttStr(Str(@"%@",[self tmui_topViewController].class)).styles(s2));
    id l1 = Label.str(a1).multiline;
    
    id a2 = AttStr(AttStr(@"tmui_previousViewController:\n").styles(s1),
                   AttStr(Str(@"%@",[self tmui_previousViewController].class)).styles(s2));
    id l2 = Label.str(a2).multiline;
    
    id a3 = AttStr(AttStr(@"tmui_nextViewController:\n").styles(s1),
                   AttStr(Str(@"%@",[self tmui_nextViewController].class)).styles(s2));
    id l3 = Label.str(a3).multiline;
    
    id b1 = Button.str(@"Click me to show custom Alert").styles(s3).addTo(self.view).onClick((^{
        [self tmui_showAlertWithTitle:@"title" message:@"message" block:^(NSInteger index) {
            [TMToast toast:[NSString stringWithFormat:@"click button index %zd",index]];
        } buttons:@"0",@"1",@"2",@"3",nil];
    }));
    
    id b2 = Button.str(@"Click me to show custom Sheet").styles(s3).addTo(self.view).onClick((^{
        [self tmui_showSheetWithTitle:@"title" message:@"message" block:^(NSInteger index) {
            [TMToast toast:[NSString stringWithFormat:@"click button index %zd",index]];
        } buttons:@"0",@"1",@"2",@"3",nil];
    }));
    
    VerStack(CUISpring,l1,l2,l3,b1,b2,CUISpring).embedIn(self.view,0,20,0,20).gap(20);
    
}

@end
