//
//  TDDebugViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/5/18.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TDDebugViewController.h"

@interface TDDebugViewController ()

@end

@implementation TDDebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Log([NSString tmui_isEmpty:@""]);
    Log(tmui_isNullString(@""));
    
    UILabel *l1 = Label;
    
    UILabel *l2 = Label;
    
    UILabel *l3 = Label;
    
//    [self.view addSubview:l1];
//    [self.view addSubview:l2];
//    [self.view addSubview:l3];
//
//    [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(NavigationContentTop+20);
//        make.left.mas_equalTo(20);
//    }];
//
//    [l2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(l1.mas_bottom).offset(20);
//        make.left.mas_equalTo(20);
//    }];
//
//    [l3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(l2.mas_bottom).offset(20);
//        make.left.mas_equalTo(20);
//    }];
    
    CGFloat lineSpacing = 20;
    [l1 tmui_setAttributesText:@"xxxxxhhahdsdasdasdsadsadsadsahf" lineSpacing:lineSpacing];
    [l2 tmui_setAttributesText:@"xxxxxhhahah\njsadkfdskfdsfds" lineSpacing:lineSpacing];
    [l3 tmui_setAttributesText:@"xxxxxhhahah\njsadkfdskfdsfds\nfhdslkfdslfsd" lineSpacing:lineSpacing];
    VerStack(l1,l2,l3,CUISpring).gap(40).embedIn(self.view, NavigationContentTop+20, 20, 0);
    
}



@end
