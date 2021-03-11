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

// method 1
TMAssociatedPropertyStrongTypeSetterGetter(NSString, method1);
// method 2
TMUISynthesizeIdStrongProperty(method2, setMethod2);
// method 3
- (void)setMethod3:(NSString *)method3{
    TMUIWeakObjectContainer *container = [TMUIWeakObjectContainer containerWithObject:method3];
    objc_setAssociatedObject(self, @selector(method3), container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)method3{
    TMUIWeakObjectContainer *container = objc_getAssociatedObject(self, @selector(tmui_emptyView));
    return container.object ?: nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bgColor(@"white");
    
    id l1 = Label.str(self.demoInstructions).styles(h1);
    
    id l2 = Label.str(@"提供三种方式快捷关联对象").styles(h2);
    
    id a3 = AttStr(
                   AttStr(@"方式一：需要传入var类型\n").styles(h3),
                   AttStr(@"TMAssociatedPropertyStrongType(NSString, method1);\n").styles(body),
                   AttStr(@"TMAssociatedPropertyStrongTypeSetterGetter(NSString, method1);\n\n").styles(body),
                   AttStr(@"方式二：包含各种数据类型可供选择,id,weak,copy,基本类型等。\n").styles(h3),
                   AttStr(@"@property (nonatomic, strong) NSString *method2;\n").styles(body),
                   AttStr(@"TMUISynthesizeIdStrongProperty(method2, setMethod2);\n\n").styles(body),
                   AttStr(@"方式三：TMUIWeakObjectContainer使用弱引用容器类，避免关联对象释放产生野指针crash。\n").styles(h3),
                   AttStr(@"@property (nonatomic, nullable, weak) NSString *method3;\n").styles(body),
                   AttStr(@"- (void)setMethod3:(NSString *)method3{\n\
                          TMUIWeakObjectContainer *container = [TMUIWeakObjectContainer containerWithObject:method3];\
                          objc_setAssociatedObject(self, @selector(method3), container,\ OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
                      }\
                      - (NSString *)method3{\
                          TMUIWeakObjectContainer *container = objc_getAssociatedObject(self,\ @selector(tmui_emptyView));\
                          return container.object ?: nil;\
                      };\n").styles(body),
                   );
    id l3 = Label.str(a3).multiline;
    
    
    VerStack(l1,l2,l3,CUISpring).embedIn(self.view, NavigationContentTop + 20,20,0).gap(30);
    
    
    self.method1 = @"method111111";
    self.method2 = @"method222222";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    Log(self.method1);
    Log(self.method2);
}


@end
