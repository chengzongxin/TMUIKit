//
// Created by Fussa on 2019/9/18.
// Copyright (c) 2019 com.upintech. All rights reserved.
//

#import "NSObject+Coordinate.h"
#include <math.h>

/**
 * 地球赤道半径(km)
 */
static double const kEarthRadius = 6378.137;

/**
 * 地球每度的弧长(km)
 */
static double const kEarthARC = 111.199;

/*
 * 大地坐标系资料WGS-84 长半径a=6378137 短半径b=6356752.3142 扁率f=1/298.2572236
 */
/** 长半径a=6378137 */
static double kEarthRadiusLong = 6378137;
/** 短半径b=6356752.3142 */
static double kEarthRadiusShort = 6356752.3142;
/** 扁率f=1/298.2572236 */
static double kEarthOblateness = 1 / 298.2572236;


@implementation NSObject (Coordinate)


///转化为弧度(rad)
- (double)mtfy_rad:(double)d {
    return (d * M_PI)/180.0;
}

/// 弧度换成度
- (double)mtfy_deg:(double)d {
    return (d * 180.0)/M_PI;
}

/// 求两经纬度距离
- (double)mtfy_getDistanceWithCoordinate1:(CLLocationCoordinate2D)coordinate1 coordinate2:(CLLocationCoordinate2D)coordinate2 {
    double r1 = [self mtfy_rad:coordinate1.latitude];
    double r2 = [self mtfy_rad:coordinate1.longitude];
    double a = [self mtfy_rad:coordinate2.latitude];
    double b = [self mtfy_rad:coordinate2.longitude];
    double s = acos(cos(r1) * cos(a) * cos(r2 - b)
            + sin(r1) * sin(a))
            * kEarthRadius;
    return s;
}


/// 求两经纬度距离 方法二
- (double)mtfy_getDistanceTwoWithCoordinate1:(CLLocationCoordinate2D)coordinate1 coordinate2:(CLLocationCoordinate2D)coordinate2 {
    double radLat1 = [self mtfy_rad:coordinate1.latitude];
    double radLat2 = [self mtfy_rad:coordinate2.latitude];
    double radLon1 = [self mtfy_rad:coordinate1.longitude];
    double radLon2 = [self mtfy_rad:coordinate2.longitude];

    if (radLat1 < 0)
        radLat1 = M_PI / 2 + fabs(radLat1);// south
    if (radLat1 > 0)
        radLat1 = M_PI / 2 - fabs(radLat1);// north
    if (radLon1 < 0)
        radLon1 = M_PI * 2 - fabs(radLon1);// west
    if (radLat2 < 0)
        radLat2 = M_PI / 2 + fabs(radLat2);// south
    if (radLat2 > 0)
        radLat2 = M_PI / 2 - fabs(radLat2);// north
    if (radLon2 < 0)
        radLon2 = M_PI * 2 - fabs(radLon2);// west
    double x1 = cos(radLon1) * sin(radLat1);
    double y1 = sin(radLon1) * sin(radLat1);
    double z1 = cos(radLat1);

    double x2 = cos(radLon2) * sin(radLat2);
    double y2 = sin(radLon2) * sin(radLat2);
    double z2 = cos(radLat2);

    double d = pow((x1 - x2), 2) + pow((y1 - y2), 2)
            + pow((z1 - z2), 2);
    // // 余弦定理求夹角
    // double theta = acos((2 - d) / 2);

    d = pow(kEarthRadius, 2) * d;
    // //余弦定理求夹角
    double theta = acos((2 * pow(kEarthRadius, 2) - d)
            / (2 * pow(kEarthRadius, 2)));

    double dist = theta * kEarthRadius;
    return dist;
}

