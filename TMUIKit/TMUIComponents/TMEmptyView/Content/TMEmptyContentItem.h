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

/**
 便捷生成对应type类型的空态视图对象,内部会处理相关需要显示的内容及UI位置等.
 */
+ (instancetype)itemWithEmptyType:(TMEmptyContentType)type;

/**
 若外部使用方法初始化，则相关具体数据内容需要自行赋值.
 */
+ (instancetype)itemWithEmptyImg:(UIImage *)img emptyImgSize:(CGSize)imgSize;

@end

#pragma mark - template content item subInfos

/// !!!: 普通场景模版样式的空态页显示对应的占位图、标题串、副描述串等数据的取值方法|  注意：以下type对应获取的图片名、标题串、副描述串均为常规类型页面下的显示数据，一些特定场景数据可能只会用到指定的某类型的占位图，其它标题、描述串可能是额外指定其它的值
/// !!!: 8.8 版本更新，优化相关代码将外部不用关注的其它inline方法放置到.m文件中，不对外暴露

/// 获取的占位图，对应显示的size应该为 {160, 160}
/// @warning 因相关资源图片是打包到此私有库中 且配置的资源代码读取路径为 TMEmptyUIAssets.bundle， 故相关图片名为拼接串，拼接格式为： "TMEmptyUIAssets.bundle/imgName"
NS_INLINE NSString *tmui_emptyImageNameByType(TMEmptyContentType type) {
    NSArray *imgNames = @[
        @"noData",
        @"netErr",
        @"noData",
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
