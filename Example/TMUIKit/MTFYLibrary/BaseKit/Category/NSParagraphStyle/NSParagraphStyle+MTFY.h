//
//  NSParagraphStyle+MTFY.h
//  Matafy
//
//  Created by Fussa on 2019/11/28.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSParagraphStyle (MTFY)

/// 从 CTParagraphStyleRef 转换成的 NSParagraphStyle
/// @param CTStyle CoreText 段落样式
+ (nullable NSParagraphStyle *)mtfy_styleWithCTStyle:(CTParagraphStyleRef)CTStyle;


/// 转换成 CoreText 样式
- (nullable CTParagraphStyleRef)mtfy_CTStyle CF_RETURNS_RETAINED;

@end

NS_ASSUME_NONNULL_END
