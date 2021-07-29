//
//  TMUICoreViewController4.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/10.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUICoreViewController4.h"

@interface TMUICoreViewController4 ()

@end

@implementation TMUICoreViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id l1 = Label.str(self.demoInstructions).styles(h1);
    id a2 = AttStr(
                   AttStr(Str(@"ScreenScale = %.1f\n",ScreenScale)),
                   AttStr(Str(@"TMUI_StatusBarHeight = %.1f\n",TMUI_StatusBarHeight)),
                   AttStr(Str(@"tmui_safeAreaTopInset() = %.1f\n",tmui_safeAreaTopInset())),
                   AttStr(Str(@"tmui_safeAreaBottomInset() = %.1f\n",tmui_safeAreaBottomInset())),
                   AttStr(Str(@"tmui_navigationBarHeight() = %.1f\n",tmui_navigationBarHeight())),
                   AttStr(Str(@"tmui_tabbarHeight() = %.1f\n",tmui_tabbarHeight())),
                   AttStr(Str(@"TMUI_SCREEN_WIDTH = %.1f\n",TMUI_SCREEN_WIDTH)),
                   AttStr(Str(@"TMUI_SCREEN_HEIGHT = %.1f\n",TMUI_SCREEN_HEIGHT)),).styles(body).match(@" \\d+(\\.\\d+)?").color(@"red");
    id l2 = Label.str(a2).multiline;
    
    id l3 = Label.str(@"结构体操作（CGPoint、CGSize、CGRect、UIEdgeInset）、安全检查、isNan，isInfi等，以免出现crash").styles(h1);
    
    VerStack(l1,l2,l3,CUISpring).embedIn(self.view, NavigationContentTop + 20,20,0).gap(10);
    
    
}
@end
