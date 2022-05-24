//
//  TMUIConfigurationViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2022/4/26.
//  Copyright © 2022 chengzongxin. All rights reserved.
//

#import "TMUIConfigurationViewController.h"

@interface TMUIConfigurationViewController ()

@end

@implementation TMUIConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /*
     #define UIColorMain                 [TMUICMI mainColor]                        // 小面积使用，用于特别需要强调的文字、按钮和图标
     #define UIColorTextImportant        [TMUICMI textImportantColor]               // 用于重要级文字信息，页内标题信息
     #define UIColorTextRegular          [TMUICMI textRegularColor]                 // 用于一般文字信息，正文或常规文字
     #define UIColorTextWeak             [TMUICMI textWeakColor]                    // 用于辅助、次要、弱提示类的文字信息
     #define UIColorTextPlaceholder      [TMUICMI textPlaceholderColor]             // 用于占位文字
     */
    
    id s1 = Style().fixWH(44,44).borderRadius(22);
    id s2 = Style().fnt(14).color(UIColorMain).multiline;
    // origin
    id v1 = View.styles(s1).bgColor(UIColorMain);
    id a1 = AttStr(
                   AttStr(Str(@"UIColorMain")).styles(s1),
                   AttStr(Str(@"\n小面积使用，用于特别需要强调的文字、按钮和图标")).styles(body)
                   ).lineGap(3);
    id l1 = Label.styles(s2).str(a1);
    // origin
    id v2 = View.styles(s1).bgColor(UIColorTextImportant);
    id a2 = AttStr(
                   AttStr(Str(@"UIColorTextImportant")).styles(s1),
                   AttStr(Str(@"\n用于重要级文字信息，页内标题信息")).styles(body)
                   ).lineGap(3);
    id l2 = Label.styles(s2).str(a2);
    // origin
    id v3 = View.styles(s1).bgColor(UIColorTextRegular);
    id a3 = AttStr(
                   AttStr(Str(@"UIColorTextRegular")).styles(s1),
                   AttStr(Str(@"\n用于一般文字信息，正文或常规文字")).styles(body)
                   ).lineGap(3);
    id l3 = Label.styles(s2).str(a3);
    // origin
    id v4 = View.styles(s1).bgColor(UIColorTextWeak);
    id a4 = AttStr(
                   AttStr(Str(@"UIColorTextWeak")).styles(s1),
                   AttStr(Str(@"\n用于辅助、次要、弱提示类的文字信息")).styles(body)
                   ).lineGap(3);
    id l4 = Label.styles(s2).str(a4);
    // origin
    id v5 = View.styles(s1).bgColor(UIColorTextPlaceholder);
    id a5 = AttStr(
                   AttStr(Str(@"UIColorTextPlaceholder")).styles(s1),
                   AttStr(Str(@"\n用于占位文字")).styles(body)
                   ).lineGap(3);
    id l5 = Label.styles(s2).str(a5);
    
    
    id scrollView = [UIScrollView new].embedIn(self.view);
    VerStack(HorStack(v1,l1).gap(20),
             HorStack(v2,l2).gap(20),
             HorStack(v3,l3).gap(20),
             HorStack(v4,l4).gap(20),
             HorStack(v5,l5).gap(20),
             ).gap(44).embedIn(scrollView, 20, 20, 80);
    
}

@end
