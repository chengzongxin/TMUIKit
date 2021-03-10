//
//  TMUICoreViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/10.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUICoreViewController.h"

@interface TMUICoreViewController ()



@end

@implementation TMUICoreViewController


TMAssociatedPropertyStrongTypeSetterGetter(NSString, method1);

TMUISynthesizeIdStrongProperty(method2, setMethod2);

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bgColor(@"white");
    
    id l1 = Label.str(self.demoInstructions).styles(@"h1");
    
    id a2 = AttStr(
                   AttStr(@"提供两种方式快捷关联对象\n"),
                   AttStr(@"方式一：需要传入var类型\n"),
                   AttStr(@"TMAssociatedPropertyStrongType(NSString, method1);\n"),
                   AttStr(@"TMAssociatedPropertyStrongTypeSetterGetter(NSString, method1);\n\n"),
                   AttStr(@"方式二：包含各种数据类型可供选择,id,weak,copy,基本类型等。\n"),
                   AttStr(@"@property (nonatomic, strong) NSString *method2;\n"),
                   AttStr(@"TMUISynthesizeIdStrongProperty(method2, setMethod2);\n"),
                   ).styles(@"h2");
    id l2 = Label.str(a2).multiline;
    
    VerStack(l1,l2,CUISpring).embedIn(self.view, NavigationContentTop + 20,20,0).gap(30);
    
    
    self.method1 = @"method111111";
    self.method2 = @"method222222";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    Log(self.method1);
    Log(self.method2);
}


@end
