//
//  URLMacros.h
//  Matafy
//
//  Created by Cheng on 2017/12/21.
//  Copyright © 2017年 com.upintech. All rights reserved.
//

#ifndef URLMacros_h
#define URLMacros_h

#pragma mark - 测试环境
//  ****************************************** 测试 ******************************************//
#if DEVELOPMENT

// MARK: 测试地址
#define HOST(subUrl) [NSString stringWithFormat:@"http://testone-mtfy-app-gw.matafy.com:8888%@",subUrl]

#define HOST_LOG(subUrl) [NSString stringWithFormat:@"http://119.23.208.201:3688%@",subUrl]
// H5
#define HOST_H5(subUrl) [NSString stringWithFormat:@"https://m.matafy.com%@",subUrl]
// 医美
#define HOST_BEAUTY(subUrl) [NSString stringWithFormat:@"https://testone.matafy.com%@",subUrl]

// APP KEY
#define BAIDU_MAP_KEY               @"SnBe5hW7kCSy1KyNfBq2zcnFjy1Unp4C"  // 百度地图key release
#define GAODE_MAP_KEY               @"52e6706595965484db6dc174b230a692"  // 高德地图key
#define UMENG_APP_KEY               @"5ae05bccf43e486393000056" // 友盟AppKey develop
#define JPUSH_APPKEY                @"a08a61f255621415bde116e7"  // 极光推送appkey @"d22756b6e9982211de63a2e5"  // 极光推送appkey
#define BUGLY_APPID                 @"53dab830e1"  // bugly appID

// 微信开放平台id
#define WECHARTID @"wxbb2c62290840d0f0"

// 微信小程序
#define WX_MINI_APP_ID          @"gh_14b133c39d40" //微信小程序原生id
#define WX_MINI_PATH_HOME       @"pages/home/home" //微信小程序主页路径
#define WX_MINI_PATH_FLY        @"pages/webview/webview" //微信小程序机票路径
#define WX_MINI_PATH_HOTEL      @"pages/webviewHotel/webviewHotel" //微信小程序酒店路径
#define WX_MINI_APP_TRAIN       @"pages/webviewTrain/webviewTrain" //微信小程序火车票路径

#define WX_MINI_PROGRAM_AIR     @"http://m.matafy.com/tickets/index.html" //测试环境 机票
#define WX_MINI_PROGRAM_HOTEL   @"http://m.matafy.com/hotel_test/index.html"//测试环境 酒店
#define WX_MINI_PROGRAM_TRAIN   @"https://m.matafy.com/train_test/index.html#/"//测试环境 火车票
#define WX_MINI_PROGRAM_SCENIC  @"https://m.matafy.com/scenic_test/index.html#/"//测试环境  门票
#define WX_MINI_PROGRAM_TRAVEL  @"https://m.matafy.com/train_test/index.html#/"//测试环境 出行

#define WX_MINI_PROGRAM_TYPE    2

// 常用联系人
#define LinkManUrl  @"https://m.matafy.com/commonH5_test/index.html#/commonContactsList?fromOrderPlatefrom=carhailing"
#define CommonContactURL @"https://testtwo.matafy.com/mtfy/contact/info/list"

// Websockt
#define HOST_CARHAILING_WEBSOCKET(subUrl) [NSString stringWithFormat:@"ws://testone.matafy.com:19090/carhailing%@",subUrl]


// H5分享
#define HOST_SHARE_H5 HOST_H5(@"/recommend_test/index.html#/Share")

#pragma mark - MQTT
// MQTT
#define HOST_MQTT @"mqtt-emq-k8s-test.matafy.com"
#define HOST_MQTT_PORT 1883

#else


#pragma mark - 正式
//  ****************************************** 正式 ******************************************//

// MARK: 正式地址
#define HOST(subUrl) [NSString stringWithFormat:@"https://mtfy-app-gw.matafy.com%@",subUrl]
// 社区埋点
#define HOST_LOG(subUrl) [NSString stringWithFormat:@"https://rs-log.matafy.com%@",subUrl]
// h5
#define HOST_H5(subUrl) [NSString stringWithFormat:@"https://m.matafy.com%@",subUrl]
// 医美
#define HOST_BEAUTY(subUrl) [NSString stringWithFormat:@"https://beauty.matafy.com%@",subUrl]

