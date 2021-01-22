//
//  MTFYMContext.m
//  Matafy
//
//  Created by Tiaotiao on 2019/5/20.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYMContext.h"

@implementation MTFYMContext

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.moduleConfigPlistName = @"MTYFModuleConfig";
    }
    return self;
}

@end
