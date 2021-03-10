//
//  TMUICoreViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/10.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUICoreViewController.h"

@interface TMUICoreViewController ()

@end

@implementation TMUICoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bgColor(@"white");
    /*
     - 设备相关的宏，例如区分当前设备是 iPhone、iPad 或是模拟器，获取当前设备的横竖屏状态、屏幕信息等。

     - 布局相关的宏，例如快速获取状态栏、导航栏的高度，为不同的屏幕大小使用不同的值，代表 1px 的宏等。

     - 常用方法的快速调用，例如读取图片、创建字体对象、创建颜色等。

     - 数学计算相关的宏，例如角度换算等。

     - 布局相关的函数，例如浮点数的像素取整计算、CGPoint、CGRect、UIEdgeIntents 的便捷操作等。

     - 运行时相关的函数，例如 swizzle 方法替换、动态添加方法等。
     */
    
    id l1 = Label.str(@"设备相关的宏，例如区分当前设备是 iPhone、iPad 或是模拟器，获取当前设备的横竖屏状态、屏幕信息等").styles(@"h1");
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
