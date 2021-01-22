//
//  UtilsMacros.h
//  Matafy
//
//  Created by Cheng on 2017/12/21.
//  Copyright © 2017年 com.upintech. All rights reserved.
//

#ifndef UtilsMacros_h
#define UtilsMacros_h

// 设置 view 圆角和边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

//重写NSLog,Debug模式下打印日志和当前行数
//#if DEBUG
//#define NSLog(FORMAT, ...) do {\
//fprintf(stderr,"\nfile:%s \nfunction:%s\nline:%d \ncontent:%s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);\
//} while (0)
//#define debugMethod() NSLog(@"%s", __func__)
//#else
//#define NSLog(FORMAT, ...) nil
//#define debugMethod()
//#endif

// 单例
#define SHARED_INSTANCE_FOR_HEADER(className) \
\
+ (className *)sharedInstance;

#define SHARED_INSTANCE_FOR_CLASS(className) \
\
+ (className *)sharedInstance { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

// token
#define X_ACCESS_TOKEN @{@"x-access-token":[User sharedInstance].token?:@""}
#define X_TOKEN @{@"token":[User sharedInstance].token?:@""}
//1、存值
#define kSaveDefault(object,key) [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize];
//2、取值
#define kFetchDefault(key) [[NSUserDefaults standardUserDefaults] objectForKey:key];

//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
// 当前trip的id
#define kCURRENT_TRIP_ID                          @"current_trip_id"
// 当前trip的title
#define kCURRENT_TRIP_TITLE                       @"current_trip_title"
// 当前trip的开始时间戳
#define kCURRENT_TRIP_BEGIN_TIME                  @"current_trip_begin_time"
// 当前trip的结束时间戳
#define kCURRENT_TRIP_END_TIME                    @"current_trip_end_time"
//示例行程ID
#define TRIP_EXAMPLE_ID                           @"trip_example_id"
//游客行程ID
#define kTEMP_TRIP                                @"kTempTrip"

// 示例行程是否被删除
#define IS_DELETE_TRIP_EXAMPLE                    @"is_delete_trip_example"

// 当前leacCloud的对话ID (Group)
#define kCURRENT_LEAN_CLOUD_GROUP_CONVERSATION_ID @"current_leanCloud_group_conversation_Id"

// 是否第一次进入AppDelegate
#define IS_FIRST_OPEN_APP_DELEGATE                @"is_first_open_app_delegate"

// 是否第一次进入Silkroad_MyTripController
#define IS_FIRST_OPEN_Silkroad_MyTripController   @"is_first_open_Silkroad_MyTripController"

// 已经被邀请过的用户id列表
#define kHAS_BEEN_INVITED_USER_ID_LIST            @"has_been_invited_user_id_list"

// 是否显示小红点
#define kDID_SHOW_RED_POINT                       @"did_show_red_point"

// 当前trip的背景图地址
#define kCURRENT_TRIP_POST_IMAGE_URL              @"current_trip_post_image"

// 支持的翻译列表
#define kSUPPORTED_LANGUAGES                      @"supported_languages"
// 支持的翻译列表code
#define kSUPPORTED_LANGUAGE_CODES                 @"supported_language_codes"

// 实时监控网络
#define kIS_NETWORK_AVAILABLE_BAIDU               @"is_network_available_baidu"
#define kIS_NETWORK_AVAILABLE_GOOGLE              @"is_network_available_google"

// 机票酒店信息
#define kINFO_FLIGHT_HOTEL                        @"info_flight_hotel"

// 当前版本号
#define kCURRENT_VERSION                          @"current_version"

// 判断新浪短链接是否可用
#define kIS_SINA_SHORT_URL_AVAILABLE              @"is_sina_short_url_available"

// 启动界面是否显示
#define kIS_LAUNCH_SHOW                           @"is_launch_show"

// 搜索历史数组
#define kSEARCH_HISTORY_ARRAY                     @"search_history_array"

// 是否已登录
#define kIS_LOGIN                                 @"is_login"

#define kLastRefreshDate                          @"kLastRefreshDate"



//---------------------------------------- WebSocket ----------------------------------------
// WebSocket的ID
#define kWEBSOCKET_ID                             @"web_socket_id"


//---------------------------------------- remote push notification ----------------------------------------

// 是否强制从"TripList"跳转到"TripDisplay" (远程推送通知)
#define kIS_FORCE_PUSH_FROM_TRIPLIST_TO_TRIPDISPLAY @"is_force_push_from_tripList_to_tripDisplay"

// 是否接收到了"远程推送通知"
#define kIS_RECEIVED_REMOTE_PUSH_NOTIFICATION       @"is_received_remote_push_notification"

// "远程推送通知"Payload里面的时间戳
#define kPAYLOAD_TIME_STAMP                         @"payload_time_stamp"




//-------------------------------------------------- 当前经纬度 --------------------------------------------------------
#define kCURRENT_LATITUDE                           @"current_latitude"
#define kCURRENT_LONGITUDE                          @"current_longitude"

#define kCURRENT_CITY                               @"current_city"


// 七牛url地址
#define API_BASE_URL_QINIU                          @"qiniu_base_url/"

/*******************************************************************************************/
#pragma mark - 增加 部分

#define STATUSBARHEIGHT [UIApplication sharedApplication].statusBarFrame.size.height // status bar height, iphoneX = 44

#define DEVICE_UUID [[[UIDevice currentDevice] identifierForVendor] UUIDString] //UUID

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]      // NSUserDefaults
#define KEY_CHAIN_SHARED_DEFAULT [PDKeychainBindings sharedKeychainBindings]


#define NOTIFICATION_CENTER [NSNotificationCenter defaultCenter] // NSNotificationCenter

#define SHARED_APPLICATION [UIApplication sharedApplication] // UIApplication

#define MAIN_BUNDLE [NSBundle mainBundle] // NSBundle

#define MAIN_SCREEN [UIScreen mainScreen] // UIScreen

#define KEY_WINDOW [UIApplication sharedApplication].keyWindow // Window

#define FILE_MANAGER [NSFileManager defaultManager] // FileManager

#define CURRENT_RUNLOOP [NSRunLoop currentRunLoop] // NSRunLoop

#endif /* UtilsMacros_h */
