//
//  TMUISegmentedControlViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/4/27.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUISegmentedControlViewController.h"

@interface TMUISegmentedControlViewController ()

@end

@implementation TMUISegmentedControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *items = @[@"1",@"2",@"3",@"4"];
    // DEMO 1
    id l1 = Label.str(@"TMUI : TMUISegmentedControl").styles(h1);
    id d1 = Label.str(@"继承自UISegmentedControl，可以比较大程度地修改样式。比如 tintColor，selectedTextColor 等等\n\
可以用图片而非 tintColor 来渲染 UISegmentedControl 的 UI").styles(h2);
    
    TMUISegmentedControl *s1 = [[TMUISegmentedControl alloc] initWithItems:items];
    s1.fixWH(250,50);
    s1.selectedSegmentIndex = 1;//设置默认选择项索引
    s1.tintColor = [UIColor redColor];
    // 可以比较大程度地修改样式。比如 tintColor，selectedTextColor
    [s1 updateSegmentedUIWithTintColor:UIColor.td_tintColor selectedTextColor:UIColor.whiteColor fontSize:UIFontSemibold(18)];
    
    // DEMO 2
    id l2 = Label.str(@"系统 : UISegmentedControl").styles(h1);
    id d2 = Label.str(@"不能修改颜色，字体等UI元素").styles(h2);
    
    UISegmentedControl *s2 = [[UISegmentedControl alloc] initWithItems:items];
    s2.fixWH(250,50);
    s2.selectedSegmentIndex = 2;//设置默认选择项索引
    s2.tintColor = [UIColor redColor];
    
    // DEMO 3
//    id l3 = Label.str(@"TMUISegmentedControl").styles(h1);
//
//    TMUISegmentedControl *s3 = [[TMUISegmentedControl alloc] initWithItems:items];
//    s3.fixWH(250,50);
//    s3.selectedSegmentIndex = 1;//设置默认选择项索引
//    s3.tintColor = [UIColor redColor];
//    // 可以比较大程度地修改样式。比如 tintColor，selectedTextColor
//    [s3 updateSegmentedUIWithTintColor:UIColor.td_tintColor
//                     selectedTextColor:UIColor.whiteColor
//                              fontSize:UIFontSemibold(18)];
//    // 用图片而非 tintColor 来渲染 UISegmentedControl 的 UI
//    [s3 setBackgroundWithNormalImage:UIImageMake(@"emotion_03")
//                       selectedImage:UIImageMake(@"emotion_04")
//                       devideImage00:Img(UIColor.td_tintColor)
//                       devideImage01:Img(UIColor.td_tintColor)
//                       devideImage10:Img(UIColor.td_tintColor)
//                           textColor:UIColor.td_tintColor
//                   selectedTextColor:UIColor.whiteColor
//                            fontSize:UIFontSemibold(18)];
    
    if (@available(iOS 13.0, *)) {
        s1.selectedSegmentTintColor = UIColor.td_tintColor;
        s2.selectedSegmentTintColor = UIColor.td_tintColor;
//        s3.selectedSegmentTintColor = UIColor.td_tintColor;
    } else {
        // Fallback on earlier versions
    }
    
    
    
    
    VerStack(l1,d1,s1,@40,l2,d2,s2,@40,CUISpring).embedIn(self.view, NavigationContentTop+20,20,0).gap(20);
    
}



@end
