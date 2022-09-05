//
//  UICollectionViewCell+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/4/16.
//

#import "UICollectionViewCell+TMUI.h"
#import "TMUICore.h"

@interface UICollectionViewCell ()
@property(nonatomic, strong) UIView *tmuicvc_selectedBackgroundView;
@end

@implementation UICollectionViewCell (TMUI)

TMUISynthesizeIdStrongProperty(tmuicvc_selectedBackgroundView, setTmuicvc_selectedBackgroundView)

static char kAssociatedObjectKey_selectedBackgroundColor;
- (void)setTmui_selectedBackgroundColor:(UIColor *)tmui_selectedBackgroundColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_selectedBackgroundColor, tmui_selectedBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (tmui_selectedBackgroundColor && !self.selectedBackgroundView && !self.tmuicvc_selectedBackgroundView) {
        self.tmuicvc_selectedBackgroundView = UIView.new;
        self.selectedBackgroundView = self.tmuicvc_selectedBackgroundView;
    }
    if (self.tmuicvc_selectedBackgroundView) {
        self.tmuicvc_selectedBackgroundView.backgroundColor = tmui_selectedBackgroundColor;
    }
}

- (UIColor *)tmui_selectedBackgroundColor {
    return (UIColor *)objc_getAssociatedObject(self, &kAssociatedObjectKey_selectedBackgroundColor);
}

@end
