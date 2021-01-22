//
//  MenuPopView.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "PromptView.h"

#define kAlertW 300
#define kAlertH 250
#define kAlertShortH 124

@interface PromptView ()

@end


@implementation PromptView

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                      confirm:(NSString *)confirm
                       cancel:(NSString *)cancel{
    self = [super init];
    if(self) {
        [self setupSubViews];
        _titleLabel.text = title;
        _subtitleLabel.text = subtitle;
        [_confirm setTitle:confirm forState:UIControlStateNormal];
        [_cancel setTitle:cancel forState:UIControlStateNormal];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                      confirm:(NSString *)confirm
                       cancel:(NSString *)cancel{
    self = [super init];
    if(self) {
        [self setupSubViews];
        _container.height = kAlertShortH;
        _titleLabel.text = title;
        [_subtitleLabel removeFromSuperview];
        _confirm.y = 72;
        [_confirm setTitle:confirm forState:UIControlStateNormal];
        _cancel.y = 72;
        [_cancel setTitle:cancel forState:UIControlStateNormal];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}


- (void)setupSubViews{
    self.frame = ScreenFrame;
    self.backgroundColor = COLOR(0, 0, 0, 0.5);
//    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)]];
    // container
    _container = [[UIView alloc] initWithFrame:CGRectMake((kMTFYScreenW-kAlertW)/2.0, -kAlertH, kAlertW, kAlertH)];
    _container.backgroundColor = UIColor.whiteColor;
    _container.layer.cornerRadius = 12;
    _container.layer.masksToBounds = YES;
    [self addSubview:_container];
    // title
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, kAlertW, 25)];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 17];
    _titleLabel.text = kLStr(@"common_alert_warmPrompt");
    _titleLabel.textColor = [UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1.0];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_container addSubview:_titleLabel];
    // subtitle
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 66, kAlertW - 40, 100)];
    _subtitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 14];
    _subtitleLabel.text = kLStr(@"community_index_WarmTip");
    _subtitleLabel.textColor = [UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1.0];
    _subtitleLabel.textAlignment = NSTextAlignmentLeft;
    _subtitleLabel.numberOfLines = 0;
    [_container addSubview:_subtitleLabel];
    // confirm
    _confirm = [[UIButton alloc] initWithFrame:CGRectMake(68, 176, 165, 50)];
    [_confirm setOkaTitleColor:UIColor.whiteColor];
    _confirm.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 17];
    _confirm.layer.cornerRadius = 4;
    _confirm.backgroundColor = HEXCOLOR(0x00C3CE);
    [_confirm setOkaTitle:kLStr(@"common_alert_know")];
    [_container addSubview:_confirm];
    [_confirm addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    //    _confirm.tag = 1;
    //    // cancel
    //    _cancel = [[UIButton alloc] initWithFrame:CGRectMake(kAlertW/2.0, 100, kAlertW/2.0, 48)];
    //    [_cancel setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    //    _cancel.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
    //    _cancel.layer.cornerRadius = 14;
    //    _cancel.backgroundColor = ColorWhite;
    //    [_container addSubview:_cancel];
    //    [_cancel setBorderForColor:HEXCOLOR(0xEEEEEE) width:1 radius:0];
    //    [_cancel addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    //    _cancel.tag = 2;
}

- (void)hilightRightButton{
    _confirm.backgroundColor = HEXCOLOR(0xC9CDD0);
    _cancel.backgroundColor = HEXCOLOR(0x00C3CE);
}

-(void)action:(UIButton *)sender {
//    if(_onAction) {
        //        _onAction(sender.tag);
        [self dismiss];
//    }
}

-(void)cancel:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_container];
    if(![_container.layer containsPoint:point]) {
        [self dismiss];
        return;
    }
    point = [sender locationInView:_cancel];
    if([_cancel.layer containsPoint:point]) {
        [self dismiss];
        return;
    }
}

- (void)show {
    if (UserDefaultObjectForKey(@"prompt")){
        return;
    }else{
        UserDefaultSetObjectForKey(@"prompt", @"prompt");
    }
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.container.y = 209;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.container.y = kMTFYScreenH;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

+ (void)showWithTitle:(NSString *)title
             subtitle:(NSString *)subtitle
              confirm:(NSString *)confirm
               cancel:(NSString *)cancel
        confirmHandle:(AlertViewConfirmHandle)confirmHandle
         cancelHandle:(AlertViewCancelHandle)cancelHandle {
    AlertView *alert = [[AlertView alloc] initWithTitle:title subtitle:subtitle confirm:confirm cancel:cancel];
    alert.onAction = ^(NSInteger index) {
        if (index == 1) {
            if (confirmHandle) {
                confirmHandle();
            }
        } else {
            if (cancelHandle) {
                cancelHandle();
            }
        }
    };
    [alert show];
}
+ (void)showWithTitle:(NSString *)title
              confirm:(NSString *)confirm
               cancel:(NSString *)cancel
        confirmHandle:(AlertViewConfirmHandle)confirmHandle
         cancelHandle:(AlertViewCancelHandle)cancelHandle {
    [self showWithTitle:title subtitle:nil confirm:confirm cancel:cancel confirmHandle:confirmHandle cancelHandle:cancelHandle];
}

+ (void)showWithTitle:(NSString *)title
              confirm:(NSString *)confirm
               cancel:(NSString *)cancel
        confirmHandle:(AlertViewConfirmHandle)handle {
    [self showWithTitle:title confirm:confirm cancel:cancel confirmHandle:handle cancelHandle:nil];
}
@end
