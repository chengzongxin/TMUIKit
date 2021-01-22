//
//  MTFYTimer.m
//  Matafy
//
//  Created by Fussa on 2019/10/18.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYTimer.h"
#import <MSWeakTimer/MSWeakTimer.h>

@interface MTFYTimer()

@end


@implementation MTFYTimer
@dynamic tolerance;

-(void)dealloc {
//    NSLog(@"%s",__FUNCTION__);
}

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats dispatchQueue:(dispatch_queue_t)dispatchQueue {
    MSWeakTimer *weakTimer = [MSWeakTimer scheduledTimerWithTimeInterval:timeInterval target:target selector:selector userInfo:userInfo repeats:repeats dispatchQueue:dispatchQueue];
    MTFYTimer *timer = [[MTFYTimer alloc] init];
    timer.timer = weakTimer;
    return timer;
}

+ (instancetype)scheduledRepeatTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector {
    return [self scheduledTimerWithTimeInterval:timeInterval target:target selector:selector userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
}

- (void)schedule {
    [self.timer schedule];
}

- (void)fire {
    [self.timer fire];
}

- (void)invalidate {
    [self.timer invalidate];
}

- (id)userInfo {
    return [self.timer userInfo];
}

- (void)setTolerance:(NSTimeInterval)tolerance {
    self.timer.tolerance = tolerance;
}

- (NSTimeInterval)tolerance {
    return self.timer.tolerance;
}


@end
