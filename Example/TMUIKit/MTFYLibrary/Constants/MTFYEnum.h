//
//  MTFYEnum.h
//  Matafy
//
//  Created by Fussa on 2019/12/27.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#ifndef MTFYEnum_h
#define MTFYEnum_h

/**
 业务类型
 */
typedef NS_ENUM(NSUInteger, MTFYBusinessType) {
    MTFYBusinessTypeHotel,                   ///< 酒店
    MTFYBusinessTypeTravel,                  ///< 出行
    MTFYBusinessTypeAirTicket,               ///< 机票
    MTFYBusinessTypeTrainTicket,             ///< 火车票
    MTFYBusinessTypeEntranceTicket,          ///< 门票
    MTFYBusinessTypeMovie,                   ///< 电影
    MTFYBusinessTypeCarRental,               ///< 租车
    MTFYBusinessTypeCosmeticMedicne,         ///< 医美
};

/**
 轮播图类型
 (1:app首页, 2:比码首页, 3:818首页, 4:供应链, 5:机票首页, 6:酒店首页, 7:火车票首页, 8:门票首页, 9:电影票首页, 10:租车首页, 11:打车首页, 12:医美首页)
 */
typedef NS_ENUM(NSUInteger, MTFYBannerType) {
    MTFYBannerTypeAPP                           = 1,    ///< app首页
    MTFYBannerTypeComparePricce                 = 2,    ///< 比码首页
    MTFYBannerType818                           = 3,    ///< 818首页
    MTFYBannerTypeSupplyChain                   = 4,    ///< 供应链
    MTFYBannerTypeAirTicket                     = 5,    ///< 机票首页
    MTFYBannerTypeHotel                         = 6,    ///< 酒店首页
    MTFYBannerTypeTrain                         = 7,    ///< 火车票首页
    MTFYBannerTypePOI                           = 8,    ///< 门票首页
    MTFYBannerTypeMovie                         = 9,    ///< 电影票首页
    MTFYBannerTypeCar                           = 10,   ///< 租车首页
    MTFYBannerTypeTravel                        = 11,   ///< 打车首页
    MTFYBannerTypeMedicial                      = 12,   ///< 医美首页
    MTFYBannerTypeInternationalZhHome           = 13,   ///< 国际版首页
    MTFYBannerTypeInternationalTraditionalZhHome = 14,  ///< 国际版繁体首页
    MTFYBannerTypeInternationalEnHome           = 15,   ///< 国际版英文首页
    MTFYBannerTypeInternationalFrHome           = 16,   ///< 国际版法文首页
    MTFYBannerTypeEnterpriseHome                = 17,   ///< 企业版首页banner
};

/**
 轮播图请求的ClientType
 */
typedef NS_ENUM(NSUInteger, MTFYPlatformType) {
    MTFYPlatformTypeIOS                     = 1,    ///< iOS
    MTFYPlatformTypeAndroid                 = 2,    ///< 安卓
    MTFYPlatformTypeInternationalIOS        = 3,    ///< iOS国际版
    MTFYPlatformTypeInternationalAndroid    = 4,    ///< 安卓国际版
    MTFYPlatformTypeEnterpriseIOS           = 5,    ///< iOS企业版
    MTFYPlatformTypeEnterpriseAndroid       = 6,    ///< 安卓企业版
};


#endif /* MTFYEnum_h */
