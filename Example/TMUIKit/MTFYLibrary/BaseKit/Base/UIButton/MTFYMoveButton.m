//
//  MTFYMoveButton.m
//  Matafy
//
//  Created by Tiaotiao on 2019/5/21.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYMoveButton.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation MTFYMoveButton

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.isNeedMove = YES;
    
    [self setImage:[UIImage imageNamed:@"taxi_ic_surpass"]  forState:UIControlStateNormal];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 18;
    [self.layer applyShadow:[UIColor mtfyBaseShadowColor000000] alpha:0.2 x:0 y:0 blue:8 spread:0];
    [self setSG_eventTimeInterval:2];
    @weakify(self);
    [[self rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.clickSubject sendNext:x];
    }];
    
    //添加手势
    UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panRcognize setMinimumNumberOfTouches:1];
    [panRcognize setEnabled:YES];
    [panRcognize delaysTouchesEnded];
    [panRcognize cancelsTouchesInView];
    [self addGestureRecognizer:panRcognize];
}

#pragma mark - Public

- (void)show {
    if (![self superview]) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
}

- (void)hide {
    if ([self superview]) {
        [self removeFromSuperview];
    }
}

#pragma mark - Event Respone

#pragma mark 刷新按钮拖拽方法

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    if (!self.isNeedMove) return;
 
    //移动状态
    UIGestureRecognizerState recState =  recognizer.state;
    
    switch (recState) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:{
            CGPoint translation = [recognizer translationInView:self.superview];
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
        }
            break;
        case UIGestureRecognizerStateEnded: {
            CGPoint stopPoint = CGPointMake(0, SCREEN_HEIGHT / 2.0);
            if (recognizer.view.center.x < SCREEN_WIDTH / 2.0) {
                if (recognizer.view.center.y <= SCREEN_HEIGHT/2.0) {
                    //左上
                    if (recognizer.view.center.x  >= recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, self.width / 2.0);
                    }else{
                        stopPoint = CGPointMake(self.width / 2.0, recognizer.view.center.y);
                    }
                } else {
                    //左下
                    if (recognizer.view.center.x  >= SCREEN_HEIGHT - recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, SCREEN_HEIGHT - self.width/2.0);
                    } else {
                        stopPoint = CGPointMake(self.width / 2.0, recognizer.view.center.y);
                    }
                }
            } else {
                if (recognizer.view.center.y <= SCREEN_HEIGHT / 2.0) {
                    //右上
                    if (SCREEN_WIDTH - recognizer.view.center.x  >= recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, self.width / 2.0);
                    }else{
                        stopPoint = CGPointMake(SCREEN_WIDTH - self.width / 2.0, recognizer.view.center.y);
                    }
                } else {
                    //右下
                    if (SCREEN_WIDTH - recognizer.view.center.x  >= SCREEN_HEIGHT - recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, SCREEN_HEIGHT - self.width/2.0);
                    }else{
                        stopPoint = CGPointMake(SCREEN_WIDTH - self.width / 2.0, recognizer.view.center.y);
                    }
                }
            }
            
            //如果按钮超出屏幕边缘
            if (stopPoint.y + self.width + kTabBarBottomMargin >= SCREEN_HEIGHT) {
                stopPoint = CGPointMake(stopPoint.x, SCREEN_HEIGHT - self.width - kTabBarBottomMargin);
            }
            
            if (stopPoint.x - self.width /2.0 <= 0) {
                stopPoint = CGPointMake(self.width/2.0, stopPoint.y);
            }
            
            if (stopPoint.x + self.width /2.0 >= SCREEN_WIDTH) {
                stopPoint = CGPointMake(SCREEN_WIDTH - self.width/2.0, stopPoint.y);
            }
            
            if (stopPoint.y - self.width <= kStatusBarHeight) {
                stopPoint = CGPointMake(stopPoint.x, kStatusBarHeight + self.width/2.0);
            }
            
            [UIView animateWithDuration:0.0 animations:^{
                recognizer.view.center = stopPoint;
            }];
        }
            break;
            
        default:
            break;
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.superview];
}

#pragma mark - Delegate
#pragma mark - Private
#pragma mark - Getters and Setters
#pragma mark - Supperclass
#pragma mark - NSObject

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