// APP KEY
#define BAIDU_MAP_KEY               @"SnBe5hW7kCSy1KyNfBq2zcnFjy1Unp4C"  // 百度地图key
#define GAODE_MAP_KEY               @"52e6706595965484db6dc174b230a692"  // 高德地图key
#define UMENG_APP_KEY               @"5881b95f3eae2542f600128c" // 友盟AppKey
#define JPUSH_APPKEY                @"a08a61f255621415bde116e7"  // 极光推送appkey
#define BUGLY_APPID                 @"64224d0635"  // bugly appID

// 微信开放平台id
#define WECHARTID @"wxbb2c62290840d0f0"

// 微信小程序
#define WX_MINI_APP_ID          @"gh_14b133c39d40" //微信小程序原生id
#define WX_MINI_PATH_HOME       @"pages/home/home" //微信小程序主页路径
#define WX_MINI_PATH_FLY        @"pages/webview/webview" //微信小程序机票路径
#define WX_MINI_PATH_HOTEL      @"pages/webviewHotel/webviewHotel" //微信小程序酒店路径
#define WX_MINI_APP_TRAIN       @"pages/webviewTrain/webviewTrain" //微信小程序火车票路径

#define WX_MINI_PROGRAM_AIR     @"https://m.matafy.com/flynow/index.html"; //生产环境 机票
#define WX_MINI_PROGRAM_HOTEL   @"http://m.matafy.com/hotel/index.html"; //生产环境 酒店
#define WX_MINI_PROGRAM_TRAIN   @"https://m.matafy.com/train/index.html#/";// 生产环境 火车票
#define WX_MINI_PROGRAM_SCENIC  @"https://m.matafy.com/scenic/index.html#/"//测试环境  门票
#define WX_MINI_PROGRAM_TRAVEL  @"https://m.matafy.com/train/index.html#/";//测试环境 出行

#define WX_MINI_PROGRAM_TYPE    0

// 常用联系人
#define LinkManUrl  @"https://m.matafy.com/commonH5/index.html#/commonContactsList?fromOrderPlatefrom=carhailing"
#define CommonContactURL  @"https://auth.matafy.com/mtfy/contact/info/list"

// Websockt
#define HOST_CARHAILING_WEBSOCKET(subUrl) [NSString stringWithFormat:@"wss://carhailing.matafy.com/carhailing%@",subUrl]

// H5分享
#define HOST_SHARE_H5 HOST_H5(@"/recommend/index.html#/Share")

#pragma mark - MQTT
// MQTT
#define HOST_MQTT @"mqtt-mqtt.matafy.com"
#define HOST_MQTT_PORT 1883

#endif



//  ****************************************** 马踏飞燕API ******************************************//


// ******* 马踏飞燕 3.5 *******//
// 内容推荐
#define URL_RECOMMEND_MATERIAL HOST(@"/mtfyan/recommend/material")

// 功能列表
#define URL_FEATURES_LIST      HOST(@"/mtfyan/feature/query/featureListQuery")

// 我的喜欢/观看记录
#define URL_USER_ACTION        HOST(@"/mtfyan/user/action")

// 添加喜欢/观看、分享
#define URL_USER_ADD           HOST(@"/mtfyan/user/add")

// 删除我的喜欢,观看记录
#define URL_USER_DEL           HOST(@"/mtfyan/user/del")

// ******* Hotel *******//

// 获取城市id
#define URL_HOTEL_CITIES       HOST(@"/fare/hotel/cities")

// 获取城市 行政区和商圈
#define URL_HOTEL_REGIONS      HOST(@"/fare/hotel/regions")

