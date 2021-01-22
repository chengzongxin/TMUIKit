//
//  StringMacros.h
//  Matafy
//
//  Created by Cheng on 2017/12/21.
//  Copyright © 2017年 com.upintech. All rights reserved.
//

#ifndef StringMacros_h
#define StringMacros_h

// 超时
#define TIME_OUT_INTERVAL               15

// 字典参数为nil
#define ERROR_CODE_NULL                 @88888
#define ERROR_MESSAGE_NULL              @"参数错误, NULL"

// 第三方登陆失败
#define ERROR_CODE_SHARE_SDK_FAIL       @33333
// 第三方登陆取消
#define ERROR_CODE_SHARE_SDK_CANCEL     @333333

// 七牛上传失败
#define ERROR_CODE_QINIU                @777777
#define ERROR_MESSAGE_QINIU             @"多媒体文件上传失败"

// 连接leacCloud服务器失败
#define ERROR_CODE_LEAN_CLOUD           @999999
#define ERROR_MESSAGE_LEAN_CLOUD        @"连接leacCloud服务器失败"


#define CODE_200                 @200  //操作成功
#define CODE_201                 @201  //创建成功
#define CODE_400                 @400  //参数类型不匹配
#define CODE_401                 @401  //未授权，需要登录
#define CODE_403                 @403  //权限设置导致禁止访问
#define CODE_404                 @404  //找不到指定的资源
#define CODE_405                 @405  //请求方法不允许
#define CODE_406                 @406  //无法接受
#define CODE_408                 @408  //响应超时
#define CODE_409                 @409  //请求冲突，如用户名已存在
#define CODE_410                 @410  //该手机号已绑定,不能重复绑定
#define CODE_415                 @415  //服务器不支持此版本的客户端
#define CODE_486                 @486  //服务器忙
#define CODE_500                 @500  //服务器内部错误


#define ERROR_MESSAGE_400                 @"参数类型不匹配"
#define ERROR_MESSAGE_401                 @"未授权, 需要登录"
#define ERROR_MESSAGE_403                 @"权限设置导致禁止访问"
#define ERROR_MESSAGE_404                 @"找不到指定的资源"
#define ERROR_MESSAGE_405                 @"请求方法不允许"
#define ERROR_MESSAGE_406                 @"无法接受"
#define ERROR_MESSAGE_408                 @"响应超时"
#define ERROR_MESSAGE_409                 @"请求冲突, 如用户名已存在"
#define ERROR_MESSAGE_410                 @"该手机号已绑定,不能重复绑定"
#define ERROR_MESSAGE_415                 @"服务器不支持此版本的客户端"
#define ERROR_MESSAGE_486                 @"服务器忙"
#define ERROR_MESSAGE_500                 @"服务器内部错误"


// 没有网络提示
#define ERROR_MESSAGE_NO_NETWORK              @"网络错误"
// 未知错误
#define ERROR_MESSAGE_UNKNOW                  @"未知错误"

//该手机号还没被注册过, 现在注册吗
#define ERROR_MESSAGE_HAS_NOT_REGISTER        @"该手机号还没被注册过, 现在注册吗?"

//该手机号码已被注册过, 去登录吗
#define ERROR_MESSAGE_HAS_REGISTER            @"该手机号码已被注册过, 去登录吗?"






//-------------------------------------- 当前时间戳 -----------------------------------------
#define CURRENT_TIME_STAMP [NSString stringWithFormat:@"?%.0f", ([[NSDate date] timeIntervalSince1970] * 1000)]

//--------------------------------------- SVProgressHUD -------------------------------------
#define SVProgressHUD_DISMISS           [SVProgressHUD dismiss];

//#define SVProgressHUD_SHOW_(str)        if ([USER_DEFAULT boolForKey:IS_FIRST_OPEN_APP_DELEGATE]) {[SVProgressHUD showWithStatus:str maskType:SVProgressHUDMaskTypeClear];};

#define SVProgressHUD_SHOW_(str)         {[SVProgressHUD showWithStatus:str maskType:SVProgressHUDMaskTypeBlack];};

#define SVProgressHUD_SHOW_INFO(str)    if ([USER_DEFAULT boolForKey:IS_FIRST_OPEN_APP_DELEGATE]) {[SVProgressHUD showInfoWithStatus:str maskType:SVProgressHUDMaskTypeBlack];};

//#define SVProgressHUD_SHOW_SUCCESS(str) if ([USER_DEFAULT boolForKey:IS_FIRST_OPEN_APP_DELEGATE]) {[SVProgressHUD showSuccessWithStatus:str maskType:SVProgressHUDMaskTypeClear];};
#define SVProgressHUD_SHOW_SUCCESS(str) {[SVProgressHUD showSuccessWithStatus:str maskType:SVProgressHUDMaskTypeBlack];};

#define SVProgressHUD_SHOW_ERROR(str)   {[SVProgressHUD showErrorWithStatus:str maskType:SVProgressHUDMaskTypeBlack];};


#define Toast(str) [self.view makeToast:str duration:3.0 position:CSToastPositionCenter style:nil];

//--------------------------------------- autolayout -------------------------------------
#define BRING_NAVI_BAR_TO_FRONT [self.view bringSubviewToFront:self.naviBarView];


//--------------------------------------- leanCloud -------------------------------------

// leanCloud一对一消息 (邀请链接)
#define kLEAN_CLOUD_SINGLE_MESSAGE_INVITE_URL    @"leanCloud_single_message_invite_url"

// leanCloud群消息 (已更新记录)
#define kLEAN_CLOUD_GROUP_MESSAGE_UPDATED_RECORD @"leanCloud_group_message_updated_record"

// leanCloud群消息 (已加入当前trip)
#define kLEAN_CLOUD_GROUP_MESSAGE_JOINED_TRIP    @"leanCloud_group_message_joined_trip"

// leanCloud群消息 (已结束当前trip)
#define kLEAN_CLOUD_GROUP_MESSAGE_ENDED_TRIP     @"leanCloud_group_message_ended_trip"

// 等待leanCloud重连时间
#define kTIME_WAIT_LEAN_CLOUD_RESUMED   10




// 录音器动画时间
#define kAnimation_time_audio_UI 0.3

#endif /* StringMacros_h */
