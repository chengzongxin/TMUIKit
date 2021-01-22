//
//  BaseWebNoNetworkView.h
//  Matafy
//
//  Created by Fussa on 2019/5/28.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseWebNoNetworkView : UIView

+ (instancetype)xib;
@property(nonatomic, copy) void (^clickBlock)(void);
@end

NS_ASSUME_NONNULL_END
