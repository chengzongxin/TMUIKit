//
//  TBasicLib.h
//  TBasicLib
//
//  Created by kevin.huang on 14-6-9.
//  Copyright (c) 2014年 binxun. All rights reserved.
//  类库的头文件

#import <Foundation/Foundation.h>

// appleid
extern int APPID;
// 导航控制器背景颜色值
extern UIColor *k_color_navBar;
// 带边框的UIBarButtonItem的背景图片名
extern NSString *kBorderBBIBgImgName;
// 返回的UIBarButtonItem的图片名
extern NSString *kBackBBIImgName;
// 常用的绿色，不同App可能有一些差别
extern UIColor *kTo8toGreen;

extern NSString *UID_TO8TO;

extern NSString *kDefaultUrl;

extern NSString *kChannelId;

// 作为是否使用webp图片的开关 .webp为使用webp图片 空的为不使用webp
extern NSString *kSuffixOfWebpImg;

extern CGFloat kTabBarHeight;

typedef enum : NSInteger {
    kTo8toAppID_zxgj = 1,       // 装修管家
    kTo8toAppID_yhq = 2,        // 优惠券
    kTo8toAppID_zxgs = 3,       // 装修公司
    kTo8toAppID_zxqne = 14,     // 装修去哪儿
    kTo8toAppID_to8to = 15,     // 土巴兔
    kTo8toAppID_tk = 16,        // 图库
    kTo8toAppID_zxfs = 17,      // 装修风水
    kTo8toAppID_zxjz = 18,      // 装修记账
    kTo8toAppID_zxwd = 19,      // 装修问答
    kTo8toAppID_zxjsq = 20,     // 装修计算器
    kTo8toAppID_zxtyg = 21,     // 装修体验馆
    kTo8toAppID_zxzxbj = 22,    // 装修在线报价
    kTo8toAppID_zxxcbd = 26,    // 装修选材宝典
    kTo8toAppID_jjdr = 27,      // 家居达人
    kTo8toAppID_jjzxsj = 28,    // 家居装修设计
    kTo8toAppID_xfzx = 29,      // 新房装修
    kTo8toAppID_shejiben = 30,  // 设计本
    kTo8toAppID_to8toHD = 31,   // 土巴兔iPad版
} kTo8toAppID;

extern kTo8toAppID kTo8toAppId;

// user-agent、大数据平台用到的app name，默认取info.plist的“TO8TO_APP_NAME”字段
extern NSString *kTo8toAppName;

// 保存uid的键
#define k_Key_inUserdefault_uid @"Key_inUserdefault_uid"

#import "Define_Basic.h"
#import "Define_Block.h"
#import "Define_SetValues.h"

@interface TBasicConstant : NSObject

@end
