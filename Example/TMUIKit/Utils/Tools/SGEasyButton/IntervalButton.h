//
//  IntervalButton.h
//  Matafy
//
//  Created by Jason on 2018/12/3.
//  Copyright © 2018 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IntervalButton : UIButton
/**
 按钮点击的间隔时间
 */
@property(nonatomic,assign) NSTimeInterval time;

@end

NS_ASSUME_NONNULL_END
