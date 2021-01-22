//
//  NSDictionary+Extension.h
//  Matafy
//
//  Created by Cheng on 2017/12/22.
//  Copyright © 2017年 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)

//json格式字符串转字典：
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
