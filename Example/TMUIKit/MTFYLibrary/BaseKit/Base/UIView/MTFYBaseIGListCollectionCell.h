//
//  MTFYBaseIGListCollectionCell.h
//  Matafy
//
// Created by Fussa on 2019/12/3.
// Copyright (c) 2019 com.upintech. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <IGListKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTFYBaseIGListCollectionCell : UICollectionViewCell<IGListBindable>

-(void)bindViewModel:(id)viewModel;

@end

NS_ASSUME_NONNULL_END
