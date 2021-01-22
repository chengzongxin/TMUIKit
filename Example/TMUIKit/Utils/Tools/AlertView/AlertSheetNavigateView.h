//
//  AlertSheetNavigateView.h
//  Matafy
//
//  Created by Fussa on 2019/7/16.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ _Nullable AlertSheetNavigateViewCompleteHandler)(BOOL success, NSString * _Nullable title);
typedef void (^ _Nullable AlertSheetNavigateViewActionHandler)(NSInteger index, NSString * _Nullable title);
typedef void (^ _Nullable AlertSheetNavigateViewCancelHandler)(void);

@interface AlertSheetNavigateView : UIView

@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, copy) AlertSheetNavigateViewCancelHandler cancelHandle;
@property (nonatomic, copy) AlertSheetNavigateViewActionHandler actionHandle;

- (void)show;


/**
 显示并跳转第三方导航
 (默认当前位置)
 
 @param toCoordinate 目的地经纬度(百度坐标)
 @param toName 目的地名称
 @param actionHandle 点击后的回调
 @param cancelHandle 取消的回调
 */
+ (void)showAndNavigateWithToCoordinate:(CLLocationCoordinate2D)toCoordinate
                                 toName:(NSString *)toName
                           actionHandle:(AlertSheetNavigateViewCompleteHandler)actionHandle
                           cancelHandle:(AlertSheetNavigateViewCancelHandler)cancelHandle;

/**
 显示并跳转第三方导航
 
 @param coordinate 当前位置经纬度(百度坐标)
 @param name 当前位置名称(默认 '我的位置')
 @param toCoordinate 目的地经纬度(百度坐标)
 @param toName 目的地名称
 @param actionHandle 点击后的回调
 @param cancelHandle 取消的回调
 */
+ (void)showAndNavigateWithCoordinate:(CLLocationCoordinate2D)coordinate
                                 name:(NSString *)name
                         toCoordinate:(CLLocationCoordinate2D)toCoordinate
                               toName:(NSString *)toName
                         actionHandle:(AlertSheetNavigateViewCompleteHandler)actionHandle
                         cancelHandle:(AlertSheetNavigateViewCancelHandler)cancelHandle;
@end

NS_ASSUME_NONNULL_END

