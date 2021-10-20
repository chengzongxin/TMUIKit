//
//  TMUIDebugViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/10/19.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUIDebugViewController.h"

@interface UIScrollView1 : UIScrollView<UIScrollViewDelegate, UIGestureRecognizerDelegate>
@end
@implementation UIScrollView1

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [RACObserve(self, contentOffset) subscribeNext:^(id  _Nullable x) {
            NSLog(@"UIScrollView1 %@",x);
        }];
    }
    return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end

@interface UIScrollView2 : UIScrollView<UIScrollViewDelegate, UIGestureRecognizerDelegate>
@end
@implementation UIScrollView2
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [RACObserve(self, contentOffset) subscribeNext:^(id  _Nullable x) {
            NSLog(@"UIScrollView2 %@",x);
        }];
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}
@end

@interface TMUIDebugViewController ()
@property (nonatomic, strong) UIScrollView1 *scroll1;
@property (nonatomic, strong) UIScrollView2 *scroll2;
@end

@implementation TMUIDebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView1 *scroll1 = (UIScrollView1 *)UIScrollView1.new
        .embedIn(self.view,20,20,20)
        .bgColor(@"random")
        .tg(1);
    
    View.addTo(scroll1).xywh(0,400,TMUI_SCREEN_WIDTH,50).bgColor(@"random");
    
    UIScrollView2 *scroll2 = (UIScrollView2 *)UIScrollView2.new
        .addTo(scroll1)
        .xywh(20,20,self.view.width - 80, self.view.height - 80)
        .bgColor(@"random")
        .tg(2);
    scroll1.contentSize = self.view.bounds.size;
    scroll2.contentSize = self.view.bounds.size;
    
    View.addTo(scroll2).xywh(0,300,TMUI_SCREEN_WIDTH,50).bgColor(@"random");
    
    Log(scroll1);
    Log(scroll2);
    
    _scroll1 = scroll1;
    _scroll2 = scroll2;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"DEBUG" style:UIBarButtonItemStylePlain target:self action:@selector(debug)];
}

- (void)debug{
//    _scroll2.contentOffset = CGPointMake(_scroll2.contentOffset.x, _scroll2.contentOffset.y + 50);
    _scroll2.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
}

@end
