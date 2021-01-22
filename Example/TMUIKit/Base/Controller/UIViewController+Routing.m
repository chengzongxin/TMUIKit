//
//  UIViewController+Routing.m
//  Matafy
//
//  Created by Joe on 2020/7/31.
//  Copyright © 2020 com.upintech. All rights reserved.
//

#import "UIViewController+Routing.h"
#import "WKAirTicketsViewController.h"

@implementation UIViewController (Routing)
- (void)jumpToInvite{
    // 邀请
    WKAirTicketsViewController *vc = [WKAirTicketsViewController new];
#if DEVELOPMENT
    // 测试连接
    NSString *url = @"https://m.matafy.com/commonH5_test/index.html#/invitation";
#else
    // 生产链接
    NSString *url = @"https://m.matafy.com/commonH5/index.html#/invitation";
#endif
    vc.url = url;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
