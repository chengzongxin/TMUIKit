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
                           ROW_TWO_CREATE(@"TMAssociatedPropertyMacro",@"针对在类型里添加属性的相关便捷宏定义", @"TMUICoreViewController"),
                           ROW_TWO_CREATE(@"TMUICommonDefines",@"设备相关的宏，例如区分当前设备是 iPhone、iPad 或是模拟器，获取当前设备的横竖屏状态、屏幕信息等。", @"TMUICoreViewController"),
                           ROW_TWO_CREATE(@"TMUICommonDefines",@"设备相关的宏，例如区分当前设备是 iPhone、iPad 或是模拟器，获取当前设备的横竖屏状态、屏幕信息等。", @"TMUICoreViewController2"),
                           ROW_TWO_CREATE(@"TMUIKitDefines",@"常用方法的快速调用，例如读取图片、创建字体对象、创建颜色等", @"TMUICoreViewController3"),
                           ).title(@"TMUI Core"),
            SECTION_CREATE(
                           ROW_ONE_CREATE(@"设置圆角、阴影、渐变、边框", @"UIViewTMUIViewController"),
                           ROW_ONE_CREATE(@"快速添加各种手势事件", @"UIViewTMUI2ViewController"),
                           ROW_ONE_CREATE(@"创建动画", @"UIViewTMUI3ViewController"),
                           ).title(@"UIView+TMUI"),
            SECTION_CREATE(
                           ROW_ONE_CREATE(@"设置富文本属性、计算文本size、富文本超链接", @"UILabelTMUIViewController"),
                           ).title(@"UILable+TMUI"),
            SECTION_CREATE(
                           ROW_ONE_CREATE(@"设置图片位置、图文间距、扩大点击区域", @"UIButtonTMUIViewController"),
                           ).title(@"UIButton+TMUI"),
            SECTION_CREATE(
                           ROW_ONE_CREATE(@"获取最上层vc、全局设置导航栏显示隐藏、导航控制器中上一个viewcontroller、导航控制器中下一个viewcontroller",@"UIViewControllerTMUIViewController"),
                           ).title(@"UIViewController+TMUI"),
            SECTION_CREATE(
                           ROW_ONE_CREATE(@"设置最大文本输入长度、设置 placeHolder 颜色和字体、文本回调",@"UITextFieldTMUIViewController"),
                           ).title(@"UITextField+TMUI"),
            SECTION_CREATE(
                           ROW_ONE_CREATE(@"设置图片外观",@"UIImageTMUIViewController1"),
                           ROW_ONE_CREATE(@"图片创建、压缩、裁剪",@"UIImageTMUIViewController2"),
                           ).title(@"UIImage+TMUI"),
            ).embedIn(self.view);
    
}

@end
