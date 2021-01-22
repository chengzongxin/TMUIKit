//
//  UILabel+Attribute.m
//  Matafy
//
//  Created by Jason on 2018/7/4.
//  Copyright © 2018年 com.upintech. All rights reserved.
//

#import "UILabel+Attribute.h"

@implementation UILabel (Attribute)

- (void)attrText:(NSString *)text textRange:(NSString *)textRange font:(UIFont *)font color:(UIColor *)color{
    // 1.创建要显示的字符串
    NSString *str = text;
    
    // 2.将字符串拆分，按照需要展现的颜色或字体的不同拆分成多个单独的字符串，并转化成NSRange格式；
    NSRange rangeA = [str rangeOfString:textRange];
    
    // 3.将 1.中创建的字符串生成可自由设置的 NSMutableAttributedString
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    // 4.给每一部分分别设置颜色
    if (color) {
        [aStr addAttribute:NSForegroundColorAttributeName value:color range:rangeA];
    }
    
    // 5.分别设置字体
    if (font) {
        [aStr addAttribute:NSFontAttributeName value:font range:rangeA];
    }
    
    // 6.创建label，设置label的显示文字，并添加到view上
    self.attributedText = aStr;
}

@end
