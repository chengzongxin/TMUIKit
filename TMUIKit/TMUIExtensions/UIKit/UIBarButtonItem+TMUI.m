//
//  UIBarButtonItem+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/4.
//

#import "UIBarButtonItem+TMUI.h"
#import "UIButton+TMUI.h"
#import <objc/runtime.h>
#import "TMUIConfigurationMacros.h"
#import "UIImage+TMUI.h"

// 导航条上相关按钮的宽高定义，通常情况下均为44x44 | 且按钮的icon的size应该规范为24x24
#define TMUIWidth_NavigationBarButton      (44)
#define TMUIHeight_NavigationBarButton     (44)

@interface _TMUIBarButtonItemBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);

- (id)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation _TMUIBarButtonItemBlockTarget

- (id)initWithBlock:(void (^)(id sender))block{
    self = [super init];
    if (self) {
        _block = [block copy];
    }
    return self;
}

- (void)invoke:(id)sender {
    if (self.block) self.block(sender);
}

@end


@implementation UIBarButtonItem (TMUI)

#pragma mark - Image
+ (UIBarButtonItem *)tmui_itemWithImage:(UIImage *)image
                                 target:(id)target
                                 action:(SEL)action{
    return [self tmui_itemWithNomalImage:image
                        higeLightedImage:nil
                         imageEdgeInsets:UIEdgeInsetsZero
                                  target:target
                                  action:action];
}

+ (UIBarButtonItem *)tmui_itemWithImage:(UIImage *)image
                        imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
                                 target:(id)target
                                 action:(SEL)action{
    return [self tmui_itemWithNomalImage:image
                        higeLightedImage:nil
                         imageEdgeInsets:imageEdgeInsets
                                  target:target
                                  action:action];
}

+ (UIBarButtonItem *)tmui_itemWithNomalImage:(UIImage *) nomalImage
                            higeLightedImage:(UIImage *)higeLightedImage
                             imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
                                      target:(id)target
                                      action:(SEL)action{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button setImage:nomalImage forState:UIControlStateNormal];
    if (higeLightedImage) {
        [button setImage:higeLightedImage forState:UIControlStateHighlighted];
    } else {
        [button setImage:[nomalImage tmui_imageWithAlpha:0.5]
                forState:UIControlStateHighlighted];
    }
    [button sizeToFit];
    if (button.bounds.size.width < TMUIWidth_NavigationBarButton) {
        CGFloat width = TMUIHeight_NavigationBarButton / button.bounds.size.height * button.bounds.size.width;
        button.frame = CGRectMake(0, 0, width, TMUIHeight_NavigationBarButton);
    }
    if (button.bounds.size.height > TMUIHeight_NavigationBarButton) {
        CGFloat height = TMUIWidth_NavigationBarButton / button.bounds.size.width * button.bounds.size.height;
        button.frame = CGRectMake(0, 0, TMUIWidth_NavigationBarButton, height);
    }
    button.imageEdgeInsets = imageEdgeInsets;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


#pragma mark - Title
+ (UIBarButtonItem *)tmui_itemWithTitle:(NSString *)title
                                 target:(id)target
                                 action:(SEL)action{
    return [self tmui_itemWithTitle:title
                    titleColorStyle:UIBarButtonItem_TMUIColorStyleBlack
                    titleEdgeInsets:UIEdgeInsetsZero
                             target:target
                             action:action];
}

+ (UIBarButtonItem *)tmui_itemWithTitle:(NSString *)title
                        titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
                                 target:(id)target
                                 action:(SEL)action{
    return [self tmui_itemWithTitle:title
                    titleColorStyle:UIBarButtonItem_TMUIColorStyleBlack
                    titleEdgeInsets:titleEdgeInsets
                             target:target
                             action:action];
}


+ (UIBarButtonItem *)tmui_itemWithTitle:(NSString *)title
                         titleColorStyle:(UIBarButtonItem_TMUIColorStyle)titleColorStyle target:(id)target
                                 action:(SEL)action{
    return [self tmui_itemWithTitle:title
                    titleColorStyle:titleColorStyle
                    titleEdgeInsets:UIEdgeInsetsZero
                             target:target
                              action:action];
}

+ (UIBarButtonItem *)tmui_itemWithTitle:(NSString *)title
                         titleColorStyle:(UIBarButtonItem_TMUIColorStyle)titleColorStyle
                         titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
                                 target:(id)target
                                 action:(SEL)action{
    return [self _tmui_itemWithTitle:title
                      titleColorStyle:titleColorStyle
                      titleEdgeInsets:titleEdgeInsets
                              target:target
                               action:action];
}

