//
//  NSDictionary+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import "NSDictionary+TMUI.h"

@implementation NSDictionary (TMUI)

- (NSDictionary *)tmui_dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary {
    NSMutableDictionary *result = [self mutableCopy];
    [result addEntriesFromDictionary:dictionary];
    return result;
}

- (NSDictionary *)tmui_dictionaryByRemovingEntriesWithKeys:(NSSet *)keys {
    NSMutableDictionary *result = [self mutableCopy];
    [result removeObjectsForKeys:keys.allObjects];
    return result;
}


@end
