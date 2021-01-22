//
//  LoginTool.h
//  silu
//
//  Created by liman on 15/5/9.
//  Copyright (c) 2015年 upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserTool : NSObject

+(instancetype) sharedInstance;

/**
 *  给User单例赋值
 */
- (void)setValuesToSharedUser:(User *)user;


/**
 *  获取User单利
 */
- (User *)user;

/**
 *  清空User单例
 */
- (void)removeValuesFromUser;

@end
