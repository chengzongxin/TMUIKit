//
//  UILabel+SBLocalizable.m
//  Matafy
//
//  Created by Tiaotiao on 2019/6/19.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "UILabel+SBLocalizable.h"
#import <objc/runtime.h>

static const void *kLabelTextKey = &kLabelTextKey;

@implementation UILabel (SBLocalizable)

- (BOOL)textAskey {
    return [objc_getAssociatedObject(self, @selector(textAskey)) boolValue];
}


- (void)setTextAskey:(BOOL)textAskey {
    objc_setAssociatedObject(self,
                             @selector(textAskey),
                             @(textAskey),
                             OBJC_ASSOCIATION_ASSIGN);
    
    if (textAskey) {
        objc_setAssociatedObject(self,
                                 kLabelTextKey,
                                 self.text,
                                 OBJC_ASSOCIATION_COPY_NONATOMIC);
        self.text = kLStr(self.text);
    } else {
        self.text = objc_getAssociatedObject(self, kLabelTextKey);
    }
}

@end
