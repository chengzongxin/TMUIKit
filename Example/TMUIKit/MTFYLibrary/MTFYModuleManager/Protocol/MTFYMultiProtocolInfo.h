//
//  MTFYMultiProtocolInfo.h
//  Matafy
//
//  Created by Tiaotiao on 2019/5/20.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTFYModuleMultiProtocol;


@interface MTFYMultiProtocolInfo : NSObject


- (instancetype)initWithMultiProtocol:(Protocol *)protocol
                            multiimpl:(id<MTFYModuleMultiProtocol>)multiImpl;

/**
 协议的名称
 */
@property (nonatomic, copy) NSString *protocolName;

/**
 实现协议的方面名称
 */
@property (nonatomic, copy) NSString *implName;

/**
 协议的所有方法列表
 */
@property (nonatomic, strong) NSArray<NSString *> *protocolMethodList;


- (BOOL)isEqualNameStr:(NSString *)nameStr;

/**
 判断protocol和impl是否符合规则
 
 @param protocol 协议
 @param mutliImpl 实现协议的实例
 @return "协议_实例" 字符串，为nil表示不符合规则
 */
+ (NSString *)checkMutliProtocol:(Protocol *)protocol impl:(id<MTFYModuleMultiProtocol>)mutliImpl;


@end
