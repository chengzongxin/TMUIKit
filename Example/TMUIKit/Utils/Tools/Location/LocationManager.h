//
//  LocationManager.h
//  Matafy
//
//  Created by Fussa on 2019/5/2.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMKLocationKit/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#define kLocationManager [LocationManager sharedManager]

NS_ASSUME_NONNULL_BEGIN

/**
 逆地理编码检索回调

 @param coordinate 检索的经纬度
 @param result 检索结果
 @param success 是否成功(若失败, result返回nil)
 */
typedef void (^LocationManagerGeoResultBlock)(CLLocationCoordinate2D coordinate, BMKReverseGeoCodeSearchResult * _Nullable result, BOOL success);
/// 连续定位回调
typedef void (^LocationManagerLocationBlock)(BMKLocation *location, NSError * _Nullable error);
/// 单次定位回调
typedef void (^LocationManagerRequestLocationCompletionBlock)(BMKLocation *location, NSError * _Nullable error);
/// 经纬度更新回调
typedef void (^LocationManagerCoordinateUpdateBlock)(CLLocationCoordinate2D coordinate, NSError * _Nullable error);
/// 朝向更新回调
typedef void (^LocationManagerHeadingUpdateBlock)(CLHeading *heading);
/// 定位权限改版回调
typedef void (^LocationManagerAuthorizationStatusChangeBlock)(CLAuthorizationStatus status);

@interface LocationManager : NSObject

+ (instancetype)sharedManager;
/// 逆地理编码检索回调
@property(nonatomic, copy) LocationManagerGeoResultBlock geoResultBlock;
/// 连续定位更新的回调
@property(nonatomic, copy) LocationManagerCoordinateUpdateBlock locationUpdateBlock;
/// 朝向更新的回调
@property(nonatomic, copy) LocationManagerHeadingUpdateBlock headingUpdateBlock;
/// 定位权限改变的回调
@property(nonatomic, copy) LocationManagerAuthorizationStatusChangeBlock authorizationStatusChangeBlock;
/// 当前位置信息
@property (nonatomic, strong, readonly, nullable) BMKLocation *locationInfo;
/// 当前位置坐标点
@property (nonatomic, assign, readonly) CLLocationCoordinate2D location;
/// 当前位置POI名称
@property (nonatomic, copy, readonly) NSString *currentPoiName;
/// 定位是否可用
@property (nonatomic, assign, readonly) BOOL isLocationServiceEnable;

/// 单次定位
- (void)requestLocationWithCompletionBlock:(LocationManagerRequestLocationCompletionBlock)completionBlock;
/// 开始连续定位
- (void)startUpdatingLocation;
/// 停止连续定位
- (void)stopUpdatingLocation;

/// 开始连续定位
- (void)startUpdatingLocationWithGeoResult:(LocationManagerGeoResultBlock)resultCallBack;
/// 开始连续定位
- (void)startUpdatingLocationWithLocation:(LocationManagerLocationBlock)locationCallBack;
/// 反地理编码
- (void)reverseGeoCodeOptionWith:(CLLocationCoordinate2D)coordinate callBack:(LocationManagerGeoResultBlock)callBack;

@end

NS_ASSUME_NONNULL_END
