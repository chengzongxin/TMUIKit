//
//  MTFYBaseIGListSectionController.m
//  Matafy
//
// Created by Fussa on 2019/12/3.
// Copyright (c) 2019 com.upintech. All rights reserved.
//
#import "MTFYBaseIGListSectionController.h"

@implementation MTFYBaseIGListSectionController

- (void)reloadSectionAnimated:(BOOL)animated {
    @weakify(self);
    [self.collectionContext performBatchAnimated:animated updates:^(id<IGListBatchContext>  _Nonnull batchContext) {
        @strongify(self);
        [batchContext reloadSectionController:self];
    } completion:nil];
}


@end
