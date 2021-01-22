//
// Created by Fussa on 2019/10/30.
// Copyright (c) 2019 com.upintech. All rights reserved.
//

#import "MTFYBaseIGListCollectionViewController.h"


@implementation MTFYBaseIGListCollectionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}


-(UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter{
    return nil;
}

-(NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter{
    return self.objects;
}

-(IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object{
    return nil;
}

-(NSMutableArray *)objects{
    if (!_objects) {
        _objects = [NSMutableArray array];
    }
    return _objects;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - dealloc
-(void)dealloc {
    NSLog(@"%s", __FUNCTION__);
    if (!self.adapter) {
        return;
    }
    [self.adapter.visibleSectionControllers mtfy_forEach:^(IGListSectionController *element, NSUInteger index) {
        if ([element respondsToSelector:@selector(removeTimer)]) {
            [element performSelector:@selector(removeTimer)];
        }
    }];
}

@end
