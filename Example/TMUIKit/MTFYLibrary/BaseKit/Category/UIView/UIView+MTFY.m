//
//  UIView+MTFY.m
//  Matafy
//
// Created by Fussa on 2019/11/25.
// Copyright (c) 2019 com.upintech. All rights reserved.
//
#import "UIView+MTFY.h"
#import <objc/runtime.h>


@implementation UIView (MTFY)

@end

static const char *mtfy_p_singerTapBlockKey;
static const char *mtfy_p_doubleTapBlockKey;
static const char *mtfy_p_longPressGestureKey;
static const char *mtfy_p_pinchGestureKey;
static const char *mtfy_p_rotationGestureKey;
static const char *mtfy_p_panGestureKey;
static const char *mtfy_p_swipeGestureKey;

@implementation UIView (MTFY_GESTURE)
#pragma mark 单击
- (void)mtfy_addSingerTapWithBlock:(void (^)(void))tapBlock {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &mtfy_p_singerTapBlockKey);
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_addSingerTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &mtfy_p_singerTapBlockKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &mtfy_p_singerTapBlockKey, tapBlock, OBJC_ASSOCIATION_COPY);
}

- (void)p_addSingerTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        void(^action)(void) = objc_getAssociatedObject(self, &mtfy_p_singerTapBlockKey);
        if (action) {
            action();
        }
    }
}


#pragma mark 双击
- (void)mtfy_addDoubleTapWithBlock:(void (^)(void))tapBlock {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &mtfy_p_doubleTapBlockKey);
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_addDoubleTapGesture:)];
        //需要轻击的次数 默认为2
        gesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &mtfy_p_doubleTapBlockKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &mtfy_p_doubleTapBlockKey, tapBlock, OBJC_ASSOCIATION_COPY);
}

- (void)p_addDoubleTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
         void(^action)(void) = objc_getAssociatedObject(self, &mtfy_p_doubleTapBlockKey);
         if (action) {
             action();
         }
     }
}

#pragma mark 长按
- (void)mtfy_addLongPressGestureWithMinimumPressDuration:(NSTimeInterval)duration allowableMovement:(CGFloat)movement stateBegin:(void (^)(void))stateBeginBlock stateEnd:(void (^)(void))stateEndBlock {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = objc_getAssociatedObject(self, &mtfy_p_longPressGestureKey);
    if (!longPress) {
        longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(p_addLongePressGesture:)];
        // 触发时间
        longPress.minimumPressDuration = duration;
        // 允许长按时间触发前允许手指滑动的范围，默认是10
        longPress.allowableMovement = movement;
        [self addGestureRecognizer:longPress];
        objc_setAssociatedObject(self, &mtfy_p_longPressGestureKey, longPress, OBJC_ASSOCIATION_RETAIN);
    }
    
    void(^longPressStateBlock)(UIGestureRecognizerState state) = ^(UIGestureRecognizerState state) {
        switch (state) {
            case UIGestureRecognizerStateBegan:
                if (stateBeginBlock) {
                    stateBeginBlock();
                }
                break;
            case UIGestureRecognizerStateEnded:
                if (stateEndBlock) {
                    stateEndBlock();
                }
                break;
            default:
                break;
        }
    };
    objc_setAssociatedObject(self, &mtfy_p_longPressGestureKey, longPressStateBlock, OBJC_ASSOCIATION_COPY);
}

- (void)mtfy_addLongPressGestureWithMinimumPressDuration:(NSTimeInterval)duration stateBegin:(void (^)(void))stateBeginBlock stateEnd:(void (^)(void))stateEndBlock {
    [self mtfy_addLongPressGestureWithMinimumPressDuration:duration allowableMovement:10 stateBegin:stateBeginBlock stateEnd:stateEndBlock];
}

- (void)p_addLongePressGesture:(UILongPressGestureRecognizer *)gesture {
    void(^action)(UIGestureRecognizerState state) = objc_getAssociatedObject(self, &mtfy_p_longPressGestureKey);
    if (action) {
        action(gesture.state);
    }
}

