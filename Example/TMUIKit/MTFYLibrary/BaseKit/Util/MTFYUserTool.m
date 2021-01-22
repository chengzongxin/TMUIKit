//
//  MTFYUserTool.m
//  Matafy
//
//  Created by Fussa on 2019/11/22.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYUserTool.h"
#import "DeviceInfo.h"
#import "UserTool.h"

@implementation MTFYUserTool

+ (void)refreshToken:(MTFYRefreshTokenSuccessBlock)successBlock failBlock:(MTFYRefreshTokenFailBlock)failBlock {
    NSString *token = [NSUserDefaults mtfy_getObjectForKey:kMatafyToken];
    if ([NSString isEmpty:token]) {
        // 模拟慢网
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameTokenRefreshResult object:@0];
        });
        
        if (successBlock) {
            successBlock(nil);
        }
        return;
    }
    [self p_refreshWithToken:token success:^(NSInteger code, User *user) {
        NSLog(@"刷新token成功");
//        NSLog(@"刷新token成功, %@", user.token);
         [NSUserDefaults mtfy_saveBool:NO key:kTokenRefreshFailed];
         [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameTokenRefresh object:nil];
         [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameTokenRefreshResult object:@1];
        if (successBlock) {
            successBlock(user);
        }
     } failure:^{
         NSLog(@"刷新token不成功");
         [NSUserDefaults mtfy_saveBool:YES key:kTokenRefreshFailed];
         [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameTokenRefreshResult object:@0];
         if (failBlock) {
             failBlock();
         }
     }];
}

+ (void)refreshTokenIfNeed:(MTFYRefreshTokenSuccessBlock)successBlock failBlock:(MTFYRefreshTokenFailBlock)failBlock {
    BOOL need = [NSUserDefaults mtfy_getBoolForKey:kTokenRefreshFailed];
    if (!need) {
        User *user = [[UserTool sharedInstance] user];
        if (successBlock) {
            successBlock(user);
        }
        return;
    }
    [self refreshToken:successBlock failBlock:failBlock];
}

+ (void)refreshTokenIfNeed:(void (^)(void))completeBlock {
    [self refreshTokenIfNeed:^(User * _Nullable user) {
        if (completeBlock) {
            completeBlock();
        }
    } failBlock:^{
        if (completeBlock) {
            completeBlock();
        }
    }];
}

#pragma mark - Private
+ (void)p_refreshWithToken:(NSString *)token success:(void(^)(NSInteger code, User *user))successBlock failure:(void (^)(void))failureBlock{
    NSMutableDictionary *header = [[DeviceInfo.sharedInstance mj_JSONObject] mutableCopy];
    [header setObject:token forKey:@"token"];
    
    [[NetworkManager sharedInstance]requestDataWithURL:[NSString stringWithFormat:@"%@%@",NEW_API_BASE_URL,NEW_REFRESH_TOKEN] method:@"POST" parameter:nil header:header body:nil timeoutInterval:15 result:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSInteger code = [[jsonDic objectForKey:@"code"] integerValue];
        if(code == 200){
            User *userObj = [User mj_objectWithKeyValues:jsonDic[@"data"]];
            // 存储用户
            [self p_saveUser:userObj];
            successBlock(code, userObj);
        }else{
            failureBlock();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock();
    }];
}


+ (void)p_saveUser:(User *)user {
    // 给User单例赋
    [[UserTool sharedInstance] setValuesToSharedUser:user];
    // 存储token
    [NSUserDefaults mtfy_saveObject:user.token key:kMatafyToken];
}
@end
