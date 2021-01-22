//
//  UIBarButtonItem+Extend.h
//  Live
//
//  Created by Cheng on 2017/5/8.
//  Copyright © 2017年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (id)itemWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action;
- (id)initWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action;
- (id)initWithTitle:(NSString *)title icon:(NSString *)icon target:(id)target action:(SEL)action;
+ (id)itemWithTitle:(NSString *)title icon:(NSString *)icon target:(id)target action:(SEL)action;
+ (id)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (instancetype)itemWithCustomTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (id)itemWithTitle:(NSString *)title textColor:(UIColor *)color font:(int)font target:(id)target action:(SEL)action;
+ (id)itemWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action;
+ (id)itemWithIcon:(NSString *)icon disableIcon:(NSString *)disableIcon target:(id)target action:(SEL)action;
- (id)initWithIcon:(NSString *)icon disableIcon:(NSString *)disableIcon target:(id)target action:(SEL)action;
@end
