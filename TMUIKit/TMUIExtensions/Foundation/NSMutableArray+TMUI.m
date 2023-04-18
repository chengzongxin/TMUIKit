//
//  NSMutableArray+safe.m
//  Juanpi
//
//  Created by xuexiang on 13-8-21.
//  Copyright (c) 2013年 Juanpi. All rights reserved.
//

#import "NSMutableArray+TMUI.h"
#import <TMUICore/TMUICore.h>
@implementation NSMutableArray (TMUI)

//+ (void)load
//{
//    ExchangeImplementations(self, @selector(setObject:atIndexedSubscript:), @selector(tmui_safeSetObject:atIndexedSubscript:));
//    ExchangeImplementations(self, @selector(addObjectsFromArray:), @selector(tmui_safeAddObjectsFromArray:));
//}

-(void)tmui_safeAddObjectsFromArray:(NSArray *)array{
    if (array && [array isKindOfClass:[NSArray class]]) {
        [self tmui_safeAddObjectsFromArray:array];
    }
}

- (void)tmui_safeSetObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
    if (obj == nil) {
        return ;
    }

    if (self.count < idx) {
        return ;
    }

    if (idx == self.count) {
        [self addObject:obj];
    } else {
        [self replaceObjectAtIndex:idx withObject:obj];
    }
}

- (void)tmui_safeAddObject:(id)object
{
	if (object == nil) {
		return;
	} else {
        [self addObject:object];
    }
}

- (void)tmui_safeInsertObject:(id)object atIndex:(NSUInteger)index
{
	if (object == nil) {
		return;
	} else if (index > self.count) {
		return;
	} else {
        [self insertObject:object atIndex:index];
    }
}

- (void)tmui_safeInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexs
{
    if (indexs == nil) {
        return;
    } else if (indexs.count!=objects.count || indexs.firstIndex>self.count) {
        return;
    } else {
        [self insertObjects:objects atIndexes:indexs];
    }
}

- (void)tmui_safeRemoveObjectAtIndex:(NSUInteger)index
{
	if (index >= self.count) {
		return;
	} else {
        [self removeObjectAtIndex:index];
    }
}

@end
