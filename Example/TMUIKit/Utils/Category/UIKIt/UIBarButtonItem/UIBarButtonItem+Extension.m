//
//  UIBarButtonItem+Extend.m
//  Live
//
//  Created by Cheng on 2017/5/8.
//  Copyright © 2017年 Joe. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIButton+EnlargeEdge.h"

@implementation UIBarButtonItem (Extension)
- (id)initWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:icon];
    [btn setImage:img forState:UIControlStateNormal];
    
    if (highlighted) {
        [btn setImage:[UIImage imageNamed:highlighted] forState:UIControlStateHighlighted];
    }
    
    btn.frame = (CGRect){CGPointZero,img.size};
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setEnlargeEdge:50];
    return [self initWithCustomView:btn];
    
}

+ (id)itemWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action
{
    return [[self alloc] initWithIcon:icon highlightedIcon:highlighted target:target action:action];
}

- (id)initWithTitle:(NSString *)title icon:(NSString *)icon target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *img = [UIImage imageNamed:icon];
    
    [btn setImage:img forState:UIControlStateNormal];
    
//    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.text = title;
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    btn.frame = (CGRect){CGPointZero,img.size};
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:btn];
}

+ (id)itemWithTitle:(NSString *)title icon:(NSString *)icon target:(id)target action:(SEL)action
{
    return [[self alloc] initWithTitle:title icon:icon target:target action:action];
}

+ (id)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    item.tintColor = [UIColor whiteColor];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName, nil] forState:UIControlStateNormal];
    return item;
}

+ (id)itemWithTitle:(NSString *)title textColor:(UIColor *)color font:(int)font target:(id)target action:(SEL)action
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    item.tintColor = color;
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font],NSFontAttributeName, nil] forState:UIControlStateNormal];
    return item;
}

+ (id)itemWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    item.tintColor = color;
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] forState:UIControlStateNormal];
    return item;
}

+ (instancetype)itemWithCustomTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0f weight:600];
    [button setTitleColor:ColorHex(0x0383FF) forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

- (id)initWithIcon:(NSString *)icon disableIcon:(NSString *)disableIcon target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:icon];
    [btn setImage:img forState:UIControlStateNormal];
    
    if (disableIcon) {
        [btn setImage:[UIImage imageNamed:disableIcon] forState:UIControlStateDisabled];
    }
    
    btn.frame = (CGRect){CGPointZero,img.size};
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setEnlargeEdge:50];
    return [self initWithCustomView:btn];
    
}

+ (id)itemWithIcon:(NSString *)icon disableIcon:(NSString *)disableIcon target:(id)target action:(SEL)action
{
    return [[self alloc] initWithIcon:icon disableIcon:disableIcon target:target action:action];
}

@end
