//
//  TDThemeGlobalConfig.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/7/29.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TDThemeGlobalConfig.h"

@implementation TDThemeGlobalConfig

@end


@implementation UITableViewCell (Base)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        OverrideImplementation([UITableViewCell class], @selector(initWithStyle:reuseIdentifier:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^UITableViewCell *(UITableViewCell *selfObject, UITableViewCellStyle firstArgv, NSString *secondArgv) {
                // call super
                UITableViewCell *(*originSelectorIMP)(id, SEL, UITableViewCellStyle, NSString *);
                originSelectorIMP = (UITableViewCell *(*)(id, SEL, UITableViewCellStyle, NSString *))originalIMPProvider();
                UITableViewCell *result = originSelectorIMP(selfObject, originCMD, firstArgv, secondArgv);
                
                result.backgroundColor = TableViewBackgroundColor;
                
                return result;
            };
        });
        
        
        
    });
}

@end

@implementation UITableView (Base)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        OverrideImplementation([UITableView class], @selector(initWithFrame:style:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^UITableView *(UITableView *selfObject, CGRect firstArgv, UITableViewStyle secondArgv) {
                
                // call super
                UITableView *(*originSelectorIMP)(id, SEL, CGRect, UITableViewStyle);
                originSelectorIMP = (UITableView *(*)(id, SEL, CGRect, UITableViewStyle))originalIMPProvider();
                UITableView *result = originSelectorIMP(selfObject, originCMD, firstArgv, secondArgv);
                
                result.backgroundColor = TableViewBackgroundColor;
                
                return result;
            };
        });
        
        
        
    });
}

@end
