//
//  AlertController.m
//  Matafy
//
//  Created by Joe on 2019/11/11.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "AlertController.h"

#define kAlertW 294
#define kAlertH 148
#define kAlertShortH 148

@implementation AlertController

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                 buttonTitles:(NSArray *)buttonTitles{
    
    self = [super init];
    if(self) {
        _title = title;
        _subtitle = subtitle;
        _buttonTitles = buttonTitles;
        
        [self setupSubViews];
    }
    return self;
}


- (void)setupSubViews{
    self.frame = ScreenFrame;
    self.backgroundColor = COLOR(0, 0, 0, 0.5);
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)]];
    
    // 判断subtitle几行
    CGFloat padding = 24;
    CGFloat rowHeight = 20;
    CGFloat textWidth = [_subtitle singleLineSizeWithText:[UIFont fontWithName:@"PingFangSC-Regular" size:14]].width;
    int additionRows = textWidth / (kAlertW - padding*2);
    CGFloat additionHeight = additionRows * rowHeight;
    
    // container
    _container = [[UIView alloc] initWithFrame:CGRectMake((kMTFYScreenW-kAlertW)/2.0, -kAlertH, kAlertW, kAlertH + additionHeight)];
    _container.backgroundColor = UIColor.whiteColor;
    _container.layer.cornerRadius = 12;
    _container.layer.masksToBounds = YES;
    [self addSubview:_container];
    // title
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, kAlertW, 25)];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
    _titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = _title;
    [_container addSubview:_titleLabel];
    // subtitle
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 58, kAlertW - padding * 2, 22 + additionHeight)];
    _subtitleLabel.numberOfLines = 0;
    _subtitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _subtitleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleLabel.text = _subtitle;
    [_container addSubview:_subtitleLabel];
    // 添加按钮
    _buttons = [NSMutableArray array];
    for (int i = 0; i < _buttonTitles.count; i++) {
        CGFloat w = kAlertW / 2;
        CGFloat h = 48;
        CGFloat x = i * (kAlertW/_buttonTitles.count);
        CGFloat y = CGRectGetMaxY(_container.bounds) - h;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [btn setTitle:_buttonTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x2A323F) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.layer.cornerRadius = 14;
        btn.backgroundColor = ColorWhite;
        [btn setBorderForColor:HEXCOLOR(0xEEEEEE) width:1 radius:0];
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [_container addSubview:btn];
        [_buttons addObject:btn];
    }
    
    [self hilightButtonIndex:0];
}

- (void)hilightButtonIndex:(NSInteger)index{
    [_buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == index) {
            [obj setTitleColor:HEXCOLOR(0x00C3CE) forState:UIControlStateNormal];
            obj.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
        }else{
            [obj setTitleColor:HEXCOLOR(0x2A323F) forState:UIControlStateNormal];
            obj.titleLabel.font = [UIFont systemFontOfSize:16];
        }
    }];
}

- (void)action:(UIButton *)sender {
    if(_onAction) {
        _onAction(sender.tag);
        [self dismiss];
    }
}

- (void)cancel:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_container];
    if(![_container.layer containsPoint:point]) {
        [self dismiss];
        return;
    }
}

- (void)show {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.container.y = 244;
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



#pragma mark - Public
+ (void)showWithTitle:(NSString *)title subtitle:(NSString *)subtitle buttonTitles:(NSArray *)buttonTitles hilightButtonIndex:(int)index actionHandle:(OnAction)actionHandle{
    AlertController *alert = [[self alloc] initWithTitle:title subtitle:subtitle buttonTitles:buttonTitles];
    [alert hilightButtonIndex:index];
    alert.onAction = actionHandle;
    [alert show];
}

+ (void)showWithTitle:(NSString *)title subtitle:(NSString *)subtitle buttonTitles:(NSArray *)buttonTitles actionHandle:(OnAction)actionHandle{
    [self showWithTitle:title subtitle:subtitle buttonTitles:buttonTitles hilightButtonIndex:0 actionHandle:actionHandle];
}

@end
