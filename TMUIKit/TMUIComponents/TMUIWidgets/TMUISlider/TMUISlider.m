//
//  TMUISlider.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/11.
//

#import "TMUISlider.h"
#import <TMUIExtensions/NSObject+TMUI.h>
#import <TMUIExtensions/UIImage+TMUI.h>
#import <TMUICore/TMUICoreGraphicsDefines.h>

@implementation TMUISlider


- (void)setThumbSize:(CGSize)thumbSize {
    _thumbSize = thumbSize;
    [self updateThumbImage];
}

- (void)setThumbColor:(UIColor *)thumbColor {
    _thumbColor = thumbColor;
    [self updateThumbImage];
}

- (void)updateThumbImage {
    if (!CGSizeIsEmpty(self.thumbSize)) {
        UIColor *thumbColor = self.thumbColor ?: self.tintColor;
        UIImage *thumbImage = [UIImage tmui_imageWithShape:TMUIImageShapeOval size:_thumbSize tintColor:thumbColor];
        [self setThumbImage:thumbImage forState:UIControlStateNormal];
        [self setThumbImage:thumbImage forState:UIControlStateHighlighted];
    }
}

- (void)setThumbShadowColor:(UIColor *)thumbShadowColor {
    _thumbShadowColor = thumbShadowColor;
    UIView *thumbView = [self thumbViewIfExist];
    if (thumbView) {
        thumbView.layer.shadowColor = _thumbShadowColor.CGColor;
        thumbView.layer.shadowOpacity = _thumbShadowColor ? 1 : 0;
    }
}

- (void)setThumbShadowOffset:(CGSize)thumbShadowOffset {
    _thumbShadowOffset = thumbShadowOffset;
    UIView *thumbView = [self thumbViewIfExist];
    if (thumbView) {
        thumbView.layer.shadowOffset = _thumbShadowOffset;
    }
}

- (void)setThumbShadowRadius:(CGFloat)thumbShadowRadius {
    _thumbShadowRadius = thumbShadowRadius;
    UIView *thumbView = [self thumbViewIfExist];
    if (thumbView) {
        thumbView.layer.shadowRadius = thumbShadowRadius;
    }
}

- (UIView *)thumbViewIfExist {
    // thumbView 并非在一开始就存在，而是在某个时机才生成的，所以可能返回 nil
    UIView *thumbView = [self tmui_valueForKey:@"thumbView"];
    return thumbView;
}

#pragma mark - Override

- (CGRect)trackRectForBounds:(CGRect)bounds {
    CGRect result = [super trackRectForBounds:bounds];
    if (self.trackHeight == 0) {
        return result;
    }
    
    result = CGRectSetHeight(result, self.trackHeight);
    result = CGRectSetY(result, CGFloatGetCenter(CGRectGetHeight(bounds), CGRectGetHeight(result)));
    return result;
}

- (void)didAddSubview:(UIView *)subview {
    [super didAddSubview:subview];
    if (subview && subview == [self thumbViewIfExist]) {
        UIView *thumbView = subview;
        thumbView.layer.shadowColor = self.thumbShadowColor.CGColor;
        thumbView.layer.shadowOpacity = self.thumbShadowColor ? 1 : 0;
        thumbView.layer.shadowOffset = self.thumbShadowOffset;
        thumbView.layer.shadowRadius = self.thumbShadowRadius;
    }
}

@end
