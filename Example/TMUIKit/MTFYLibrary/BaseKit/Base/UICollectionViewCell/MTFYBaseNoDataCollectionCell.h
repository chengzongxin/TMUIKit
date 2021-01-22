//
//  MTFYBaseNoDataCollectionCell.h
//  Matafy
//
// Created by 曾福生 on 2019/12/7.
// Copyright (c) 2019 com.upintech. All rights reserved.
//
#import <UIKit/UIKit.h>

@class MTFYBaseNoDataModel;
@interface MTFYBaseNoDataCollectionCell : MTFYBaseIGListCollectionCell

-(void)bindViewModel:(MTFYBaseNoDataModel *)viewModel;

@end