//
//  Macros.h
//  Matafy
//
//  Created by Cheng on 2017/12/21.
//  Copyright © 2017年 com.upintech. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#import "ThemeMacros.h"
#import "UtilsMacros.h"
#import "URLMacros.h"
#import "ThirdMacros.h"
#import "StringMacros.h"
#import "PathMacros.h"
#import "KeyChain_Macros.h"
#import "API_NewMacros.h"
#import "MacroDefinition.h"


//UDID MD5_UDID
#define UDID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
#define MD5_UDID [UDID md5]

#define StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define SafeAreaTopHeight ((kMTFYScreenH >= 812.0) && [[UIDevice currentDevice].model isEqualToString:@"iPhone"] ? 88 : 64)
#define SafeAreaBottomHeight ((kMTFYScreenH >= 812.0) && [[UIDevice currentDevice].model isEqualToString:@"iPhone"]  ? 30 : 0)

#define ScreenFrame [UIScreen mainScreen].bounds


//color
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0    \
blue:((float)(rgbValue & 0xFF)) / 255.0             \
alpha:1.0]

#define RGBA(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define ColorWhiteAlpha40 RGBA(255.0, 255.0, 255.0, 0.4)
#define ColorWhiteAlpha80 RGBA(255.0, 255.0, 255.0, 0.8)

#define ColorBlackAlpha1 RGBA(0.0, 0.0, 0.0, 0.01)
#define ColorBlackAlpha20 RGBA(0.0, 0.0, 0.0, 0.2)
#define ColorBlackAlpha40 RGBA(0.0, 0.0, 0.0, 0.4)
#define ColorBlackAlpha60 RGBA(0.0, 0.0, 0.0, 0.6)


#define ColorThemeBackground RGBA(14.0, 15.0, 26.0, 1.0)
// 主题蓝色
#define ColorThemeTiffanyBlue [UIColor colorWithRed:0/255.0 green:195/255.0 blue:206/255.0 alpha:1.0]

#define ColorThemeRed RGBA(241.0, 47.0, 84.0, 1.0)

#define ColorClear [UIColor clearColor]
#define ColorWhite [UIColor whiteColor]
#define ColorGray  [UIColor grayColor]
#define ColorBlue RGBA(40.0, 120.0, 255.0, 1.0)


//Font
#define SuperSmallFont [UIFont systemFontOfSize:10.0]
#define SuperSmallBoldFont [UIFont boldSystemFontOfSize:10.0]

#define SmallFont [UIFont systemFontOfSize:12.0]
#define SmallBoldFont [UIFont boldSystemFontOfSize:12.0]

#define MediumFont [UIFont systemFontOfSize:14.0]
#define MediumBoldFont [UIFont boldSystemFontOfSize:14.0]

#define BigFont [UIFont systemFontOfSize:16.0]
#define BigBoldFont [UIFont boldSystemFontOfSize:16.0]

#define LargeFont [UIFont systemFontOfSize:18.0]
#define LargeBoldFont [UIFont boldSystemFontOfSize:18.0]

#define SuperBigFont [UIFont systemFontOfSize:26.0]
#define SuperBigBoldFont [UIFont boldSystemFontOfSize:26.0]


//safe thread
#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


// 版本号Version (比如"1.0.0")
#define VERSION                     [[MAIN_BUNDLE infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 计算"当地时间"与"格林时间"的时间差
#define DATE_GREECE                 [[DateTool sharedInstance] calculateDate_localMinusGreece]

// 开启状态栏菊花
#define NETWORK_INDICATOR_OPEN      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
// 关闭状态栏菊花
#define NETWORK_INDICATOR_CLOSE     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

// http字符串
#define HTTP_STRING                 @"http://"
// https字符串
#define HTTPS_STRING                @"https://"


#define kAspectRatio(var)   var/375.f * [[UIApplication sharedApplication].delegate window].frame.size.width
#define kAspectRatioiPhone6(var)   var/750.f * [[UIApplication sharedApplication].delegate window].frame.size.width
#define XLabelFontAndName(namex,sizex) [UIFont fontWithName:namex size:kAspectRatio(sizex)]
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define kServiceTypeChanged @"ServiceTypeChanged"

#define Font(sizeX) [UIFont systemFontOfSize:kAspectRatio(sizeX)]

#define kUrlScheme      @"endlessgo" // 这个是你定义的 URL Scheme，支付宝、微信支付、银联和测试模式需要。

#define DEFAULTIMAGE  @"default240"  // 默认图片

#define EID  [[NSUserDefaults standardUserDefaults]objectForKey:@"equipmentId"]


//获得存储的对象
#define UserDefaultObjectForKey(__KEY__)  [[NSUserDefaults standardUserDefaults] objectForKey:__KEY__]

//存储对象
#define UserDefaultSetObjectForKey(__VALUE__,__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] setObject:__VALUE__ forKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

// 移除对象
#define UserDefaultRemoveObjectForKey(__KEY__)  [[NSUserDefaults standardUserDefaults] removeObjectForKey:__KEY__];


// 判断iphonex
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#endif /* Macros_h */
