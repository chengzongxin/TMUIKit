//
// Created by Fussa on 2019/9/18.
// Copyright (c) 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NSObject (Coordinate)

/**
 * 转化为弧度(rad)
 */
- (double)mtfy_rad:(double)d;

/**
 * 弧度换成度
 * @param value 弧度
 * @return 度
 */
- (double)mtfy_deg:(double)value;


 /**
  * 求两经纬度距离
  * @param coordinate1 第一点的经纬度
  * @param coordinate2 第二点的经纬度
  * @return 距离 (单位 km)
  */
- (double)mtfy_getDistanceWithCoordinate1:(CLLocationCoordinate2D)coordinate1 coordinate2:(CLLocationCoordinate2D)coordinate2;


/**
 * 求两经纬度距离 方法二
 * @param coordinate1 第一点的经纬度
 * @param coordinate2 第二点的经纬度
 * @return 距离 (单位 km)
 */
- (double)mtfy_getDistanceTwoWithCoordinate1:(CLLocationCoordinate2D)coordinate1 coordinate2:(CLLocationCoordinate2D)coordinate2;

/**
 * 求两经纬度方向角
 * @param coordinate1 第一点的经纬度
 * @param coordinate2 第二点的经纬度
 * @return 方位角，角度（单位：°）
 */
- (double)mtfy_getDirectionAngleWithCoordinate1:(CLLocationCoordinate2D)coordinate1 coordinate2:(CLLocationCoordinate2D)coordinate2;

/**
 * 已知一点经纬度A，和与另一点B的距离和方位角，求B的经纬度
 * @param coordinate A的经纬度
 * @param distance AB距离（单位：米）
 * @param brng AB方位角
 * @return B的经纬度
 * */
- (CLLocationCoordinate2D)mtfy_convertDistanceToCoordinateWith:(CLLocationCoordinate2D)coordinate distance:(double)distance brng:(double)brng;


@end