//
//  MTFYModuleInfo.h
//  Matafy
//
//  Created by Tiaotiao on 2019/5/20.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTFYMBaseProtocolPool.h"
#import "MTFYModuleConstant.h"
#import "MTFYModuleProtocol.h"
//#import <MTFYLibrary/MTFYLTools.h>


@protocol MTFYMSystemEventProtocol;

@interface MTFYModuleInfo : NSObject

@property (nonatomic, assign, readonly) NSTimeInterval registerTimestamp;

@property (nonatomic, copy, readonly) NSString *moduleName;

@property (nonatomic, strong, readonly) id<MTFYModuleBaseProtocol> moduleInstance;

@property (nonatomic, strong) id<MTFYModuleSingleProtocol> fetchProtocol;

@property (nonatomic, assign, readonly) MTFYModuleLevel level;

- (instancetype)initWithModuleName:(NSString *)moduleName NS_DESIGNATED_INITIALIZER;

- (instancetype)init
MTFY_UNAVAILABLE_INSTEAD("use initWithModuleName:");

/**
 比较两个模块
 优先比较level，如果level相同，比较注册时间
 
 @param object 比较的模块
 @return 比较结果
 */
- (NSComparisonResult)compare:(MTFYModuleInfo *)object;



@end
