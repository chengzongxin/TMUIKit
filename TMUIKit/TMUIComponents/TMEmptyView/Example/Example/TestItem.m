//
//  TestItem.m
//  Example
//
//  Created by nigel.ning on 2020/8/14.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "TestItem.h"

@implementation TestItem
+ (instancetype)itemWithType:(TMEmptyContentType)type {
    TestItem *item = [[self alloc] init];
    item.type = type;
    item.title = tmui_emptyTitleByType(type);
    return item;
}
@end
