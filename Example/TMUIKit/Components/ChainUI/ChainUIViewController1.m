//
//  ChainUIViewController1.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/19.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "ChainUIViewController1.h"

@interface ChainUIViewController1 ()

@end

@implementation ChainUIViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Color(0xFF990010);
    id l1 = Label.str(@"Color() 颜色宏的使用：").styles(h1);
    
    
    /*
     Color(0x00FFFF50)
     Color([UIColor redColor]),
               Color(@"red"),
               Color(@"red,0.5"),
               Color(@"255,0,0,1"),
               Color(@"#F00,0.5"),
               Color(@"random,0.5")
     */
    
    BOOL isobj = CUI_CHECK_IS_OBJECT(0xEEEEEE);
    
    Log(isobj);
    Log(11);
    
    Log(CUI_TYPE(0xEEEEEE));
    Log(CUI_TYPE([UIColor redColor]));
    Log(CUI_TYPE(@"red,0.5"));
    
    VerStack(l1,
             Label.str(@"颜色对象 [UIColor brownColor]").txtColor(Color([UIColor brownColor])), // UIExtendedSRGBColorSpace
             Label.str(@"系统颜色 gray,0.5").txtColor(Color(@"gray,0.5")),
             Label.str(@"RGBA字符串 255,200,0,1").txtColor(Color(@"255,200,0,1")),
             Label.str(@"RGBA字符串 #A00,0.5").txtColor(Color(@"#A00,0.5")),
             Label.str(@"随机色 random,0.5").txtColor(Color(@"random,0.5")),
             Label.str(@"字符串  0x00FFFF").txtColor(Color(@"0x00FFFF")),
             Label.str(@"十六进制（含alpha）0x00FFFF50").txtColor(Color(0x00FFFF50)),
             Label.str(@"十六进制  0x00FFFF").txtColor(Color(0x00FFFF)),
             CUISpring)
    .embedIn(self.view, NavigationContentTop + 20,20,0).gap(10);
    
    
    
    NSArray *result = @[@1,@2,@3].forEach((NSNumber *)^(NSNumber *num) {
        NSLog(@"%@",num);
        return @(num.intValue+10);
    });
    
    NSLog(@"%@",result);
}
@end
