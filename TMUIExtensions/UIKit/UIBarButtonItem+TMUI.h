//
//  UIBarButtonItem+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, UIBarButtonItem_TMUIColorStyle) {
    /// 白色导航条上显示的文本颜色
    UIBarButtonItem_TMUIColorStyleBlack = 0,
    /// 深色导航条上显示的文本颜色-whilteColor
    UIBarButtonItem_TMUIColorStyleWhite,
    /// 一些地方按钮文本颜色是土巴兔主题绿色
    UIBarButtonItem_TMUIColorStyleTheme
    ///可扩展其它特殊的颜色...
};

@interface UIBarButtonItem (TMUI)

/**
 根据图片生成UIBarButtonItem
 
 @param image image
 @param target target对象
 @param action 响应方法
 @return 生成的UIBarButtonItem
 */
+ (UIBarButtonItem *)tmui_itemWithImage:(UIImage *)image
                                 target:(id)target
                                 action:(SEL)action;
/**
 根据图片生成UIBarButtonItem
 
 @param image image
 @param imageEdgeInsets 图片偏移
 @param target target对象
 @param action 响应方法
 @return 生成的UIBarButtonItem
 */
+ (UIBarButtonItem *)tmui_itemWithImage:(UIImage *)image
                        imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
                                 target:(id)target
                                 action:(SEL)action;
/**
 根据图片生成UIBarButtonItem
 
 @param nomalImage nomalImage
 @param higeLightedImage higeLightedImage
 @param imageEdgeInsets 图片偏移
 @param target target对象
 @param action 响应方法
 @return 生成的UIBarButtonItem
 */
+ (UIBarButtonItem *)tmui_itemWithNomalImage:(UIImage *)nomalImage
                            higeLightedImage:(nullable UIImage *)higeLightedImage
                             imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
                                      target:(id)target
                                      action:(SEL)action;

/**
 根据文字生成UIBarButtonItem
 @note 默认文字为偏黑色，显示在白色导航条上
 @param title title
 @param target target对象
 @param action 响应方法
 @return 生成的UIBarButtonItem
 */
+ (UIBarButtonItem *)tmui_itemWithTitle:(NSString *)title
                                 target:(id)target
                                 action:(SEL)action;
/**
 根据文字生成UIBarButtonItem
 @note 默认文字为偏黑色，显示在白色导航条上
 @param title title
 @param titleEdgeInsets 文字偏移
 @param target target对象
 @param action 响应方法
 @return 生成的UIBarButtonItem
 */
+ (UIBarButtonItem *)tmui_itemWithTitle:(NSString *)title
                        titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
                                 target:(id)target
                                 action:(SEL)action;

/**
 根据文字生成UIBarButtonItem
 @param title title
 @param titleColorStyle 文本显示的颜色样式
 @param target target对象
 @param action 响应方法
 @return 生成的UIBarButtonItem
 */
+ (UIBarButtonItem *)tmui_itemWithTitle:(NSString *)title
                        titleColorStyle:(UIBarButtonItem_TMUIColorStyle)titleColorStyle
                                 target:(id)target
                                 action:(SEL)action;


/**
 根据文字生成UIBarButtonItem
 @param title title
 @param titleColorStyle 文本显示的颜色样式
 @param titleEdgeInsets 文字偏移
 @param target target对象
 @param action 响应方法
 @return 生成的UIBarButtonItem
 */
+ (UIBarButtonItem *)tmui_itemWithTitle:(NSString *)title
                        titleColorStyle:(UIBarButtonItem_TMUIColorStyle)titleColorStyle
                        titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
                                 target:(id)target
                                 action:(SEL)action;



/// 根据宽度生成弹簧item
/// @param width 弹簧宽度
+ (instancetype)tmui_fixedSpaceItemWithWidth:(CGFloat)width;

/// 生成弹簧item
+ (instancetype)tmui_flexibleSpaceItem;

/**
 The block that invoked when the item is selected. The objects captured by block
 will retained by the ButtonItem.
 
 @discussion This param is conflict with `target` and `action` property.
 Set this will set `target` and `action` property to some internal objects.
 */
@property (nullable, nonatomic, copy) void (^tmui_actionBlock)(id);






//+ (instancetype)tmui_itemWithTitle:(NSString *)title target:(nullable id)target action:(nullable SEL)action;
//- (instancetype)tmui_initWithTitle:(NSString *)title target:(nullable id)target action:(nullable SEL)action;
//
//+ (instancetype)tmui_itemWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(nullable id)target action:(nullable SEL)action;
//- (instancetype)tmui_initWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlighted target:(nullable id)target action:(nullable SEL)action;
//
//+ (instancetype)tmui_itemWithTitle:(NSString *)title icon:(NSString *)icon target:(nullable id)target action:(nullable SEL)action;
//- (instancetype)tmui_initWithTitle:(NSString *)title icon:(NSString *)icon target:(nullable id)target action:(nullable SEL)action;
//
//
//+ (instancetype)tmui_itemWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font target:(nullable id)target action:(nullable SEL)action;
//- (instancetype)tmui_initWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font target:(nullable id)target action:(nullable SEL)action;
//
//+ (instancetype)tmui_itemWithIcon:(NSString *)icon disableIcon:(NSString *)disableIcon target:(nullable id)target action:(nullable SEL)action;
//- (instancetype)tmui_initWithIcon:(NSString *)icon disableIcon:(NSString *)disableIcon target:(nullable id)target action:(nullable SEL)action;


@end

NS_ASSUME_NONNULL_END
