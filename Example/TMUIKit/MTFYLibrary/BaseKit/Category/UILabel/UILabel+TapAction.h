//
// Created by Fussa on 2019/12/31.
// Copyright (c) 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTFYRichTextDelegate <NSObject>
@optional
/**
 *  MTFYRichTextDelegate
 *
 *  @param string  点击的字符串
 *  @param range   点击的字符串range
 *  @param index   点击的字符在数组中的index
 */
- (void)didClickRichText:(NSString *)string range:(NSRange)range index:(NSInteger)index;
@end

@interface UILabel (TapAction)

/**
 *  是否打开点击效果，默认是打开
 */
@property (nonatomic, assign) BOOL enabledClickEffect;

/**
 *  点击效果颜色 默认lightGrayColor
 */
@property (nonatomic, strong) UIColor *clickEffectColor;

/**
 *  给文本添加Block点击事件回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param clickAction 点击事件回调
 */
- (void)mtfy_clickRichTextWithStrings:(NSArray <NSString *> *)strings clickAction:(void (^) (NSString *string, NSRange range, NSInteger index))clickAction;

/**
 *  给文本添加点击事件delegate回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param delegate 富文本代理
 */
- (void)mtfy_clickRichTextWithStrings:(NSArray <NSString *> *)strings delegate:(id <MTFYRichTextDelegate> )delegate;

@end
