//
//  UIButton+SBLocalizable.m
//  Matafy
//
//  Created by Tiaotiao on 2019/6/19.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "UIButton+SBLocalizable.h"
#import <objc/runtime.h>

static const void *kBtnNormalTitleKey = &kBtnNormalTitleKey;
static const void *kBtnSelectedTitleKey = &kBtnSelectedTitleKey;
static const void *kBtnDisableTitleKey = &kBtnDisableTitleKey;

@implementation UIButton (SBLocalizable)

- (BOOL)textAsKey {
    return [objc_getAssociatedObject(self, @selector(textAsKey)) boolValue];
}

- (void)setTextAsKey:(BOOL)textAsKey {
    objc_setAssociatedObject(self,
                             @selector(textAsKey),
                             @(textAsKey),
                             OBJC_ASSOCIATION_ASSIGN);
    
    if (textAsKey) {
        NSString *normalTitle = [self titleForState:UIControlStateNormal];
        if (normalTitle) {
            objc_setAssociatedObject(self,
                                     kBtnNormalTitleKey,
                                     normalTitle,
                                     OBJC_ASSOCIATION_COPY_NONATOMIC);
            [self setTitle:kLStr(normalTitle) forState:UIControlStateNormal];
        }
        
        NSString *selectedTitle = [self titleForState:UIControlStateSelected];
        if (selectedTitle) {
            objc_setAssociatedObject(self,
                                     kBtnSelectedTitleKey,
                                     selectedTitle,
                                     OBJC_ASSOCIATION_COPY_NONATOMIC);
            [self setTitle:kLStr(selectedTitle) forState:UIControlStateSelected];
        }
        
        NSString *disableTitle = [self titleForState:UIControlStateDisabled];
        if (disableTitle) {
            objc_setAssociatedObject(self,
                                     kBtnDisableTitleKey,
                                     disableTitle,
                                     OBJC_ASSOCIATION_COPY_NONATOMIC);
            [self setTitle:kLStr(disableTitle) forState:UIControlStateDisabled];
        }
        
    } else {
        NSString *normalTitle = objc_getAssociatedObject(self, kBtnNormalTitleKey);
        if (normalTitle) {
            [self setTitle:normalTitle forState:UIControlStateNormal];
        }
        
        NSString *selectedTitle = objc_getAssociatedObject(self, kBtnSelectedTitleKey);
        if (selectedTitle) {
            [self setTitle:selectedTitle forState:UIControlStateSelected];
        }
        
        NSString *disableTitle = objc_getAssociatedObject(self, kBtnDisableTitleKey);
        if (disableTitle) {
            [self setTitle:disableTitle forState:UIControlStateDisabled];
        }
    }
}
@end
