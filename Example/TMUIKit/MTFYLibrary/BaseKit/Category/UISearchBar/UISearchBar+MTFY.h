//
// Created by Fussa on 2019/10/30.
// Copyright (c) 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UISearchBar (MTFY)

/**
 * 修改SearchBar系统自带的TextField
 */
- (void)mtfy_changeSearchTextFieldWithCompletionBlock:(void(^)(UITextField *textField))completionBlock;


@end