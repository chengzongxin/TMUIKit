//
//  MTFYTimer.h
//  Matafy
//
//  Created by Fussa on 2019/10/18.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSWeakTimer;

/**
 * 计时器
 */
@interface MTFYTimer : NSObject

@property (nonatomic, strong) MSWeakTimer *timer;
@property (atomic, assign) NSTimeInterval tolerance;

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                        target:(id)target
                                      selector:(SEL)selector
                                      userInfo:(id)userInfo
                                       repeats:(BOOL)repeats
                                 dispatchQueue:(dispatch_queue_t)dispatchQueue;

+ (instancetype)scheduledRepeatTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                              target:(id)target
                                            selector:(SEL)selector;

- (void)schedule;
- (void)fire;
- (void)invalidate;
- (id)userInfo;

@end

