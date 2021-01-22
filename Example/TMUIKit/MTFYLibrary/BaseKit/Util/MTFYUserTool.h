//
//  MTFYUserTool.h
//  Matafy
//
//  Created by Fussa on 2019/11/22.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^MTFYRefreshTokenSuccessBlock)(User *_Nullable user);
typedef void (^MTFYRefreshTokenFailBlock)(void);

@interface MTFYUserTool : NSObject

/// 刷新token (有token则刷新, 无token, user返回nil)
/// @param successBlock 成功回调, 返回User
/// @param failBlock 失败回调
+ (void)refreshToken: (nonnull MTFYRefreshTokenSuccessBlock)successBlock failBlock: (nullable MTFYRefreshTokenFailBlock)failBlock;

/// 刷新token (如果之前刷新失败, 则进行刷新, 否则不刷新直接返回)
/// @param successBlock 成功回调, 返回User
/// @param failBlock 失败回调
+ (void)refreshTokenIfNeed: (nonnull MTFYRefreshTokenSuccessBlock)successBlock failBlock: (nullable MTFYRefreshTokenFailBlock)failBlock;

/// 刷新token
/// @param completeBlock 回调
+ (void)refreshTokenIfNeed:(void (^)(void))completeBlock;

@end

NS_ASSUME_NONNULL_END
