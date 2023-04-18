//
//  TMUINavigationBarApprance.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/5/23.
//

#import "TMUINavigationBarApprance.h"
#import <TMUIExtensions/TMUIExtensions.h>
#import <TMUICore/TMUICore.h>
NS_INLINE UIImage *kNavAssetsImgName(NSString *imageName) {
    return [NSBundle tmui_imageName:imageName bundleName:@"TMUINavigationBarUIAssets"]; // 位于pod中使用
//     [UIImage tmui_imageInBundleWithName:imgName];  // 位于项目中使用
}

@implementation TMUINavigationBarApprance

+ (instancetype)appranceWithBarStyle:(TMUINavigationBarStyle)barStyle{
    TMUINavigationBarApprance *apprance = [[TMUINavigationBarApprance alloc] init];
    if (barStyle == TMUINavigationBarStyle_Light) {
        apprance.backgroundColor = UIColorWhite;
        apprance.backBtnImg = kNavAssetsImgName(@"tmui_nav_back_black");
        apprance.titleColor = UIColorBlack;
        apprance.shareImg = kNavAssetsImgName(@"tmui_nav_share_black");
        apprance.searchImg = kNavAssetsImgName(@"tmui_nav_search_black");
    }else{
        apprance.backgroundColor = UIColorBlack;
        apprance.backBtnImg = kNavAssetsImgName(@"tmui_nav_back_white");
        apprance.titleColor = UIColorWhite;
        apprance.shareImg = kNavAssetsImgName(@"tmui_nav_share_white");
        apprance.searchImg = kNavAssetsImgName(@"tmui_nav_search_white");
    }
    return apprance;
}

@end
