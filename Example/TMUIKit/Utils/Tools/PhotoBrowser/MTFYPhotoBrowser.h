//
//  MTFYPhotoBrowser.h
//  Matafy
//
// Created by Fussa on 2019/12/2.
// Copyright (c) 2019 com.upintech. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 图片浏览器
@interface MTFYPhotoBrowser : NSObject

/// 显示图片浏览器
/// @param images 图片数组(url string)
/// @param sourceView 显示和退出时, 做放大缩小的原始图
/// @param index 当前显示的下标
+ (void)browserWithImages:(NSArray *)images sourceView:(UIView *)sourceView currentIndex:(NSInteger)index;


/// 显示图片浏览器
/// @param images 图片数组(url string)
/// @param index 当前显示的下标
/// @param title 标题
/// @param viewController 当前控制器
+ (void)browserWithImages:(NSArray *)images currentIndex:(NSInteger)index title:(NSString *)title fromVC:(UIViewController *)viewController;


/// 显示图片浏览器
/// @param images 图片数组(url string)
/// @param sourceView 显示和退出时, 做放大缩小的原始图
/// @param index 当前显示的下标
/// @param title 标题
/// @param viewController 当前控制器
+ (void)browserWithImages:(NSArray *)images sourceView:(nullable UIView *)sourceView currentIndex:(NSInteger)index title:(NSString *)title fromVC:(UIViewController *)viewController;


@end

NS_ASSUME_NONNULL_END
