//
//  MTFYLoadingView.m
//  Matafy
//
//  Created by Tiaotiao on 2019/4/16.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYLoadingView.h"

@interface MTFYLoadingView ()

@property (nonatomic, strong) MaterialDesignSpinner *spinner;

@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation MTFYLoadingView

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self.layer applyShadow:HEXCOLOR(0x85868B) alpha:1 x:0 y:0 blue:16 spread:0];
        self.layer.cornerRadius = 8;
    }
    return self;
}

#pragma mark - Public

- (void)show {
    if ([self.spinner superview]) {
        [self.spinner removeFromSuperview];
        self.spinner = nil;
    }
    
    [self addSubview:self.spinner];
}

- (void)showWithStatus:(NSString *)status {
    [self show];
    if (!self.statusLabel.superview) {
        [self addSubview:self.statusLabel];
        CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        self.statusLabel.center = center;
        self.statusLabel.x = 0;
        self.statusLabel.width = self.frame.size.width;
    }
    self.statusLabel.text = status;
}

- (void)dismiss {
    if ([self superview]) {
        [self.spinner stopAnimating];
        [self.spinner removeFromSuperview];
        self.spinner = nil;
        [self removeFromSuperview];
    }
}

- (void)showWithNoRemove {
    self.hidden = NO;
    [self.spinner startAnimating];
    [self addSubview:self.spinner];
}

- (void)dismissNoRemove {
    [self.spinner stopAnimating];
    self.hidden = YES;
}

- (void)showWithStatusWithNoRemove:(NSString *)status {
    [self showWithNoRemove];
    if (!self.statusLabel.superview) {
        [self addSubview:self.statusLabel];
        CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        self.statusLabel.center = center;
        self.statusLabel.x = 0;
        self.statusLabel.width = self.frame.size.width;
    }
    self.statusLabel.text = status;
}

#pragma mark - Event Respone

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Getters and Setters

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.frame = CGRectMake(0, 0, 45, 15);
        _statusLabel.font = [UIFont pingFangSCRegular:10];
        _statusLabel.textColor = HEXCOLOR(0x999999);
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}
     
- (MaterialDesignSpinner *)spinner {
    if (!_spinner) {
        CGFloat lineWidth = 2.0;
        CGFloat w = self.width - lineWidth * 2;
        _spinner = [[MaterialDesignSpinner alloc] initWithFrame:CGRectMake(lineWidth, lineWidth, w, w)];
        _spinner.lineWidth = lineWidth;
        _spinner.tintColor = self.lineColor ? self.lineColor : [UIColor whiteColor];
        [_spinner startAnimating];
    }
    return _spinner;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    
    if (lineColor) {
        self.spinner.tintColor = lineColor;
    }
}

#pragma mark - Supperclass

#pragma mark - NSObject

@end