+ (UIBarButtonItem *)_tmui_itemWithTitle:(NSString *)title
                          titleColorStyle:(UIBarButtonItem_TMUIColorStyle)titleColorStyle
                          titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
                                  target:(id)target
                                  action:(SEL)action{
    //config font & textColor
    UIColor *textColor;
    if (titleColorStyle == UIBarButtonItem_TMUIColorStyleWhite) {
        textColor = NavBarItemLightColor;
    }else if (titleColorStyle == UIBarButtonItem_TMUIColorStyleTheme) {
        textColor = NavBarItemThemeColor;
    }else if (titleColorStyle == UIBarButtonItem_TMUIColorStyleBlack) {
        textColor = NavBarItemDarkColor;
    }
    UIColor *highlightTextColor = [textColor colorWithAlphaComponent:0.5];
    UIFont *textFont = NavBarItemFont;
    //
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = textFont;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setTitleColor:highlightTextColor forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button sizeToFit];
    
    CGSize lblBtnSize = button.intrinsicContentSize;
    
    if (button.bounds.size.width < TMUIWidth_NavigationBarButton) {
        CGFloat width = TMUIHeight_NavigationBarButton / button.bounds.size.height * button.bounds.size.width;
        button.frame = CGRectMake(0, 0, width, TMUIHeight_NavigationBarButton);
    }
    if (button.bounds.size.height > TMUIHeight_NavigationBarButton) {
        CGFloat height = TMUIWidth_NavigationBarButton / button.bounds.size.width * button.bounds.size.height;
        button.frame = CGRectMake(0, 0, TMUIWidth_NavigationBarButton, height);
    }
    
    //需要根据edgeInsets调整宽度
    if (titleEdgeInsets.left != 0 ||
        titleEdgeInsets.right != 0) {
        
        CGFloat fitWidth = lblBtnSize.width + fabs(titleEdgeInsets.left) + fabs(titleEdgeInsets.right);
        if (fitWidth <= button.frame.size.width) {
            //小于某范围时按原逻辑直接将insets参数传递给titleEdgeInsets
            button.titleEdgeInsets = titleEdgeInsets;
        }else {
            //当大于某范围时，需要特殊修正一下数字，防止text显示被截断或过多偏移
            UIEdgeInsets fitEdgeInsets = UIEdgeInsetsZero;
            //注意：inset.left和inset.right > 0时表示文本左或右距离按钮的左或右边需要一些额外的间隔;
            //当 < 0 时表示需要将Lbl向left或right移动一些距离
            //适配后的inset位移始终是在新的fitWidth的居中位置进行左右偏移
            if ((titleEdgeInsets.left >= 0 && titleEdgeInsets.right >= 0) ||
                (titleEdgeInsets.left <= 0 && titleEdgeInsets.right <= 0)) {
                //(left >= 0 && right >= 0) || (left <= 0 && right <= 0)
                // | left , --lbl-- , right | ==> fitWidth: left+lbl.width+right,
                //inset.left = (left-right)/2, inset.right = -inset.left
                CGFloat left = fabs(titleEdgeInsets.left);
                CGFloat right = fabs(titleEdgeInsets.right);
                
                fitWidth = lblBtnSize.width + left + right;
                fitEdgeInsets.left = (left - right)/2;
                fitEdgeInsets.right = -fitEdgeInsets.left;
            }else if (titleEdgeInsets.left >= 0) {
                //left >= 0 && right < 0,
                if (fabs(titleEdgeInsets.left) == fabs(titleEdgeInsets.right)) {
                    fitWidth = lblBtnSize.width + fabs(titleEdgeInsets.left);
                    fitEdgeInsets.left = (titleEdgeInsets.left)/2;
                    fitEdgeInsets.right = -fitEdgeInsets.left;
                }else {
                    CGFloat left = titleEdgeInsets.left;
                    CGFloat right = fabs(titleEdgeInsets.right);
                    CGFloat addWidth = MAX(left, right);
                    fitWidth = lblBtnSize.width + addWidth;
                    fitEdgeInsets.left = left - addWidth/2;
                    fitEdgeInsets.right = -fitEdgeInsets.left;
                }
                
            }else {
                //left < 0 && right >= 0
                if (fabs(titleEdgeInsets.left) == fabs(titleEdgeInsets.right)) {
                    fitWidth = lblBtnSize.width + fabs(titleEdgeInsets.left);
                    fitEdgeInsets.left = (titleEdgeInsets.left)/2;
                    fitEdgeInsets.right = -fitEdgeInsets.left;
                }else {
                    CGFloat left = fabs(titleEdgeInsets.left);
                    CGFloat right = fabs(titleEdgeInsets.right);
                    CGFloat addWidth = MAX(left, right);
                    fitWidth = lblBtnSize.width + addWidth;
                    fitEdgeInsets.right = right - addWidth/2;
                    fitEdgeInsets.left = -fitEdgeInsets.right;
                    
                }
                
            }
            
            //
            CGRect rt = button.frame;
            rt.size.width = fitWidth;
            button.frame = rt;
            button.titleEdgeInsets = fitEdgeInsets;
        }
    }
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


