//
//  CycleView.m
//  Matafy
//
//  Created by Joe on 2020/4/14.
//  Copyright © 2020 com.upintech. All rights reserved.
//

#import "CycleView.h"
#import "SDCycleScrollView+scroll.h"

@interface CycleView ()<SDCycleScrollViewDelegate>

@property (strong, nonatomic) SDCycleScrollView *cycleView;

@end

@implementation CycleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addSubview:self.cycleView];
    }
    return self;
}

- (void)setImageUrls:(NSArray<NSString *> *)imageUrls{
    _imageUrls = imageUrls;
    self.cycleView.imageURLStringsGroup = imageUrls;
}

- (SDCycleScrollView *)cycleView{
    if (!_cycleView) {
//        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds imageNamesGroup:@[@"museum_banner_01"]];
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds shouldInfiniteLoop:NO imageNamesGroup:@[@"museum_banner_01"]];
        _cycleView.backgroundColor = UIColor.whiteColor;
        _cycleView.delegate = self;
        _cycleView.showPageControl = NO;
        _cycleView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleView.autoScroll = YES;
        _cycleView.autoScrollTimeInterval = 5;
        _cycleView.layer.cornerRadius = 8;
        _cycleView.layer.masksToBounds = YES;
    }
    return _cycleView;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"%zd",index);
    if (self.tapItem) {
        self.tapItem(index);
    }
    if (self.tapScaleEnable) {
        [MTFYPhotoBrowser browserWithImages:cycleScrollView.imageURLStringsGroup sourceView:cycleScrollView currentIndex:index];
    }
}


@end
