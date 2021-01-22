//
// Created by Fussa on 2019/10/23.
// Copyright (c) 2019 com.upintech. All rights reserved.
//

#import <IGListKit/IGListSectionController.h>


NS_ASSUME_NONNULL_BEGIN

@interface MTFYEmptySectionController : IGListSectionController

- (instancetype)initWithHeight:(CGFloat)height;

- (void)updateHeight:(CGFloat)height;


@end

NS_ASSUME_NONNULL_END