// 新接口2019-03-12
// 获取酒店列表
#define URL_HOTEL_LIST         HOST(@"/fare/hotel/list")
// 获取酒店列表(新API)
#define URL_HOTEL_LIST_NEW     HOST(@"/fare/hotel/list/listnew")
// 获取酒店列表查询qid
#define URL_HOTEL_LIST_TASK    HOST(@"/fare/hotel/list/query/task")
// 获取城市 行政区和商圈
#define URL_HOTEL_REGIONS_NEW  HOST(@"/fare/hotel/search/regions")
// 根据经纬度获取城市ID
#define URL_HOTEL_GET_CITY_ID  HOST(@"/fare/hotel/search/getCityId")
// 查询国内酒店品牌
#define URL_HOTEL_SEARCH_BRAND  HOST(@"/fare/hotel/search/brand")


// 获取POI数据接口
#define URL_GET_POI            HOST(@"/mtfyan/poi/getpoifromcity/v")

// 获取poi详情
#define URL_POI_DETAIL         HOST(@"/mtfyan/poi/detail")

// 获取小程序接口
#define URL_MINIPROGRAM        HOST(@"/mtfyan/welcomemsg/sharingActivities")

// 获取POI数据接口(new)
#define URL_GET_NEW_POI        HOST(@"/mtfyan/poi/getNewpoifromcity")

// 查询二级分类
#define URL_GET_TYPE_COUNT     HOST(@"/mtfyan/poi/getTypeCount")

// 我的消息列表接口
#define URL_MESSAGE_GETLIST    HOST(@"/push/message/getList")

// 已读消息接口
#define URL_MESSAGE_READED     HOST(@"/push/message/readed")


//  ****************************************** 马踏飞燕社区API 4.0 ******************************************//

// Bannad
#define URL_WELCOME_ROTATIONCHAT    HOST(@"/mtfyan/welcomemsg/rotationChart")

// 举报
#define URL_REPORT_DYNAMIC          HOST(@"/mtfyan/report/dynamic")

// 获取上传图片token
#define URL_UPLOAD_IMAGE_TOKEN      HOST(@"/community/qiniu/upload/image/token")

// 获取上传视频token
#define URL_UPLOAD_VIDEO_TOKEN      HOST(@"/community/qiniu/upload/video/token")

// 发布动态
#define URL_DYNAMIC_PUBLISH         HOST(@"/community/dynamic/publish")

// 社区发现列表
#define URL_DYNAMIC_RECOMMEND_LIST  HOST(@"/community/dynamic/recommend/list")

// 通用瀑布流列表
#define URL_DYNAMIC_LIST            HOST(@"/community/dynamic/list")

//  网红景点
#define URL_SCENICSPOT_LIST         HOST(@"/community/hot/spot/list")

// 社区关注列表
#define URL_DYNAMIC_FOLLOW_LIST     HOST(@"/community/follow/my/follow/target/new/dynamic/list")

// 官博
#define URL_OFFICAL_DYNAMIC_LIST    HOST(@"/community/offical/dynamic/list")

// 删除帖子动态
#define URL_DYNAMIC_DELETE          HOST(@"/community/dynamic/delete")

// 分享获取积分
#define URL_SHARE_MESSAHE           HOST(@"/community/dynamic/share/message")

// 根据ID获取动态详情
#define URL_DYNAMIC_DETAIL          HOST(@"/community/dynamic/detail")

// 关注
#define URL_FOLLOW_ADD              HOST(@"/community/follow/add")

// 取消关注
#define URL_FOLLOW_CANCEL           HOST(@"/community/follow/cancel")

// 根据用户ID获取用户的动态列表
#define URL_USER_DYNAMIC_LIST       HOST(@"/community/dynamic/user/dynamic/list")

// 分享
#define URL_DYNAMIC_SHARE           HOST(@"/community/dynamic/share")

/************** 收藏 **************/
// 新增收藏
#define URL_COLLECT_ADD             HOST(@"/community/collect/add")
// 取消收藏
#define URL_COLLECT_CANCEL          HOST(@"/community/collect/cancel")
// 我的收藏列表
#define URL_COLLECT_MY_LIST         HOST(@"/community/collect/my/list")

/************** 评论 **************/
// 添加评论
#define URL_COMMENT_ADD             HOST(@"/community/comment/add")
// 删除评论
#define URL_COMMENT_DELETE          HOST(@"/community/comment/delete")
// 回复评论
#define URL_COMMENT_REPLY           HOST(@"/community/comment/reply")
// 分页查询评论
#define URL_COMMENT_LIST            HOST(@"/community/comment/list")

