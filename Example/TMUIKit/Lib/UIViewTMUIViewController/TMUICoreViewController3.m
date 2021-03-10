//
//  TMUICoreViewController3.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/10.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUICoreViewController3.h"


@interface TMUICoreViewController3 ()

@end

@implementation TMUICoreViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bgColor(@"white");
    
    id l1 = Label.str(@"常用方法的快速调用，例如读取图片、创建字体对象、创建颜色等。").styles(@"h1");
    
    
    View.bgColor(UIColorMake(1, 1, 1));
    
    id a2 = AttStr(
                   AttStr(Str(@"IS_DEBUG : %d\n",IS_DEBUG),
                          AttStr(Str(@"IOS10 : %d\nIOS11 : %d\nIOS12 : %d\nIOS13 : %d\nIOS14 : %d\n",IOS10_SDK_ALLOWED,IOS11_SDK_ALLOWED,IOS12_SDK_ALLOWED,IOS13_SDK_ALLOWED,IOS14_SDK_ALLOWED),
                                 AttStr(Str(@"IS_IPAD : %d\nIS_IPOD : %d\nIS_IPHONE : %d\nIS_SIMULATOR : %d\nIS_MAC : %d\n",IS_IPAD,IS_IPOD,IS_IPHONE,IS_SIMULATOR,IS_MAC)),
                                 AttStr(Str(@"IOS_VERSION : %.1f\nIOS_VERSION_NUMBER : %zd\n",IOS_VERSION,IOS_VERSION_NUMBER)),
                          )).styles(@"h2")).match(@" \\d+(\\.\\d+)?").color(@"red");
    
    
    id l2 = Label.str(a2).multiline;
    
    VerStack(l1,l2,CUISpring).embedIn(self.view, NavigationContentTop+20,20,0).gap(10);
    
    
}

@end
