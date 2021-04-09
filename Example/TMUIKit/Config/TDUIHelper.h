//
//  TDUIHelper.h
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/4/9.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TDUIHelper : NSObject

@end

@interface TDUIHelper (Theme)

+ (UIImage *)navigationBarBackgroundImageWithThemeColor:(UIColor *)color;
@end


NS_ASSUME_NONNULL_END
