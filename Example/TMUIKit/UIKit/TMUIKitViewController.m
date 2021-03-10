//
//  TMUIKitViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/19.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUIKitViewController.h"
#import "TMUIButtonViewController.h"
#import "TMUILabelViewController.h"
#import "TMUITextFieldViewController.h"
#import "TMUITextViewViewController.h"

@interface TMUIKitViewController ()

@end

@implementation TMUIKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GroupTV(
            SECTION_CREATE(
                           ROW_CREATE(@"TMUIButton",@"设置图片、文字位置、图文间距", @"TMUIButtonViewController"),
                           ROW_CREATE(@"TMUILabel",@"设置Label内容inset、设置复制", @"TMUILabelViewController"),
                           ROW_CREATE(@"TMUITextField",@"设置TextField内容Inset、clearButton位置、限制文本长度", @"TMUITextFieldViewController"),
                           ROW_CREATE(@"TMUITextView",@"TextView设置placeholder、内容长度限制、inset、高度自适应", @"TMUITextViewViewController"),
                           ).title(@"TMUI Widget"),
            SECTION_CREATE(
                           ROW_CREATE(@"设置圆角、阴影、渐变、边框", @"UIViewTMUIViewController"),
                           ROW_CREATE(@"快速添加各种手势事件", @"UIViewTMUI2ViewController"),
                           ROW_CREATE(@"创建动画", @"UIViewTMUI3ViewController"),
                           ).title(@"UIView+TMUI"),
            SECTION_CREATE(
                           ROW_CREATE(@"设置富文本属性、计算文本size、富文本超链接", @"UILabelTMUIViewController"),
                           ).title(@"UILable+TMUI"),
            SECTION_CREATE(
                           ROW_CREATE(@"设置图片位置、图文间距、扩大点击区域", @"UIButtonTMUIViewController"),
                           ).title(@"UIButton+TMUI"),
            SECTION_CREATE(
                           ROW_CREATE(@"获取最上层vc、全局设置导航栏显示隐藏、导航控制器中上一个viewcontroller、导航控制器中下一个viewcontroller",@"UIViewControllerTMUIViewController"),
                           ).title(@"UIViewController+TMUI"),
            SECTION_CREATE(
                           ROW_CREATE(@"设置最大文本输入长度、设置 placeHolder 颜色和字体、文本回调",@"UITextFieldTMUIViewController"),
                           ).title(@"UITextField+TMUI"),
            SECTION_CREATE(
                           ROW_CREATE(@"设置图片外观",@"UIImageTMUIViewController1"),
                           ROW_CREATE(@"图片创建、压缩、裁剪",@"UIImageTMUIViewController2"),
                           ).title(@"UIImage+TMUI"),
            ).embedIn(self.view);
}


@end
