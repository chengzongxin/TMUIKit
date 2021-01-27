//
//  UINib+TLoadNib.m
//  Housekeeper_ipad
//
//  Created by to on 15-4-29.
//  Copyright (c) 2015年 to. All rights reserved.
//

#import "UINib+TLoadNib.h"

@implementation UINib (THKLoadNib)

+ (UINib *)nibWithNibClass:(Class)aClass {
    return [UINib nibWithNibName:NSStringFromClass(aClass) bundle:[NSBundle bundleForClass:aClass]];
}

@end
