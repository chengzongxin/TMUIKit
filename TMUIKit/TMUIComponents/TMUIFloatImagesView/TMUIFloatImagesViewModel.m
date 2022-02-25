//
//  THKFloatImagesViewModel.m
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/11/30.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "TMUIFloatImagesViewModel.h"
#import <objc/runtime.h>

@interface TMUIFloatImagesViewModel ()
@property (nonatomic, strong) NSArray <THKFloatImageModel *> *model;
@end

@implementation TMUIFloatImagesViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithModel:(id)model {
    self = [super init];
    if (self) {
        [self initialize];
        self.model = model;
    }
    return self;
}

- (void)bindWithModel:(id)model {
    self.model = model;
}

- (void)setModel:(NSArray<THKFloatImageModel *> *)model{
    _model = model;
    
    if ([model isKindOfClass:NSArray.class]) {
        _imageNum = model.count;
    }
}

- (void)initialize{
//    [super initialize];
    
    self.maxShowNum = 9;
    self.minimumInteritemSpacing = 8;
    self.minimumLineSpacing = 8;
    self.itemCornerRadius = 2;
}

@end

@implementation THKFloatImageModel
@end
