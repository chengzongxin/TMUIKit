//
//  UIButton+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/22.
//

#import "UIButton+TMUI.h"
#import <objc/runtime.h>

@implementation UIButton (TMUI)


+ (instancetype)tmui_button {
    return [self buttonWithType:UIButtonTypeCustom];
}

- (void)setTmui_text:(NSString *)tmui_text{
    [self setTitle:tmui_text forState:UIControlStateNormal];
}

- (NSString *)tmui_text{
    return self.currentTitle;
}

- (void)setTmui_font:(UIFont *)tmui_font{
    self.titleLabel.font = tmui_font;
}

- (UIFont *)tmui_font{
    return self.titleLabel.font;
}

- (void)setTmui_attrText:(NSAttributedString *)tmui_attrText{
    [self setAttributedTitle:tmui_attrText forState:UIControlStateNormal];
}

- (NSAttributedString *)tmui_attrText{
    return self.currentAttributedTitle;
}

- (void)setTmui_titleColor:(UIColor *)tmui_titleColor{
    [self setTitleColor:tmui_titleColor forState:UIControlStateNormal];
}

- (UIColor *)tmui_titleColor{
    return [self titleColorForState:UIControlStateNormal];
}

- (void)setTmui_image:(UIImage *)tmui_image{
    [self setImage:tmui_image forState:UIControlStateNormal];
}

- (UIImage *)tmui_image{
    return [self imageForState:UIControlStateNormal];
}

