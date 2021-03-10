//
//  TMUICoreViewController2.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/10.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUICoreViewController2.h"

@interface TMUICoreViewController2 ()

@end

@implementation TMUICoreViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bgColor(@"white");
    
    id l3 = Label.str(@"布局相关的宏，例如快速获取状态栏、导航栏的高度，为不同的屏幕大小使用不同的值，代表 1px 的宏等").styles(@"h1");
    id a4 = AttStr(
                   AttStr(Str(@"IS_LANDSCAPE = %.1f\n",IS_LANDSCAPE)),
                   AttStr(Str(@"IS_DEVICE_LANDSCAPE = %.1f\n",IS_DEVICE_LANDSCAPE)),
                   AttStr(Str(@"SCREEN_WIDTH = %.1f\n",SCREEN_WIDTH)),
                   AttStr(Str(@"SCREEN_HEIGHT = %.1f\n",SCREEN_HEIGHT)),
                   AttStr(Str(@"DEVICE_WIDTH = %.1f\n",DEVICE_WIDTH)),
                   AttStr(Str(@"DEVICE_HEIGHT = %.1f\n",DEVICE_HEIGHT)),
                   AttStr(Str(@"ToolBarHeight = %.1f\n",ToolBarHeight)),
                   AttStr(Str(@"TabBarHeight = %.1f\n",TabBarHeight)),
                   AttStr(Str(@"StatusBarHeight = %.1f\n",StatusBarHeight)),
                   AttStr(Str(@"StatusBarHeightConstant = %.1f\n",StatusBarHeightConstant)),
                   AttStr(Str(@"NavigationBarHeight = %.1f\n",NavigationBarHeight)),
                   AttStr(Str(@"NavigationContentTop = %.1f\n",NavigationContentTop)),
                   AttStr(Str(@"NavigationContentTopConstant = %.1f\n",NavigationContentTopConstant)),
                   AttStr(Str(@"SafeAreaInsetsConstantForDeviceWithNotch = %.1f\n",SafeAreaInsetsConstantForDeviceWithNotch)),).styles(@"h2").match(@" \\d+(\\.\\d+)?").color(@"red");
    id l4 = Label.str(a4).multiline;
    
    VerStack(l3,l4,CUISpring).embedIn(self.view, NavigationContentTop + 20,20,0).gap(10);
}


@end
