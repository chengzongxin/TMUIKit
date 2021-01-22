//
// Created by Fussa on 2019/10/30.
// Copyright (c) 2019 com.upintech. All rights reserved.
//

#import "UISearchBar+MTFY.h"


@implementation UISearchBar (MTFY)

/// 修改SearchBar系统自带的TextField
- (void)mtfy_changeSearchTextFieldWithCompletionBlock:(void(^)(UITextField *textField))completionBlock {

    if (!completionBlock) {
        return;
    }
    UITextField *textField = [self mtfy_findTextFieldWithView:self];
    if (textField) {
        completionBlock(textField);
    }
}

/// 递归遍历UISearchBar的子视图，找到UITextField
- (UITextField *)mtfy_findTextFieldWithView:(UIView *)view {

    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            return (UITextField *)subview;
        }else if (subview.subviews.count > 0) {
            return [self mtfy_findTextFieldWithView:subview];
        }
    }
    return nil;
}

@end