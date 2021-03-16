//
//  UIBarButtonItem+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/4.
//

#import "UIBarButtonItem+TMUI.h"
#import "UIButton+TMUI.h"
#import <objc/runtime.h>


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

- (instancetype)tmui_initWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:icon];
    [btn setImage:img forState:UIControlStateNormal];
    
    if (highlighted) {
        [btn setImage:[UIImage imageNamed:highlighted] forState:UIControlStateHighlighted];
    }
    
    btn.frame = (CGRect){CGPointZero,img.size};
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn tmui_setEnlargeEdge:50];
    return [self initWithCustomView:btn];
    
}

+ (instancetype)tmui_itemWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action{
    return [[self alloc] tmui_initWithIcon:icon highlightedIcon:highlighted target:target action:action];
}

- (instancetype)tmui_initWithTitle:(NSString *)title icon:(NSString *)icon target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *img = [UIImage imageNamed:icon];
    
    [btn setImage:img forState:UIControlStateNormal];
    
    btn.titleLabel.text = title;
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    btn.frame = (CGRect){CGPointZero,img.size};
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:btn];
}

+ (instancetype)tmui_itemWithTitle:(NSString *)title icon:(NSString *)icon target:(id)target action:(SEL)action{
    return [[self alloc] tmui_initWithTitle:title icon:icon target:target action:action];
}


+ (instancetype)tmui_itemWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action{
    return [[self alloc] tmui_initWithTitle:title color:color font:font target:target action:action];
}

- (instancetype)tmui_initWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    item.tintColor = color;
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] forState:UIControlStateNormal];
    return item;
}


- (instancetype)tmui_initWithIcon:(NSString *)icon disableIcon:(NSString *)disableIcon target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:icon];
    [btn setImage:img forState:UIControlStateNormal];
    
    if (disableIcon) {
        [btn setImage:[UIImage imageNamed:disableIcon] forState:UIControlStateDisabled];
    }
    
    btn.frame = (CGRect){CGPointZero,img.size};
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn tmui_setEnlargeEdge:50];
    return [self initWithCustomView:btn];
    
}

+ (instancetype)tmui_itemWithIcon:(NSString *)icon disableIcon:(NSString *)disableIcon target:(id)target action:(SEL)action{
    return [[self alloc] tmui_initWithIcon:icon disableIcon:disableIcon target:target action:action];
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


@end