/************** 点赞 **************/
// 点赞
#define URL_THUMB_UP_ADD            HOST(@"/community/thumb/up/add")
// 取消点赞
#define URL_THUMB_UP_CANCEL         HOST(@"/community/thumb/up/cancel")

/************** 消息 **************/

// 消息统计
#define URL_MESSAGE_STATISTICS      HOST(@"/community/message/my/message/statistics")
// 点赞消息列表
#define URL_MESSAGE_THUMBUP_LIST    HOST(@"/community/message/thumb/up/list")
// 评论消息列表
#define URL_MESSAGE_COMMENT_LIST    HOST(@"/community/message/comment/list")
// 粉丝消息列表
#define URL_MESSAGE_FANS_LIST       HOST(@"/community/message/fans/list")
// 系统消息列表
#define URL_MESSAGE_SYSTEM_LIST     HOST(@"/community/message/system/list")

/************** 我的 **************/

#define URL_MY_DYNAMIC_LIST         HOST(@"/community/dynamic/my/list")

#define URL_USER_STATISTIC          HOST(@"/community/user/data/statistic/detail")

// 根据用户ID获取用户的关注列表
#define URL_USER_FOLLOW_LIST        HOST(@"/community/follow/get/user/follow/list")
// 根据用户ID获取用户的粉丝列表
#define URL_USER_FANS_LIST          HOST(@"/community/follow/get/user/fans/list")
// 更新个人信息
#define URL_USER_INFO_UPDATE        HOST(@"/mtfy/user/info/update")

/************** 权限设置 **************/

// 回复评论权限设置
#define URL_PERMISSTION_COMMENT      HOST(@"/community/permission/config/comment/update")

// 推送消息设置
#define URL_PERMISSTION_MESSAGE      HOST(@"/community/permission/config/message/update")

// 获取我的权限配置
#define URL_PERMISSTION_CONFIG       HOST(@"/community/permission/config/get")


/************** 网红酒店 **************/

// 跳转预订中间页接口
#define URL_HOT_HOTEL_DETAIL         HOST(@"/community/hot/hotel/middle/page/info")

// 异步查询酒店价格
#define URL_HOT_HOTEL_PRICE          HOST(@"/community/hot/hotel/async/price")

// 首页网红酒店推荐 （已经登入情况下请求头需要x-access-token)
#define URL_DYNAMIC_HOT_HOTEL        HOST(@"/community/dynamic/top/hotel")

/************** 搜索 **************/
// 社区内容搜索
#define URL_DYNAMIC_SEARCH           HOST(@"/community/dynamic/search")

/************** 出行 **************/
// 获取首页面板数据
#define URL_CARHAILING_INDEX_CARPRICEQUERY      HOST(@"/carhailing/car/query/carPriceHomePageQuery")
#define URL_CARHAILING_WEBINDEX_CARPRICEQUERY   HOST(@"/trip/pannel/index/price/query")