- (void)tmui_addTarget:(nullable id)target action:(nonnull SEL)sel {
    [self addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
}

- (void)tmui_setNormalTitle:(NSString *)normalTitle selectedTitle:(NSString *)selectedTitle{
    [self setTitle:normalTitle forState:UIControlStateNormal];
    [self setTitle:selectedTitle forState:UIControlStateSelected];
}

- (void)tmui_setNormalBackGroundColor:(UIColor *)normalColor selectedBackGroundColor:(UIColor *)selectedColor{
    // style
    UIImage *enableBGImage = [self imageWithColor:normalColor];
    UIImage *selectedBGImage = [self imageWithColor:selectedColor];
    [self setBackgroundImage:enableBGImage forState:UIControlStateNormal];
    [self setBackgroundImage:selectedBGImage forState:UIControlStateSelected];
}


- (void)tmui_setNormalBackGroundColor:(UIColor *)normalColor disableBackGroundColor:(UIColor *)disableColor{
    // style
    UIImage *enableBGImage = [self imageWithColor:normalColor];
    UIImage *disableBGImage = [self imageWithColor:disableColor];
    [self setBackgroundImage:enableBGImage forState:UIControlStateNormal];
    [self setBackgroundImage:disableBGImage forState:UIControlStateDisabled];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)tmui_buttonWithText:(NSString *)text textColor:(UIColor *)textColor font:(CGFloat)font{
    UIButton *btn = [self buttonWithType:UIButtonTypeCustom];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    return btn;
}

+ (instancetype)tmui_buttonWithText:(NSString *)text textColor:(UIColor *)textColor font:(CGFloat)font backgoundColor:(UIColor *)backgroudColor target:(id)target action:(SEL)sel{
    UIButton *btn = [self buttonWithType:UIButtonTypeCustom];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    btn.backgroundColor = backgroudColor;
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)setTmui_click:(void (^)(void))tmui_click{
    self.userInteractionEnabled = YES;
    objc_setAssociatedObject(self, @selector(tmui_click), tmui_click, OBJC_ASSOCIATION_COPY);
    [self addTarget:self action:@selector(tmui_clickHandle:) forControlEvents:UIControlEventTouchUpInside];
}

- (void (^)(void))tmui_click{
    return objc_getAssociatedObject(self, _cmd);
}


- (void)tmui_clickHandle:(UIButton *)button {
    void(^action)(void) =  objc_getAssociatedObject(self, @selector(tmui_click));
    if (action) {
        action();
    }
}


@end


@implementation UIButton (TMUI_Layout)


- (void)tmui_buttonImageTitleWithStyle:(TMUIButtonImageTitleStyle)style
                             padding:(CGFloat)padding {
    if (self.imageView.image != nil && self.titleLabel.text != nil) {
        
        //先还原
        self.titleEdgeInsets = UIEdgeInsetsZero;
        self.imageEdgeInsets = UIEdgeInsetsZero;
        
        CGRect imageRect = self.imageView.frame;
        CGRect titleRect = self.titleLabel.frame;
        
        CGFloat totalHeight = imageRect.size.height + padding + titleRect.size.height;
        CGFloat selfHeight = self.frame.size.height;
        CGFloat selfWidth = self.frame.size.width;
        
        switch (style) {
            case TMUIButtonImageTitleStyleLeft:
                if (padding != 0) {
                    self.titleEdgeInsets = UIEdgeInsetsMake(0, padding / 2, 0, -padding / 2);
                    self.imageEdgeInsets = UIEdgeInsetsMake(0, -padding / 2, 0, padding / 2);
                }
                break;
            case TMUIButtonImageTitleStyleRight: {
                //图片在右，文字在左
                self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageRect.size.width + padding / 2), 0, (imageRect.size.width + padding / 2));
                self.imageEdgeInsets = UIEdgeInsetsMake(0, (titleRect.size.width + padding / 2), 0, -(titleRect.size.width + padding / 2));
            }
                break;
            case TMUIButtonImageTitleStyleTop: {
                //图片在上，文字在下
                self.titleEdgeInsets = UIEdgeInsetsMake(
                                                        ((selfHeight - totalHeight) / 2 + imageRect.size.height + padding - titleRect.origin.y),
                                                        (selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                        -((selfHeight - totalHeight) / 2 + imageRect.size.height + padding - titleRect.origin.y),
                                                        -(selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsetsMake(
                                                        ((selfHeight - totalHeight) / 2 - imageRect.origin.y),
                                                        (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                        -((selfHeight - totalHeight) / 2 - imageRect.origin.y),
                                                        -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
                
            }
                break;
            case TMUIButtonImageTitleStyleBottom: {
                //图片在下，文字在上。
                self.titleEdgeInsets = UIEdgeInsetsMake(
                                                        ((selfHeight - totalHeight) / 2 - titleRect.origin.y),
                                                        (selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                        -((selfHeight - totalHeight) / 2 - titleRect.origin.y),
                                                        -(selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsetsMake(
                                                        ((selfHeight - totalHeight) / 2 + titleRect.size.height + padding - imageRect.origin.y),
                                                        (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                        -((selfHeight - totalHeight) / 2 + titleRect.size.height + padding - imageRect.origin.y),
                                                        -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
            }
                break;
            case TMUIButtonImageTitleStyleCenterTop: {
                self.titleEdgeInsets = UIEdgeInsetsMake(
                                                        -(titleRect.origin.y - padding),
                                                        (selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                        (titleRect.origin.y - padding),
                                                        -(selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsetsMake(
                                                        0,
                                                        (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                        0,
                                                        -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
            }
                break;
            case TMUIButtonImageTitleStyleCenterBottom: {
                self.titleEdgeInsets = UIEdgeInsetsMake(
                                                        (selfHeight - padding - titleRect.origin.y - titleRect.size.height),
                                                        (selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                        -(selfHeight - padding - titleRect.origin.y - titleRect.size.height),
                                                        -(selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                        (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                                        0,
                                                        -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
            }
                break;
            case TMUIButtonImageTitleStyleCenterUp: {
                self.titleEdgeInsets = UIEdgeInsetsMake(
                                                        -(titleRect.origin.y + titleRect.size.height - imageRect.origin.y + padding),
                                                        (selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                        (titleRect.origin.y + titleRect.size.height - imageRect.origin.y + padding),
                                                        -(selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsetsMake(0, (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2), 0, -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
            }
                break;
            case TMUIButtonImageTitleStyleCenterDown: {
                self.titleEdgeInsets = UIEdgeInsetsMake(
                                                        (imageRect.origin.y + imageRect.size.height - titleRect.origin.y + padding),
                                                        (selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                                        -(imageRect.origin.y + imageRect.size.height - titleRect.origin.y + padding),
                                                        -(selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2);
                
                self.imageEdgeInsets = UIEdgeInsetsMake(0, (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2), 0, -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2));
            }
                break;
            case TMUIButtonImageTitleStyleRightLeft: {
                //图片在右，文字在左，距离按钮两边边距
                self.titleEdgeInsets = UIEdgeInsetsMake(0, -(titleRect.origin.x - padding), 0, (titleRect.origin.x - padding));
                self.imageEdgeInsets = UIEdgeInsetsMake(0, (selfWidth - padding - imageRect.origin.x - imageRect.size.width), 0, -(selfWidth - padding - imageRect.origin.x - imageRect.size.width));
            }
                break;
            case TMUIButtonImageTitleStyleLeftRight: {
                //图片在左，文字在右，距离按钮两边边距
                self.titleEdgeInsets = UIEdgeInsetsMake(0, (selfWidth - padding - titleRect.origin.x - titleRect.size.width), 0, -(selfWidth - padding - titleRect.origin.x - titleRect.size.width));
                self.imageEdgeInsets = UIEdgeInsetsMake(0, -(imageRect.origin.x - padding), 0, (imageRect.origin.x - padding));
            }
                break;
            default:
                break;
        }
    } else {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}


@end



@implementation UIButton (TMUI_EnlargeEdge)
static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;


- (void)tmui_setEnlargeEdge:(CGFloat)size
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)tmui_setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect
{
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}

- (UIView*)hitTest:(CGPoint) point withEvent:(UIEvent*) event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

@end
