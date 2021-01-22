//
//  MTFYLocationTool.m
//  Matafy
//
//  Created by Tiaotiao on 2019/5/21.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYLocationTool.h"

@implementation MTFYLocationTool

#pragma mark 计算相关

-(CGFloat)mtfy_fetchDistanceBetween:(CGFloat)lat1
                               lng1:(CGFloat)lng1
                               lat2:(CGFloat)lat2
                               lng2:(CGFloat)lng2
{
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    
    CGFloat distance = [curLocation distanceFromLocation:otherLocation];
    
    return  distance;
}

// 返回的是米
- (CGFloat)mtfy_fetchDistance:(CGFloat)lat1 lng1:(CGFloat)lng1 lat2:(CGFloat)lat2 lng2:(CGFloat)lng2 {
    // 地球半径
    int R = 6378137;
    
    //将角度转为弧度
    
    CGFloat radLat1 = [self radians:lat1];
    
    CGFloat radLat2 = [self radians:lat2];
    
    CGFloat radLng1 = [self radians:lng1];
    
    CGFloat radLng2 = [self radians:lng2];
    
    // 结果
    CGFloat s = acos(cos(radLat1) * cos(radLat2) * cos(radLng1-radLng2) + sin(radLat1) * sin(radLat2)) * R;
    
    return  s;
}

- (CGFloat)radians:(CGFloat)degrees {
    return (degrees * 3.14159265)/180.0;
}


@end