/// 求两经纬度方向角
- (double)mtfy_getDirectionAngleWithCoordinate1:(CLLocationCoordinate2D)coordinate1 coordinate2:(CLLocationCoordinate2D)coordinate2 {
//    double d = 0;
//    double lat1 = [self mtfy_rad:coordinate1.latitude];
//    double lat2 = [self mtfy_rad:coordinate2.latitude];
//    double lon1 = [self mtfy_rad:coordinate1.longitude];
//    double lon2 = [self mtfy_rad:coordinate2.longitude];
//
//    d = sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(lon2 - lon1);
//    d = sqrt(1 - d * d);
//    d = cos(lat2) * sin(lon2 - lon1) / d;
//    d = [self mtfy_deg:asin(d)];
//    if (isnan(d)) {
//        if (lon1 < lon2) {
//            d = 90.0;
//        } else {
//            d = 270;
//        }
//    }
//    return d;
    
//}
//
//function GetLineAngle(lon1, lat1, lon2, lat2)
    double mathPI = M_PI;
    double d = 0;
    double lat1 = coordinate1.latitude;
    double lon1 = coordinate1.longitude;
    double lat2 = coordinate2.latitude;
    double lon2 = coordinate2.longitude;

    double latStart = lat1 * mathPI / 180;
    double lngStart = lon1 * mathPI / 180;
    double latEnd = lat2 * mathPI / 180;
    double lngEnd = lon2 * mathPI / 180;
    if (lon1 == lon2 || lat1 == lat2) {
        /// 经度相同
       if (lon1 == lon2) {
           if (lat2 >= lat1) {
               return 0;
           } else {
               return 180;
           }
       }
        /// 纬度相同
       else {
           if (lon2 >= lon1) {
               return 90;
           } else {
               return 270;
           }
       }
    }

    d = sin(latStart) * sin(latEnd) + cos(latStart) * cos(latEnd) * cos(lngEnd - lngStart);
    d = sqrt(1 - d * d);
    d = cos(latEnd) * sin(lngEnd - lngStart) / d;
    double resultAngle = fabs(asin(d) * 180 / mathPI);

    if (lon2 > lon1) {
        /// 第一象限
       if (lat2 >= lat1) {
           return resultAngle;
       }
       /// 第二象限
       else{
           return 180 - resultAngle;
       }
    } else {
       /// 第四象限
       if (lat2 >= lat1) {
           return 360 - resultAngle;
       }
       /// 第三象限
       else {
           return 180 + resultAngle;
       }
    }
}


/// 已知一点经纬度A，和与另一点B的距离和方位角，求B的经纬度
- (CLLocationCoordinate2D)mtfy_convertDistanceToCoordinateWith:(CLLocationCoordinate2D)coordinate distance:(double)distance brng:(double)brng {
    double alpha1 = [self mtfy_rad:brng];
    double sinAlpha1 = sin(alpha1);
    double cosAlpha1 = cos(alpha1);

    double a = kEarthRadiusLong;
    double b = kEarthRadiusShort;
    double f = kEarthOblateness;

    double tanU1 = (1 - f) * tan([self mtfy_rad:coordinate.latitude]);
    double cosU1 = 1 / sqrt((1 + tanU1 * tanU1));
    double sinU1 = tanU1 * cosU1;
    double sigma1 = atan2(tanU1, cosAlpha1);
    double sinAlpha = cosU1 * sinAlpha1;
    double cosSqAlpha = 1 - sinAlpha * sinAlpha;
    double uSq = cosSqAlpha * (a * a - b * b) / (b * b);
    double A = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
    double B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));

    double cos2SigmaM=0;
    double sinSigma=0;
    double cosSigma=0;
    double sigma = distance / (b * A), sigmaP = 2 * M_PI;
    while (fabs(sigma - sigmaP) > 1e-12) {
        cos2SigmaM = cos(2 * sigma1 + sigma);
        sinSigma = sin(sigma);
        cosSigma = cos(sigma);
        double deltaSigma = B * sinSigma * (cos2SigmaM + B / 4 * (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)
                - B / 6 * cos2SigmaM * (-3 + 4 * sinSigma * sinSigma) * (-3 + 4 * cos2SigmaM * cos2SigmaM)));
        sigmaP = sigma;
        sigma = distance / (b * A) + deltaSigma;
    }

    double tmp = sinU1 * sinSigma - cosU1 * cosSigma * cosAlpha1;
    double lat2 = atan2(sinU1 * cosSigma + cosU1 * sinSigma * cosAlpha1,
            (1 - f) * sqrt(sinAlpha * sinAlpha + tmp * tmp));
    double lambda = atan2(sinSigma * sinAlpha1, cosU1 * cosSigma - sinU1 * sinSigma * cosAlpha1);
    double C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));
    double L = lambda - (1 - C) * f * sinAlpha
            * (sigma + C * sinSigma * (cos2SigmaM + C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));

    double revAz = atan2(sinAlpha, -tmp); // final bearing

//    NSLog(@"revAz--->%f", revAz);
//    NSLog(@"mtfy_convertDistanceToCoordinateWith--->%f+%f,%f", coordinate.longitude, [self mtfy_deg:L], [self mtfy_deg:lat2]);
    return CLLocationCoordinate2DMake([self mtfy_deg:lat2], coordinate.longitude + [self mtfy_deg:L]);
}


@end
