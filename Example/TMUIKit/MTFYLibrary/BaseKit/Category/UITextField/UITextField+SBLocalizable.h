//
//  UITextField+SBLocalizable.h
//  Matafy
//
//  Created by Fussa on 2019/7/2.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (SBLocalizable)

/**
 是否把当前title作为多语言的key
 */
@property (nonatomic, assign) IBInspectable BOOL textAskey;

@end

NS_ASSUME_NONNULL_END
