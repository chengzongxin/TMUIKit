//
// Created by Fussa on 2019/10/23.
// Copyright (c) 2019 com.upintech. All rights reserved.
//

#import "MTFYEmptySectionController.h"


@interface MTFYEmptySectionController()
@property (nonatomic, assign) CGFloat sectionHeight;
@end

@implementation MTFYEmptySectionController

- (instancetype)initWithHeight:(CGFloat)height {
    if (self = [super init]) {
        self.sectionHeight = height;
    }
    return self;
}

- (void)updateHeight:(CGFloat)height {
    self.sectionHeight = height;
    [self reloadCollectionView];
}


- (void)reloadCollectionView {
    @weakify(self);
    [self.collectionContext performBatchAnimated:NO updates:^(id<IGListBatchContext>  _Nonnull batchContext) {
        @strongify(self);
        [batchContext reloadSectionController:self];
    } completion:nil];
}

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(kMTFYScreenW, self.sectionHeight);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:[UICollectionViewCell class] forSectionController:self atIndex:index];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - Pribvate




@end
