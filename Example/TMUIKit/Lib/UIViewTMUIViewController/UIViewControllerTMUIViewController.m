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

    id a1 = AttStr(AttStr(@"tmui_topViewController:\n").styles(s1),
                   AttStr(Str(@"%@",[self tmui_topViewController].class)).styles(s2));
    id l1 = Label.str(a1).multiline;
    
    id a2 = AttStr(AttStr(@"tmui_previousViewController:\n").styles(s1),
                   AttStr(Str(@"%@",[self tmui_previousViewController].class)).styles(s2));
    id l2 = Label.str(a2).multiline;
    
    id a3 = AttStr(AttStr(@"tmui_nextViewController:\n").styles(s1),
                   AttStr(Str(@"%@",[self tmui_nextViewController].class)).styles(s2));
    id l3 = Label.str(a3).multiline;
    
    id a4 = AttStr(AttStr(@"tmui_nextViewController:\n").styles(s1),
                   AttStr(Str(@"%@",[self tmui_nextViewController].class)).styles(s2));
    id l4 = Label.str(a4).multiline;
    
    id button = Button.str(@"Click me to show Alert controller").borderRadius(10).fnt(14).color(@"white").addTo(self.view).makeCons(^{
    }).bgColor(Color(@"random")).onClick((^{
        [self tmui_showAlertViewWithTitle:@"title" message:@"message" cancelButtonTitle:@"cancel" buttonIndexBlock:^(NSInteger buttonIndex) {
            [TMToast toast:[NSString stringWithFormat:@"click button index %zd",buttonIndex]];
        } otherButtonTitles:@"other1",@"other2",@"other3",nil];
    }));
    
    VerStack(CUISpring,l1,l2,l3,l4,button,CUISpring).embedIn(self.view,0,20,0,20).gap(20);
    
}

@end
