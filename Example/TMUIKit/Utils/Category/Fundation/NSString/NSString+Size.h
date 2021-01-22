//
//  NSString+Size.h
//  Matafy
//
//  Created by Jason on 2019/1/9.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Size)
//提供一个类的接口,方便在整个项目中调用

+ (CGSize)sizeWithString:(NSString*)str andFont:(UIFont*)font andMaxSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
