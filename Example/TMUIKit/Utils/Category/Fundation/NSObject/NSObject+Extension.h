//
//  NSObject+Extend.h
//  Live
//
//  Created by Cheng on 2017/5/9.
//  Copyright © 2017年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>

#define isNULL(obj) [NSObject isNull:obj]

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Extension)
/* keyvalue 字典转模型方法 */
- (instancetype)initWithDict:(NSDictionary *)dict;
/* 获取对象的所有属性，不包括属性值 */
- (NSArray *)getAllProperties;
/* 获取对象的所有属性 以及属性值 */
- (NSDictionary *)properties_aps;
/* 获取对象的所有方法 */
-(void)printMothList;

+ (BOOL)isNull:(id)object;

- (BOOL)showLoginVC;

- (UIViewController *)currentVC;

- (void)callPhone:(NSString *)phoneNum;

- (void)mtfy_openURL:(NSString * _Nonnull)url options:(nullable NSDictionary<UIApplicationOpenExternalURLOptionsKey, id> *)options completionHandler:(void (^ __nullable)(BOOL success))completion;
- (void)mtfy_openURL:(NSString * _Nonnull)url completionHandler:(void (^ __nullable)(BOOL success))completion;
- (BOOL)mtfy_canOpenURL:(NSString * _Nonnull)url;

- (BOOL)mtfy_coordinateNotZero: (CLLocationCoordinate2D)coordinate;
- (BOOL)mtfy_coordinateZero: (CLLocationCoordinate2D)coordinate;
/**
 * 随机生成字符串(由大小写字母组成)
 */
- (NSString *)mtfy_randomString: (int)len;

/**
 * 判断是小数还是整数
 */
- (BOOL)mtfy_isPureFloat:(NSString *)numStr;

@end

NS_ASSUME_NONNULL_END
