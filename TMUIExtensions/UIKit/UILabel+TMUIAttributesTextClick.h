//
//  UILabel+TMUIAttributesTextClick.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/7/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TMUIAttrTextDelegate <NSObject>
@optional
/**
 *  TMUIAttrTextDelegate
 *
 *  @param string  点击的字符串
 *  @param range   点击的字符串range
 *  @param index   点击的字符在数组中的index
 */
- (void)didClickAttrText:(NSString *)string range:(NSRange)range index:(NSInteger)index;
@end




@interface UILabel (TMUIAttributesTextClick)

/**
 *  是否打开点击效果，默认是打开
 */
@property (nonatomic, assign) BOOL tmui_enabledClickEffect;

/**
 *  是否扩大点击范围，默认是打开
 */
@property (nonatomic, assign) CGPoint tmui_enlargeClickArea;

/**
 *  点击效果颜色 默认lightGrayColor
 */
@property (nonatomic, strong) UIColor *tmui_clickEffectColor;

/**
 * 给文本添加Block点击事件回调
 *
 * @param strings  需要添加的字符串数组
 * @param clickAction 点击事件回调
 */
- (void)tmui_clickAttrTextWithStrings:(NSArray <NSString *> *)strings clickAction:(void (^) (NSString *string, NSRange range, NSInteger index))clickAction;

/**
 * 给文本添加Block点击事件回调
 *
 * @param strings  需要添加的字符串数组
 * @param attributes  需要添加的字符的富文本属性
 * @param clickAction 点击事件回调
 */
- (void)tmui_clickAttrTextWithStrings:(NSArray <NSString *> *)strings attributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attributes clickAction:(void (^) (NSString *string, NSRange range, NSInteger index))clickAction;

/**
 * 给文本添加点击事件delegate回调
 *
 * @param strings  需要添加的字符串数组
 * @param delegate 富文本代理
 */
- (void)tmui_clickAttrTextWithStrings:(NSArray <NSString *> *)strings delegate:(id <TMUIAttrTextDelegate> )delegate;

/**
 * 给文本添加点击事件delegate回调
 *
 * @param strings  需要添加的字符串数组
 * @param attributes  需要添加的字符的富文本属性
 * @param delegate 富文本代理
 */
- (void)tmui_clickAttrTextWithStrings:(NSArray <NSString *> *)strings attributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attributes delegate:(id <TMUIAttrTextDelegate> )delegate;


/// 移除点击事件
- (void)tmui_removeAttributeAction;

@end

NS_ASSUME_NONNULL_END
