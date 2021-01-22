//
//  FFToastTool.m
//  Matafy
//
//  Created by Cheng on 2018/2/6.
//  Copyright © 2018年 com.upintech. All rights reserved.
//

#import "FFToastTool.h"
#import "FFToast.h"

@implementation FFToastTool

+ (void)toast:(NSString *)string{
    FFToast *toast =  [[FFToast alloc] initToastWithTitle:nil message:string iconImage:nil];
    toast.gradientStartColor = @"FFA900";
    toast.gradientEndColor = @"FDEB71";
    toast.duration = 2;
    [toast show];
}
@end
