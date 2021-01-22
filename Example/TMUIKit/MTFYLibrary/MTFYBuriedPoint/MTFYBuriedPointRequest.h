//
//  MTFYBuriedPointRequest.h
//  Matafy
//
//  Created by Fussa on 2019/10/15.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTFYBuriedPointRequest : NSObject


/**
 分享拉新红包埋点

 @param activityId 活动ID
 */
+ (void)addShareActivityBuriedPointWithActivityId:(NSString *)activityId;

@end

NS_ASSUME_NONNULL_END
