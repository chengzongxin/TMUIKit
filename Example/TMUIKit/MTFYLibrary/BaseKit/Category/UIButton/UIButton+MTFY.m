//
//  UIButton+MTFY.m
//  Matafy
//
// Created by Fussa on 2019/12/2.
// Copyright (c) 2019 com.upintech. All rights reserved.
//
#import "UIButton+MTFY.h"
#import <objc/runtime.h>

static const char *mtfy_p_clickWithBlockKey;


@implementation UIButton (MTFY)

- (void)mtfy_clickWithBlock:(void (^)(void))block {
    self.userInteractionEnabled = YES;
    [self addTarget:self action:@selector(p_clickHandle:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(self, &mtfy_p_clickWithBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)p_clickHandle:(UIButton *)button {
    void(^action)(void) =  objc_getAssociatedObject(self, &mtfy_p_clickWithBlockKey);
    if (action) {
        action();
    }
}


@end