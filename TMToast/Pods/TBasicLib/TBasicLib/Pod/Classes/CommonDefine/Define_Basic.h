//
//  Define_Basic.h
//  JJTYG_IPhone
//
//  Created by 程 司 on 14-4-3.
//  Copyright (c) 2014年 binxun. All rights reserved.
//

#ifndef JJTYG_IPhone_Define_Basic_h
#define JJTYG_IPhone_Define_Basic_h

#import <UIKit/UIKit.h>

//app 8.9 移除旧网络库时，所需要调整增加的几个字符串宏定义

#define kAction             @"action"
#define kModel              @"model"
#define KT8TTokenKey        @"T8TTokenKey"
#define KNetFailure         @"网络出问题了，请检查网络连接"
#define kT8TServerFailure   @"请求失败，请稍后重试"

#if DEBUG
#define BASIC_DEBUG_Code(...) \
    __VA_ARGS__;
#else
#define BASIC_DEBUG_Code(...)
#endif

#pragma mark - 普通对象懒加载宏

///协议属性的synthesize声明宏
#define Basic_PropertySyntheSize(propertyName) \
@synthesize propertyName = _##propertyName;

///NSObject类型的属性的懒加载宏
#define Basic_PropertyLazyLoad(Type, propertyName) \
- (Type *)propertyName { \
    if (!_##propertyName) {\
        _##propertyName = [[Type alloc] init]; \
    } \
    return _##propertyName; \
}   \


//------------------------------------------------

// 是否iOS7以上系统
#define kIsIOS7 (device_version() >=7.0)
// 是否iOS8以上系统
#define kIsIOS8 (device_version() >=8.0)
// iOS7以上视图中包含状态栏预留的高度
#define kHeightInViewForStatus (kIsIOS7?20:0)
// 状态条占的高度
#define kHeightForStatus (kIsIOS7?0:20)
// 导航栏高度
#define kNavBarHeight (kIsIOS7?64:44)
// 视图的位置起点y值
#define kViewOriginY (kIsIOS7?kNavBarHeight:0)

// 辨别iphone5
#define kIs4Inch (CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size))
// 辨别iphone4
#define kIsIphone4 (CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size))
// 辨别iphone5
#define kIsIphone5 (CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size))
// 辨别iphone6
#define kIsIphone6 (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size))
// 辨别iphone6p
#define kIsIphone6p (CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size))

// 屏幕高度
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
// 屏幕宽
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

// 颜色 两种参数
#define RGB_255(r,g,b) [UIColor colorWithRed:(CGFloat)r/255.0 green:(CGFloat)g/255.0 blue:(CGFloat)b/255.0 alpha:1]
#define RGB_1(r,g,b) [UIColor colorWithRed:r green:g blue:b alpha:1]
// RGB颜色转换（16进制->10进制）
#define KColorFromRGB(rgbValue) [UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0 green:((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0 blue:((CGFloat)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 当前window
#define kCurrentWindow [[UIApplication sharedApplication].windows firstObject]

// 非空的NSNumber
#define kUnNilNumber(number) ([number isKindOfClass:[NSNumber class]]?number:@(0))
// 非空的字符串 避免输出null
#define kUnNilStr(str) ((str && ![str isEqual:[NSNull null]])?str:@"")
// 非空的字符串 输出空格
#define kUnNilStrSpace(str) ((str && ![str isEqual:[NSNull null]] && ![str isEqualToString:@"(null)"])?str:@" ")
// 整数转换成字符串
#define kStrWithInter(i) [NSString stringWithFormat:@"%@",@(i)]
// CGFloat转换成字符串
#define kStrWithFloat(f) [NSString stringWithFormat:@"%0.1f",f]
// App名称
#define kAppName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
// App版本
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// 验证字典有没有某个key 并且判断值的类型
#define ValidateDicWithKey(dic,key) ([dic objectForKey:key] && [dic objectForKey:key] != [NSNull null])
#define ValidateDicWithKey_Dic(dic,key) ([dic objectForKey:key] && [[dic objectForKey:key] isKindOfClass:[NSDictionary class]])
#define ValidateDicWithKey_Arr(dic,key) ([dic objectForKey:key] && [[dic objectForKey:key] isKindOfClass:[NSArray class]])
#define ValidateDicWithKey_Str(dic,key) ([dic objectForKey:key] && [[dic objectForKey:key] isKindOfClass:[NSString class]])
// 视图的宽、高、y
#define kSelfViewWidth CGRectGetWidth(self.view.frame)
#define kSelfViewHeight CGRectGetHeight(self.view.frame)
#define kSelfViewOriginY self.view.frame.origin.y
// 列表imgv默认图片
#define kCellDefaultImg [UIImage imageNamed:@"bg_cell_defaultImg"]
// 默认头像
#define kDefaultHeadImg [UIImage imageNamed:@"img_defaultHead"]
// 列表imgv默认背景颜色 与图片背景颜色一致
#define kColorForCellDefaultImgBg RGB_255(230, 230, 230)
// 警告提示 带标题
#define kAlter(title,msg)  kAlterBtnTitle(title,msg,@"关闭")
// 警告提示
NS_INLINE void kAlterBtnTitle(NSString *title,NSString *msg, NSString *btnTitle) {
    
    UIViewController *rootVc = nil;
    UITabBarController *tabBarController  = kCurrentWindow.rootViewController;
    
    if ([tabBarController isKindOfClass:[UITabBarController class]]) {
        rootVc =  tabBarController;
        while (rootVc.presentedViewController) {
            rootVc = rootVc.presentedViewController;
        }
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleCancel handler:nil]];
    [rootVc presentViewController:alertController animated:YES completion:nil];
}



#define kMsgLocation [NSString stringWithFormat:@"请在系统设置开启定位服务\n(设置 > 隐私 > 定位服务 > 开启%@)",kUnNilStr(kAppName)]

#define kAlterLocation() kAlterBtnTitle(@"定位服务未开启", kMsgLocation, @"我知道了")

// 警告提示 不带标题
#define kUnTitleAlter(msg) kAlter(@"",msg)
// NSUserDefaults
#define kUserDefaults [NSUserDefaults standardUserDefaults]

// 将链接字符串转换成文件名
#define kFileNameWithUrlStr(urlStr) [urlStr getMd5_32Bit]

// 对应的.bundle的名称
#define kTBasicLibResourceBundleName @"TBasicLibResource"

//判断是否是ipad
#define kIsPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// App评分接口
#define APP_COMMENT_URL [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d",APPID]

#define TCallBlock(block, ...) if(block) block(__VA_ARGS__)

#define kDefaultMobileRegex @"^(13[0-9]|14[57]|15[012356789]|17[0678]|18[0-9])[0-9]{8}$"

// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

#define kTo8toPhoneNumber @"4006900288"

#endif
