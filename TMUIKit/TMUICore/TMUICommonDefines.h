//
//  TMUICommonDefines.h
//  Pods
//
//  Created by nigel.ning on 2020/4/15.
//

#ifndef TMUICommonDefines_h
#define TMUICommonDefines_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "TMUICoreGraphicsDefines.h"
#import "TMUIKitDefines.h"
#import "NSString+TMUI.h"


#pragma mark - 变量-编译相关

/// 判断当前是否debug编译模式
#ifdef DEBUG
#define IS_DEBUG YES
#else
#define IS_DEBUG NO
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
/// 当前编译使用的 Base SDK 版本为 iOS 9.0 及以上
#define IOS9_SDK_ALLOWED YES
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
/// 当前编译使用的 Base SDK 版本为 iOS 10.0 及以上
#define IOS10_SDK_ALLOWED YES
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
/// 当前编译使用的 Base SDK 版本为 iOS 11.0 及以上
#define IOS11_SDK_ALLOWED YES
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 120000
/// 当前编译使用的 Base SDK 版本为 iOS 12.0 及以上
#define IOS12_SDK_ALLOWED YES
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
/// 当前编译使用的 Base SDK 版本为 iOS 13.0 及以上
#define IOS13_SDK_ALLOWED YES
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 140000
/// 当前编译使用的 Base SDK 版本为 iOS 14.0 及以上
#define IOS14_SDK_ALLOWED YES
#endif

#pragma mark - Clang

#define ArgumentToString(macro) #macro
#define ClangWarningConcat(warning_name) ArgumentToString(clang diagnostic ignored warning_name)

/// 参数可直接传入 clang 的 warning 名，warning 列表参考：https://clang.llvm.org/docs/DiagnosticsReference.html
#define BeginIgnoreClangWarning(warningName) _Pragma("clang diagnostic push") _Pragma(ClangWarningConcat(#warningName))
#define EndIgnoreClangWarning _Pragma("clang diagnostic pop")

#define BeginIgnorePerformSelectorLeaksWarning BeginIgnoreClangWarning(-Warc-performSelector-leaks)
#define EndIgnorePerformSelectorLeaksWarning EndIgnoreClangWarning

#define BeginIgnoreAvailabilityWarning BeginIgnoreClangWarning(-Wpartial-availability)
#define EndIgnoreAvailabilityWarning EndIgnoreClangWarning

#define BeginIgnoreDeprecatedWarning BeginIgnoreClangWarning(-Wdeprecated-declarations)
#define EndIgnoreDeprecatedWarning EndIgnoreClangWarning

#pragma mark - 忽略 iOS 13 KVC 访问私有属性限制

/// 将 KVC 代码包裹在这个宏中，可忽略系统的  KVC 访问限制
#define BeginIgnoreUIKVCAccessProhibited if (@available(iOS 13.0, *)) NSThread.currentThread.tmui_shouldIgnoreUIKVCAccessProhibited = YES;
#define EndIgnoreUIKVCAccessProhibited if (@available(iOS 13.0, *)) NSThread.currentThread.tmui_shouldIgnoreUIKVCAccessProhibited = NO;

#pragma mark - 变量-设备相关

/// 设备类型
#define IS_IPAD [TMUIHelper isIPad]
#define IS_IPOD [TMUIHelper isIPod]
#define IS_IPHONE [TMUIHelper isIPhone]
#define IS_SIMULATOR [TMUIHelper isSimulator]
#define IS_MAC [TMUIHelper isMac]

/// 操作系统版本号，只获取第二级的版本号，例如 10.3.1 只会得到 10.3
#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] doubleValue])

/// 数字形式的操作系统版本号，可直接用于大小比较；如 110205 代表 11.2.5 版本；根据 iOS 规范，版本号最多可能有3位
#define IOS_VERSION_NUMBER [TMUIHelper numbericOSVersion]

/// 是否横竖屏
/// 用户界面横屏了才会返回YES
#define IS_LANDSCAPE UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)
/// 无论支不支持横屏，只要设备横屏了，就会返回YES
#define IS_DEVICE_LANDSCAPE UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])

/// 屏幕宽度，会根据横竖屏的变化而变化
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

/// 屏幕高度，会根据横竖屏的变化而变化
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

/// 设备宽度，跟横竖屏无关
#define DEVICE_WIDTH MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)

