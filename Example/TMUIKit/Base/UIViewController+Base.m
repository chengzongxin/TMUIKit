//
//  UIViewController+Base.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/10.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UIViewController+Base.h"

@implementation UIViewController (Base)


+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        ExchangeImplementations([self class], @selector(viewDidLoad), @selector(tmui_viewDidLoad));
        
//        ExtendImplementationOfVoidMethodWithSingleArgument([UIViewController class], @selector(viewWillAppear:), ^(UIViewController *selfObject) {
//            selfObject.view.backgroundColor = UIColor.redColor;
//        });
        
//        ExtendImplementationOfVoidMethodWithSingleArgument([self class], @selector(viewWillAppear:), BOOL, ^(UIViewController *selfObject, BOOL animate) {
//            selfObject.navigationItem.title = NSStringFromClass(selfObject.class);
//        });
        [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
        
        ExtendImplementationOfVoidMethodWithoutArguments([self class], @selector(viewDidLoad), ^(UIViewController *selfObject) {
            TMUILabel *label = [[TMUILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
            label.text = NSStringFromClass(selfObject.class);
            label.font = UIFontMedium(18);
            label.textAlignment = NSTextAlignmentCenter;
            selfObject.navigationItem.titleView = label;
            // set
            label.canPerformCopyAction = YES;
            label.didCopyBlock = ^(TMUILabel * _Nonnull label, NSString * _Nonnull stringCopied) {
                NSLog(@"%@",stringCopied);
                [TMToast toast:stringCopied];
            };
            
        });
    });
}

//- (void)tmui_viewDidLoad{
//    [self tmui_viewDidLoad];
//
//    self.view.bgColor(@"white");
//
//    Log(@"tmui_viewDidLoad");
//}

@end


@interface UINavigationController (Base)

@end

@implementation UINavigationController (Base)

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    viewController.view.backgroundColor = UIColor.whiteColor;
//}

@end
