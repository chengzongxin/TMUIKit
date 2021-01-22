//
//  ThemeMacros.h
//  Matafy
//
//  Created by Cheng on 2017/12/21.
//  Copyright © 2017年 com.upintech. All rights reserved.
//

#ifndef ThemeMacros_h
#define ThemeMacros_h


/** RGB颜色 + A透明度 */
#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define ColorAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

/** 十六进制颜色 Hex */
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ColorHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/** 工程颜色 Hex */
#define MAP_GREEN_COLOUR ColorHex(0x05AFAF)
#define MAP_GRAY_COLOUR  [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:251.0/255.0 alpha:1]
#define MAP_FILTER_TEXT_COLOUR  ColorHex(0x333333)

/**
 背景色

 @param 0xF4F5F5 背景色
 */
#define COLOR_LIGHT_GRAY_BGCOLOR ColorHex(0xF4F5F5) // 背景色

#define FONT(s)     [UIFont fontWithName:@"PingFang-SC-Medium" size:s]

#endif /* ThemeMacros_h */
