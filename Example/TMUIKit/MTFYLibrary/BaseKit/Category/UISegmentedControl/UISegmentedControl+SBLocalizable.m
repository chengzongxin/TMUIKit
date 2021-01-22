//
//  UISegmentedControl+SBLocalizable.m
//  Matafy
//
//  Created by Tiaotiao on 2019/6/19.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "UISegmentedControl+SBLocalizable.h"
#import <objc/runtime.h>

@implementation UISegmentedControl (SBLocalizable)

- (BOOL)textAsKey {
    return [objc_getAssociatedObject(self, @selector(textAsKey)) boolValue];
}

- (void)setTextAsKey:(BOOL)textAsKey {
    objc_setAssociatedObject(self,
                             @selector(textAsKey),
                             @(textAsKey),
                             OBJC_ASSOCIATION_ASSIGN);
    
    if (textAsKey) {
        for (NSInteger i = 0; i < self.numberOfSegments; i++) {
            NSString *title = [self titleForSegmentAtIndex:i];
            [self setTitle:kLStr(title) forSegmentAtIndex:i];
        }
        
    } else {
        //        for (NSInteger i = 0; i < self.numberOfSegments; i++) {
        //            NSString *title = objc_getAssociatedObject(self, &keyId);
        //            [self setTitle:title forSegmentAtIndex:i];
        //        }
    }
}
@end
