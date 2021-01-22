//
//  DataBase.h
//  silu
//
//  Created by liman on 15/4/15.
//  Copyright (c) 2015年 upintech. All rights reserved.
//

// TODO:
//#import "DBTool.h"
#import "User.h"

// 数据库
#define DB_DEFAULT_NAME  @"test.db"

#define DB_TABLE_USER @"user_table"

#define DB_ID_USER @"user_id"



//------------------------------------- 钥匙串里面的 token userID -----------------------------
#define KEY_CHAIN_TOKEN_SSO                     @"token_sso"
#define KEY_CHAIN_TOKEN_SYSTEM                  @"token_system"
#define KEY_CHAIN_TOKEN_WEBSOCKET               @"token_web_socket"

#define TOKEN_SSO                               [KEY_CHAIN_SHARED_DEFAULT objectForKey:KEY_CHAIN_TOKEN_SSO]
#define TOKEN_SYSTEM                            [KEY_CHAIN_SHARED_DEFAULT objectForKey:KEY_CHAIN_TOKEN_SYSTEM]
#define TOKEN_WEBSOCKET                         [KEY_CHAIN_SHARED_DEFAULT objectForKey:KEY_CHAIN_TOKEN_WEBSOCKET]


//------------------------------------- 钥匙串里面的 手机号码 密码 -----------------------------
#define KEY_CHAIN_PHONE_NUMBER                  @"phoneNumber"
#define KEY_CHAIN_PASSWORD                      @"password"

//[[PDKeychainBindings sharedKeychainBindings] objectForKey:@"phoneNumber"]

#define PHONE_NUMBER                            [KEY_CHAIN_SHARED_DEFAULT objectForKey:KEY_CHAIN_PHONE_NUMBER]
#define PASSWORD                                [KEY_CHAIN_SHARED_DEFAULT objectForKey:KEY_CHAIN_PASSWORD]


//------------------------------------- 钥匙串里面的 第三方登录参数字典 -----------------------------
#define KEY_CHAIN_THIRD_LOGIN_PARAMETER         @"third_login_parameter"

#define THIRD_LOGIN_PARAMETER                   [[KEY_CHAIN_SHARED_DEFAULT objectForKey:KEY_CHAIN_THIRD_LOGIN_PARAMETER] transferToJsonDict]


//------------------------------------- 钥匙串里面的 第三方登录 accessToken -----------------------------
#define KEY_CHAIN_ACCESS_TOKEN_QQ               @"access_token_qq"
#define KEY_CHAIN_ACCESS_TOKEN_WEIBO            @"access_token_weibo"

#define ACCESS_TOKEN_QQ                         [KEY_CHAIN_SHARED_DEFAULT objectForKey:KEY_CHAIN_ACCESS_TOKEN_QQ]
#define ACCESS_TOKEN_WEIBO                      [KEY_CHAIN_SHARED_DEFAULT objectForKey:KEY_CHAIN_ACCESS_TOKEN_WEIBO]


