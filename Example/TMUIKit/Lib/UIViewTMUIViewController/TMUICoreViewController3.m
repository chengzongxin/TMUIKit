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
    
    id l1 = Label.str(self.demoInstructions).styles(h1);
    
    id a2 = AttStr(AttStr(@"图片加载2：\n").styles(h2),
           AttStr(@"(不会被系统缓存，用于不被复用的图片，特别是大图)").styles(body));
    
    
    VerStack(l1,
             Label.str(@"123456789ABCDEFG").fnt(UIFont(20)).txtColor(UIColorHexString(@"5F00FF")),
             Label.str(@"123456789ABCDEFG").fnt(UIFontItalic(20)).txtColor(UIColorHexString(@"4FFF00")),
             Label.str(@"123456789ABCDEFG").fnt(UIFontRegular(20)).txtColor(UIColorHexString(@"30000F")),
             Label.str(@"123456789ABCDEFG").fnt(UIFontMedium(20)).txtColor(UIColorHexString(@"2FAA0F")),
             Label.str(@"123456789ABCDEFG").fnt(UIFontBold(20)).txtColor(UIColorHexString(@"1F550F")),
             @30,
             Label.str(@"图片加载1：").styles(h2),
             ImageView.img(UIImageMake(@"angel")).fixWH(150,100),
             @30,
             Label.str(a2).multiline,
             ImageView.img(UIImageMakeWithFileAndSuffix(@"snk", @"jpg")).fixWH(150,100),
             CUISpring)
    .embedIn(self.view, NavigationContentTop + 20,20,0).gap(10);
    
}

@end
