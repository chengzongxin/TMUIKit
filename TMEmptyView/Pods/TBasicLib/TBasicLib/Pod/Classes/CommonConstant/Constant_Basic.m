//
//  TBasicLib.m
//  TBasicLib
//
//  Created by kevin.huang on 14-6-9.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#import "Constant_Basic.h"

// appleid
int APPID;
// 导航控制器背景颜色值
UIColor *k_color_navBar;
// 常用的绿色，不同app可能有一些差别
UIColor *kTo8toGreen;

NSString *UID_TO8TO;

NSString *kDefaultUrl;

kTo8toAppID kTo8toAppId;


//--------有默认值----------

// 带边框的UIBarButtonItem的背景图片名
NSString *kBorderBBIBgImgName = @"bbi_border";
// 返回的UIBarButtonItem的图片名
NSString *kBackBBIImgName = @"bbi_back";

NSString *kChannelId = nil;

// 作为是否使用webp图片的开关 .webp为使用webp图片 空的为不使用webp
NSString *kSuffixOfWebpImg = nil;

NSString *kTo8toAppName = nil;

@implementation TBasicConstant

+ (void)load {
    kTo8toAppName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"TO8TO_APP_NAME"];
}

@end
