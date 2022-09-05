//
//  TMUIPopupMenuBaseItem.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/4/24.
//

#import "TMUIPopupMenuBaseItem.h"

@implementation TMUIPopupMenuBaseItem


@synthesize title = _title;
@synthesize height = _height;
@synthesize handler = _handler;
@synthesize menuView = _menuView;

- (instancetype)init {
    if (self = [super init]) {
        self.height = -1;
    }
    return self;
}

- (void)updateAppearance {
    
}


@end
