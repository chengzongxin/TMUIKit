//
//  TMUICoreViewController5.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/11.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUICoreViewController5.h"


@implementation UIViewController (swizzViewDidLoad)


- (BOOL)swizzViewDidLoad{
    return [TMUIHelper executeBlock:^{
        ExchangeImplementationsInTwoClasses(UIViewController.class, @selector(viewDidLoad),self.class, @selector(tm5_viewDidLoad));
        ExchangeImplementationsInTwoClasses(UIViewController.class, @selector(viewDidLoad),self.class, @selector(tm6_viewDidLoad));
    } oncePerIdentifier:Str(self.class).a(@"swizzViewDidLoad")];
}

- (void)tm5_viewDidLoad{
    [self tm5_viewDidLoad];
    
    Log(@"执行交换方法tm5_viewDidLoad  current = %s",_cmd);
}

- (void)tm6_viewDidLoad{
    [self tm6_viewDidLoad];
    
    Log(@"执行交换方法tm6_viewDidLoad  current = %s",_cmd);
}

@end


@interface TMUICoreViewController5 ()

@property (nonatomic, strong) NSString *czx;
@property (nonatomic, strong) NSString *npp;
@property (nonatomic, strong) NSString *xyz;

@end

@implementation TMUICoreViewController5

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.czx = @"chengzongxin";
    
    id l1 = Label.str(self.demoInstructions).styles(h1);
    
    // 以高级语言的方式描述一个 objc_property_t 的各种属性，请使用 `+descriptorWithProperty` 生成对象后直接读取对象的各种值
    __block objc_property_t property_czx;
    // get prop 1
    [self tmui_enumratePropertiesUsingBlock:^(objc_property_t  _Nonnull property, NSString * _Nonnull propertyName) {
        property_czx = [propertyName isEqualToString:@"czx"] ? property : property_czx;
    }];
    
    // get prop 2
    objc_property_t prop = class_getProperty(self.class, "czx");
    TMUIPropertyDescriptor *prop_czx = [TMUIPropertyDescriptor descriptorWithProperty:prop];
    
    // get ivar
    __block Ivar ivar_czx = NULL;
    [self tmui_enumrateIvarsUsingBlock:^(Ivar  _Nonnull ivar, NSString * _Nonnull ivarDescription) {
        if ([ivarDescription containsString:@"_czx"]) {
            ivar_czx = ivar;
        }
    }];
    
    id l2 = Label.str(@"\n获取属性信息：@property (nonatomic, strong) NSString *czx;").styles(h2);
    
    id a3 = AttStr(AttStr(DebugStrN(prop_czx.name)),
                   AttStr(DebugStrN(prop_czx.getter)),
                   AttStr(DebugStrN(prop_czx.setter)),
                   AttStr(DebugStrN(prop_czx.isAtomic)),
                   AttStr(DebugStrN(prop_czx.isNonatomic)),
                   AttStr(DebugStrN(prop_czx.isAssign)),
                   AttStr(DebugStrN(prop_czx.isStrong)),
                   AttStr(DebugStrN(prop_czx.isCopy)),
                   AttStr(DebugStrN(prop_czx.isReadonly)),
                   AttStr(DebugStrN(prop_czx.isReadwrite)),
                   AttStr(DebugStrN(prop_czx.type)),
                   AttStr(DebugStrN(getObjectIvarValue(self, ivar_czx))),
                   ).styles(body).lineGap(8).match(@" \\d+(\\.\\d+)?").color(@"red");
    id l3 = Label.str(a3).multiline;
    
    id l4 = Label.str(@"判断是否重写父类方法:").styles(h2);
    
    id l5 = Label.str(DebugStr(HasOverrideSuperclassMethod(self.class, @selector(viewDidLoad)))).styles(body).fnt(11);
    
    id l6 = Label.str(DebugStr(HasOverrideSuperclassMethod(self.class, @selector(viewWillAppear:)))).styles(body).fnt(11);
    
    id l7 = Label.str(@"\n交换两个类的方法:ExchangeImplementations(并且只交换一次)").styles(h2);
    
    id b1 = Button.styles(button).str(@"点击交换viewDidLoad方法").fixWH(300,44).onClick(^{
        BOOL isSuccess = [self swizzViewDidLoad];
        [TMUITips showWithText:Str(@"方法交换%@！",isSuccess?@"成功":@"失败")];
    });
    
    id l8 = Label.str(@"\n用 block 重写某个 class 的指定方法:OverrideImplementation").styles(h2);
    id b2 = Button.styles(button).str(@"点击重写%@的viewDidLayoutSubviews方法",Str(self.class)).fixHeight(44).fnt(12).onClick(^{
        BOOL isSuccess = [TMUIHelper executeBlock:^{
            [TMUITips showWithText:Str(@"方法重写成功")];
            ExtendImplementationOfVoidMethodWithoutArguments(self.class, @selector(viewDidLayoutSubviews), ^(__kindof UIViewController * _Nonnull selfObject) {
                Log(@"invoke viewDidLayoutSubviews");
                
            });
        } oncePerIdentifier:Str(self.class).a(@"viewDidLayoutSubviews")];
        
        [TMUITips showWithText:Str(@"方法重写%@！",isSuccess?@"成功":@"失败")];
    });
        
    id l9 = Label.str(@"\n判断Ivar 是哪种类型、获取Ivar的值").styles(h2);
    
    VerStack(l1,l2,l3,l4,l5,l6,l7,b1,l8,b2,l9,CUISpring).embedIn(self.view, NavigationContentTop + 20,20,0).gap(10);
    
}



@end

