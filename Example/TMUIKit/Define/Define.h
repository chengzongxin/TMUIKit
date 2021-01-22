//
//  Define.h
//
//
//  Created by 朱伟 on 15/12/1.
//  Copyright (c) 2015年 朱伟. All rights reserved.
//

#ifndef WuLiu_Define_h
#define WuLiu_Define_h

#import <Reachability.h>

#define WEAK(weakSelf)      __weak    __typeof(&*self)weakSelf = self;
#define WSCELL(weakCell)    __weak __typeof(&*cell)weakCell = cell;
#define kNotificationNameLike             @"kNotificationNameLike"            // 是否like

#define kNotificationNameShare            @"kNotificationNameShare"           // 分享后通知首页

#define kNotificationNameRanking            @"kNotificationNameRanking"           // 分享后通知首页

#define kNotificationNameInternational    @"kNotificationNameInternational"   // 是否国际酒店

#define kNotificationNameHotelPara        @"kNotificationNameHotelPara"       // 酒店参数

#define kNotificationNameWebURL           @"kNotificationNameWebURL"          // webview url

#define kNotificationNameWebTitles        @"kNotificationNameWebTitles"       // webview titles

//  社区 2.0 搜索通知
#define kNotificationNameToCommunitySearch @"kNotificationNameToCommunitySearch"

#define kNotificationNameMute             @"kNotificationNameMute"            // 是否静音

#define kNotificationNamePresentNewPlayer @"kNotificationNamePresentNewPlayer"// 弹出新的播放器页面

#define kNotificationNameFollowClick      @"kNotificationNameFollowClick"     // 在他人的界面点了关注/取消关注按钮

#define kNotificationNameOnlyMTFYClick    @"kNotificationNameOnlyMTFYClick"     // 在发现页面点了仅马踏飞燕按钮

#define kNotificationNameDouYinSwitchClick     @"kNotificationNameDouYinSwitchClick"     // 在发现页面点了仅马踏飞燕按钮

#define kNotificationNameUploadClick      @"kNotificationNameUploadClick"     // 在视频录制页面点击上传按钮

#define kNotificationNameThumbupClick     @"kNotificationNameThumbupClick"     // 在视频/图文详情页点赞按钮事件

#define kNotificationNameMessageCount     @"kNotificationNameMessageCount"     // 在视频/图文详情消息数量事件

#define kNotificationNameCollectClick     @"kNotificationNameCollectClick"     // 在视频/图文详情页收藏按钮事件

#define kNotificationNameTokenRefresh     @"kNotificationNameTokenRefresh"     // 刷新了token通知

#define kNotificationNameTokenRefreshResult     @"kNotificationNameTokenRefreshResult"     // 刷新了token通知,返回结果

#define kNotificationNameLogout           @"kNotificationNameLogout"          // 点击退出

#define kNotificationNameVideoListCollectClick     @"kNotificationNameVideoListCollectClick"     // 在视频列表收藏按钮事件 @{_aweme.id:@(1)}

#define kNotificationNameVideoListFollowClick     @"kNotificationNameVideoListFollowClick"     // 在视频列表关注按钮事件 @{_aweme.id:@(1)}

// 社区发现页点击banner
#define kNotificationNameClickMuseumBanner     @"kNotificationNameClickMuseumBanner"

/******************************************首页 banner 改版***************************************************/
#define kNotificationNameShareImg     @"kNotificationNameShareImg"

// 广告ID
// 广点通
#define GDTID   @"1106951478"

// 科大讯飞ID
#define Ifly_APP_ID @"5cbd2815"


//适配
#define IPHONE_FIT KMainScreenWidth/375.0

//获取屏幕宽高
#define KMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define KMainScreenHeight [UIScreen mainScreen].bounds.size.height


//颜色
#define RGBA_COLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define RGBACOLOR(r,g,b,a)              [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kBgColor                        RGBACOLOR(243, 245, 249, 1.0)


//判断字符串是否为空(仅适用于NSString)
#define NULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || (string == nil) || [string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)


/**
 *  进制颜色转RGB
 */
