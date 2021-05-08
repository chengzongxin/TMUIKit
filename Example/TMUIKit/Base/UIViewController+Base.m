//
//  UIViewController+Base.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/10.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UIViewController+Base.h"
#import "TDThemeManager.h"

static NSString * const kShowByUser = @"kShowByUser";

@implementation UIResponder (hideKeyboard)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        ExchangeImplementations(self, @selector(touchesBegan:withEvent:), @selector(base_touchesBegan:withEvent:));
    });
}


- (void)base_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self base_touchesBegan:touches withEvent:event];
    if ([self isKindOfClass:UIViewController.class]) {
        [[(UIViewController *)self view] endEditing:YES];
    }
}

@end

@implementation UIViewController (Base)


TMUISynthesizeIdCopyProperty(demoInstructions, setDemoInstructions)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 全局配置
        ExtendImplementationOfVoidMethodWithoutArguments([self class], @selector(viewDidLoad), ^(UIViewController *selfObject) {
            if ([selfObject tmui_getBoundBOOLForKey:kShowByUser]) {
                selfObject.view.backgroundColor = UIColor.td_backgroundColor;
                selfObject.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:NavBarBackIndicatorImage style:UIBarButtonItemStylePlain target:selfObject action:@selector(popLastViewController)];
                // 标题可复制
                TMUILabel *label = [[TMUILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
                label.text = NSStringFromClass(selfObject.class);
                label.font = NavBarTitleFont;
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = NavBarTitleColor;
                selfObject.navigationItem.titleView = label;
                // set
                label.canPerformCopyAction = YES;
                label.didCopyBlock = ^(TMUILabel * _Nonnull label, NSString * _Nonnull stringCopied) {
                    NSLog(@"%@",stringCopied);
                    [TMToast toast:stringCopied];
                };
            }
        });
        
        // 必须分类先添加方法，才能替换重写
//        ExtendImplementationOfVoidMethodWithTwoArguments(self, @selector(touchesBegan:withEvent:), NSSet<UITouch *> *, UIEvent *, ^(UIViewController *selfObject, NSSet<UITouch *> *touches, UIEvent *event) {
//
//        });
        
        ExchangeImplementations(self, @selector(touchesBegan:withEvent:), @selector(base_touchesBegan:withEvent:));
        
    });
}

- (void)popLastViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    Log(@"origin base vc touch");
}

- (void)base_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    Log(@"swizz base vc touch");
    
    [self.view endEditing:YES];
}

- (void)getFirstRegist{
    //结束键盘编辑
    __weak typeof(self)weakSelf = self;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];//注意是UITapGestureRecognizer
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];//主队列
    //在键盘出现之前，这个函数会被触发（键盘内置的方法，来获取这个通知中的消息）
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:mainQueue usingBlock:^(NSNotification *note) {
        [weakSelf.view addGestureRecognizer:tapGestureRecognizer];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:mainQueue usingBlock:^(NSNotification *note) {
        [weakSelf.view removeGestureRecognizer:tapGestureRecognizer];
    }];
}
- (void)hiddenKeyBoard{
    [self.view endEditing:YES];
}

@end


@interface UINavigationController (Base)

@end

@implementation UINavigationController (Base)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
        
        ExchangeImplementations([self class], @selector(pushViewController:animated:), @selector(tmui_pushViewController:animated:));
    });
}

- (void)tmui_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self tmui_pushViewController:viewController animated:animated];
    [viewController tmui_bindBOOL:YES forKey:kShowByUser];
}

@end

@interface UITabBarController (Base)

@end

@implementation UITabBarController (Base)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
        ExtendImplementationOfVoidMethodWithoutArguments(self, @selector(awakeFromNib), ^(__kindof UITabBarController * _Nonnull selfObject) {
            for (UINavigationController *nav in selfObject.childViewControllers) {
                [nav.topViewController tmui_bindBOOL:YES forKey:kShowByUser];
            }
        });
    });
}


@end
