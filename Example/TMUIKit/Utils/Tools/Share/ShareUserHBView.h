//
//  ShareUserHBView.h
//  Matafy
//
//  Created by Fussa on 2019/5/30.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ShareUserHBViewItemClickBlock)(NSInteger index);
typedef void (^ShareUserHBViewSuccessBlock)(void);
typedef void (^ShareUserHBViewFailBlock)(void);


/**
 助力抢红包活动分享界面(分享平台为: 微信/朋友圈/QQ/微博/钉钉)
 */
@interface ShareUserHBView : UIView


/**
 构造方法
 */
+ (instancetype)xibView;


/**
 配置分享信息

 @param title 标题
 @param content 内容
 @param image 分享图片
 @param url 分享的URL
 @param clickHandle 点击各个平台的回调
 @param success 分享成功回调
 @param fail 分享失败回调
 */
- (void)shareViewWithTitle:(NSString *)title
                   content:(NSString *)content
                     image:(id)image
                       url:(NSString *)url
               clickHandle:(ShareUserHBViewItemClickBlock)clickHandle
                   success:(ShareUserHBViewSuccessBlock)success
                      fail:(ShareUserHBViewFailBlock)fail;

/**
 配置分享信息
 
 @param title 标题
 @param content 内容
 @param pathUrl 小程序path
 @param image 分享图片
 @param url 分享的URL
 @param clickHandle 点击各个平台的回调
 @param success 分享成功回调
 @param fail 分享失败回调
 */
- (void)shareViewWithTitle:(NSString *)title
                   content:(NSString *)content
                   pathUrl:(NSString *)pathUrl
                     image:(id)image
                       url:(NSString *)url
               clickHandle:(ShareUserHBViewItemClickBlock)clickHandle
                   success:(ShareUserHBViewSuccessBlock)success
                      fail:(ShareUserHBViewFailBlock)fail;

@end

NS_ASSUME_NONNULL_END