/// 设备高度，跟横竖屏无关
#define DEVICE_HEIGHT MAX([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)

/// 在 iPad 分屏模式下等于 app 实际运行宽度，否则等同于 SCREEN_WIDTH
#define APPLICATION_WIDTH [TMUIHelper applicationSize].width

/// 在 iPad 分屏模式下等于 app 实际运行宽度，否则等同于 DEVICE_HEIGHT
#define APPLICATION_HEIGHT [TMUIHelper applicationSize].height

/// 是否全面屏设备
#define IS_NOTCHED_SCREEN [TMUIHelper isNotchedScreen]
/// iPhone 12 Pro Max
#define IS_67INCH_SCREEN [TMUIHelper is67InchScreen]
/// iPhone XS Max
#define IS_65INCH_SCREEN [TMUIHelper is65InchScreen]
/// iPhone 12 / 12 Pro
#define IS_61INCH_SCREEN_AND_IPHONE12 [TMUIHelper is61InchScreenAndiPhone12]
/// iPhone XR
#define IS_61INCH_SCREEN [TMUIHelper is61InchScreen]
/// iPhone X/XS
#define IS_58INCH_SCREEN [TMUIHelper is58InchScreen]
/// iPhone 6/7/8 Plus
#define IS_55INCH_SCREEN [TMUIHelper is55InchScreen]
/// iPhone 12 mini
#define IS_54INCH_SCREEN [TMUIHelper is54InchScreen]
/// iPhone 6/7/8
#define IS_47INCH_SCREEN [TMUIHelper is47InchScreen]
/// iPhone 5/5S/SE
#define IS_40INCH_SCREEN [TMUIHelper is40InchScreen]
/// iPhone 4/4S
#define IS_35INCH_SCREEN [TMUIHelper is35InchScreen]
/// iPhone 4/4S/5/5S/SE
#define IS_320WIDTH_SCREEN (IS_35INCH_SCREEN || IS_40INCH_SCREEN)

/// 是否Retina
#define IS_RETINASCREEN ([[UIScreen mainScreen] scale] >= 2.0)

/// 是否放大模式（iPhone 6及以上的设备支持放大模式，iPhone X 除外）
#define IS_ZOOMEDMODE [TMUIHelper isZoomedMode]

#pragma mark - 变量-布局相关

/// 获取一个像素
#define PixelOne [TMUIHelper pixelOne]

/// bounds && nativeBounds / scale && nativeScale
#define ScreenBoundsSize ([[UIScreen mainScreen] bounds].size)
#define ScreenNativeBoundsSize ([[UIScreen mainScreen] nativeBounds].size)
#define ScreenScale ([[UIScreen mainScreen] scale])
#define ScreenNativeScale ([[UIScreen mainScreen] nativeScale])

/// toolBar相关frame
#define ToolBarHeight (IS_IPAD ? (IS_NOTCHED_SCREEN ? 70 : (IOS_VERSION >= 12.0 ? 50 : 44)) : (IS_LANDSCAPE ? PreferredValueForVisualDevice(44, 32) : 44) + SafeAreaInsetsConstantForDeviceWithNotch.bottom)

/// tabBar相关frame
#define TabBarHeight (IS_IPAD ? (IS_NOTCHED_SCREEN ? 65 : (IOS_VERSION >= 12.0 ? 50 : 49)) : (IS_LANDSCAPE ? PreferredValueForVisualDevice(49, 32) : 49) + SafeAreaInsetsConstantForDeviceWithNotch.bottom)

/// 状态栏高度(来电等情况下，状态栏高度会发生变化，所以应该实时计算，iOS 13 起，来电等情况下状态栏高度不会改变)
#define StatusBarHeight (UIApplication.sharedApplication.statusBarHidden ? 0 : UIApplication.sharedApplication.statusBarFrame.size.height)

/// 状态栏高度(如果状态栏不可见，也会返回一个普通状态下可见的高度)
#define StatusBarHeightConstant (UIApplication.sharedApplication.statusBarHidden ? (IS_IPAD ? (IS_NOTCHED_SCREEN ? 24 : 20) : PreferredValueForNotchedDevice(IS_LANDSCAPE ? 0 : ([[TMUIHelper deviceModel] isEqualToString:@"iPhone12,1"] ? 48 : (IS_61INCH_SCREEN_AND_IPHONE12 || IS_67INCH_SCREEN ? 47 : 44)), 20)) : UIApplication.sharedApplication.statusBarFrame.size.height)

