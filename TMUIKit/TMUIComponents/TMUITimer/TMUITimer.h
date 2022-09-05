//
//  TMUITimer.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/1/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMUITimer : NSObject

/// 定时器
@property (nonatomic, strong, nullable) NSTimer *timer;

/// 定时器间隔
@property (nonatomic, assign) NSTimeInterval interval;

/// 回调事件
@property (nonatomic, copy) void (^timerEvent)(void);


/// 初始化方法，创建后，会直接运行计时器
- (instancetype)initWithInterval:(NSTimeInterval)interval block:(void(^)(void))block;
/// 启动定时器
- (void)startTimer;
/// 移除定时器
- (void)removeTimer;
/// 恢复计时器
- (void)resumeTimer;
/// 暂停计时器
- (void)pauseTimer;

@end

NS_ASSUME_NONNULL_END
