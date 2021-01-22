//
//  MTFYBuriedPointActivity.m
//  Matafy
//
//  Created by Fussa on 2019/10/15.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYBuriedPointActivity.h"
#import "MTFYBuriedPointRequest.h"

@implementation MTFYBuriedPointActivity


+ (void)bp_redPkgShareActivity:(NSString *)activityId {
    [MTFYBuriedPointRequest addShareActivityBuriedPointWithActivityId:activityId];
}

@end
