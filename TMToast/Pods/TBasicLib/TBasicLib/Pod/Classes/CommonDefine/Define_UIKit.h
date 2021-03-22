#ifndef BasicUIKitDefines_h
#define BasicUIKitDefines_h

#pragma mark - 创建UIKit库里基础对象的便捷宏

///MARK: UIImage
#define UIImageMake(imgName)      [UIImage imageNamed:imgName]

/// 使用文件名(不带后缀名，仅限png)创建一个UIImage对象，不会被系统缓存，用于不被复用的图片，特别是大图
#define UIImageMakeWithFile(name) UIImageMakeWithFileAndSuffix(name, @"png")
#define UIImageMakeWithFileAndSuffix(name, suffix) [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", [[NSBundle mainBundle] resourcePath], name, suffix]]

///MARK: UIColor
#define UIColorRGB(r, g, b)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UIColorRGBA(r, g, b, a)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]

///MARK: UIFont
#define UIFont(size)              UIFontRegular(size)
#define UIFontItalic(size)        [UIFont italicSystemFontOfSize:size] /// 斜体只对数字和字母有效，中文无效
//其它系统级自定义weight的字体
#define UIFontRegular(size)       BasicUIFontWeight(size, UIFontWeightRegular)
#define UIFontMedium(size)        BasicUIFontWeight(size, UIFontWeightMedium)
#define UIFontBold(size)          BasicUIFontWeight(size, UIFontWeightBold)
#define UIFontSemibold(size)      BasicUIFontWeight(size, UIFontWeightSemibold)
#define UIFontLight(size)         BasicUIFontWeight(size, UIFontWeightLight)
#define UIFontThin(size)          BasicUIFontWeight(size, UIFontWeightThin)
#define UIFontUltraLight(size)    BasicUIFontWeight(size, UIFontWeightUltraLight)
#define UIFontHeavy(size)         BasicUIFontWeight(size, UIFontWeightHeavy)
#define UIFontBlack(size)         BasicUIFontWeight(size, UIFontWeightBlack)

#define BasicUIFontWeight(size_, weight_) [UIFont systemFontOfSize:size_ weight:weight_]

#endif /* BasicUIKitDefines_h */