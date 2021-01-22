//
//  NSString+Extension.h
//  Matafy
//
//  Created by Cheng on 2018/2/3.
//  Copyright © 2018年 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
// 单位转换
+ (NSString *)convertIntUnit:(NSInteger)time;
+ (NSString *)formatWatchNum:(NSInteger)number;
+ (NSString *)formatLargeNumber:(NSInteger)number;

// 时间转换
+(NSString *)getUTCFormateDate:(NSString *)newsDate;

// 获取输入行数
- (NSInteger)numberOfLines:(UIFont *)font inSize:(CGSize)inSize;

// 单位转换  100w及以上时显示为100w+
+ (NSString *)transToBaiWanUnit:(int)value;

// 单位转换  10w及以上时显示为10w+
+ (NSString *)transToShiWanUnit:(int)value;

// 单位转换  10w及100w 转换到 int
- (int)transToIntUnit;

// 时间显示规则为：如联系行为在当日，则显示xx（时）：xx（分）；如联系行为在一天前，则显示 昨天xx（时）：xx（分）；如联系行为在昨天以前，显示 xxxx年xx月xx日 xx：xx；
- (NSString *)transToCommunityTime;

- (CGSize)singleLineSizeWithAttributeText:(UIFont *)font;

- (CGSize)multiLineSizeWithAttributeText:(CGFloat)width font:(UIFont *)font;

- (CGSize)singleLineSizeWithText:(UIFont *)font;

- (NSString *)md5;

- (NSURL *)urlScheme:(NSString *)scheme;

+ (NSString *)formatCount:(NSInteger)count;

+(NSDictionary *)readJson2DicWithFileName:(NSString *)fileName;

+ (NSString *)currentTime;
//Decoding :
- (UIImage *)decodeBase64ToImage;

- (UIImage *)decodeBase64ToGIFImage;
/**
 通过格式返回日期对象Date

 @param format @"yyyy-MM-dd HH:mm:ss" 传nil,默认
 @return 对象Date
 */
- (NSDate *)dateWithFormat:(NSString *)format;


/**
 当前时间与自身string间隔秒

 @return 时间间隔
 */
- (NSTimeInterval)intervalFromNow;
/**
 传入时间与自身string间隔秒

 @return 时间间隔
 */
- (NSTimeInterval)intervalFromDate:(NSDate *)date;

// 以公里和米为单位
- (NSString *)kmUnit;
- (NSString *)kmUnitFromIntValue:(int)value;
- (NSString *)kmEnUnitFromIntValue:(int)value;

+ (NSString *)kmUnitFromIntValue:(int)value;
+ (NSString *)kmEnUnitFromIntValue:(int)value;


/**
 URL编码处理
 */
+ (NSString *)mtfy_URLEncodedString:(NSString *)string;

/**
 URL解码处理
 */
+ (NSString *)mtfy_URLDecodeString:(NSString*)encodedString;

/**
 *  生成32位UUID
 */
+ (NSString *)uuidString;

/**
 * 获取字符串中的数字
 */
- (int)getNumberFromString;

/**
 * 判断是否含有汉字
 */
- (BOOL)includeChinese;

/**
 *  中文转码 (你好啊 -> %E4%BD%A0%E5%A5%BD%E5%95%8A)
 */
- (NSString *)encodingString;

/**
 *  截取URL中的参数
 */
- (NSDictionary *)mtfy_getURLParameters;

/**
 * 拼接closeweb=1
 */
- (NSString *)appendCloseWebview;

// 拼接时间戳
- (NSString *)appendTimestampMatafy;

/**
 * 随机生成一串固定长度的字符串
 * @param length 字符串长度
 * @return 字符串
 */
+ (NSString *)mtfy_randomStringAndNumbers:(NSInteger)length;

/**
 * URL地址拼接parameter参数
 * @param dictionary 参数字典
 * @return 拼接好的字符串
 */
- (NSString *)mtfy_urlAppendParameterWithDictionary:(NSDictionary *)dictionary;

@end
