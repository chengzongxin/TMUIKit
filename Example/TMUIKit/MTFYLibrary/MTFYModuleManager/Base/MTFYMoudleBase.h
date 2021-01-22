//
//  MTFYMoudleBase.h
//  Matafy
//
//  Created by Tiaotiao on 2019/5/20.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTFYModuleProtocol.h"
//#import "MTFYMSystempProtocolPool.h"

@interface MTFYMoudleBase : NSObject <MTFYModuleBaseProtocol>


/**
 加入提供api接口实现的实例类
 一般 模块提供的接口都是由主模块类提供的，
 但是实际应用中，很大概率会分子模块，有些接口是间接由子接口提供的，
 如果有些api是由子模块提供的，不需要再主模块在写一个相同的api，然后调用子模块的api，直接在住模块add下就ok
 
 @param instance 实例类
 */
- (void)addProviceApiInstance:(id<NSObject>)instance;


/**
 调用api时，先会找下该api是由那个类提供的，这个方法，一般不需要使用者自己调用该方法
 
 @param aSelector api方法
 @return 实现改api的所有者
 */
- (id<NSObject>)findForwardingTarget:(SEL)aSelector;

@end


