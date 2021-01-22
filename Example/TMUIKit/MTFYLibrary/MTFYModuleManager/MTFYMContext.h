//
//  MTFYMContext.h
//  Matafy
//
//  Created by Tiaotiao on 2019/5/20.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTFYMContext : NSObject

@property (nonatomic, weak) UIApplication *application;

@property (nonatomic, strong) NSDictionary *launchOptions;


/**
 如果需要设置为其他的plist
 需要在调用[super application: didFinishLaunchingWithOptions:] 之前设置
 只支持设置一次，设置多次无效
 */
@property (nonatomic, copy) NSString *moduleConfigPlistName;

/**
 是否是生产环境
 */
@property (nonatomic, assign) BOOL productEnv;

@end