#pragma mark 捏合手势
- (void)mtfy_addPinchGestureWithBlock:(void (^)(CGFloat, CGFloat, UIGestureRecognizerState))block {
    self.userInteractionEnabled = YES;
    UIPinchGestureRecognizer *gesture = objc_getAssociatedObject(self, &mtfy_p_pinchGestureKey);
    if (!gesture) {
        gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(p_addPinchGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &mtfy_p_pinchGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &mtfy_p_pinchGestureKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)p_addPinchGesture:(UIPinchGestureRecognizer *)gesture {
     void(^action)(CGFloat scale, CGFloat velocity, UIGestureRecognizerState state) = objc_getAssociatedObject(self, &mtfy_p_pinchGestureKey);
     if (action) {
         action(gesture.scale, gesture.velocity, gesture.state);
     }
}

#pragma mark 旋转手势
- (void)mtfy_addRotationGestureWithBlock:(void (^)(CGFloat, CGFloat, UIGestureRecognizerState))block {
 self.userInteractionEnabled = YES;
    UIRotationGestureRecognizer *gesture = objc_getAssociatedObject(self, &mtfy_p_rotationGestureKey);
    if (!gesture) {
        gesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(p_addRotationGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &mtfy_p_rotationGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &mtfy_p_rotationGestureKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)p_addRotationGesture:(UIRotationGestureRecognizer *)gesture {
     void(^action)(CGFloat rotation, CGFloat velocity, UIGestureRecognizerState state) = objc_getAssociatedObject(self, &mtfy_p_rotationGestureKey);
     if (action) {
         action(gesture.rotation, gesture.velocity, gesture.state);
     }
}

#pragma mark 移动
- (void)mtfy_addPanGestureWithMinimumNumberOfTouches:(NSUInteger)min maximumNumberOfTouches:(NSUInteger)max block:(void (^)(CGPoint, UIGestureRecognizerState, UIPanGestureRecognizer *))block {
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *gesture = objc_getAssociatedObject(self, &mtfy_p_panGestureKey);
    if (!gesture) {
        gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(p_addPanGesture:)];
        gesture.minimumNumberOfTouches = min;
        gesture.maximumNumberOfTouches = max;
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &mtfy_p_panGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &mtfy_p_panGestureKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)mtfy_addPanGestureWithBlock:(void (^)(CGPoint, UIGestureRecognizerState, UIPanGestureRecognizer *))block {
    [self mtfy_addPanGestureWithMinimumNumberOfTouches:1 maximumNumberOfTouches:UINT_MAX block:block];
}

- (void)p_addPanGesture:(UIPanGestureRecognizer *)gesture {
    void(^action)(CGPoint point, UIGestureRecognizerState state, UIPanGestureRecognizer *gesture) = objc_getAssociatedObject(self, &mtfy_p_panGestureKey);
    if (action) {
        CGPoint point = [gesture translationInView:self];
        action(point, gesture.state, gesture);
    }
}

#pragma mark 轻扫
- (void)mtfy_addSwipeGestureWithDirection:(UISwipeGestureRecognizerDirection)direction numberOfTouchesRequired:(NSUInteger)numberOfTouches block:(void (^)(UIGestureRecognizerState))block {
    self.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *gesture = objc_getAssociatedObject(self, &mtfy_p_swipeGestureKey);
    if (!gesture) {
        gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(p_addSwipeGesture:)];
        gesture.direction = direction;
        gesture.numberOfTouchesRequired = numberOfTouches;
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &mtfy_p_swipeGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &mtfy_p_swipeGestureKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)mtfy_addSwipeGestureWithDirection:(UISwipeGestureRecognizerDirection)direction block:(void (^)(UIGestureRecognizerState))block {
    [self mtfy_addSwipeGestureWithDirection:direction numberOfTouchesRequired:1 block:block];
}

- (void)p_addSwipeGesture:(UISwipeGestureRecognizer *)gesture {
    void(^action)(UIGestureRecognizerState state) = objc_getAssociatedObject(self, &mtfy_p_swipeGestureKey);
    if (action) {
        action(gesture.state);
    }
}

@end
