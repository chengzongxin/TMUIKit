//
//  SharePopView.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ShareType) {
    ShareTypeWechat = 0,               // 微信
    ShareTypeWechatFriend,             // 朋友圈
    ShareTypeCopyLink,                 // 复制链接
    ShareTypeSaveLocal,                // 保存本地
    ShareTypeCommunity                 // 分享到社区
};

typedef void(^SelectBlock)(NSUInteger type);


@interface SharePopViewForWebView : UIView

//@param shareTitle 标题
@property (nonatomic, copy) NSString *shareTitle;
//@param shareContent 文本
@property (nonatomic, copy) NSString *shareContent;
//@param shareImg  图片集合,传入参数可以为单张图片信息，也可以为一个NSArray，数组元素可以为UIImage、NSString（图片路径）、NSURL（图片路径）、SSDKImage。如: @"http://www.mob.com/images/logo_black.png" 或 @[@"http://www.mob.com/images/logo_black.png"]
@property (nonatomic, copy) id       shareImg;
//@param shareUrl url
@property (nonatomic, copy) NSString *shareUrl;

@property (nonatomic, strong) UIView           *container;
@property (nonatomic, strong) UIButton         *cancel;


@property (nonatomic, copy) SelectBlock selectBlock;

@property (nonatomic,strong) NSArray *iconImageArray;
@property (nonatomic,strong) NSArray *titleArray;



- (void)show;
- (void)dismiss;

- (void)showCopyUrlItem;
- (void)hideCopyUrlItem;

@end


@interface ShareItemForWebView:UIView

@property (nonatomic, strong) UIImageView      *icon;
@property (nonatomic, strong) UILabel          *label;

- (void)startAnimation:(NSTimeInterval)delayTime;

@end
