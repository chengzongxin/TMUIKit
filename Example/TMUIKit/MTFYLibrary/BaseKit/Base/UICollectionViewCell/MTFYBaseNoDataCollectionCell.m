//
//  MTFYBaseNoDataCollectionCell.m
//  Matafy
//
// Created by 曾福生 on 2019/12/7.
// Copyright (c) 2019 com.upintech. All rights reserved.
//
#import "MTFYBaseNoDataCollectionCell.h"
#import "MTFYBaseNoDataModel.h"
#import "MTFYBaseNoDataView.h"


@interface MTFYBaseNoDataCollectionCell()
@property(nonatomic, strong) MTFYBaseNoDataView *noDataView;
@end
@implementation MTFYBaseNoDataCollectionCell
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
    self.backgroundColor = [UIColor whiteColor];
    MTFYBaseNoDataView *noDataView = [[MTFYBaseNoDataView alloc] init];
    self.noDataView = noDataView;
    [self addSubview:noDataView];
    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.mas_equalTo(self);
    }];
}

- (void)bindViewModel:(MTFYBaseNoDataModel *)viewModel {
    self.noDataView.model = viewModel;
}

@end