// 获取用车价格
#define URL_CARHAILING_CARPRICEQUERY            HOST(@"/carhailing/car/query/carPriceAsynchQuery")
// 第三方平台用车价格
#define URL_CARHAILING_GETALLPRICE              HOST(@"/trip/query/getAsync/all/price")
// 创建订单(派单叫车)
#define URL_CARHAILING_ORDER_CREATE_COMMAND     HOST(@"/carhailing/order/command/orderCreateCommand")
// 取消订单
#define URL_CARHAILING_ORDER_CANCEL_COMMAND     HOST(@"/carhailing/order/command/orderCancelCommand")
// 查看取消费用
#define URL_CARHAILING_ORDER_CANCEL_FEE         HOST(@"/carhailing/order/query/orderCancelFee")
// 查看订单详情
#define URL_CARHAILING_ORDER_DETAIL_QUERY       HOST(@"/carhailing/order/query/orderDetailQuery")
// 订阅订单消息推送
#define URL_CARHAILING_WEBSOCKET                HOST_CARHAILING_WEBSOCKET(@"/websocket/")
// 获取支付参数
#define URL_CARHAILING_ORDERPAYPARAMCOMMAND     HOST(@"/carhailing/order/command/orderPayParamCommand")
// 获取司机实时位置
#define URL_CARHAILING_ORDERDRIVERQUERY         HOST(@"/carhailing/order/query/orderDriverQuery")
// 查询协议内容
#define URL_CARHAILING_AGREEMENTQUERY           HOST(@"/carhailing/agreement/query/agreementQuery")
// 查询接受协议
#define URL_CARHAILING_AGREEMENTACCEPTEDQUERY   HOST(@"/carhailing/agreement/query/agreementAcceptedQuery")
// 确认接受协议
#define URL_CARHAILING_AGREEMENTACCEPTECOMMAND  HOST(@"/carhailing/agreement/command/agreementAcceptedCommand")
// 获取进行中订单
#define URL_CARHAILING_WAITPAYORDERQUERY        HOST(@"/carhailing/order/query/waitPayOrderQuery")
// 获取全量初始化常量
#define URL_CARHAILING_ALLINITCONSTANTQUERY     HOST(@"/carhailing/config/query/allInitConstantQuery")
// 获取预约用车时间区间
#define URL_CARHAILING_SubscribeTimeQuery       HOST(@"/carhailing/car/query/subscribeTimeQuery")
/// 附近车辆查询
#define URL_CARHAILING_NEARBY_CAR_QUERY         HOST(@"/carhailing/car/query/nearbyCarQuery")
// 查询发票
#define URL_CARHAILING_INVOICE                  HOST(@"/carhailing/invoice/query/invoiceQuery")
// 申请发票
#define URL_CARHAILING_ADD_INVOICE              HOST(@"/carhailing/invoice/command/addInvoiceCommand")
// 预约分享社区
#define URL_COMMUNITY_PRICESNAPSHOT_SHARE       HOST(@"/community/priceSnapshot/share")



#pragma mark 出行乘车人
// 新增乘车人
#define URL_RIDER_ADD                           HOST(@"/carhailing/passenger/command/passengerCreateCommand")
// 删除乘车人
#define URL_RIDER_DELETE                        HOST(@"/carhailing/passenger/command/passengerDeleteCommand")
// 获取用户乘车人列表
#define URL_RIDER_HISTORY                       HOST(@"/carhailing/passenger/query/passengerListQuery")
// 更新乘车人
#define URL_RIDER_UPDATE                        HOST(@"/carhailing/passenger/command/passengerUpdateCommand")

#pragma mark 接送机
// 机场列表查询
#define URL_CITY_AIRPORT_QUERY                  HOST(@"/carhailing/car/query/cityAirportQuery")
// 航班信息查询
#define URL_FLIGHT_INFO_QUERY                   HOST(@"/carhailing/car/query/flightInfoQuery")

/************** 实名认证 **************/
#pragma mark - 实名认证
/// 实名认证 获取人脸核对token接口
#define URL_FACEID_GET_BIZ_TOEKN                HOST(@"/mtfy/api/face_id/getBizToken")
/// 获取人脸核对返回结果
#define URL_FACEID_RESULT                       HOST(@"/mtfy/api/face_id/result")
/// 获取身份证识别sigh签名
#define URL_FACEID_GET_ID_CARD_BIZ_TOKEN        HOST(@"/mtfy/api/face_id/getSign")
/// 获取身份证识别返回接口
#define URL_FACEID_ID_CARD_RESULT               HOST(@"/mtfy/api/face_id/idcardResult")
/// 获取实名认证信息
#define URL_FACEID_GET_USER_CERT_INFO           HOST(@"/mtfy/api/face_id/getUserCertInfo")
/// 获取实名认证状态
#define URL_FACEID_GET_USER_CERT_STATUS         HOST(@"/mtfy/api/face_id/getUserCertStatus")


/************** 红包 **************/
#pragma mark - 红包
#pragma mark 出行分享红包
/// 创建活动
#define URL_SHAER_CREAT_ACTIVITY                HOST(@"/appact/car/share/coupon/activity/command/creatActivity")
/// 校验订单信息
#define URL_SHAER_VALID_ORDER_INFO              HOST(@"/appact/car/share/coupon/activity/command/validOrderInfo")
/// 查询用户当前活动
#define URL_SHAER_GET_ACTIVITY_BY_ORDER_NO      HOST(@"/appact/car/share/coupon/activity/query/getActivityByOrderNo")
/// 生成二维码
#define URL_SHAER_GENERATE_QR_CODE              HOST(@"/appact/QrCode/generate")


