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

- (void)push:(Class)vcClass{
    UIViewController *vc = [[vcClass alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GroupTV(
            Section(
                    Row.str(@"TMUIButton").fnt(18).detailStr(@"设置图片、文字位置、图文间距").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TMUIButtonViewController.class];
                        }),
                    Row.str(@"TMUILabel").fnt(18).detailStr(@"设置Label内容inset、设置复制").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TMUILabelViewController.class];
                        }),
                    Row.str(@"TMUITextField").fnt(18).detailStr(@"设置TextField内容Inset、clearButton位置、限制文本长度").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TMUITextFieldViewController.class];
                        }),
                    Row.str(@"TMUITextView").fnt(18).detailStr(@"TextView设置placeholder、内容长度限制、inset、高度自适应").subtitleStyle.cellHeightAuto.onClick(^{
                            [self push:TMUITextViewViewController.class];
                        }),
                    ).title(@"TMUI Widgets")
            ).embedIn(self.view);
}


@end
