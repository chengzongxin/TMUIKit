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

/// 使用文件名(不带后缀名，仅限png)创建一个UIImage对象，不会被系统缓存，用于不被复用的图片，特别是大图
#define UIImageMakeWithFile(name) UIImageMakeWithFileAndSuffix(name, @"png")
#define UIImageMakeWithFileAndSuffix(name, suffix) [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", [[NSBundle mainBundle] resourcePath], name, suffix]]

///MARK: UIColor
#define UIColorRGB(r, g, b)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UIColorRGBA(r, g, b, a)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]
/// UIColor 相关的宏，用于快速创建一个 UIColor 对象，更多创建的宏可查看 UIColor+TMUI.h
/// UIColorHexString(hexStr)
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



#endif /* TMUIKitDefines_h */
