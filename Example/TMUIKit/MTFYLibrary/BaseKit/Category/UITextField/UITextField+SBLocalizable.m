//
//  UITextField+SBLocalizable.m
//  Matafy
//
//  Created by Fussa on 2019/7/2.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "UITextField+SBLocalizable.h"
#import <objc/runtime.h>

static const void *kTextFieldTextKey = &kTextFieldTextKey;

@implementation UITextField (SBLocalizable)

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
                                 kTextFieldTextKey,
                                 self.placeholder,
                                 OBJC_ASSOCIATION_COPY_NONATOMIC);
        self.placeholder = kLStr(self.placeholder);
    } else {
        self.placeholder = objc_getAssociatedObject(self, kTextFieldTextKey);
    }
}

@end
