//
//  TMUIKitDefines.h
//  Pods
//
//  Created by nigel.ning on 2020/4/15.
//

#ifndef TMUIKitDefines_h
#define TMUIKitDefines_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/// !!!: 此UIKit库扩展的一些宏定义均以相关UIKit里的类名作开头



#pragma mark - 创建UIKit库里基础对象的便捷宏

///MARK: UIImage
#define UIImageMake(imgName)      [UIImage imageNamed:imgName]


/// 使用文件名(不带后缀名，仅限png)创建一个UIImage对象，不会被系统缓存，用于不被复用的图片，特别是大图
#define UIImageMakeWithFile(name) UIImageMakeWithFileAndSuffix(name, @"png")
#define UIImageMakeWithFileAndSuffix(name, suffix) [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", [[NSBundle mainBundle] resourcePath], name, suffix]]

///MARK: UIColor
#define UIColorRGB(r, g, b)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UIColorRGBA(r, g, b, a)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]
#ifndef UIColorHex
#define UIColorHex(_hex_)   tmui_colorWithHexString((__bridge NSString *)CFSTR(#_hex_))
#endif
#ifndef UIColorHexString
#define UIColorHexString(hexStr) tmui_colorWithHexString(hexStr)
#endif

#define UIColorMake(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UIColorMakeWithRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]

///MARK: UIFont
#define UIFont(size)              UIFontRegular(size)
#define UIFontItalic(size)        [UIFont italicSystemFontOfSize:size] /// 斜体只对数字和字母有效，中文无效
//其它系统级自定义weight的字体
#define UIFontRegular(size)       TMUIFontWeight(size, UIFontWeightRegular)
#define UIFontMedium(size)        TMUIFontWeight(size, UIFontWeightMedium)
#define UIFontBold(size)          TMUIFontWeight(size, UIFontWeightBold)
#define UIFontSemibold(size)      TMUIFontWeight(size, UIFontWeightSemibold)
#define UIFontLight(size)         TMUIFontWeight(size, UIFontWeightLight)
#define UIFontThin(size)          TMUIFontWeight(size, UIFontWeightThin)
#define UIFontUltraLight(size)    TMUIFontWeight(size, UIFontWeightUltraLight)
#define UIFontHeavy(size)         TMUIFontWeight(size, UIFontWeightHeavy)
#define UIFontBlack(size)         TMUIFontWeight(size, UIFontWeightBlack)

#define TMUIFontWeight(size_, weight_) [UIFont systemFontOfSize:size_ weight:weight_]
/// 字体相关的宏，用于快速创建一个字体对象，更多创建宏可查看 UIFont+TMUI.h
#define UIFontMake(size) [UIFont systemFontOfSize:size]
#define UIFontItalicMake(size) [UIFont italicSystemFontOfSize:size] /// 斜体只对数字和字母有效，中文无效
#define UIFontBoldMake(size) [UIFont boldSystemFontOfSize:size]
#define UIFontBoldWithFont(_font) [UIFont boldSystemFontOfSize:_font.pointSize]




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

#pragma mark - App 相关


/// 操作系统版本号，只获取第二级的版本号，例如 10.3.1 只会得到 10.3
#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] doubleValue])


#pragma mark - 方法-创建器

#define CGSizeMax CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)



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

#define StringFromBOOL(_flag) (_flag ? @"YES" : @"NO")



#pragma mark - Selector

/**
 根据给定的 getter selector 获取对应的 setter selector
 @param getter 目标 getter selector
 @return 对应的 setter selector
 */