#define JColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RequestSuccess RequestSuccess

/**
 *  融云相关
 */
#define USE_BUNDLE_RESOUCE 1


//-----------UI-Macro Definination---------//
#define RCDLive_RGBCOLOR(r, g, b) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:1]
#define RCDLive_HEXCOLOR(rgbValue)                                                                                             \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0                                               \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0                                                  \
blue:((float)(rgbValue & 0xFF)) / 255.0                                                           \
alpha:1.0]


#if USE_BUNDLE_RESOUCE
#define RCDLive_IMAGE_BY_NAMED(value) [RCDLiveKitUtility imageNamed:(value)ofBundle:@"RongCloud.bundle"]
#else
#define RCDLive_IMAGE_BY_NAMED(value) [UIImage imageNamed:NSLocalizedString((value), nil)]
#endif // USE_BUNDLE_RESOUCE

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define RCDLive_RC_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define RCDLive_RC_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

// 大于等于IOS7
#define RCDLive_RC_MULTILINE_TEXTSIZE_GEIOS7(text, font, maxSize) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;

// 小于IOS7
#define RCDLive_RC_MULTILINE_TEXTSIZE_LIOS7(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;

#ifdef DEBUG
#define RCDLive_DebugLog( s, ... ) NSLog( @"[%@:(%d)] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define RCDLive_DebugLog( s, ... )
#endif


#define  kKeyWindow  [[UIApplication sharedApplication] keyWindow]


// code by ares
// 判断iphonex
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 刘海屏 宏定义
#define IS_iPhoneX_Series (([UIScreen mainScreen].bounds.size.height == 812.f || [UIScreen mainScreen].bounds.size.height == 896.f )? YES : NO)
// 适配刘海屏状态栏高度
#define kStatusBarHeight (IS_iPhoneX_Series ? 44.f : 20.f)
// 适配iPhone X 导航栏高度
#define kNavBarHeight (IS_iPhoneX_Series ? 88.f : 64.f)
// 适配iPhone X Tabbar距离底部的距离
#define kTabBarBottomMargin (IS_iPhoneX_Series ? 34.f : 0.f)
// 适配iPhone X Tabbar高度
#define kTabBarHeight (IS_iPhoneX_Series ? (49.f+34.f) : 49.f)
// 状态栏
#define kStatusHeight [UIApplication sharedApplication].statusBarFrame.size.height


//判断设备类型
#define iPhone4 ([UIScreen mainScreen].bounds.size.height == 480)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size)) : NO)
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
//#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})


// 状态栏高度
#define STATUS_BAR_HEIGHT (IPHONE_X? 44.0 : 20.0)
// 导航栏高度
#define NAVIGATION_BAR_HEIGHT (IPHONE_X ? 88.0 : 64.0)
#define IPHONEX_BOOTOM_HEIGHT (IPHONE_X ? 34.f : 0.f)
/// 导航栏高度（不包括状态栏）
#define NAVI_BAR_HEIGHT 44.0f
/// Tab Bar高度
#define TABBAR_HEIGHT (IPHONE_X ? 83.0 : 49.0)
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kWidth(R) (R)*(kScreenWidth)/375
//这里的375我是针对6为标准适配的,如果需要其他标准可以修改
#define kHeight(R) kWidth(R)
//这里的667我是针对6为标准适配的,如果需要其他标准可以修改 代码简单我就不介绍了, 以此思想,我们可以对字体下手
#define font(R)  (R)*(kScreenWidth)/375.0


// 随机颜色
#define Xrandoms(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define XRC Xrandoms(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define ADS(tableView) if (@available(iOS 11.0, *)) { (tableView).contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; }else { self.automaticallyAdjustsScrollViewInsets = NO; }

// 16进制颜色
#define X16Color(string) [UIColor colorWithHexString:string]

#define XIMGURL(string) [NSURL URLWithString:string]
#define XImage(string)  [UIImage imageNamed:string]
#define XUrlWithString(string)   [NSURL URLWithString:string]
// 友盟点击统计
#define uploadEvent(string) [MobClick event:string];

#endif
