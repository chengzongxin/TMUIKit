//
//  TMEmptyContentItem.m
//  Masonry
//
//  Created by nigel.ning on 2020/6/29.
//

#import "TMEmptyContentItem.h"
#import "TMUICore.h"

@interface TMEmptyContentItem()
@property (nonatomic, strong)UIImage *emptyImg;
@property (nonatomic, assign)CGSize emptyImgSize;
@end

@implementation TMEmptyContentItem
TMUI_PropertySyntheSize(title);
TMUI_PropertySyntheSize(attributedTitle);
TMUI_PropertySyntheSize(desc);
TMUI_PropertySyntheSize(attributedDesc);
TMUI_PropertySyntheSize(clickEmptyBlock);

+ (instancetype)itemWithEmptyImg:(UIImage *)img emptyImgSize:(CGSize)imgSize {
    TMEmptyContentItem *item = [[[self class] alloc] initWithEmptyImg:img emptyImgSize:imgSize];
    return item;
}

- (instancetype)initWithEmptyImg:(UIImage *)img emptyImgSize:(CGSize)imgSize {
    self = [super init];
    if (self) {
        self.emptyImg = img;
        self.emptyImgSize = imgSize;
    }
    return self;
}

@end
