//
//  MTFYBaseNoDataModel.h
//  Matafy
//
// Created by Fussa on 2019/12/7.
// Copyright (c) 2019 com.upintech. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "IGListDiffable.h"

@interface MTFYBaseNoDataModel : NSObject<IGListDiffable>

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *imageName;

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName;
+ (instancetype)modelWithTitle:(NSString *)title imageName:(NSString *)imageName;

@end
