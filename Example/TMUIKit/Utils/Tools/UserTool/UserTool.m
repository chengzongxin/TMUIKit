//
//  LoginTool.m
//  silu
//
//  Created by liman on 15/5/9.
//  Copyright (c) 2015年 upintech. All rights reserved.
//

#import "UserTool.h"
//#import "LeanCloudTool.h"

@implementation UserTool

+(instancetype) sharedInstance {
    static UserTool *_tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[self alloc] init];
    });
    return _tool;
}

#pragma mark - tool
// 开启当前用户的leanCloud聊天功能
//- (void)openLeanCloud
//{
//    [[LeanCloudTool sharedInstance] openLeanCloudWithSuccess:^(AVIMClient *client) {
//        [UIAlertView showWithMessage:@"开启当前用户的leanCloud聊天功能 success"];
//        
//    } failure:^(NSNumber *statusCode, NSString *message) {
//        [MessageTool showMessage:message code:statusCode];
//    }];
//}

// QQ头像替换为高清
- (void)replaceQQ_avatar:(User *)user {
//    "http://qzapp.qlogo.cn/qzapp/1104596641/E33E844206A2A51FF325523CC41DB19E/40"   像素:40, 100, 160
    
    
    NSString *iconUrl_old = user.iconUrl;
    if ([iconUrl_old hasPrefix:HTTP_STRING] || [iconUrl_old hasPrefix:HTTPS_STRING]) {
        if ([iconUrl_old hasSuffix:@"/40"]) {
            NSString *iconUrl_new = [[iconUrl_old substringWithRange:NSMakeRange(0, iconUrl_old.length - 3)] stringByAppendingString:@"/100"];
            [User sharedInstance].iconUrl = iconUrl_new;
        }
    }
}

// "新浪微博"头像替换为高清
- (void)replaceWeibo_avatar:(User *)user {
//    "http://tp4.sinaimg.cn/1764018123/50/5713342268/1"    像素:50
}

// "微信"头像替换为高清
- (void)replaceWeixin_avatar:(User *)user {
//    "http://wx.qlogo.cn/mmopen/ZIaV3dXUHRd7HwX4icnCs9KFYmLKtP3FjFYedCmzMQSFzBuQxoXn1tfyPv9QYGhRsUdf1a1Wv5icm9oia2b9bytS3mIJ15hrudX/0"     像素:640
}

// facebook头像替换为高清
- (void)replaceFacebook_avatar:(User *)user {
//    "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/v/t1.0-1/c15.0.50.50/p50x50/10354686_10150004552801856_220367501106153455_n.jpg?oh=e0b37ad2914032931c273619126878aa&oe=56496A2F&__gda__=1447695355_10ff74ec6ef8e26e46c4751a34c49bd0"    像素:50
}

// twitter头像替换为高清
- (void)replaceTwitter_avatar:(User *)user {
//    "http://abs.twimg.com/sticky/default_profile_images/default_profile_4_normal.png"     像素:??
}

#pragma mark - public
/**
 *  给User单例赋值
 */
- (void)setValuesToSharedUser:(User *)user {
    [User sharedInstance].token = user.token;
    [User sharedInstance].user = user;
    [User sharedInstance].Id = user.Id;
    [User sharedInstance].nickname = user.nickname;
    [User sharedInstance].gender = user.gender;
    [User sharedInstance].province = user.province;
    [User sharedInstance].city = user.city;
    [User sharedInstance].location = user.location;
    [User sharedInstance].iconUrl = user.iconUrl;
    [User sharedInstance].desc = user.desc;
    [User sharedInstance].type = user.type;
    [User sharedInstance].signature = user.signature;
    [User sharedInstance].background = user.background;
    [User sharedInstance].eid = user.eid;
    [User sharedInstance].age = user.age;
    [User sharedInstance].role = user.role;
    [User sharedInstance].country = user.country;
    [User sharedInstance].invatorNo = user.invatorNo;
    [User sharedInstance].userId = user.userId;
    [User sharedInstance].guide = user.guide;
    [User sharedInstance].isOnline = [NSString stringWithFormat:@"%@", [user.guide objectForKey:@"isOnline"]];
    [User sharedInstance].qulifications = user.qulifications;
    [User sharedInstance].guiderQual = [(NSDictionary *)user.qulifications objectForKey:@"guiderQual"];
    [User sharedInstance].rentalVechileQual = [(NSDictionary *)user.qulifications objectForKey:@"rentalVechileQual"];
    [User sharedInstance].homeStayQual = [(NSDictionary *)user.qulifications objectForKey:@"homeStayQual"];
    [User sharedInstance].undergroundRestaurantQual = [(NSDictionary *)user.qulifications objectForKey:@"undergroundRestaurantQual"];

    [User sharedInstance].rongCloudToken = user.rongCloudToken;
    [User sharedInstance].zhuboAuthStatus = user.zhuboAuthStatus;
    [User sharedInstance].lvkaAuthStatus = user.lvkaAuthStatus;
    [User sharedInstance].walletId = user.walletId;
    
    
    /**
     *  New Login
     */
    [User sharedInstance].username = user.username;
    [User sharedInstance].countryCode = user.countryCode;
    [User sharedInstance].mobile = user.mobile;
    [User sharedInstance].email = user.email;
    [User sharedInstance].expire = user.expire;

    // 开启当前用户的leanCloud聊天功能
//    [self openLeanCloud];
    
    // QQ头像替换为高清
//    [self replaceQQ_avatar:user];
}

- (User *)user {
    return [User sharedInstance];
}

/**
 *  清空User单例
 */
- (void)removeValuesFromUser
{
    [User sharedInstance].token = nil;
    [User sharedInstance].Id = nil;
    [User sharedInstance].nickname = nil;
    [User sharedInstance].gender = nil;
    [User sharedInstance].province = nil;
    [User sharedInstance].city = nil;
    
    [User sharedInstance].location = nil;
    [User sharedInstance].iconUrl = nil;
    [User sharedInstance].desc = nil;
    [User sharedInstance].type = nil;
    [User sharedInstance].signature = nil;
    [User sharedInstance].background = nil;
    [User sharedInstance].eid = nil;
    [User sharedInstance].age = nil;
    [User sharedInstance].role = nil;
    [User sharedInstance].country = nil;
    [User sharedInstance].invatorNo = nil;
    [User sharedInstance].userId = nil;
    [User sharedInstance].guide = nil;
    [User sharedInstance].isOnline = nil;
    [User sharedInstance].qulifications = nil;
    [User sharedInstance].guiderQual = nil;
    [User sharedInstance].rentalVechileQual = nil;
    [User sharedInstance].homeStayQual = nil;
    [User sharedInstance].undergroundRestaurantQual = nil;
    [User sharedInstance].username = nil;
    [User sharedInstance].countryCode = nil;
    [User sharedInstance].mobile = nil;
    [User sharedInstance].email = nil;
    [User sharedInstance].expire = nil;
}

@end
