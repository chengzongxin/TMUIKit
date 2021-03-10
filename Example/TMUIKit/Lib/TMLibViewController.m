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
    
    GroupTV(
            SECTION_CREATE(
                           ROW_CREATE(@"TMAssociatedPropertyMacro",@"针对在类型里添加属性的相关便捷宏定义", @"TMUICoreViewController"),
                           ROW_CREATE(@"TMUICommonDefines",@"设备相关的宏，例如区分当前设备是 iPhone、iPad 或是模拟器，获取当前设备的横竖屏状态、屏幕信息等。", @"TMUICoreViewController"),
                           ROW_CREATE(@"TMUICommonDefines",@"设备相关的宏，例如区分当前设备是 iPhone、iPad 或是模拟器，获取当前设备的横竖屏状态、屏幕信息等。", @"TMUICoreViewController2"),
                           ROW_CREATE(@"TMUIKitDefines",@"常用方法的快速调用，例如读取图片、创建字体对象、创建颜色等", @"TMUICoreViewController3"),
                           ).title(@"TMUI Core"),
            ).embedIn(self.view);
    
}

@end
