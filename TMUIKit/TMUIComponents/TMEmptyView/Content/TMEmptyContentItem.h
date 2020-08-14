//
//  TMEmptyContentItem.h
//  Masonry
//
//  Created by nigel.ning on 2020/6/29.
//

#import <Foundation/Foundation.h>
#import "TMEmptyContentItemProtocol.h"
#import "TMEmptyDefine.h"
#import "TMUIKitDefines.h"

NS_ASSUME_NONNULL_BEGIN

/**
 遵循TMEmptyContentItemProtocol协议的数据类
 @note 外部若有其它自定义的空态样式则可选择自行实现协议 或 直接使用此类进行相关数据的自定义赋值
 */
@interface TMEmptyContentItem : NSObject<TMEmptyContentItemProtocol>

+ (instancetype)itemWithEmptyType:(TMEmptyContentType)type emptyImgSize:(CGSize)imgSize;

+ (instancetype)itemWithEmptyImg:(UIImage *)img emptyImgSize:(CGSize)imgSize;

@end

#pragma mark - template content item subInfos

/// !!!: 普通场景模版样式的空态页显示对应的占位图、标题串、副描述串等数据的取值方法|  注意：以下type对应获取的图片名、标题串、副描述串均为常规类型页面下的显示数据，一些特定场景数据可能只会用到指定的某类型的占位图，其它标题、描述串可能是额外指定其它的值

/// 获取的占位图，对应显示的size应该为 {160, 160}
/// @warning 因相关资源图片是打包到此私有库中 且配置的资源代码读取路径为 TMEmptyUIAssets.bundle， 故相关图片名为拼接串，拼接格式为： "TMEmptyUIAssets.bundle/imgName"
NS_INLINE NSString *tmui_emptyImageNameByType(TMEmptyContentType type) {
    NSArray *imgNames = @[
        @"noData",
        @"netErr",
        @"netErr",
        @"noCollection",
        @"noLike",
        @"noPublishUgc",
        @"dataNoExist",
        @"noComment",
        @"noSearchResult",
        @"noOrder",
        @"noGift",
        //8.8新增特定场景空态或错误页
        @"photoDetailErr",
        @"videoDetailErr"
    ];
    
    NSString *imgName = (type >= 0 && type < imgNames.count) ? imgNames[type] : nil;
    if (imgName.length > 0) {
        imgName = [NSString stringWithFormat:@"TMEmptyUIAssets.bundle/%@", imgName];
    }
    
    return imgName;
}

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

NS_INLINE UIImage * tmui_emptyNavBackIconByType(TMEmptyContentType type) {
    NSString *imgName = @"navBackBlack";//默认白底用黑色icon
    if (type == TMEmptyContentTypePhotoDetailErr ||
        type == TMEmptyContentTypeVideoDetailErr) {
        //黑底用白色icon
        imgName = @"navBackWhite";
    }
    
    imgName = [NSString stringWithFormat:@"TMEmptyUIAssets.bundle/%@", imgName];
    
    return [UIImage imageNamed:imgName];
}

NS_ASSUME_NONNULL_END