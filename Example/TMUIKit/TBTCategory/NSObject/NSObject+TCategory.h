//
//  NSObject+TCategory.h
//  HouseKeeper
//
//  Created by kevin.huang on 14-8-5.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TCategory)

+ (instancetype)t_instance;
+ (void)t_setNilForDefaultTarget;

+ (instancetype)t_instanceForTarget:(id)target;
+ (void)t_setNilForTarget:(id)target;

+ (instancetype)t_instanceForTarget:(id)target keyName:(NSString *)strKeyName;
+ (void)t_setNilForTarget:(id)target keyName:(NSString *)strKeyName;

@end


@interface TNone : NSObject

@end
