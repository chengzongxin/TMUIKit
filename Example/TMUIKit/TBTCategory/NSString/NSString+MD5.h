//
//  NSString+MD5.h
//  TMUIKitmui_Example
//
//  Created by cl w on 2021/2/1.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MD5)

/**md5 16位加密 默认小写*/
- (NSString *)tmui_getMd5_16Bit;

/**md5 32位加密 默认小写*/
- (NSString *)tmui_getMd5_32Bit;

/**md5 16位加密 大写*/
- (NSString *)tmui_getMd5_16Bit_upperString;

/**md5 32位加密 大写*/
- (NSString *)tmui_getMd5_32Bit_upperString;

@end

NS_ASSUME_NONNULL_END
