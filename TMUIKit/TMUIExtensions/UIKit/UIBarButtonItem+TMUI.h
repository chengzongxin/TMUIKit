//
//  UIBarButtonItem+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (TMUI)

+ (instancetype)tmui_itemWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action;
- (instancetype)tmui_initWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(id)target action:(SEL)action;

+ (instancetype)tmui_itemWithTitle:(NSString *)title icon:(NSString *)icon target:(id)target action:(SEL)action;
- (instancetype)tmui_initWithTitle:(NSString *)title icon:(NSString *)icon target:(id)target action:(SEL)action;


+ (instancetype)tmui_itemWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action;
- (instancetype)tmui_initWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action;

+ (instancetype)tmui_itemWithIcon:(NSString *)icon disableIcon:(NSString *)disableIcon target:(id)target action:(SEL)action;
- (instancetype)tmui_initWithIcon:(NSString *)icon disableIcon:(NSString *)disableIcon target:(id)target action:(SEL)action;

/**
 The block that invoked when the item is selected. The objects captured by block
 will retained by the ButtonItem.
 
 @discussion This param is conflict with `target` and `action` property.
 Set this will set `target` and `action` property to some internal objects.
 */
@property (nullable, nonatomic, copy) void (^tmui_actionBlock)(id);

@end

NS_ASSUME_NONNULL_END
