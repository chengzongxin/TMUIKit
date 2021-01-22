//
//  NSTimer+SGLUnRetain.m
//  Matafy
//
//  Created by Jason on 2018/12/27.
//  Copyright © 2018 com.upintech. All rights reserved.
//

#import "NSTimer+SGLUnRetain.h"

@implementation NSTimer (SGLUnRetain)
+ (NSTimer *)sgl_scheduledTimerWithTimeInterval:(NSTimeInterval)inerval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block{
    
    return [NSTimer scheduledTimerWithTimeInterval:inerval target:self selector:@selector(sgl_blcokInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)sgl_blcokInvoke:(NSTimer *)timer {
    
    void (^block)(NSTimer *timer) = timer.userInfo;
    
    if (block) {
        block(timer);
    }
}
@end
