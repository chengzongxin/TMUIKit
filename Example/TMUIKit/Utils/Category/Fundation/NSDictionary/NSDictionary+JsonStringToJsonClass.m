//
//  NSDictionary+JsonStringToJsonClass.m
//  Matafy
//
//  Created by silkents on 2019/5/20.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "NSDictionary+JsonStringToJsonClass.h"

@implementation NSDictionary (JsonStringToJsonClass)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
