//
//  MTFYNetworkCenter.h
//  Matafy
//
//  Created by Tiaotiao on 2019/3/23.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "MTFYNetworkError.h"


#define kMTFYNetworkCenter [MTFYNetworkCenter shareInstance]

#define isHaveNetwork ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN || [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi)

typedef void(^EnableBlock)(BOOL enable);
typedef void(^NetworkStatusBlock)(NetworkStatus status);

/**
 用于app网络状态的监听
 */
@interface MTFYNetworkCenter : NSObject

/**
 单例
 
 @return YFNetworkObserver
 */
+ (nonnull MTFYNetworkCenter *)shareInstance;

/**
 获取当前的网络状态
 */
@property (nonatomic, assign, readonly) NSInteger currentNetworkStatus;

// 并不一定是真的连通，有可能wifi 连着但是实际上网络不通的情况
- (BOOL)checkNetworkIsConnected;

/**
 检查蜂窝网络是否授权可用，block只会调用一次
 
 @param block 结果回调
 */
- (void)checkCellualrDataEnableBlock:(nullable EnableBlock)block __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_9_0);

/**
 监听蜂窝网络是否授权可以，block会跟随状态更改而发生回调
 
 @param observer 接收网络授权回调监听者
 @param block 结果回调
 */
- (void)addCellualrDataAuthorObserver:(nonnull NSObject *)observer
                                block:(nullable EnableBlock)block __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_9_0);

/**
 移除observer对蜂窝网络是否授权的监听
 */
- (void)removeCellualrDataAuthorObserver:(nonnull NSObject *)observer;


/**
 检查当前app网络是否可用，block只会调用一次
 
 @param block 结果回调
 */
- (void)checkNetworkEnableBlock:(nullable EnableBlock)block;

/**
 监听当前app网络状态，block会跟随状态根系而发生回调
 
 @param observer 接收网络状态回调监听者
 @param block 结果回调
 */
- (void)addNetworkReachabilityStatusObserver:(nonnull NSObject *)observer
                                       block:(nullable NetworkStatusBlock)block;


/**
 移除observer对网络状态回调的监听
 */
- (void)removeNetworkReachabilityStatusObserver:(nonnull NSObject *)observer;

@end