#pragma mark - Flexible item
+ (instancetype)tmui_fixedSpaceItemWithWidth:(CGFloat)width {
    UIBarButtonItem *item = [[self alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
    item.width = width;
    return item;
}

+ (instancetype)tmui_flexibleSpaceItem {
    return [[self alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
}

//static const int block_key;

- (void)setTmui_actionBlock:(void (^)(id sender))block {
    _TMUIBarButtonItemBlockTarget *target = [[_TMUIBarButtonItemBlockTarget alloc] initWithBlock:block];
    objc_setAssociatedObject(self, @selector(tmui_actionBlock), target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setTarget:target];
    [self setAction:@selector(invoke:)];
}

- (void (^)(id))tmui_actionBlock {
    _TMUIBarButtonItemBlockTarget *target = objc_getAssociatedObject(self, _cmd);
    return target.block;
}





//#pragma mark - TMUI BarButton
//- (instancetype)tmui_initWithTitle:(NSString *)title target:(id)target action:(SEL)action{
//    return [self tmui_initWithTitle:title color:NavBarItemLightColor font:NavBarItemFont target:target action:action];
//}
//
//+ (instancetype)tmui_itemWithTitle:(NSString *)title target:(id)target action:(SEL)action{
//    return [[self alloc] tmui_initWithTitle:title target:target action:action];
//}
//
//
//- (instancetype)tmui_initWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action{
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *img = [UIImage imageNamed:icon];
//    [btn setImage:img forState:UIControlStateNormal];
//
//    if (highlighted) {
//        [btn setImage:[UIImage imageNamed:highlighted] forState:UIControlStateHighlighted];
//    }else{
//        [btn setImage:[img tmui_imageWithAlpha:0.5] forState:UIControlStateHighlighted];
//    }
//
//    btn.frame = (CGRect){CGPointZero,img.size};
//
//    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    [btn tmui_setEnlargeEdge:50];
//    return [self initWithCustomView:btn];
//
//}
//
//+ (instancetype)tmui_itemWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action{
//    return [[self alloc] tmui_initWithIcon:icon highlightedIcon:highlighted target:target action:action];
//}
//
//- (instancetype)tmui_initWithTitle:(NSString *)title icon:(NSString *)icon target:(id)target action:(SEL)action{
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//
//    UIImage *img = [UIImage imageNamed:icon];
//
//    [btn setImage:img forState:UIControlStateNormal];
//
//    btn.titleLabel.text = title;
//
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//    btn.frame = (CGRect){CGPointZero,img.size};
//
//    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//
//    return [self initWithCustomView:btn];
//}
//
//+ (instancetype)tmui_itemWithTitle:(NSString *)title icon:(NSString *)icon target:(id)target action:(SEL)action{
//    return [[self alloc] tmui_initWithTitle:title icon:icon target:target action:action];
//}
//
//
//+ (instancetype)tmui_itemWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action{
//    return [[self alloc] tmui_initWithTitle:title color:color font:font target:target action:action];
//}
//
//- (instancetype)tmui_initWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action{
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
//    item.tintColor = color;
//    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] forState:UIControlStateNormal];
//    return item;
//}
//
//
//- (instancetype)tmui_initWithIcon:(NSString *)icon disableIcon:(NSString *)disableIcon target:(id)target action:(SEL)action{
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *img = [UIImage imageNamed:icon];
//    [btn setImage:img forState:UIControlStateNormal];
//
//    if (disableIcon) {
//        [btn setImage:[UIImage imageNamed:disableIcon] forState:UIControlStateDisabled];
//    }
//
//    btn.frame = (CGRect){CGPointZero,img.size};
//
//    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    [btn tmui_setEnlargeEdge:50];
//    return [self initWithCustomView:btn];
//
//}
//
//+ (instancetype)tmui_itemWithIcon:(NSString *)icon disableIcon:(NSString *)disableIcon target:(id)target action:(SEL)action{
//    return [[self alloc] tmui_initWithIcon:icon disableIcon:disableIcon target:target action:action];
//}


@end

