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
    
    
    Color([UIColor greenColor]); // UIExtendedSRGBColorSpace
    Color(@"red,0.5");
    Color(@"255,0,0,1");
    Color(@"#F00,0.5");
    Color(@"random,0.5");
    Color(0xAABBCC);
    
    id l1 = Label.str(@"this is title").styles(h1);
    
    
    /*
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
             Label.str(@"[UIColor brownColor]").txtColor(Color([UIColor brownColor])), // UIExtendedSRGBColorSpace
             Label.str(@"red,0.5").txtColor(Color(@"gray,0.5")),
             Label.str(@"255,0,0,1").txtColor(Color(@"255,200,0,1")),
             Label.str(@"#F00,0.5").txtColor(Color(@"#A00,0.5")),
             Label.str(@"random,0.5").txtColor(Color(@"random,0.5")),
             Label.str(@"0xFF00FF").txtColor(Color(0xFF00FF)),
             CUISpring)
    .embedIn(self.view, NavigationContentTop + 20,20,0).gap(10);
    
}
@end
