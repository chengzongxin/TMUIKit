//
//  UILabel+AttributeText.h
//  Matafy
//
//  Created by Tiaotiao on 2019/5/7.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (AttributeText)

// 给label指定text的颜色、字体
- (void)mtfy_addAttributesText:(NSString *)text color:(UIColor *)color font:(UIFont *)font;

- (void)mtfy_addAttributesText:(CGFloat)lineSpacing;

- (void)mtfy_addAttributesLineOffset:(CGFloat)lineOffset;

- (void)mtfy_addAttributesLineSingle;

@end

NS_ASSUME_NONNULL_END
