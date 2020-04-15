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

/// !!!: 此处定义的宏定义均以 TMUI_ 为前缀

/// 屏幕宽度，会根据横竖屏的变化而变化
#define TMUI_SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

/// 屏幕高度，会根据横竖屏的变化而变化
#define TMUI_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

/// 状态栏高度(来电等情况下，状态栏高度会发生变化，所以应该实时计算，iOS 13 起，来电等情况下状态栏高度不会改变)
#define TMUI_StatusBarHeight (UIApplication.sharedApplication.statusBarHidden ? 0 : UIApplication.sharedApplication.statusBarFrame.size.height)

///获取一个像素
#define TMUI_PixelOne tmui_pixelOne()

NS_INLINE CGFloat tmui_pixelOne() {
    static CGFloat _tmui_pixelOne = -1.0f;
    if (_tmui_pixelOne < 0) {
        _tmui_pixelOne = 1.0f / [[UIScreen mainScreen] scale];
    }
    return _tmui_pixelOne;
}

#pragma mark - 数学计算

/// 角度转弧度
#define TMUI_AngleWithDegrees(deg) (M_PI * (deg) / 180.0)

#endif /* TMUICommonDefines_h */
