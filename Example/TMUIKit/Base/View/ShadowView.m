//
//  ShadowImageView.m
//  Matafy
//
//  Created by Jason on 2018/8/23.
//  Copyright © 2018年 com.upintech. All rights reserved.
//

#import "ShadowView.h"

@interface ShadowView ()
{
    UIView *_contentView;
}
@end

@implementation ShadowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self initViews];
    [self initConstraints];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    [self initViews];
    [self initConstraints];
    
    return self;
}

- (void)initViews
{
    self.backgroundColor = UIColor.whiteColor;
    self.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowRadius = 4;
    
    _contentView = [[UIView alloc] init];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentView.userInteractionEnabled = NO;
    _contentView.layer.masksToBounds = YES;
    
    [self setRadius:6];
    
    [super addSubview:_contentView];
}

- (void)initConstraints
{
    [_contentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [_contentView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [_contentView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [_contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
}


#pragma mark - functions

// Override to add views to content view
- (void)addSubview:(UIView *)view
{
    [_contentView addSubview:view];
}


#pragma mark - properties

- (UIView *)contentView
{
    return _contentView;
}

- (void)setRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    _contentView.layer.cornerRadius = radius;
}


@end
