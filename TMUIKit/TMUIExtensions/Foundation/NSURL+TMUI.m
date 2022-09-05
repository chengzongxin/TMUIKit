//
//  NSURL+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import "NSURL+TMUI.h"

@implementation NSURL (TMUI)

- (NSDictionary<NSString *, NSString *> *)tmui_queryItems {
    if (!self.absoluteString.length) {
        return nil;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:self.absoluteString];
    
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.name) {
            [params setObject:obj.value ?: [NSNull null] forKey:obj.name];
        }
    }];
    return [params copy];
}


- (id)tmui_parameterValueForKey:(NSString *)key {
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

- (instancetype)tmui_replaceParameterKey:(NSString *)key withValue:(NSString *)value{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"&#\n"];
    
    NSString *url = self.absoluteString;
    NSRange range2 = [url rangeOfString:key];
    if (range2.location != NSNotFound) {
        NSString *subString = [url substringFromIndex:range2.location];
        NSScanner *scanner = [NSScanner scannerWithString:subString];
        
        NSString *destString = nil;
        BOOL res = [scanner scanUpToCharactersFromSet:set intoString:&destString];
        if (res) {
            url = [url stringByReplacingOccurrencesOfString:destString withString:[NSString stringWithFormat:@"%@=%@", key, value]];
            return [NSURL URLWithString:url];
        } else {
            return self;
        }
    } else {
        return self;
    }
}

@end