/// navigationBar 的静态高度
#define NavigationBarHeight (IS_IPAD ? (IOS_VERSION >= 12.0 ? 50 : 44) : (IS_LANDSCAPE ? PreferredValueForVisualDevice(44, 32) : 44))

/// 代表(导航栏+状态栏)，这里用于获取其高度
/// @warn 如果是用于 viewController，请使用 UIViewController(TMUI) tmui_navigationBarMaxYInViewCoordinator 代替
#define NavigationContentTop (StatusBarHeight + NavigationBarHeight)

/// 同上，这里用于获取它的静态常量值
#define NavigationContentTopConstant (StatusBarHeightConstant + NavigationBarHeight)

/// 判断当前是否是处于分屏模式的 iPad
#define IS_SPLIT_SCREEN_IPAD (IS_IPAD && APPLICATION_WIDTH != SCREEN_WIDTH)

/// iPhoneX 系列全面屏手机的安全区域的静态值
#define SafeAreaInsetsConstantForDeviceWithNotch [TMUIHelper safeAreaInsetsForDeviceWithNotch]

/// 将所有屏幕按照宽松/紧凑分类，其中 iPad、iPhone XS Max/XR/Plus 均为宽松屏幕，但开启了放大模式的设备均会视为紧凑屏幕
#define PreferredValueForVisualDevice(_regular, _compact) ([TMUIHelper isRegularScreen] ? _regular : _compact)

/// 将所有屏幕按照 Phone/Pad 分类，由于历史上宽高比最大（最胖）的手机为 iPhone 4，所以这里以它为基准，只要宽高比比 iPhone 4 更小的，都视为 Phone，其他情况均视为 Pad。注意 iPad 分屏则取分屏后的宽高来计算。
#define PreferredValueForInterfaceIdiom(_phone, _pad) (APPLICATION_WIDTH / APPLICATION_HEIGHT <= TMUIHelper.screenSizeFor35Inch.width / TMUIHelper.screenSizeFor35Inch.height ? _phone : _pad)

/// 区分全面屏和非全面屏
#define PreferredValueForNotchedDevice(_notchedDevice, _otherDevice) ([TMUIHelper isNotchedScreen] ? _notchedDevice : _otherDevice)


#pragma mark - 变量-布局相关-已废弃
/// 由于 iOS 设备屏幕碎片化越来越严重，因此以下这些宏不建议使用，以后有设备更新也不再维护，请使用 PreferredValueForVisualDevice、PreferredValueForInterfaceIdiom 代替。

/// 按屏幕宽度来区分不同 iPhone 尺寸，iPhone XS Max/XR/Plus 归为一类，iPhone X/8/7/6 归为一类。
/// iPad 也会视为最大的屏幕宽度来处理
#define PreferredValueForiPhone(_65or61or55inch, _47or58inch, _40inch, _35inch) PreferredValueForDeviceIncludingiPad(_65or61or55inch, _65or61or55inch, _47or58inch, _40inch, _35inch)

/// 同上，单独将 iPad 区分对待
#define PreferredValueForDeviceIncludingiPad(_iPad, _65or61or55inch, _47or58inch, _40inch, _35inch) PreferredValueForAll(_iPad, _65or61or55inch, _65or61or55inch, _47or58inch, _65or61or55inch, _47or58inch, _40inch, _35inch)

/// 若 iPad 处于分屏模式下，返回 iPad 接近 iPhone 宽度（320、375、414）中近似的一种，方便屏幕适配。
#define IPAD_SIMILAR_SCREEN_WIDTH [TMUIHelper preferredLayoutAsSimilarScreenWidthForIPad]

#define _40INCH_WIDTH [TMUIHelper screenSizeFor40Inch].width
#define _58INCH_WIDTH [TMUIHelper screenSizeFor58Inch].width
#define _65INCH_WIDTH [TMUIHelper screenSizeFor65Inch].width

