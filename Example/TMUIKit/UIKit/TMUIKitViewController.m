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
                           ROW_CREATE(@"TMUIButton",
                                      @"设置图片、文字位置、图文间距",
                                      @"TMUIButtonViewController"),
                           ROW_CREATE(@"TMUILabel",
                                      @"控制label内容的padding、设置是否需要长按复制的功能",
                                      @"TMUILabelViewController"),
                           ROW_CREATE(@"TMUITextField",
                                      @"自定义 placeholderColor、支持限制输入的文字的长度、超过时回调、设置TextField内容Inset、clearButton位置偏移",
                                      @"TMUITextFieldViewController"),
                           ROW_CREATE(@"TMUITextView",
                                      @"支持 placeholder 并支持更改 placeholderColor；若使用了富文本文字，则 placeholder 的样式也会跟随文字的样式（除了 placeholder 颜色）、支持在文字发生变化时计算内容高度并通知 delegate、支持限制输入框最大高度，一般配合第 2 点使用、支持限制输入的文本的最大长度，默认不限制、修正系统 UITextView 在输入时自然换行的时候，contentOffset 的滚动位置没有考虑textContainerInset.bottom",
                                      @"TMUITextViewViewController"),
                           ROW_CREATE(@"TMUISlider",
                                      @"修改背后导轨的高度、修改圆点的大小、修改圆点的阴影样式",
                                      @"TMUISliderViewController"),
                           ).title(@"TMUI Widget"),
            SECTION_CREATE(
                           ROW_CREATE(@"设置圆角、阴影、渐变、边框", @"UIViewTMUIViewController"),
                           ROW_CREATE(@"快速添加各种手势事件、坐标系转换", @"UIViewTMUI2ViewController"),
                           ROW_CREATE(@"创建动画", @"UIViewTMUI3ViewController"),
                           ROW_CREATE(@"UIView+TMUIBorder",@"设置边框", @"UIViewTMUI4ViewController"),
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
            SECTION_CREATE(
                           ROW_CREATE(@"frame、tranform属性快速访问、修改、移除默认动画、不带动画修改layer属性",
                                      @"CALayerTMUIViewController"),
                           ).title(@"CALayer+TMUI"),
            SECTION_CREATE(
                           ROW_CREATE(@"支持用 block 的形式添加对 animationDidStart 和 animationDidStop 的监听，无需自行设置 delegate",
                                      @"CAAnimationTMUIViewController"),
                           ).title(@"CAAnimation+TMUI"),
            ).embedIn(self.view);
}


@end
