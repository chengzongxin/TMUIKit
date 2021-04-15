//
//  NSTimer+Block.m
//  HouseKeeper
//
//  Created by 荀青锋 on 2019/6/24.
//  Copyright © 2019 binxun. All rights reserved.
//

#import "NSTimer+TMUI.h"

@implementation NSTimer (TMUI)

+ (NSTimer *)tmui_timerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)(void))block
                                        repeats:(BOOL)repeats
                                  mode:(NSRunLoopMode)mode {
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(thk_blockInvoke:) userInfo:[block copy] repeats:repeats];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:mode];
    
    return timer;
}

+ (NSTimer *)tmui_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)(void))block
                                        repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(thk_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)thk_blockInvoke:(NSTimer *)timer {
    void (^block)(void) = timer.userInfo;
    if(block) {block();}
}

+ (dispatch_source_t)tmui_dispatchTimerWithTarget:(id)target
                                    timeInterval:(NSTimeInterval)timeInterval
                                           block:(void(^)(void))block {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), (uint64_t)(timeInterval * NSEC_PER_SEC), 0);
    // 设置回调
    __weak __typeof(target) weaktarget  = target;
    dispatch_source_set_event_handler(timer, ^{
        if (!weaktarget)  {
            dispatch_source_cancel(timer);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {block();}
            });
        }
    });
    // 启动定时器
    dispatch_resume(timer);
    
    return timer;
}

@end
