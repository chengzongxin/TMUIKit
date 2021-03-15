//
//  UINib+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINib (TMUI)

+ (UINib *)tmui_nibWithNibClass:(Class)aClass;
@end

NS_ASSUME_NONNULL_END
