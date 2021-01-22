//
// Created by Fussa on 2019/10/30.
// Copyright (c) 2019 com.upintech. All rights reserved.
//

#import "BaseViewController.h"
#import <IGListKit.h>


@interface MTFYBaseIGListCollectionViewController : UIViewController<IGListAdapterDataSource>

@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) IGListAdapter *adapter;
@property(nonatomic,strong) NSMutableArray *objects;

@end
