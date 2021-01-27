//
//  NSURL+TCategory.m
//  TBasicLib
//
//  Created by kevin.huang on 15-1-5.
//  Copyright (c) 2015年 binxun. All rights reserved.
//

#import "NSURL+TCategory.h"

@implementation NSURL (TCategory)

- (id)parameterValueForKey:(NSString *)key {
    if (![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSString *urlStr = [self absoluteString];
    urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSString *query = [url query];
    // 如果不是按不是URL格式，就当字符串处理
    if (!query) {
        query = [self absoluteString];
        query = [query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = kv[1];
        // 替换值含有/的字符串
        val = [val stringByReplacingOccurrencesOfString:@"/" withString:@""];
        if (val) {
            [params setObject:val forKey:kv[0]];
        }
    }
    id value = params[key];
    return value;
}

@end
