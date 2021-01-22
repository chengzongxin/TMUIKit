//
//  MTFYADManager.h
//  Matafy
//
//  Created by Fussa on 2019/8/19.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MTFYADManagerCompleteHandle)(void);
NS_ASSUME_NONNULL_BEGIN

@interface MTFYADManager : NSObject

+ (instancetype)shareInstance;

- (void)loadSplashADInWindow:(UIWindow *)window completeHandle:(MTFYADManagerCompleteHandle)complteHandle;

@end

NS_ASSUME_NONNULL_END