CG_INLINE SEL
setterWithGetter(SEL getter) {
    NSString *getterString = NSStringFromSelector(getter);
    NSMutableString *setterString = [[NSMutableString alloc] initWithString:@"set"];
    [setterString appendString:[NSString stringWithFormat:@"%@%@", [getterString substringToIndex:1].uppercaseString, [getterString substringFromIndex:1]].copy];
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
tmui_isNullString(NSString *string){
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

NS_INLINE UIColor *
tmui_colorWithHex(NSUInteger hex,CGFloat alpha){
    float r, g, b, a;
    a = alpha;
    b = hex & 0x0000FF;
    hex = hex >> 8;
    g = hex & 0x0000FF;
    hex = hex >> 8;
    r = hex;
    return [UIColor colorWithRed:r/255.0f
                           green:g/255.0f
                           blue:b/255.0f
                           alpha:a];
}

NS_INLINE CGFloat
tmui_colorComponentFrom(NSString *string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

/**
 *  使用HEX命名方式的颜色字符串生成一个UIColor对象
 *
 *  @param hexString 支持以 # 开头、0x开头、 纯hex 字符串
 *      #RGB        例如#f0f，等同于#ffff00ff，RGBA(255, 0, 255, 1)
 *      #ARGB       例如#0f0f，等同于#00ff00ff，RGBA(255, 0, 255, 0)
 *      #RRGGBB     例如#ff00ff，等同于#ffff00ff，RGBA(255, 0, 255, 1)
 *      #AARRGGBB   例如#00ff00ff，等同于RGBA(255, 0, 255, 0)
 *
 * @return UIColor对象
 */
NS_INLINE UIColor *
tmui_colorWithHexString(NSString *hexString) {
    if (hexString.length <= 0) return nil;
    
    NSString *colorString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([colorString hasPrefix:@"#"]) {
        colorString = [colorString substringFromIndex:1];
    } else if ([colorString hasPrefix:@"0X"]) {
        colorString = [colorString substringFromIndex:2];
    }
    
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = tmui_colorComponentFrom(colorString,  0,  1);
            green = tmui_colorComponentFrom(colorString,  1,  1);
            blue  = tmui_colorComponentFrom(colorString,  2,  1);
            break;
        case 4: // #ARGB
            alpha = tmui_colorComponentFrom(colorString,  0,  1);
            red   = tmui_colorComponentFrom(colorString,  1,  1);
            green = tmui_colorComponentFrom(colorString,  2,  1);
            blue  = tmui_colorComponentFrom(colorString,  3,  1);
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = tmui_colorComponentFrom(colorString,  0,  2);
            green = tmui_colorComponentFrom(colorString,  2,  2);
            blue  = tmui_colorComponentFrom(colorString,  4,  2);
            break;
        case 8: // #AARRGGBB
            alpha = tmui_colorComponentFrom(colorString,  0,  2);
            red   = tmui_colorComponentFrom(colorString,  2,  2);
            green = tmui_colorComponentFrom(colorString,  4,  2);
            blue  = tmui_colorComponentFrom(colorString,  6,  2);
            break;
        default: {
//            NSAssert(NO, @"Color value %@ is invalid. It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString);
            return nil;
        }
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
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

#pragma mark - 单例
// .h
#define SHARED_INSTANCE_FOR_HEADER \
\
+ (instancetype)sharedInstance;
// .m
#define SHARED_INSTANCE_FOR_CLASS \
+ (instancetype)sharedInstance {\
    static dispatch_once_t onceToken;\
    static id instance = nil;\
    dispatch_once(&onceToken, ^{\
        instance = [[super allocWithZone:NULL] init];\
    });\
    return instance;\
}\
+ (id)allocWithZone:(struct _NSZone *)zone {\
    return [self sharedInstance];\
}

#pragma mark - 文件目录
// 缓存路径-cach目录
NS_INLINE NSString *tmui_filePathAtCacheWithName(NSString *fileName) {
    static NSString *cachFilePath = nil;
    if (!cachFilePath) {
        cachFilePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    }
    return [cachFilePath stringByAppendingPathComponent:fileName];
}

// 缓存路径-document目录
NS_INLINE NSString *tmui_filePathAtDocumentWithName(NSString *fileName) {
    static NSString *documentFilePath = nil;
    if (!documentFilePath) {
        documentFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    }
    return [documentFilePath stringByAppendingPathComponent:fileName];
}

// 缓存路径-temp目录
NS_INLINE NSString *tmui_filePathAtTempWithName(NSString *fileName) {
//    return [NSTemporaryDirectory() stringByAppendingString:fileName]; //  旧的是没有拼接path的，替换需要注意
    return [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    
}



//分别对UIView及NSObject    子类实现相关init方法时提取相关重复代码定义为宏，让子类的初始化过程中仅需专注于子类自身的变量或其它数据的初始化处理

#pragma mark - UI Init Methods Macro

#define TM_INIT_View_Override(...) \
- (instancetype)initWithFrame:(CGRect)frame {   \
    self = [super initWithFrame:frame]; \
    if (self) { \
        __VA_ARGS__;    \
    }   \
    return self;    \
}   \
    \
- (instancetype)initWithCoder:(NSCoder *)coder {    \
    self = [super initWithCoder:coder]; \
    if (self) { \
        __VA_ARGS__;    \
    }   \
    return self;    \
}   \


#pragma mark - NSObject Init Methods Macro

#define TM_INIT_Object_Override(...) \
- (instancetype)init {   \
    self = [super init]; \
    if (self) { \
        __VA_ARGS__;    \
    }   \
    return self;    \
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


#endif /* TMUIKitDefines_h */
