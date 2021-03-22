/*
  基本常见的内联函数，以IN为前缀区分以K前缀的常量
*/

#import "Define_Basic.h"

#pragma mark - 字符串正则匹配
NS_INLINE BOOL INIsBlankString(NSString *string){
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

// 判断字符串是否全部是数字
NS_INLINE BOOL INIsAllNum(NSString *string){
    if (INIsBlankString(string)) {
        return NO;
    }
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

// 替换字符串某个字符串
NS_INLINE NSString *kReplySuffixStr(NSString *str_ori, NSString *str_1, NSString *str_2) {
    if (str_ori.length > 0 && str_1.length > 0) {
        if ([str_ori hasSuffix:@".webp"]) {
            return str_ori;
        }
        if (str_2.length > 0 && [str_ori rangeOfString:str_2].location != NSNotFound) {
            return str_ori;
        }
        NSRange range = [str_ori rangeOfString:str_1 options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            return [str_ori stringByReplacingOccurrencesOfString:str_1 withString:str_2 ? : @"" options:NSBackwardsSearch range:range];
        }
    }
    return str_ori;
}

// 验证手机号
NS_INLINE BOOL INCheckPhoneNumber(NSString *_text) {
    //   (13[0-9]|14[57]|15[012356789]|18[02356789])\\d{8}
    NSString *Regex = kDefaultMobileRegex;
    
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    
    return [mobileTest evaluateWithObject:_text];
}

// 验证邮箱
NS_INLINE BOOL INCheckEmailNumber(NSString *_text) {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:_text];
}

//验证密码 
NS_INLINE BOOL INCheckPassWord(NSString *_text)
{
    NSString *passwordRegex = @"^(?![0-9]+$)(?![,.#%'+*:;^_`-]+$)(?![a-zA-Z]+$)[0-9A-Za-z,.#%'+*:;^_`-]{8,}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passwordTest evaluateWithObject:_text];
}

// URL编码
NS_INLINE NSString *kEncodeURL(NSString *string) {
    if(![string isKindOfClass:[NSString class]]){
        return nil;
    }
    NSString *newString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
	if (newString) {
		return newString;
	}
	return @"";
}

#pragma mark - UI界面相关
NS_INLINE CGFloat INColorComponentFrom(NSString *string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

/**
 *  使用HEX命名方式的颜色字符串生成一个UIColor对象
 *
 *  @param hexString 支持以 # 开头和不以 # 开头的 hex 字符串
 *      #RGB        例如#f0f，等同于#ffff00ff，RGBA(255, 0, 255, 1)
 *      #ARGB       例如#0f0f，等同于#00ff00ff，RGBA(255, 0, 255, 0)
 *      #RRGGBB     例如#ff00ff，等同于#ffff00ff，RGBA(255, 0, 255, 1)
 *      #AARRGGBB   例如#00ff00ff，等同于RGBA(255, 0, 255, 0)
 *
 * @return UIColor对象
 */
NS_INLINE UIColor *UIColorHexString(NSString *hexString) {
    if (hexString.length <= 0) return nil;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = INColorComponentFrom(colorString,0,1);
            green = INColorComponentFrom(colorString,1,1);
            blue  = INColorComponentFrom(colorString,2,1);
            break;
        case 4: // #ARGB
            alpha   = INColorComponentFrom(colorString,0,1);
            red = INColorComponentFrom(colorString,1,1);
            green  = INColorComponentFrom(colorString,2,1);
            blue  = INColorComponentFrom(colorString,3,1);
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = INColorComponentFrom(colorString,0,2);
            green = INColorComponentFrom(colorString,2,2);
            blue  = INColorComponentFrom(colorString,4,2);
            break;
        case 8: // #AARRGGBB
            alpha = INColorComponentFrom(colorString,0,2);
            red   = INColorComponentFrom(colorString,2,2);
            green = INColorComponentFrom(colorString,4,2);
            blue  = INColorComponentFrom(colorString,6,2);
            break;
        default: {
            NSCAssert(NO, @"Color value %@ is invalid. It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString);
            return nil;
        }
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

NS_INLINE CGFloat INSafeAreaTopInset(){
    CGFloat top = 0;
    if (@available(iOS 11.0, *)) {
        top = kCurrentWindow.safeAreaInsets.top;
    }
    return top;
}

NS_INLINE CGFloat INSafeAreaBottomInset(){
    CGFloat bottom = 0;
    if (@available(iOS 11.0, *)) {
        bottom = kCurrentWindow.safeAreaInsets.bottom;
    }
    return bottom;
}

NS_INLINE CGFloat INNavigationBarHeight(){
    static CGFloat navHeight = 0;
    if (navHeight > 0) {
        return navHeight;
    }
    navHeight = 64;
    if (@available(iOS 11.0, *)) {
        CGFloat top = kCurrentWindow.safeAreaInsets.top;
        navHeight = top > 0 ? kCurrentWindow.safeAreaInsets.top + 44 : 64;
    }
    return navHeight;
}


#pragma mark - iOS系统相关

//系统版本
NS_INLINE CGFloat device_version() {
    return [[[UIDevice currentDevice] systemVersion] doubleValue];
}

// 缓存路径-cach目录
NS_INLINE NSString *INFilePathAtCachWithName(NSString *fileNAme) {
    static NSString *cachFilePath = nil;
    if (!cachFilePath) {
        cachFilePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    }
    return [cachFilePath stringByAppendingPathComponent:fileNAme];
}

// 缓存路径-document目录
NS_INLINE NSString *INFilePathAtDocumentWithName(NSString *fileNAme) {
    static NSString *documentFilePath = nil;
    if (!documentFilePath) {
        documentFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    }
    return [documentFilePath stringByAppendingPathComponent:fileNAme];
}

// 缓存路径-tem目录
NS_INLINE NSString *INFilePathAtTemWithName(NSString *fileNAme) {
    static NSString *tempFilePath = nil;
    if (!tempFilePath) {
        tempFilePath = [NSTemporaryDirectory() stringByAppendingString:fileNAme];
    }
    return [tempFilePath stringByAppendingPathComponent:fileNAme];
}

