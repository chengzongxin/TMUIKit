//
//  MTFYBaseNoDataView.m
//  Matafy
//
// Created by Fussa on 2019/12/7.
// Copyright (c) 2019 com.upintech. All rights reserved.
//
#import "MTFYBaseNoDataView.h"

@interface MTFYBaseNoDataView()

@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *label;

@end

@implementation MTFYBaseNoDataView
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
    self.backgroundColor = [UIColor clearColor];

    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor clearColor];
    self.containerView = containerView;
    [self addSubview:containerView];

    UIImage *image = [UIImage imageNamed:@"official_no_comment"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView = imageView;
    [containerView addSubview:imageView];

    UILabel *label = [UILabel new];
    label.text = kLStr(@"common_no_data");
    label.textColor = ColorHex(0x8F8F8F);
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    self.label = label;
    [containerView addSubview:label];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.imageView.superview);
        make.bottom.mas_equalTo(self.label.mas_top).inset(10);
    }];
    
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.label.superview);
        make.top.mas_equalTo(self.imageView.mas_bottom).inset(10);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.mas_equalTo(self);
    }];
}

- (void)setModel:(MTFYBaseNoDataModel *)model {
    _model = model;
    UIImage *image = [UIImage imageNamed:model.imageName];
    if ([NSString isEmpty:model.imageName] || !image) {
        self.imageView.hidden = YES;

        if ([NSString isNotEmpty:model.title]) {
            self.label.text = model.title;
        }

        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.mas_equalTo(self.containerView);
        }];

    } else {
        self.imageView.image = image;
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self.imageView.superview);
            make.bottom.mas_equalTo(self.label.mas_top).inset(10);
        }];

        [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(self.label.superview);
            make.top.mas_equalTo(self.imageView.mas_bottom).inset(10);
        }];
    }
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.mas_equalTo(self);
    }];
}


@end
