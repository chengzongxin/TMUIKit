//
//  NSString+Attribute.h
//  TMUIKit_Example
//
//  Created by cl w on 2021/2/3.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Attribute)

/**转化为富文本*/
- (NSMutableAttributedString *)tmui_convertToAttributedStringWithFont:(UIFont *)font
                                                            textColor:(UIColor *)color;

- (NSMutableAttributedString *)tmui_attributedStringFormatLineWithFont:(UIFont *)font
                                                                 color:(UIColor *)color
                                                              maxWidth:(CGFloat)maxWidth
                                                           lineSpacing:(CGFloat)spacing
                                                             alignment:(NSTextAlignment)alignment;

@end

NS_ASSUME_NONNULL_END
