//
//  LocationManager.m
//  Matafy
//
//  Created by Fussa on 2019/5/2.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager()<BMKLocationManagerDelegate, BMKGeoCodeSearchDelegate, BMKLocationAuthDelegate>

@property (nonatomic, strong) BMKLocationManager *manager;
/// 逆地理编码检索对象
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic, strong) BMKReverseGeoCodeSearchResult *searchResult;
@property (nonatomic, strong, readwrite, nullable) BMKLocation *locationInfo;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, copy) NSString *currentPoiName;

/// 当前位置地理反编码回调
@property (nonatomic, copy) LocationManagerGeoResultBlock geoResultCallBack;
/// 连续定位回调
@property (nonatomic, copy) LocationManagerLocationBlock locationCallBack;
/// 单次定位回调
@property (nonatomic, copy) LocationManagerLocationBlock singerRequestLocationCallBack;

/// 根据经纬度进行逆地理反编码的检索对象
@property (nonatomic, strong) BMKGeoCodeSearch *locationGeoCodeSearch;
/// 根据经纬度地理反编码回调
@property (nonatomic, copy) LocationManagerGeoResultBlock locationGeoResultCallBack;

@end

@implementation LocationManager
+ (instancetype)sharedManager {
    static LocationManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[LocationManager alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.geoCodeSearch.delegate = self;
    self.locationGeoCodeSearch.delegate = self;
    [self initLocationManager];
}

- (void)initLocationManager{
    // 定位鉴权
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:BAIDU_MAP_KEY authDelegate:self];
    //定位功能可用
    BMKLocationManager *manager = [[BMKLocationManager alloc] init];
    self.manager = manager;
    manager.delegate = self;
    // 设定定位坐标系类型.
    manager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    // 设定定位的最小更新距离.
    manager.distanceFilter = kCLLocationAccuracyBestForNavigation;
    // 设定定位精度.
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设定定位类型
    manager.activityType = CLActivityTypeAutomotiveNavigation;
    // 指定定位是否会被系统自动暂停
    manager.pausesLocationUpdatesAutomatically = NO;
    // 是否允许后台定位。默认为NO。只在iOS 9.0及之后起作用。设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
    manager.allowsBackgroundLocationUpdates = NO;
    // 指定单次定位超时时间
    manager.locationTimeout = 10;
    // 指定单次定位逆地理超时时间
    manager.reGeocodeTimeout = 10;
    // 设备指向
    // [manager startUpdatingHeading];
    // 开始连续定位
    // [manager startUpdatingLocation];
}

/// 开始连续定位
- (void)startUpdatingLocation {
    [self.manager startUpdatingLocation];
    [self.manager startUpdatingHeading];
}

/// 停止连续定位
- (void)stopUpdatingLocation {
    [self.manager stopUpdatingLocation];
    [self.manager stopUpdatingHeading];
}

- (void)requestLocationWithCompletionBlock:(LocationManagerRequestLocationCompletionBlock)completionBlock {
    BOOL success = [self.manager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (error) {
            NSLog(@"百度定位失败: %@", error.localizedDescription);
        }
        self.locationInfo = location;
        if (completionBlock) {
            completionBlock(location, error);
        }
    }];

    if (!success) {
        self.singerRequestLocationCallBack = completionBlock;
    }
}

/// 开始连续定位
- (void)startUpdatingLocationWithGeoResult:(LocationManagerGeoResultBlock)resultCompleteHandle {
    self.geoResultCallBack = resultCompleteHandle;
    [self startUpdatingLocation];
}

/// 开始连续定位
- (void)startUpdatingLocationWithLocation:(LocationManagerLocationBlock)locationCompleteHandle {
    self.locationCallBack = locationCompleteHandle;
    [self startUpdatingLocation];
}

/// 定位全选是否可用
- (BOOL)isLocationServiceEnable {
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
         [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined ||
         [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
            return YES;
        }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
            return NO;
        }
    return NO;
}

