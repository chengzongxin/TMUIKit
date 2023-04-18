//
//  NSBundle+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/21.
//

#import "NSBundle+TMUI.h"
#import <TMUICore/TMUICore.h>
@implementation NSBundle (TMUI)

+ (UIImage *)tmui_imageName:(NSString *)imageName bundleName:(NSString *)bundleName{
    // 获取当前的bundle,self只是在当前pod库中的一个类，也可以随意写一个其他的类,只要是一个Framework里的就行，这里取最通用的最外层的TMUICore中一个类作为标准
    NSBundle *currentBundle = [NSBundle bundleForClass:[TMUIRuntime class]];
    // 获取屏幕pt和px之间的比例
    NSInteger scale = [UIScreen mainScreen].scale;
    NSString *imagefailName = [NSString stringWithFormat:@"%@@%zdx.png",imageName,scale];
    // 获取图片的路径,其中BMCH5WebView是组件名
    NSString *imagePath = [currentBundle pathForResource:imagefailName ofType:nil inDirectory:[NSString stringWithFormat:@"%@.bundle",bundleName]];
    // 获取图片
    return [UIImage imageWithContentsOfFile:imagePath];
}

/**
 获取文件所在name，默认情况下podName和bundlename相同，传一个即可
 
 @param bundleName bundle名字，就是在resource_bundles里面的名字
 @param podName pod的名字
 @return bundle
 */
+ (NSBundle *)tmui_bundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName{
    if (bundleName == nil && podName == nil) {
        @throw @"bundleName和podName不能同时为空";
    }else if (bundleName == nil ) {
        bundleName = podName;
    }else if (podName == nil) {
        podName = bundleName;
    }
    
    
    if ([bundleName containsString:@".bundle"]) {
        bundleName = [bundleName componentsSeparatedByString:@".bundle"].firstObject;
    }
    //没使用framwork的情况下
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"];
    //使用framework形式
    if (!associateBundleURL) {
        associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
        associateBundleURL = [associateBundleURL URLByAppendingPathComponent:podName];
        associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
        NSBundle *associateBunle = [NSBundle bundleWithURL:associateBundleURL];
        associateBundleURL = [associateBunle URLForResource:bundleName withExtension:@"bundle"];
    }
    
    NSAssert(associateBundleURL, @"取不到关联bundle");
    //生产环境直接返回空
    return associateBundleURL?[NSBundle bundleWithURL:associateBundleURL]:nil;
}

+ (NSString *)tmui_filePathWithFileName:(NSString *)fileName bundleName:(NSString *)bundleName podName:(NSString *)podName{
    NSBundle *bundle = [self tmui_bundleWithBundleName:bundleName podName:podName];
    NSString *path = [bundle pathForResource:fileName ofType:nil];
    return path;
}

+ (UIImage *)tmui_imageWithImageName:(NSString *)imageName bundleName:(NSString *)bundleName podName:(NSString *)podName{
    NSString *path = [self tmui_filePathWithFileName:imageName bundleName:bundleName podName:podName];
    return [UIImage imageWithContentsOfFile:path];;
}


@end
