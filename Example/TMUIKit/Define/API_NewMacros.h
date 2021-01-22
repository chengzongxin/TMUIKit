//
//  http://auth.matafy.com.h
//  silu
//
//  Created by sawyerzhang on 2017/7/21.
//  Copyright © 2017年 upintech. All rights reserved.


/*
 2018.2.1 3.5版本IP
 */

#if DEVELOPMENT
//测试
#define NEW_API_BASE_URL @"http://testone-mtfy-app-gw.matafy.com:8888/"
#define NEW_API_BASE_URL_ZERO         @"http://testone.matafy.com:8088/"

#else
// 正式
#define NEW_API_BASE_URL @"https://mtfy-app-gw.matafy.com/"
#define NEW_API_BASE_URL_ZERO           @"http://auth.matafy.com/"

#endif
/*---------------------API--------------------------*/

#define NEW_API_HOMEPAGE_REFRESH  @"trip/homepage/recommend/"       /// 首页刷新

#define NEW_API_VIDEO_PLAY_ADDCOUNT @"trip/video/incr/clicknum/"    /// 视频播放次数加1

#define NEW_API_POIDETAIL_DATA @"trip/newpoi/detail/"               /// poi详情数据

#define NEW_API_POIDETAIL_COLLECT @"trip/collect/newpoi/"          /// poi详情收藏

#define NEW_API_LBS_POIDATA @"getpoifromcity?size=300"              /// poi数据(除了top必去)

#define NEW_API_LBS_TOPDATA @"topsearch?city="                      /// top必去

#define NEW_API_SEARCH_ACTIVE @"getpoifromcity?size=10"    

#define NEW_API_LOGIN_SMS    @"mtfy/user/login/send/sms"            /// 注册短信验证码

#define NEW_API_LOGIN        @"mtfy/user/login"                     /// 登录

#define NEW_REFRESH_TOKEN    @"mtfy/user/refresh/token"             /// 刷新token

#define NEW_REFRESH_IMAGE_CODE @"mtfy/user/refresh/image/code"     // 刷新验证码

#define NEW_VALID_IMAGE_CODE     @"mtfy/user/valid/image/code"        // 验证图形验证码

#define NEW_VALID_APP_SLIDE      @"mtfy/user/valid/app/slide"        // APP滑动验证

/*
     2018.2.1 3.5版本API
 */

#define NEW_API_UPDATE_35               @"mtfyan/version/update/"            // 更新
#define NEW_API_CONFIGURER_35           @"mtfyan/version/configurer/"        // 获取活动的全局配置(如是否显示拉新红包)

/* 比码大赛 */
#define BIMA_BANNER_QUERY                @"mtfyan/welcomemsg/query/bimaBannerQuery"

