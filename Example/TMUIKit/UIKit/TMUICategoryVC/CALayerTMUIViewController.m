//
//  CALayerTMUIViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/12.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "CALayerTMUIViewController.h"

@interface CALayerTMUIViewController ()

@end

@implementation CALayerTMUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bgColor(@"white");
    
    id l1 = Label.str(self.demoInstructions).styles(h1);
    
    UIView *v1 = View.fixWH(300,500);
    
    CALayer *c1 = [[CALayer alloc] init];
    c1.frame = CGRectMake(100, 100, 100, 100);
    c1.backgroundColor = Color(@"random").CGColor;
    c1.cornerRadius = 50;
    [v1.layer addSublayer:c1];
    
    CALayer *c2 = [[CALayer alloc] init];
    c2.frame = CGRectMake(100, 300, 100, 100);
    c2.backgroundColor = Color(@"random").CGColor;
    c2.cornerRadius = 50;
    [v1.layer addSublayer:c2];
    
    UIButton *b1 = Button.styles(button).fixWH(300,44).str(@"执行动画");
    UIButton *b2 = Button.styles(button).fixWH(300,44).str(@"不执行动画");
    UIButton *b3 = Button.styles(button).fixWH(300,44).str(@"复位");
    
    VerStack(l1,v1,b1,b2,b3,CUISpring).embedIn(self.view, NavigationContentTop+20,20,0).gap(20);
    
    
    // api
    [c1 tmui_setLayerShadow:Color(@"black") offset:CGSizeMake(10, 10) radius:5];
    
    [c2 tmui_setLayerShadow:Color(@"black") offset:CGSizeMake(10, 10) alpha:1 radius:5 spread:0];
    
    
    b1.onClick(^{
        c1.transformTranslationX = 100;
        c2.transformTranslationX = 100;

        c1.transformScaleX = 1.2;
        c2.transformScaleX = 1.2;
        c1.transformScaleY = 1.2;
        c2.transformScaleY = 1.2;
        c1.transformScaleZ = 1.2;
        c2.transformScaleZ = 1.2;
    });
    
    b2.onClick(^{
        [CALayer tmui_performWithoutAnimation:^{
            c1.transformTranslationX = 100;
            c2.transformTranslationX = 100;
            
            c1.transformScaleX = 1.2;
            c2.transformScaleX = 1.2;
            c1.transformScaleY = 1.2;
            c2.transformScaleY = 1.2;
            c1.transformScaleZ = 1.2;
            c2.transformScaleZ = 1.2;
        }];
    });
    
    b3.onClick(^{
        [CALayer tmui_performWithoutAnimation:^{
            c1.transform = CATransform3DIdentity;
            c2.transform = CATransform3DIdentity;
        }];
    });
}


@end
