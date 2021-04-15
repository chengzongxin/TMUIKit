//
//  NSMutableArray+safe.h
//  Juanpi
//
//  Created by xuexiang on 13-8-21.
//  Copyright (c) 2013年 Juanpi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (TMUI)

- (void)tmui_safeAddObject:(id)object;

- (void)tmui_safeInsertObject:(id)object atIndex:(NSUInteger)index;

- (void)tmui_safeInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexs;

- (void)tmui_safeRemoveObjectAtIndex:(NSUInteger)index;

@end
