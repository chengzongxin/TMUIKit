//
//  MTFYAvatarView.m
//  Matafy
//
// Created by Fussa on 2019/12/5.
// Copyright (c) 2019 com.upintech. All rights reserved.
//
#import "MTFYAvatarView.h"

@implementation MTFYAvatarView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.layer.cornerRadius = self.height * 0.5;
    self.layer.masksToBounds = YES;
}
@end