//
//  NSObject+NSArrayASCorDESC.h
//  Matafy
//
//  Created by silkents on 2019/5/20.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (NSArrayASCorDESC)
// 数组升序
- (NSArray *)arraySortASC:(NSArray *)array;
// 数组降序
- (NSArray *)arraySortDESC:(NSArray *)array;
// 阿拉伯数字转汉字
- (NSString *)translation:(NSString *)arebic;
// 字典数组排序
- (NSArray *)sortASCDictionaryArray:(NSArray *)array  withKey:(NSString *)key ascending:(BOOL)isASC;
// 时间戳转换时间格式
- (NSString *)ConvertStrToTime:(NSString *)timeStr;
// view 转 image

@end

NS_ASSUME_NONNULL_END
