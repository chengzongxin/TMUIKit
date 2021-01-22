//
//  NSString+Extension.m
//  Matafy
//
//  Created by Cheng on 2018/2/3.
//  Copyright © 2018年 com.upintech. All rights reserved.
//

#import "NSString+Extension.h"

#import <CommonCrypto/CommonDigest.h>
#import <CoreText/CoreText.h>
#import <CoreText/CoreText.h>
#import <CoreText/CoreText.h>
#import "UIImage+GIFImage.h"

@implementation NSString (Extension)

// 单位转换
+ (NSString *)convertIntUnit:(NSInteger)time{
    float t = (float)time;

    if (t < 10000) {
        return [NSString stringWithFormat:@"%ld",(long)time];
    } else if (t < 100000000){
        return [NSString stringWithFormat:@"%0.1f%@", (float)time/10000.0, kLStr(@"common_unit_ten_thousand")];
    } else {
        return [NSString stringWithFormat:@"%0.1f%@", (float)time/100000000.0, kLStr(@"common_unit_hundred_million")];
    }
}

+ (NSString *)formatWatchNum:(NSInteger)number
{
    CGFloat t = (CGFloat)number;

//    MTFYMultiLanguageType languageType = [kMTFYMultiLanguageModule modCurLanguageType];
//
//    if (languageType == MTFYMultiLanguageTypeEnglish) {
//    }

    if (t < 10000) {
        return [NSString stringWithFormat:@"%ld%@", (long)time, kLStr(@"home_index_time_watch")];
    } else if (t < 100000000){
        return [NSString stringWithFormat:@"%0.1f%@", (CGFloat)number/10000.0, kLStr(@"home_index_ten_thousand_time_watch")];
    } else {
        return [NSString stringWithFormat:@"%0.1f%@", (CGFloat)number/100000000.0, kLStr(@"home_index_hundred_million_time_watch")];
    }
}

+ (NSString *)formatLargeNumber:(NSInteger)number
{
    CGFloat t = (CGFloat)number;

    if (t < 10000) {
        return [NSString stringWithFormat:@"%ld", (long)time];
    } else if (t < 100000000){
        return [NSString stringWithFormat:@"%0.1f", (CGFloat)number/10000.0];
    } else {
        return [NSString stringWithFormat:@"%0.1f", (CGFloat)number/100000000.0];
    }
}

// 时间转换
+(NSString *)getUTCFormateDate:(NSString *)newsDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *newsDateFormatted = [dateFormatter dateFromString:newsDate];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    [dateFormatter setTimeZone:timeZone];
    
    NSDate* current_date = [[NSDate alloc] init];
    
    NSTimeInterval time=[current_date timeIntervalSinceDate:newsDateFormatted];//间隔的秒数
    
    int year =((int)time)/(3600*24*30*12);
    
    int month=((int)time)/(3600*24*30);
    
    int days=((int)time)/(3600*24);
    
    int hours=((int)time)%(3600*24)/3600;
    
    int minute=((int)time)%(3600*24)/60;
    
    NSString *dateContent;
    
    if (year!=0) {
        
        dateContent = [NSString stringWithFormat:@"%i%@",year, kLStr(@"common_date_year_before")];
        
    }else if(month!=0){
        
        dateContent = [NSString stringWithFormat:@"%i%@",month, kLStr(@"common_date_month_before")];
        
    }else if(days!=0){
        
        dateContent = [NSString stringWithFormat:@"%i%@",days, kLStr(@"common_date_day_before")];
        
    }else if(hours!=0){
        
        dateContent = [NSString stringWithFormat:@"%i%@",hours, kLStr(@"common_date_hour_before")];
        
    }else {
        
        dateContent = [NSString stringWithFormat:@"%i%@",minute, kLStr(@"common_date_minute_before")];
        
    }
    
    return dateContent;
    
}

