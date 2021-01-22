//
//  NSDictionary+Extension.m
//  Matafy
//
//  Created by Cheng on 2017/12/22.
//  Copyright © 2017年 com.upintech. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

//json格式字符串转字典：

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    if (!jsonData) return nil;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：jsonString = %@,error = %@",jsonString,err);
        
        return nil;
        
    }
    
    return dic;
    
}


@end