- (void)reverseGeoCodeOptionWith:(CLLocationCoordinate2D)coordinate callBack:(LocationManagerGeoResultBlock)callBack {
    self.locationGeoResultCallBack = callBack;
    [self reverseGeoCodeOptionWith:coordinate search:self.locationGeoCodeSearch callback:^(BOOL success) {
        if (!success && callBack) {
            callBack(coordinate, nil, NO);
        }
    }];
}

#pragma mark - Action
/// 发起反地理编码
- (void)reverseGeoCodeOptionWith:(CLLocationCoordinate2D)coordinate search:(BMKGeoCodeSearch *)search callback:(void (^)(BOOL success))callback{
    BMKReverseGeoCodeSearchOption *option = [[BMKReverseGeoCodeSearchOption alloc]init];
    option.location = coordinate;
    // 是否访问最新版行政区划数据（仅对中国数据生效）
    option.isLatestAdmin = YES;
    BOOL flag = [search reverseGeoCode: option];
    if (flag) {
//        NSLog(@"逆geo检索发送成功");
    }  else  {
        NSLog(@"逆geo检索发送失败");
    }
    if (callback) {
        callback(flag);
    }
}



#pragma mark - BMKLocationManagerDelegate

/// 当定位发生错误时，会调用代理的此方法
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error {
    
}

/// 连续定位回调函数。
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error {
    self.locationInfo = location;
    CLLocationCoordinate2D coordinate = location.location.coordinate;
    self.location = coordinate;
    if (self.locationUpdateBlock) {
        self.locationUpdateBlock(coordinate, error);
    }
    if (self.locationCallBack) {
        // 连续定位
        self.locationCallBack(location, error);
    }
    if (self.singerRequestLocationCallBack) {
        self.singerRequestLocationCallBack(location, error);
        // 单次定位, 用完一次则销毁
        self.singerRequestLocationCallBack = nil;
    }

    @weakify(self);
    [self reverseGeoCodeOptionWith:coordinate search:self.geoCodeSearch callback:^(BOOL success) {
        @strongify(self);
        if (!success) {
            if (self.geoResultCallBack) {
                self.geoResultCallBack(coordinate, nil, NO);
            }
            if (self.geoResultBlock) {
                self.geoResultBlock(coordinate, nil, NO);
            }
        }
    }];
}

/// 定位权限状态改变时回调函数
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (self.authorizationStatusChangeBlock) {
        self.authorizationStatusChangeBlock(status);
    }
}

/// 该方法为BMKLocationManager提供设备朝向的回调方法
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateHeading:(CLHeading * _Nullable)heading {
    if (self.headingUpdateBlock) {
        self.headingUpdateBlock(heading);
    }
}

#pragma mark - BMKGeoCodeSearchDelegate
/// 接收反向地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        if (searcher == self.geoCodeSearch) {
            self.searchResult = result;
            if (result.poiList.count) {
                self.currentPoiName = result.poiList.firstObject.name;
            }
            if (self.geoResultCallBack) {
                self.geoResultCallBack(result.location, result, YES);
            }
            if (self.geoResultBlock) {
                self.geoResultBlock(result.location, result, YES);
            }
        } else if (searcher == self.locationGeoCodeSearch) {
            if (self.locationGeoResultCallBack) {
                self.locationGeoResultCallBack(result.location, result, YES);
            }
        }
    } else {
        NSLog(@"检索失败");
    }
}

#pragma mark - BMKLocationAuthDelegate
/// 返回授权验证错误
- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError {
    if (iError == BMKLocationAuthErrorSuccess) {
        NSLog(@"百度定位鉴权成功");
    } else {
        NSLog(@"百度定位鉴权失败, %ld",(long)iError);
    }
}

#pragma mark - Setter && Getter
- (NSString *)currentPoiName {
    return [NSString validStr:_currentPoiName];
}
- (BMKGeoCodeSearch *)geoCodeSearch {
    if (!_geoCodeSearch) {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    }
    return _geoCodeSearch;
}

- (BMKGeoCodeSearch *)locationGeoCodeSearch {
    if (!_locationGeoCodeSearch) {
        _locationGeoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    }
    return _locationGeoCodeSearch;
}

@end
