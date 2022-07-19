//
//  UIControl+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/6/14.
//

#import "UIControl+TMUI.h"
#import <objc/runtime.h>

static const void *blkKey = "tmuiControlBlockKey";

@implementation UIControl (TMUI)

- (void)tmui_addActionBlock:(void (^)(NSInteger tag))blk
           forControlEvents:(UIControlEvents)event{
    objc_setAssociatedObject(self, blkKey, blk, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(action) forControlEvents:event];
}

- (void)tmui_action{
    void (^blk)(NSInteger) = objc_getAssociatedObject(self, blkKey);
    if (blk) {
        blk(self.tag);
    }
}

@end
