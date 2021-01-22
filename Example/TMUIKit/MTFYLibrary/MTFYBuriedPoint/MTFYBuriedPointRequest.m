//
//  MTFYBuriedPointRequest.m
//  Matafy
//
//  Created by Fussa on 2019/10/15.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYBuriedPointRequest.h"

@implementation MTFYBuriedPointRequest

+ (void)addShareActivityBuriedPointWithActivityId:(NSString *)activityId {
    NSDictionary *header = X_ACCESS_TOKEN;
    NSString *URLString = URL_RED_PACKET_BURIED_POINT;
    
    NSDictionary *param = @{
                            @"activityId":activityId
                            };
    [[NetworkManager sharedInstance] requestWithURL:URLString method:@"POST" parameter:param header:header body:nil timeoutInterval:15 result:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:[responseObject mj_JSONString]];
        int code = [dict[@"code"] intValue];
        if (code == 200) {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];
}


@end
