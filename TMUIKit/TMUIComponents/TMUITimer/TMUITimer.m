//
//  TMUITimer.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/1/27.
//

#import "TMUITimer.h"
#import "NSTimer+TMUI.h"

@interface TMUITimer ()

@end

@implementation TMUITimer

- (instancetype)initWithInterval:(NSTimeInterval)interval block:(void (^)(void))block{
    if (self = [super init]) {
        self.interval = interval;
        self.timerEvent = block;
        [self startTimer];
    }
    return self;
}

- (void)didInitailize{
    [self addObservers];
}


- (void)addObservers {
    
    // 后台进前台通知 UIApplicationDidBecomeActiveNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    // 进入后台通知 UIApplicationDidEnterBackgroundNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)startTimer {
    [self removeTimer];
    
    self.timer = [NSTimer tmui_scheduledTimerWithTimeInterval:self.interval block:self.timerEvent repeats:YES];
}

- (void)removeTimer {
    if (!self.timer) {
        return;
    }
    
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
    
    self.timer = nil;
}

- (void)resumeTimer {
    if (!self.timer) {
        return;
    }
    
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)pauseTimer {
    if (!self.timer) {
        return;
    }
    
    [self.timer setFireDate:[NSDate distantFuture]];
}

// 后台进前台通知
// UIApplicationDidBecomeActiveNotification
- (void)didBecomeActive {
    [self resumeTimer];
}

// 进入后台通知
// UIApplicationDidEnterBackgroundNotification
- (void)didEnterBackground {
    [self pauseTimer];
}

@end
