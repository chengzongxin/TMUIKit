//
//  NSBundle+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/21.
//

#import "NSBundle+TMUI.h"

@implementation NSBundle (TMUI)
/**
 获取文件所在name，默认情况下podName和bundlename相同，传一个即可
 
 @param bundleName bundle名字，就是在resource_bundles里面的名字
 @param podName pod的名字
 @return bundle
 */
+ (NSBundle *)bundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName{
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

+ (NSString *)filePathWithFileName:(NSString *)fileName bundleName:(NSString *)bundleName podName:(NSString *)podName{
    NSBundle *bundle = [self bundleWithBundleName:bundleName podName:podName];
    NSString *path = [bundle pathForResource:fileName ofType:nil];
    return path;
}

+ (UIImage *)imageWithImageName:(NSString *)imageName bundleName:(NSString *)bundleName podName:(NSString *)podName{
    NSString *path = [self filePathWithFileName:imageName bundleName:bundleName podName:podName];
    return [UIImage imageWithContentsOfFile:path];;
}

@end
