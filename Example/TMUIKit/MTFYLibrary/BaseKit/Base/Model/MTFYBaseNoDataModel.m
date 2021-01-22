//
//  MTFYBaseNoDataModel.m
//  Matafy
//
// Created by Fussa on 2019/12/7.
// Copyright (c) 2019 com.upintech. All rights reserved.
//
#import "MTFYBaseNoDataModel.h"

@implementation MTFYBaseNoDataModel
- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName {
    self = [super init];
    if (self) {
        self.title = title;
        self.imageName = imageName;
    }

    return self;
}

+ (instancetype)modelWithTitle:(NSString *)title imageName:(NSString *)imageName {
    return [[self alloc] initWithTitle:title imageName:imageName];
}


- (id <NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(NSObject <IGListDiffable> *)object {
    if (object != self) {
        return NO;
    } else if (![object isKindOfClass:[MTFYBaseNoDataModel class]]) {
        return NO;
    } else {
        return [self isEqual:object];
    }
}

@end
