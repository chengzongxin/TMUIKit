//
//  NSTimer+SGLUnRetain.h
//  Matafy
//
//  Created by Jason on 2018/12/27.
//  Copyright © 2018 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (SGLUnRetain)
+ (NSTimer *)sgl_scheduledTimerWithTimeInterval:(NSTimeInterval)inerval
                                        repeats:(BOOL)repeats
                                          block:(void(^)(NSTimer *timer))block;
@end

NS_ASSUME_NONNULL_END
