//
//  NSObject+Extend.m
//  Live
//
//  Created by Cheng on 2017/5/9.
//  Copyright © 2017年 Joe. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>

@implementation NSObject (Extension)

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [self init];
    
    [self setValuesForKeysWithDictionary:dict];
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

- (void)setNilValueForKey:(NSString *)key{
    [self setValue:@"0" forKey:key];
    
//    MYLog(@"%@",key);
}

/* 获取对象的所有属性，不包括属性值 */
- (NSArray *)getAllProperties
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

/* 获取对象的所有属性 以及属性值 */
- (NSDictionary *)properties_aps
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
//        if (!propertyValue) [props setObject:@"0" forKey:propertyName];
    }
    free(properties);
    return props;
}

/* 获取对象的所有方法 */
-(void)printMothList
{
    unsigned int mothCout_f =0;
    Method* mothList_f = class_copyMethodList([self class],&mothCout_f);
    for(int i=0;i<mothCout_f;i++)
    {
        Method temp_f = mothList_f[i];
//        IMP imp_f = method_getImplementation(temp_f);
//        SEL name_f = method_getName(temp_f);
        const char* name_s =sel_getName(method_getName(temp_f));
        int arguments = method_getNumberOfArguments(temp_f);
        const char* encoding =method_getTypeEncoding(temp_f);
        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s],
              arguments,[NSString stringWithUTF8String:encoding]);
    }
    free(mothList_f);
}


+ (BOOL)isNull:(id)object{
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return NO;
}

- (BOOL)showLoginVC{
    return [[[UIViewController new] currentVC] showLoginVC];
}

- (UIViewController *)currentVC{
    return [[UIViewController new] currentVC];
}

- (void)callPhone:(NSString *)phoneNum{
    NSString *telephoneNumber = phoneNum;
    if (![telephoneNumber hasPrefix:@"tel:"]) {
        telephoneNumber = [NSString stringWithFormat:@"tel:%@",telephoneNumber];
    }
    
    [self mtfy_openURL:telephoneNumber completionHandler:^(BOOL success) {
        //OpenSuccess=选择 呼叫 为 1  选择 取消 为0
        NSLog(@"OpenSuccess=%d",success);
    }];
}

- (void)mtfy_openURL:(NSString *)url options:(NSDictionary<UIApplicationOpenExternalURLOptionsKey,id> *)options completionHandler:(void (^)(BOOL))completion {
    if (![self mtfy_canOpenURL:url]) {
        if (completion) {
            completion(NO);
        }
        return;
    }
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
            if (completion) {
                completion(success);
            }
        }];
    } else {
        BOOL success = [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:url]];
        if (completion) {
            completion(success);
        }
    }
}


- (void)mtfy_openURL:(NSString *)url completionHandler:(void (^)(BOOL))completion {
    [self mtfy_openURL:url options:nil completionHandler:completion];
}

- (BOOL)mtfy_canOpenURL:(NSString *)url {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
}

- (BOOL)mtfy_coordinateNotZero:(CLLocationCoordinate2D)coordinate {
    return (BOOL) (coordinate.latitude * coordinate.longitude);
}

- (BOOL)mtfy_coordinateZero:(CLLocationCoordinate2D)coordinate {
    return ![self mtfy_coordinateNotZero:coordinate];
}

- (NSString *)mtfy_randomString:(int)len {
    char ch[len];
    for (int index=0; index<len; index++) {
        int num = arc4random_uniform(58)+65;
        if (num>90 && num<97) { num = num%90+65; }
        ch[index] = (char) num;
    }
    return [[NSString alloc] initWithBytes:ch length:len encoding:NSUTF8StringEncoding];
}

- (BOOL)mtfy_isPureFloat:(NSString *)numStr {
    CGFloat num = [numStr floatValue];
    int i = (int) num;
    CGFloat result = num - i;
    // 当不等于0时，是小数
    return result != 0;
}

@end
