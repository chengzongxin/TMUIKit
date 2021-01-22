//
//  MTFYConstants.h
//  Matafy
//
//  Created by Fussa on 2019/4/30.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTFYRequestConstants.h"
#import "MTFYEnum.h"

#pragma mark - 一般Key
/// 用户token
extern NSString *const kMatafyToken;
/// 我的所有优惠券可用优惠券数量
extern NSString *const kMyAllCouponEnableAmount;
/// 显示用户拉新红包
extern NSString *const kShowShareNewUserRedpkg;

extern NSString *const kHasCloseShareUserRedpkg;
/// 是否加载红包活动失败
extern NSString *const kHasRequestActivityConfigFail;
//  配置文件缓存key
extern NSString *const kConfigurationModelData;
/// 刷新Token失败
FOUNDATION_EXPORT NSString *const kTokenRefreshFailed;


#pragma mark - 通知

/// 广告消失
extern NSString *const kAdDismissNotification;
/// 语音切换
extern NSString *const kNotificationNameLanguageChange;
/// 首页刷新
extern NSString *const kNotificationNameHomeWillRefresh;

#pragma mark - 友盟事件统计事件常量
#pragma mark 新人红包
/// 红包弹出次数
extern NSString *const kMobClickEnventRedPkgShow;
/// 红包拆开次数
extern NSString *const kMobClickEnventRedPkgOpen;
/// 邀请好友翻倍次数
extern NSString *const kMobClickEnventRedPkgClickInvite;
/// 发送微信好友次数
extern NSString *const kMobClickEnventRedPkgSendWX;
/// 发送微信朋友圈次数
extern NSString *const kMobClickEnventRedPkgSendWXMoments;
/// 生成图片次数
extern NSString *const kMobClickEnventRedPkgSavePic;

#pragma mark 6元打车
/// App首页6元打车活动banner点击次数
extern NSString *const kMobClickEnventBannerClickCar6Act;
/// 打车首页6元打车icon点击次数
extern NSString *const kMobClickEnventCarMainClick6Act;

#pragma mark 行程结束红包
/// 通过行程结束弹窗发起活动次数
extern NSString *const kMobClickEnventCarFinishClickRedPkgDialog;
/// 通过行程结束红包icon发起活动次数
extern NSString *const kMobClickEnventCarFinishClickRedPkgIcon;
/// 行程结束分享红包给微信好友次数
extern NSString *const kMobClickEnventCarFinishSendRedPkgWX;
/// 行程结束分享红包给微信朋友圈次数
extern NSString *const kMobClickEnventCarFinishSendRedPkgWXMoments;

#pragma mark 分享拉新红包
/// 用户点击首页用户分享拉新红包图标
extern NSString *const kMobClickEnventRedpkgShareNewUserOpen;
/// 红包按钮曝光
extern NSString *const kMobClickEnventRedpkgSW;
/// 点击红包按钮
extern NSString *const kMobClickEnventRedpkgCK;
/// 点击关闭按钮
extern NSString *const kMobClickEnventCloseRedpkgSW;

/// 客服电话
FOUNDATION_EXTERN NSString *const AppCustomerServicePhoneNum;