#define AS_IPAD (DynamicPreferredValueForIPad ? ((IS_IPAD && !IS_SPLIT_SCREEN_IPAD) || (IS_SPLIT_SCREEN_IPAD && APPLICATION_WIDTH >= 768)) : IS_IPAD)
#define AS_65INCH_SCREEN (IS_67INCH_SCREEN || IS_65INCH_SCREEN || (IS_IPAD && DynamicPreferredValueForIPad && IPAD_SIMILAR_SCREEN_WIDTH == _65INCH_WIDTH))
#define AS_61INCH_SCREEN (IS_61INCH_SCREEN_AND_IPHONE12 || IS_61INCH_SCREEN)
#define AS_58INCH_SCREEN (IS_58INCH_SCREEN || IS_54INCH_SCREEN || ((AS_61INCH_SCREEN || AS_65INCH_SCREEN) && IS_ZOOMEDMODE) || (IS_IPAD && DynamicPreferredValueForIPad && IPAD_SIMILAR_SCREEN_WIDTH == _58INCH_WIDTH))
#define AS_55INCH_SCREEN (IS_55INCH_SCREEN)
#define AS_47INCH_SCREEN (IS_47INCH_SCREEN || (IS_55INCH_SCREEN && IS_ZOOMEDMODE))
#define AS_40INCH_SCREEN (IS_40INCH_SCREEN || (IS_IPAD && DynamicPreferredValueForIPad && IPAD_SIMILAR_SCREEN_WIDTH == _40INCH_WIDTH))
#define AS_35INCH_SCREEN IS_35INCH_SCREEN
#define AS_320WIDTH_SCREEN IS_320WIDTH_SCREEN

#define PreferredValueForAll(_iPad, _65inch, _61inch, _58inch, _55inch, _47inch, _40inch, _35inch) \
(AS_IPAD ? _iPad :\
(AS_35INCH_SCREEN ? _35inch :\
(AS_40INCH_SCREEN ? _40inch :\
(AS_47INCH_SCREEN ? _47inch :\
(AS_55INCH_SCREEN ? _55inch :\
(AS_58INCH_SCREEN ? _58inch :\
(AS_61INCH_SCREEN ? _61inch : _65inch)))))))

#pragma mark - 方法-创建器

#define CGSizeMax CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)

#define UIImageMake(img) [UIImage imageNamed:img]

/// 使用文件名(不带后缀名，仅限png)创建一个UIImage对象，不会被系统缓存，用于不被复用的图片，特别是大图
#define UIImageMakeWithFile(name) UIImageMakeWithFileAndSuffix(name, @"png")
#define UIImageMakeWithFileAndSuffix(name, suffix) [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", [[NSBundle mainBundle] resourcePath], name, suffix]]

/// 字体相关的宏，用于快速创建一个字体对象，更多创建宏可查看 UIFont+TMUI.h
#define UIFontMake(size) [UIFont systemFontOfSize:size]
#define UIFontItalicMake(size) [UIFont italicSystemFontOfSize:size] /// 斜体只对数字和字母有效，中文无效
#define UIFontBoldMake(size) [UIFont boldSystemFontOfSize:size]
#define UIFontBoldWithFont(_font) [UIFont boldSystemFontOfSize:_font.pointSize]

/// UIColor 相关的宏，用于快速创建一个 UIColor 对象，更多创建的宏可查看 UIColor+TMUI.h
#define UIColorMake(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UIColorMakeWithRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]


#pragma mark - 数学计算

#define AngleWithDegrees(deg) (M_PI * (deg) / 180.0)


#pragma mark - 动画

#define TMUIViewAnimationOptionsCurveOut (7<<16)
#define TMUIViewAnimationOptionsCurveIn (8<<16)

#pragma mark - 无障碍访问
CG_INLINE void
AddAccessibilityLabel(NSObject *obj, NSString *label) {
    obj.accessibilityLabel = label;
}

CG_INLINE void
AddAccessibilityHint(NSObject *obj, NSString *hint) {
    obj.accessibilityHint = hint;
}


#pragma mark - 其他

// 固定黑色的 StatusBarStyle，用于亮色背景，作为 -preferredStatusBarStyle 方法的 return 值使用。
#define TMUIStatusBarStyleDarkContent [TMUIHelper statusBarStyleDarkContent]

#define StringFromBOOL(_flag) (_flag ? @"YES" : @"NO")

#pragma mark - Selector

/**
 根据给定的 getter selector 获取对应的 setter selector
 @param getter 目标 getter selector
 @return 对应的 setter selector
 */

