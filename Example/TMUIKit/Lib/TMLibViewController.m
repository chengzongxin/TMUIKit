//
//  TMLibViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/19.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMLibViewController.h"



@interface TMLibViewController ()

@end

@implementation TMLibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     - 设备相关的宏，例如区分当前设备是 iPhone、iPad 或是模拟器，获取当前设备的横竖屏状态、屏幕信息等。

     - 布局相关的宏，例如快速获取状态栏、导航栏的高度，为不同的屏幕大小使用不同的值，代表 1px 的宏等。

     - 常用方法的快速调用，例如读取图片、创建字体对象、创建颜色等。

     - 数学计算相关的宏，例如角度换算等。

     - 布局相关的函数，例如浮点数的像素取整计算、CGPoint、CGRect、UIEdgeIntents 的便捷操作等。

     - 运行时相关的函数，例如 swizzle 方法替换、动态添加方法等。
     */
    
    GroupTV(
            SECTION_CREATE(
                           ROW_CREATE(@"TMUIAssociatedPropertyDefines",
                                      @"针对在类型里添加属性的相关便捷宏定义",
                                      @"TMUICoreViewController"),
                           ROW_CREATE(@"TMUICommonDefines",
                                      @"设备相关的宏，例如区分当前设备是 iPhone、iPad 或是模拟器，获取当前设备的横竖屏状态、屏幕信息等。",
                                      @"TMUICoreViewController1"),
                           ROW_CREATE(@"TMUICommonDefines",
                                      @"设备相关的宏，例如区分当前设备是 iPhone、iPad 或是模拟器，获取当前设备的横竖屏状态、屏幕信息等。",
                                      @"TMUICoreViewController2"),
                           ROW_CREATE(@"TMUIKitDefines",
                                      @"常用方法的快速调用，例如读取图片、创建字体对象、创建颜色等",
                                      @"TMUICoreViewController3"),
                           ROW_CREATE(@"TMUICoreGraphicsDefines",
                                      @"布局相关的函数，例如浮点数的像素取整计算、CGPoint、CGRect、UIEdgeIntents 的便捷操作等。",
                                      @"TMUICoreViewController4"),
                           ROW_CREATE(@"TMUIRuntime",
                                      @"运行时相关的函数，例如 swizzle 方法替换、动态添加方法等",
                                      @"TMUICoreViewController5"),
                           ).THEME_TITLE(@"TMUI Core"),
            ).embedIn(self.view);
    
}

@end