// 获取输入行数
- (NSInteger)numberOfLines:(UIFont *)font inSize:(CGSize)inSize{
    CGSize size = [self boundingRectWithSize:inSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
    //    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(KMainScreenWidth - 27*2, CGFLOAT_MAX)];
    NSInteger lines = (NSInteger)(size.height / font.lineHeight);
    return lines;
}

+ (NSString *)transToBaiWanUnit:(int)value{
    if (value >= 1000000) {
        return @"100w+";
    }
    return [NSString stringWithFormat:@"%d",value];
}


+ (NSString *)transToShiWanUnit:(int)value{
    if (value >= 100000) {
        return @"10w+";
    }
    return [NSString stringWithFormat:@"%d",value];
}

// 单位转换  10w及100w 转换到 int
- (int)transToIntUnit{
    //    if ([self containsString:@"万"]) {
        if ([self containsString:kLStr(@"common_unit_ten_thousand")]) {
        //TODO :
        NSString *wanStr = [self substringToIndex:[self rangeOfString:@"万"].location];
        int number = [wanStr intValue] * 10000;
        return number;
    }
    return [self intValue];
}


// 时间转换
-(NSString *)transToCommunityTime{
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *microTimeFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    NSString *normalTimeFormat = @"yyyy-MM-dd HH:mm:ss";
    if (self.length < microTimeFormat.length) {
        [dateFormatter setDateFormat:normalTimeFormat];
    }else{
        [dateFormatter setDateFormat:microTimeFormat];
    }
    
    NSDate *newsDateFormatted = [dateFormatter dateFromString:self];
    
    NSTimeInterval timeInterval = [newsDateFormatted timeIntervalSinceDate:[NSDate date]];
//    NSLog(@"timeInterval = %f")
//    [UIWindow showTips:[NSString stringWithFormat:@"%@ =interval= %f",self,timeInterval]];
    if (timeInterval > -600) {
        return kLStr(@"community_time_just_now");
    }
    
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
//    [dateFormatter setTimeZone:timeZone];
    
    
    
    BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:newsDateFormatted];
    
    BOOL isYesterday = [[NSCalendar currentCalendar] isDateInYesterday:newsDateFormatted];
    
    NSDateFormatter *currentDateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *dateContent;
    
    if (isToday) {
        [currentDateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm", kLStr(@"common_time_today")]];
        dateContent = [currentDateFormatter stringFromDate:newsDateFormatted];
    }else if (isYesterday){
        [currentDateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm", kLStr(@"common_time_yesterday")]];
        dateContent = [currentDateFormatter stringFromDate:newsDateFormatted];
    }else{
        [currentDateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm", kLStr(@"common_date_format")]];
        dateContent = [currentDateFormatter stringFromDate:newsDateFormatted];
    }
    
    return dateContent;
    
}



//计算单行文本行高、支持包含emoji表情符的计算。开头空格、自定义插入的文本图片不纳入计算范围
- (CGSize)singleLineSizeWithAttributeText:(UIFont *)font {
    CTFontRef cfFont = CTFontCreateWithName((CFStringRef) font.fontName, font.pointSize, NULL);
    CGFloat leading = font.lineHeight - font.ascender + font.descender;
    CTParagraphStyleSetting paragraphSettings[1] = { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof (CGFloat), &leading };
    
    CTParagraphStyleRef  paragraphStyle = CTParagraphStyleCreate(paragraphSettings, 1);
    CFRange textRange = CFRangeMake(0, self.length);
    
    CFMutableAttributedStringRef string = CFAttributedStringCreateMutable(kCFAllocatorDefault, self.length);
    
    CFAttributedStringReplaceString(string, CFRangeMake(0, 0), (CFStringRef) self);
    
    CFAttributedStringSetAttribute(string, textRange, kCTFontAttributeName, cfFont);
    CFAttributedStringSetAttribute(string, textRange, kCTParagraphStyleAttributeName, paragraphStyle);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(string);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSizeMake(DBL_MAX, DBL_MAX), nil);
    
    CFRelease(paragraphStyle);
    CFRelease(string);
    CFRelease(cfFont);
    CFRelease(framesetter);
    return size;
}

//固定宽度计算多行文本高度，支持包含emoji表情符的计算。开头空格、自定义插入的文本图片不纳入计算范围、
- (CGSize)multiLineSizeWithAttributeText:(CGFloat)width font:(UIFont *)font {
    CTFontRef cfFont = CTFontCreateWithName((CFStringRef) font.fontName, font.pointSize, NULL);
    CGFloat leading = font.lineHeight - font.ascender + font.descender;
    CTParagraphStyleSetting paragraphSettings[1] = { kCTParagraphStyleSpecifierLineBreakMode, sizeof (CGFloat), &leading };
    
    CTParagraphStyleRef  paragraphStyle = CTParagraphStyleCreate(paragraphSettings, 1);
    CFRange textRange = CFRangeMake(0, self.length);
    
    //  Create an empty mutable string big enough to hold our test
    CFMutableAttributedStringRef string = CFAttributedStringCreateMutable(kCFAllocatorDefault, self.length);
    
    //  Inject our text into it
    CFAttributedStringReplaceString(string, CFRangeMake(0, 0), (CFStringRef) self);
    
    //  Apply our font and line spacing attributes over the span
    CFAttributedStringSetAttribute(string, textRange, kCTFontAttributeName, cfFont);
    CFAttributedStringSetAttribute(string, textRange, kCTParagraphStyleAttributeName, paragraphStyle);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(string);
    
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSizeMake(width, DBL_MAX), nil);
    
    CFRelease(paragraphStyle);
    CFRelease(string);
    CFRelease(cfFont);
    CFRelease(framesetter);
    
    return size;
}

//计算单行文本宽度和高度，返回值与UIFont.lineHeight一致，支持开头空格计算。包含emoji表情符的文本行高返回值有较大偏差。
- (CGSize)singleLineSizeWithText:(UIFont *)font{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

- (NSString *) md5 {
    const char *str = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( str, (CC_LONG)strlen(str), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

- (NSURL *)urlScheme:(NSString *)scheme {
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:[NSURL URLWithString:self] resolvingAgainstBaseURL:NO];
    components.scheme = scheme;
    return [components URL];
}

+ (NSString *)formatCount:(NSInteger)count {
    if(count < 10000) {
        return [NSString stringWithFormat:@"%ld",(long)count];
    }else {
        return [NSString stringWithFormat:@"%.1fw",count/10000.0f];
    }
}

+(NSDictionary *)readJson2DicWithFileName:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return dic;
}

+ (NSString *)currentTime {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time * 1000];
    return timeString;
}

//Decoding :
- (UIImage *)decodeBase64ToImage{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

    //Decoding :
- (UIImage *)decodeBase64ToGIFImage{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return [UIImage imageWithGIFData:data];
}

- (NSDate *)dateWithFormat:(NSString *)format{
    
    NSString *dateFormat = format ?: @"yyyy-MM-dd HH:mm:ss";
    
    NSArray *resultArr = [self componentsSeparatedByString:@" "];
    
    NSString *timeStr = [resultArr lastObject];
    
    if (timeStr) {
        NSArray *arr = [timeStr componentsSeparatedByString:@":"];
        dateFormat = arr.count == 2 ? @"yyyy-MM-dd HH:mm" : @"yyyy-MM-dd HH:mm:ss";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:dateFormat];
    
    //    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    //    [dateFormatter setTimeZone:timeZone];
    
    return [dateFormatter dateFromString:self];
}

- (NSTimeInterval)intervalFromNow{
    NSDate *currentDate = [[NSDate alloc] init];
    return [self intervalFromDate:currentDate];
}

- (NSTimeInterval)intervalFromDate:(NSDate *)date {
    NSDate *sinceDate = [self dateWithFormat:nil];
    NSTimeInterval time =[date timeIntervalSinceDate:sinceDate];//间隔的秒数
    return time;
}

// 以公里和米为单位
- (NSString *)kmUnit{
    NSString *km;
    int value = [self intValue];
    if (value > 1000) {
        km = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%0.1f%@", value/1000.0, kLStr(@"common_unit_km")]];
//        km = [NSString stringWithFormat:@"%0.1f公里",value/1000.0];
    }else{
        km = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%d%@", value, kLStr(@"common_unit_m")]];
//        km = [NSString stringWithFormat:@"%d米",value];
    }
    return km;
}

- (NSString *)kmUnitFromIntValue:(int)value{
    NSString *km;
    if (value > 1000) {
        km = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%0.1f%@", value/1000.0, kLStr(@"common_unit_km")]];
//        km = [NSString stringWithFormat:@"%0.1f公里",value/1000.0];
    }else{
        km = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%d%@", value, kLStr(@"common_unit_m")]];
//        km = [NSString stringWithFormat:@"%d米",value];
    }
    return km;
}

- (NSString *)kmEnUnitFromIntValue:(int)value{
    NSString *km;
    if (value > 1000) {
        km = [NSString stringWithFormat:@"%0.1fkm",value/1000.0];
    }else{
        km = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%d%@", value, kLStr(@"common_unit_m")]];
//        km = [NSString stringWithFormat:@"%d米",value];
    }
    return km;
}

+ (NSString *)kmUnitFromIntValue:(int)value {
    return [[NSString new] kmUnitFromIntValue:value];
}

+ (NSString *)kmEnUnitFromIntValue:(int)value {
    return [[NSString new] kmEnUnitFromIntValue:value];
}


+ (NSString *)mtfy_URLEncodedString:(NSString *)string {
    NSString *unencodedString = string;
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

//urldecode
+ (NSString *)mtfy_URLDecodeString:(NSString*)encodedString{
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

/**
 *  生成32位UUID
 */
+ (NSString *)uuidString{

    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);

    //去除UUID ”-“
    NSString *UUID = [uuid lowercaseString];

    return UUID;
}


- (int)getNumberFromString{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *numberStr = [[self componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
    return [numberStr intValue];
}
- (BOOL)includeChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00 && a <0x9fff){
            return YES;
        }
    }
    return NO;
}

- (NSString *)encodingString{
    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef) self, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
//    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}



- (NSDictionary *)mtfy_getURLParameters {
    
    // 查找参数
    NSRange range = [self rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [self substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return [NSDictionary dictionaryWithDictionary:params];
}

- (NSString *)appendCloseWebview{
    if ([self containsString:@"?"]) {
        return [self stringByAppendingString:@"&closeWebview=1"];
    }else{
        return [self stringByAppendingString:@"?closeWebview=1"];
    }
}

- (NSString *)appendTimestampMatafy{

    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([[NSDate date] timeIntervalSince1970]*1000)];
    NSString *para;
    if ([self containsString:@"?"]) {
        para = [NSString stringWithFormat:@"&timestampMatafy=%@",timeSp];
    }else{
        para = [NSString stringWithFormat:@"?timestampMatafy=%@",timeSp];
    }

    return [self stringByAppendingString:para];
}

+ (NSString *)mtfy_randomStringAndNumbers:(NSInteger)length {
    //定义一个包含数字，大小写字母的字符串
    NSString * strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //定义一个结果
    NSString * result = [[NSMutableString alloc] initWithCapacity:16];
    for (int i = 0; i < length; i++) {
        //获取随机数
        NSUInteger index = arc4random() % (strAll.length-1);
        char tempStr = (char) [strAll characterAtIndex:index];
        result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
    }
    return result;
}


- (NSString *)mtfy_urlAppendParameterWithDictionary:(NSDictionary *)dictionary {
    if (dictionary == nil || [dictionary isKindOfClass:[NSNull class]] || dictionary.count == 0) {
        return self;
    }
    __block NSString *result = [NSString stringWithFormat:@"%@?", self];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            obj = [NSString mtfy_URLEncodedString:obj];
        }
        result = [result stringByAppendingFormat:@"%@=%@&", key, obj];
    }];
    // 去除最后一个"&"
    result = [result substringWithRange:NSMakeRange(0, [result length] - 1)];
    return result;
}
@end