#pragma mark 新人红包
/// 拆红包
#define URL_NEW_USER_RED_PACKET_OPEN            HOST(@"/appact/new/user/open/red/packet")
/// 分享红包翻倍
#define URL_NEW_USER_RED_PACKET_SHARE_DOUBLE    HOST(@"/appact/new/user/share/double")
/// 获取当前用户今天是否已开过红包
#define URL_NEW_USER_RED_PACKET_WHETHER_OPEN    HOST(@"/appact/new/user/today/whether/open")
/// 领取现金券
#define URL_RED_PACKET_GENERATE_COUPON          HOST(@"/appact/new/user/generate/coupon")
/// 红包分享埋点
#define URL_RED_PACKET_BURIED_POINT             HOST(@"/appact/share/new/activity/command/shareActivity")



/************** 埋点 **************/
#pragma mark - 埋点
#pragma mark 社区埋点
/// 社区埋点
#define URL_LOG_APP_COMMUNITY                   HOST_LOG(@"/log/app/community")


/************** 语音识别 **************/
#pragma mark - 语音识别
/// 语音识别
#define URL_SPEECH_HANDLE_MESSAGE               HOST(@"/handleMessage")


/************** 电影票 **************/
#pragma mark - 电影票
/// 获取所有城市
#define URL_MOVIE_GET_ALL_CITY                   HOST(@"/city/getall")
/// 查询影院列表
#define URL_MOVIE_QUERY_CINEMA_LIST              HOST(@"/movie/query/mapcinemalist")
/// 查询电影详情
#define URL_MOVIE_QUERY_DETAIL_PRICE             HOST(@"/movie/query/detailprice")
/// 查询电影列表
#define URL_MOVIE_QUERY_FILM_LIST                HOST(@"/movie/query/filmlist")
/// 电影院 - 观影日期列表
#define URL_MOVIE_QUERY_DAY_LIST                 HOST(@"/movie/query/daylist")

// API
#define HOST_RECOMMEND_PANEL_API                 HOST(@"/recommend/index/panel/v3");
// MQTT Price
#define HOST_RECOMMEND_PANEL_TOPIC_PRICE        @"/recommend/index/panel"
// MQTT Search times
#define HOST_RECOMMEND_PANEL_TOPIC_METRICS      @"/recommend/index/metrics"

/************** 优惠券 **************/
#pragma mark - 优惠券
/// 优惠券前端调用 - 查询当前用户券状态及数量
#define URL_COUPON_OVERVIEW                      HOST(@"/coupon/open/my/coupons/overview")

/************** 租车 **************/
#pragma mark - 租车
#define URL_ZHUCHE_PLATFORM_SHOPS                HOST(@"/zuche/platform_shops")

/************** 社区2.0 **************/

#define URL_COMMUNITY_FRIENDS                    HOST(@"/recommend/community/friends/v1")

// 818 直播banner
#define URL_818_BANNER                           HOST(@"/mtfyan/welcomemsg/query/bannerQuery")

// 首页酒店搜索
#define URL_POI_SEARCH_QUERY                     HOST(@"/mtfyan/poi/query/searchQuery")

// 首页酒店搜索
#define URL_POI_HINT_QUERY                       HOST(@"/mtfyan/poi/query/hintQuery")

// 用户积分
#define URL_TOTAL_SCORE_QUERY                    HOST(@"/mtfy-app-gw/score-app/score/query/totalScoreQuery")

/// 获取banner集合
#define URL_BANNER_QUERY                         HOST(@"/mtfyan/welcomemsg/query/bannerQuery")


/************** 订单支付和改造 **************/

