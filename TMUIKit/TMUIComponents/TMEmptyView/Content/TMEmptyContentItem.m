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
TMUI_PropertySyntheSize(distanceBetweenImgBottomAndTitleTop);
TMUI_PropertySyntheSize(emptyBackgroundColor);
TMUI_PropertySyntheSize(navBackIcon);


+ (instancetype)itemWithEmptyType:(TMEmptyContentType)type {
    NSString *imgName = tmui_emptyImageNameByType(type);
    CGSize imgSize = tmui_emptyImgSizeByType(type);
    UIImage *img = imgName ? [UIImage imageNamed:imgName] : nil;
    
    TMEmptyContentItem *item = [self itemWithEmptyImg:img emptyImgSize:img ? imgSize : CGSizeZero];
    
    item.title = tmui_emptyTitleByType(type);
    item.attributedTitle = tmui_emptyAttributedTitleByType(type);
    
    item.desc  = tmui_emptyDescByType(type);
    item.attributedDesc = tmui_emptyAttributedDescByType(type);
    
    item.distanceBetweenImgBottomAndTitleTop = tmui_emptyDistanceBetweenImgBottomAndTitleTopByType(type);
    item.emptyBackgroundColor = tmui_emptyBackgroundColorByType(type);
    
    item.navBackIcon = tmui_emptyNavBackIconByType(type);
    item.contentCenterOffsetY = tmui_emptyContentCenterOffsetYByType(type);
    
    return item;
}

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
        self.distanceBetweenImgBottomAndTitleTop = 24;
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

#pragma mark - INLINE HELP METHODS

NS_INLINE CGSize tmui_emptyImgSizeByType(TMEmptyContentType type) {
    if (type == TMEmptyContentTypePhotoDetailErr ||
        type == TMEmptyContentTypeVideoDetailErr) {
        return CGSizeMake(50, 36);
    }
    return CGSizeMake(100, 100);
}

NS_INLINE NSString *tmui_emptyTitleByType(TMEmptyContentType type) {
    NSArray *titles = @[
        @"这里空空如也",
        @"网络正在开小差",
        kTMEmptyViewServerErrTitle,
        @"收藏夹空空的",
        @"还没有喜欢的内容",
        @"还没有发布过内容",
        @"该内容已不存在",
        @"还没有评论",
        @"暂无搜索结果",
        @"还没有相关订单",
        @"暂时还没有获得礼品哦",
        //8.8新增特定场景空态或错误页
        kTMEmptyViewPhotoDetailEmptyTitle,
        kTMEmptyViewVideoDetailEmptyTitle,
    ];
    
    return (type >= 0 && type < titles.count) ? titles[type] : nil;
}


NS_INLINE NSAttributedString *tmui_emptyAttributedTitleByType(TMEmptyContentType type) {
    if (type == TMEmptyContentTypePhotoDetailErr ||
        type == TMEmptyContentTypeVideoDetailErr) {
        NSString *title = tmui_emptyTitleByType(type);
        if (title.length > 0) {
            NSMutableParagraphStyle *pStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
            pStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            pStyle.alignment = NSTextAlignmentCenter;
            NSAttributedString *attrStr = [[NSAttributedString alloc]
                                                  initWithString:title attributes:@{NSParagraphStyleAttributeName: pStyle, NSForegroundColorAttributeName : [[UIColor whiteColor] colorWithAlphaComponent:0.6],
                                                                                    NSFontAttributeName: UIFont(14)
                                                  }];
            return attrStr;
        }
    }
    return nil;
}

NS_INLINE NSString *tmui_emptyDescByType(TMEmptyContentType type) {
    NSArray *descs = @[
        @"去其它地方逛逛吧",
        @"点击刷新一下屏幕吧",
        kTMEmptyViewServerErrDesc,
        @"快去找感兴趣的内容吧",
        @"快去找喜欢的内容吧",
        @"去分享一下你的灵感吧",
        @"去看看其他有趣的内容吧",
        @"快去发表你的观点吧",
        @"没找到呢，换个关键词试试",
        @"去开启你的装修之旅吧",
        @"去参加活动赢取大奖吧",
        //8.8新增特定场景空态或错误页--desc默认为空
        @"",
        @"",
    ];
    
    return (type >= 0 && type < descs.count) ? descs[type] : nil;
}

NS_INLINE NSAttributedString *tmui_emptyAttributedDescByType(TMEmptyContentType type) {
    return nil;
}

NS_INLINE NSInteger tmui_emptyDistanceBetweenImgBottomAndTitleTopByType(TMEmptyContentType type) {
    if (type == TMEmptyContentTypePhotoDetailErr ||
        type == TMEmptyContentTypeVideoDetailErr) {
        return 16;
    }
    return 24;
}

NS_INLINE UIColor * tmui_emptyBackgroundColorByType(TMEmptyContentType type) {
    if (type == TMEmptyContentTypePhotoDetailErr ||
        type == TMEmptyContentTypeVideoDetailErr) {
        return [UIColor blackColor];
    }
    return nil;
}

NS_INLINE CGFloat tmui_emptyContentCenterOffsetYByType(TMEmptyContentType type) {
    if (type == TMEmptyContentTypePhotoDetailErr ||
        type == TMEmptyContentTypeVideoDetailErr) {
        //此两个空态类型特殊，需要整体居中显示
        return 0;
    }
    //通用空态样式内容默认向上偏移70位置显示
    return -70;
}

@end
