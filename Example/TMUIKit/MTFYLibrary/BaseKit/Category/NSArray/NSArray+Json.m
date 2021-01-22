//
//  NSArray+Json.m
//  Matafy
//
//  Created by Tiaotiao on 2019/7/8.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "NSArray+Json.h"

@implementation NSArray (Json)

+ (NSArray *)formartWithJson:(NSString *)jsonStr {
    if (!jsonStr) {
        return nil;
    }
    
    NSError *error;
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObjc = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:&error];
    
    if(error || !jsonObjc) {
        return nil;
    }
    
    if ([jsonObjc isKindOfClass:[NSArray class]]) {
        return jsonObjc;
    } else if([jsonObjc isKindOfClass:[NSString class]]
              || [jsonObjc isKindOfClass:[NSDictionary class]]) {
        return [NSArray arrayWithObject:jsonObjc];
    } else {
        return nil;
    }
}

@end
