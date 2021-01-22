//
// Created by Fussa on 2019/10/30.
// Copyright (c) 2019 com.upintech. All rights reserved.
//

#import "UIViewController+ChangeDefaultPresentStyle.h"

static const char *mtfy_automaticallySetModalPresentationStyleKey;

@implementation UIViewController (ChangeDefaultPresentStyle)


+ (void)load {
    Method originAddObserverMethod = class_getInstanceMethod(self, @selector(presentViewController:animated:completion:));
    Method swizzledAddObserverMethod = class_getInstanceMethod(self, @selector(mtfy_presentViewController:animated:completion:));
    method_exchangeImplementations(originAddObserverMethod, swizzledAddObserverMethod);
}

- (void)setMtfy_automaticallySetModalPresentationStyle:(BOOL)mtfy_automaticallySetModalPresentationStyle {
      objc_setAssociatedObject(self, mtfy_automaticallySetModalPresentationStyleKey, @(mtfy_automaticallySetModalPresentationStyle), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)mtfy_automaticallySetModalPresentationStyle {
    id obj = objc_getAssociatedObject(self, mtfy_automaticallySetModalPresentationStyleKey);
    if (obj) {
        return [obj boolValue];
    }
    return [self.class mtfy_automaticallySetModalPresentationStyle];
}

+ (BOOL)mtfy_automaticallySetModalPresentationStyle {
    if ([self isKindOfClass:[UIImagePickerController class]] || [self isKindOfClass:[UIAlertController class]]) {
        return NO;
    }
    return YES;
}

- (void)mtfy_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (@available(iOS 13.0, *)) {
        if (viewControllerToPresent.mtfy_automaticallySetModalPresentationStyle) {
            viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        [self mtfy_presentViewController:viewControllerToPresent animated:flag completion:completion];
    } else {
        [self mtfy_presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}


@end

