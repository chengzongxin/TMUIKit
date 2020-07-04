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
TMUI_PropertySyntheSize(contentCenterOffsetY);

+ (instancetype)itemWithEmptyType:(TMEmptyContentType)type emptyImgSize:(CGSize)imgSize {
    UIImage *img = nil;
    NSString *imgName = tmui_emptyImageNameByType(type);
    if (imgName) {
        img = [UIImage imageNamed:imgName];
    }
    return [self itemWithEmptyImg:img emptyImgSize:imgSize];
}

+ (instancetype)itemWithEmptyImg:(UIImage *)img emptyImgSize:(CGSize)imgSize {
    TMEmptyContentItem *item = [[[self class] alloc] initWithEmptyImg:img emptyImgSize:imgSize];
    return item;
}

- (instancetype)initWithEmptyImg:(UIImage *)img emptyImgSize:(CGSize)imgSize {
    self = [super init];
    if (self) {
        self.emptyImg = img;
        self.emptyImgSize = imgSize;
        self.contentCenterOffsetY = -70;
    }
    return self;
}

#pragma mark - protocol api methods
- (void)updateImage:(UIImage *)img {
    self.emptyImg = img;
}

- (void)updateImageFromType:(TMEmptyContentType)type {
    UIImage *img = nil;
    NSString *imgName = tmui_emptyImageNameByType(type);
    if (imgName) {
        img = [UIImage imageNamed:imgName];
    }
    self.emptyImg = img;
}

- (void)updateImageSize:(CGSize)imgSize {
    self.emptyImgSize = imgSize;
}

@end
