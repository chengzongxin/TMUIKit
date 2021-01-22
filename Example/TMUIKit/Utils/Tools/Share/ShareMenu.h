//
//  ShareMenu.h
//  Matafy
//
//  Created by Joe on 2019/5/28.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareKit.h"

NS_ASSUME_NONNULL_BEGIN
/* 分享样式 */
typedef enum : NSUInteger {
    // 商务样式H5
    ShareStyleBusiness  = 0,
    // 社区样式
    ShareStyleCommunity = 1
    
} ShareStyle;

@interface ShareMenu : UIView

@property (strong, nonatomic) UIImageView *headerSloganImageView;

@property (copy, nonatomic) NSArray <NSString *>* topIcons;
@property (copy, nonatomic) NSArray <NSString *>* topTexts;
@property (copy, nonatomic) NSArray <NSString *>* bottomIcons;
@property (copy, nonatomic) NSArray <NSString *>* bottomTexts;
@property (assign, nonatomic) ShareStyle style;  // ShareStyleBusiness default

- (instancetype)initWithTopIcons:(NSArray *)topIcons topTexts:(NSArray *)topTexts;
- (instancetype)initWithTopIcons:(NSArray *)topIcons topTexts:(NSArray *)topTexts style:(ShareStyle)style;
- (instancetype)initWithTopIcons:(NSArray *)topIcons topTexts:(NSArray *)topTexts bottomIcons:(nullable NSArray *)bottomIcons bottomTexts:(nullable NSArray *)bottomTexts;
- (instancetype)initWithTopIcons:(NSArray *)topIcons topTexts:(NSArray *)topTexts bottomIcons:(nullable NSArray *)bottomIcons bottomTexts:(nullable NSArray *)bottomTexts style:(ShareStyle)style;

@property (nonatomic,copy) void (^tapItem)(NSIndexPath *indexPath);
@property (nonatomic,copy) void (^dismissHandle)(void);

- (void)setBackgroundViewColor:(UIColor *)color;

- (void)show;
- (void)dismiss;

@end

@interface ShareMenuItem : UIView

@property (nonatomic, strong) UIImageView      *icon;
@property (nonatomic, strong) UILabel          *label;

-(void)startAnimation:(NSTimeInterval)delayTime;

@end


NS_ASSUME_NONNULL_END



//- (void)shareClick{
//    NSArray *topIcons = @[@"share_h5_微信",@"share_h5_朋友圈",@"share_h5_copylink",@"share_h5_微信",@"share_h5_微信"];
//    NSArray *topTexts = @[@"微信",@"朋友圈",@"复制链接",@"保存为图片",@"分享到社区"];
//    //    ShareMenu *share = [[ShareMenu alloc] initWithTopIcons:topIcons topTexts:topTexts bottomIcons:topIcons bottomTexts:topTexts];
//    ShareMenu *share = [[ShareMenu alloc] initWithTopIcons:topIcons topTexts:topTexts];
//    [share show];
//    share.tapItem = ^(NSIndexPath * _Nonnull indexPath) {
//        NSLog(@"%@",indexPath);
//        SSDKPlatformType type;
//        switch (indexPath.item) {
//            case 0:
//                type = SSDKPlatformTypeWechat;
//                break;
//            case 1:
//                type = SSDKPlatformSubTypeWechatTimeline;
//                break;
//            case 2:
//                type = SSDKPlatformTypeQQ;
//                break;
//            case 3:
//                type = SSDKPlatformTypeSinaWeibo;
//                break;
//            case 4:
//                type = SSDKPlatformTypeSMS;
//                break;
//            default:
//                break;
//        }
//        //        [ShareKit shareToPlatform:@"啦啦啦" content:@"哈哈哈" image:[UIImage imageNamed:@"share_h5_微信"] url:@"www.baidu.com" platform:type];
//        //        [ShareKit shareWeixinMiniProgram:@"我发现了一个很厉害的机票预订小程序"
//        //                                   image:@"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS55jcTHt473TtjxkNcew234fhZ3fxwkulTwkmJz-F4q-2wKmZvEg"
//        //                                 pathUrl:@"pages/webview/webview"
//        //                             webPageuUrl:@"http://m.matafy.com/tickets/index.html"];
//        [ShareKit shareWeixinMiniProgram:@"我发现了一个很厉害的机票预订小程序"
//                                   image:[User sharedInstance].iconUrl
//                                 pathUrl:@"pages/webview/webview"
//                             webPageuUrl:@"http://m.matafy.com/tickets/index.html"];
//    };
//}