// 获取业务线列表
#define URL_ORDER_BUSINESS_SYSTEM_QUERY           HOST(@"/order-app/command/orderBusinessSystemQuery")
// 订单列表查询
#define URL_ORDER_SEARCH_PAGE_QUERY               HOST(@"/order-app/command/orderSearchPageQuery")
// 删除订单
#define URL_ORDER_DELETE_ORDER                    HOST(@"/order-app/command/deteleOrderCommand")
// 取消订单
#define URL_ORDER_CANCEL_ORDER                    HOST(@"/order-app/command/cancelOrderCommand")
// 订单页面推荐
#define URL_ORDER_RECOMMEND_ORDER                 HOST(@"/recommend/order")
// 订单搜索
#define URL_ORDER_SARCH_BY_KEYWORD                HOST(@"/order-app/command/orderSearchByKeyword")
/// 跳转记录
#define URL_ORDER_SEARCH_RECORD               HOST(@"/order-app/command/thirdOrderSearchPageQuery")

#define URL_SHARE                                 HOST_SHARE_H5

#pragma mark 优惠券列表
#define Travel_Coupon_URL                         HOST(@"/coupon/my/canuse/coupon/CAR_HAILING")

#endif /* URLMacros_h */


/************** 医美 **************/
#pragma mark - 医美
/// 医美日记
#define URL_BEAUTY_DAY_LIST                         HOST(@"/beauty/index/day_list")
/// 医美首页推荐
#define URL_BEAUTY_RECOMMEND                        HOST(@"/beauty/index/recommend")
/// 医美文章详情
#define URL_BEAUTY_DETAIL_RECOMMEND                 HOST(@"/beauty/index/detail/recommend")



/************** 博物馆 **************/
/* museum_query - 博物馆列表  0.0.0  POST  */
#define URL_GET_MUSEUM_LIST    HOST(@"/museum/getMuseumList")

/* museum_query - 博物馆详情  0.0.0  POST  */
#define URL_GET_MUSEUM_DETAIL    HOST(@"/museum/getMuseumDetail")

/* museum_query - 藏品列表  0.0.0  POST  */
#define URL_GET_COLLECTION_LIST    HOST(@"/museum/getCollectionList")

/* museum_query - 藏品详情  0.0.0  POST  */
#define URL_GET_COLLECTION_DETAIL    HOST(@"/museum/getCollectionDetail")

/* museum_query - 首页banner  0.0.0  POST  */
#define URL_GET_RECOMMEND_MUSEUM   HOST(@"/recommend/museum")
/* museum_query - 智能生成图片  0.0.0  POST  */
#define URL_GEN_PICTURE    HOST(@"/museum/genPicture")

/* 首页分享图片接口  */
#define URL_SHARE_IMAGE    HOST(@"/mtfyan/welcomemsg/query/postersQuery")

/* museum query - 博物馆搜索  0.0.0  GET  */
#define URL_MUSEUM_SEARCH    HOST(@"/museum/search")

/* museum query  museum query - 3D藏品列表  0.0.0  POST  */
#define URL_GET_3D_COLLECTION_LIST    HOST(@"/museum/get3DCollectionList")



/************** AI换脸 **************/
/* AI换脸模板图像列表  */
#define URL_GET_TEMPLATE_LIST       HOST(@"/museum/getTemplateList")

/* 智能生成AI换脸图片 */
#define URL_FACE_PICTURE            HOST(@"/museum/FacePicture")


/* 拉新注册活动 - 查看邀请者信息  0.0.0  查看邀请者信息,通过邀请码  POST  */
#define URL_INVITER_INFO    HOST(@"/appact/pull/new/register/activity/query/inviterInfo")

/* 拉新注册活动 - 接收邀请  0.0.0  接收邀请,通过邀请码  POST  */
#define URL_RECEIVE_INVITATION    HOST(@"/appact/pull/new/register/activity/command/receiveInvitation")

/* 拉新注册活动 - 用户是否可以接受邀请  0.0.0  查看用户是否可以接受邀请；活动已下线、用户未注册或获取信息异常、注册超过7天 均不能接受邀请  POST  */
#define URL_CAN_RECEIVE    HOST(@"/appact/pull/new/register/activity/query/canReceive")

/* 拉新注册活动 - 查询奖励常量  0.0.0  查询活动奖励值  POST  */
#define URL_REWARDS    HOST(@"/appact/pull/new/register/activity/query/rewards")
