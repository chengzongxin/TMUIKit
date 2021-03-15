//
//  NSBundle+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (TMUI)
/**
 获取文件所在name，默认情况下podName和bundlename相同，传一个即可
 
 @param bundleName bundle名字，就是在resource_bundles里面的名字
 @param podName pod的名字
 @return bundle
 */
+ (NSBundle *)tmui_bundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName;

+ (NSString *)tmui_filePathWithFileName:(NSString *)fileName bundleName:(NSString *)bundleName podName:(NSString *)podName;

+ (UIImage *)tmui_imageWithImageName:(NSString *)imageName bundleName:(NSString *)bundleName podName:(NSString *)podName;

@end

NS_ASSUME_NONNULL_END