#define SETTER_METHOD(getter) \
- (SEL)setterWithGetter1:(SEL)getter{\
    NSString *getterString = NSStringFromSelector(getter);\
    NSMutableString *setterString = [[NSMutableString alloc] initWithString:@"set"];\
    [setterString appendString:getterString.tmui_capitalizedString];\
    [setterString appendString:@":"];\
    SEL setter = NSSelectorFromString(setterString);\
    return setter;\
}

CG_INLINE SEL
setterWithGetter(SEL getter) {
    NSString *getterString = NSStringFromSelector(getter);
    NSMutableString *setterString = [[NSMutableString alloc] initWithString:@"set"];
    [setterString appendString:getterString.tmui_capitalizedString];
    [setterString appendString:@":"];
    SEL setter = NSSelectorFromString(setterString);
    return setter;
}


/**
 *  判断字符串是否为空
 *
 *  @param string 输入的字符串
 *
 *  @return YES,为空；NO,不为空
 */
NS_INLINE BOOL
k_IsBlankString(NSString *string){
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

#pragma mark - 数学计算

/// 角度转弧度
#define TMUI_AngleWithDegrees(deg) (M_PI * (deg) / 180.0)

#pragma mark - 通用辅助宏

#pragma mark - weakify & strongify (reactcocoa库里的简化版本，只支持一个参数)

#if DEBUG
#define tmui_keywordify autoreleasepool {}
#else
#define tmui_keywordify try {} @catch (...) {}
#endif

#define TMUI_weakify(obj) \
tmui_keywordify \
    __weak __typeof__(obj) obj##_tmui_weak_ = obj;

#define TMUI_strongify(obj) \
tmui_keywordify \
    __strong __typeof__(obj) obj = obj##_tmui_weak_;


#pragma mark - Debug Code & Logger Helpers
///可用于调试的代码，宏参数里的代码仅在DEBUG模式下会有效执行
#if DEBUG
#define TMUI_DEBUG_Code(...) \
    __VA_ARGS__;
#else
#define TMUI_DEBUG_Code(...)
#endif

///用于调试时重写类的dealloc方法并打印相关log的便捷宏
#define TMUI_DEBUG_Code_Dealloc \
TMUI_DEBUG_Code (   \
- (void)dealloc {   \
NSLog(@"dealloc: %@", NSStringFromClass(self.class));   \
}   \
)   \

///用于调试时重写类的dealloc方法并打印相关log及添加其它额外代码的便捷宏
#define TMUI_DEBUG_Code_Dealloc_Other(...) \
TMUI_DEBUG_Code (   \
- (void)dealloc {   \
NSLog(@"dealloc: %@", NSStringFromClass(self.class));   \
    __VA_ARGS__;    \
}   \
)   \

#pragma mark - 普通对象懒加载宏

///协议属性的synthesize声明宏
#define TMUI_PropertySyntheSize(propertyName) \
@synthesize propertyName = _##propertyName;

///NSObject类型的属性的懒加载宏
#define TMUI_PropertyLazyLoad(Type, propertyName) \
- (Type *)propertyName { \
    if (!_##propertyName) {\
        _##propertyName = [[Type alloc] init]; \
    } \
    return _##propertyName; \
}   \


#pragma mark - Clang

#define ArgumentToString(macro) #macro
#define ClangWarningConcat(warning_name) ArgumentToString(clang diagnostic ignored warning_name)

/// 参数可直接传入 clang 的 warning 名，warning 列表参考：https://clang.llvm.org/docs/DiagnosticsReference.html
#define BeginIgnoreClangWarning(warningName) _Pragma("clang diagnostic push") _Pragma(ClangWarningConcat(#warningName))
#define EndIgnoreClangWarning _Pragma("clang diagnostic pop")

#define BeginIgnorePerformSelectorLeaksWarning BeginIgnoreClangWarning(-Warc-performSelector-leaks)
#define EndIgnorePerformSelectorLeaksWarning EndIgnoreClangWarning

#define BeginIgnoreAvailabilityWarning BeginIgnoreClangWarning(-Wpartial-availability)
#define EndIgnoreAvailabilityWarning EndIgnoreClangWarning

#define BeginIgnoreDeprecatedWarning BeginIgnoreClangWarning(-Wdeprecated-declarations)
#define EndIgnoreDeprecatedWarning EndIgnoreClangWarning

#pragma mark - CGFloat


#endif /* TMUICommonDefines_h */
