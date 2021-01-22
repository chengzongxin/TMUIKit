//
//  UIButton+SBLocalizable.h
//  Matafy
//
//  Created by Tiaotiao on 2019/6/19.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (SBLocalizable)

/**
 是否把当前title作为多语言的key
 */
@property (nonatomic, assign) IBInspectable BOOL textAsKey;

@end

NS_ASSUME_NONNULL_END
