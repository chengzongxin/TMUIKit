//
//  UIView+MTFY.h
//  Matafy
//
// Created by Fussa on 2019/11/25.
// Copyright (c) 2019 com.upintech. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (MTFY)
@end

#pragma mark - 手势
@interface UIView (MTFY_GESTURE)

#pragma mark 点击手势
/// 点击手势
/// @param tapBlock 手势回调
- (void)mtfy_addSingerTapWithBlock:(void (^)(void))tapBlock;

#pragma mark 双击手势
/// 双击手势
/// @param tapBlock 手势回调
- (void)mtfy_addDoubleTapWithBlock:(void (^)(void))tapBlock;

#pragma mark 长按手势
/// 长按手势
/// @param duration 触发时间
/// @param movement 允许长按时间触发前允许手指滑动的范围，默认是10
/// @param stateBeginBlock 长按开始的回调
/// @param stateEndBlock 长按结束的回调
- (void)mtfy_addLongPressGestureWithMinimumPressDuration:(NSTimeInterval)duration allowableMovement:(CGFloat)movement  stateBegin:(void (^)(void))stateBeginBlock stateEnd:(void (^)(void))stateEndBlock;

/// 长按手势
/// @param duration 触发时间
/// @param stateBeginBlock 长按开始的回调
/// @param stateEndBlock 长按结束的回调
- (void)mtfy_addLongPressGestureWithMinimumPressDuration:(NSTimeInterval)duration stateBegin:(void (^)(void))stateBeginBlock stateEnd:(void (^)(void))stateEndBlock;

#pragma mark 捏合手势
/// 捏合手势
/// @param block 手势回调
- (void)mtfy_addPinchGestureWithBlock:(void (^)(CGFloat scale, CGFloat velocity, UIGestureRecognizerState state))block;

#pragma mark 旋转手势
/// 旋转手势
/// @param block 手势回调
- (void)mtfy_addRotationGestureWithBlock:(void (^)(CGFloat rotation, CGFloat velocity, UIGestureRecognizerState state))block;

#pragma mark 移动手势
/// 移动手势
/// @param block 手势回调
- (void)mtfy_addPanGestureWithBlock:(void (^)(CGPoint point, UIGestureRecognizerState state, UIPanGestureRecognizer *gesture))block;

/// 移动手势
/// @param min 最小手指数
/// @param max 最大手指数
/// @param block 手势回调
- (void)mtfy_addPanGestureWithMinimumNumberOfTouches:(NSUInteger)min maximumNumberOfTouches:(NSUInteger)max block:(void (^)(CGPoint point, UIGestureRecognizerState state, UIPanGestureRecognizer *gesture))block;

#pragma mark 轻扫手势
/// 轻扫手势
/// @param direction 手势方向
/// @param block 手势回调
- (void)mtfy_addSwipeGestureWithDirection:(UISwipeGestureRecognizerDirection)direction block:(void (^)(UIGestureRecognizerState state))block;

/// 轻扫手势
/// @param direction 手势方向
/// @param numberOfTouches 手指数
/// @param block 手势回调
- (void)mtfy_addSwipeGestureWithDirection:(UISwipeGestureRecognizerDirection)direction numberOfTouchesRequired:(NSUInteger)numberOfTouches block:(void (^)(UIGestureRecognizerState state))block;

@end

NS_ASSUME_NONNULL_END
