//
//  MTFYBaseIGListSectionController.h
//  Matafy
//
// Created by Fussa on 2019/12/3.
// Copyright (c) 2019 com.upintech. All rights reserved.
//
#import <IGListKit/IGListKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTFYBaseIGListSectionController : IGListBindingSectionController

- (void)reloadSectionAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
