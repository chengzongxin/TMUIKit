//
//  MTFYBuriedPointActivity.h
//  Matafy
//
//  Created by Fussa on 2019/10/15.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTFYBuriedPointActivity : NSObject

/// 拉新红包分享埋点
+ (void)bp_redPkgShareActivity:(NSString *)activityId;

@end

NS_ASSUME_NONNULL_END
