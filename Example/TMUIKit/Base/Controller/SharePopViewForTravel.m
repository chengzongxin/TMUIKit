//
//  SharePopView.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "SharePopViewForTravel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <MessageUI/MessageUI.h>
#import <Photos/Photos.h>

#define shareAppLogan @"share_slogan"

@interface SharePopViewForTravel ()

@property (nonatomic, strong) NSMutableArray<ShareItemForTravel *> *shareItemArr;

@end

@implementation SharePopViewForTravel

- (instancetype)init {
    self = [super init];
    if (self) {
        NSArray *topIconsName = @[
                                  @"share_h5_微信",
                                  @"share_h5_朋友圈",
                                  @"share_h5_发送给朋友",
                                  @"h5_社区"
                                  ];
        NSArray *topTexts = @[
                              kLStr(@"share_wx_wx"),
                              kLStr(@"share_wx_timeline"),
                              kLStr(@"share_save_image"),
                              kLStr(@"share_community")
                              ];
        
        self.frame = ScreenFrame;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)]];
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, kMTFYScreenH, kMTFYScreenW, 188 + SafeAreaBottomHeight)];
        _container.backgroundColor = UIColor.whiteColor;
        [self addSubview:_container];
        
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:_container.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0f, 10.0f)];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        _container.layer.mask = shape;
        
        UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        visualEffectView.frame = self.bounds;
        visualEffectView.alpha = 1.0f;
        [_container addSubview:visualEffectView];
        
        CGFloat loganImgViewW = 186;
        UIImageView *loganImgView = [[UIImageView alloc]initWithFrame:CGRectMake((kMTFYScreenW - loganImgViewW ) * 0.5, 14, loganImgViewW , 20)];
        loganImgView.image = [UIImage imageNamed:shareAppLogan];
        loganImgView.contentMode = UIViewContentModeScaleAspectFit;
        [_container addSubview:loganImgView];
        
        UIButton *closeButton = [UIButton button];
        closeButton.frame = CGRectMake(kMTFYScreenW - 30, 17, 17, 17);
        [closeButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [closeButton setOkaImage:@"share_h5_x"];
        [closeButton addTarget:self action:@selector(dismiss)];
        [_container addSubview:closeButton];
        
        CGFloat wMultiple = 0.9;
        CGFloat scrollW = kMTFYScreenW * wMultiple;
        CGFloat itemWidth = (scrollW)/topIconsName.count;
        
        UIScrollView *topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kMTFYScreenW * ((1 - wMultiple) * 0.5), 50, scrollW, 156)];
        topScrollView.contentSize = CGSizeMake(itemWidth * topIconsName.count, 80);
        topScrollView.showsHorizontalScrollIndicator = NO;
        topScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 30);
        [_container addSubview:topScrollView];
        
        [self.shareItemArr removeAllObjects];
        for (NSInteger i = 0; i < topIconsName.count; i++) {
            ShareItemForTravel *item = [[ShareItemForTravel alloc] initWithFrame:CGRectMake(itemWidth*i, 0, itemWidth, 156)];
            item.icon.image = [UIImage imageNamed:topIconsName[i]];
            item.label.text = topTexts[i];
            item.tag = TravelShareTypeWechat + i;
            [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onShareItemTap:)]];
            [item startAnimation:i*0.03f];
            [topScrollView addSubview:item];
            
            [self.shareItemArr addObject:item];
        }
        
        if ([Global sharedInstance].isPriceContest) {
            ShareItemForTravel *item = self.shareItemArr.lastObject;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(item.icon.centerX+30, 0, 40, 16)];
            label.text = @"低价大赛";
            label.font = [UIFont systemFontOfSize:8];
            label.textColor = UIColor.whiteColor;
            label.backgroundColor = UIColor.redColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 8;
            label.layer.masksToBounds = YES;
            [item.icon addSubview:label];
        }
    }
    return self;
}

#pragma mark - Tap Action
- (void)onShareItemTap:(UITapGestureRecognizer *)sender {
    
    // 完全回调到外面去处理的情况
    if (self.isBlockoOutside && self.selectBlock) {
        @weakify(self);
        // 消失完才回调
        [self dismiss:^{
            @strongify(self);
            self.selectBlock(sender.view.tag);
        }];
        
        return;
    }
    
    [self dismiss];
    switch (sender.view.tag) {
        case 0: {
            if (self.selectBlock) {
                self.selectBlock(sender.view.tag);
            } else {
                [self weixinAction];
            }
        }
            break;
        case 1:
            [self friendCircleAction];
            if (self.selectBlock) {
                self.selectBlock(sender.view.tag);
            }
            break;
        case 2:
            [self savedPhotosAlbum:self.shareImg];
            if (self.selectBlock) {
                self.selectBlock(sender.view.tag);
            };
            break;
        default:
            break;
    }
}

//- (void)onActionItemTap:(UITapGestureRecognizer *)sender {
//    switch (sender.view.tag) {
//        case 0:
//        {
//            VideoTousuViewController *vc = [VideoTousuViewController new];
//            [[self currentVC].navigationController pushViewController:vc animated:YES];
//        }
//            break;
//        case 1:
//        {
//            UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
//            pastboard.string = self.shareUrl;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [UIWindow showTips:@"已复制链接"];
//            });
//        }
//        default:
//            break;
//    }
//    [self dismiss];
//}

- (void)handleGuesture:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_container];
    if(![_container.layer containsPoint:point]) {
        [self dismiss];
        return;
    }
    point = [sender locationInView:_cancel];
    if([_cancel.layer containsPoint:point]) {
        [self dismiss];
    }
}

- (void)show {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];

    [self.shareItemArr enumerateObjectsUsingBlock:^(ShareItemForTravel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj startAnimation:idx * 0.03f];
    }];
    
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.container.frame;
                         frame.origin.y = frame.origin.y - frame.size.height;
                         self.container.frame = frame;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = self.container.frame;
                         frame.origin.y = frame.origin.y + frame.size.height;
                         self.container.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)dismiss:(DismissBlock)dismissBlock
{
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = self.container.frame;
                         frame.origin.y = frame.origin.y + frame.size.height;
                         self.container.frame = frame;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         if (dismissBlock) {
                             dismissBlock ();
                         }
                     }];
}


/**
 微信
 */
- (void)weixinAction {
    SSDKPlatformType temp = SSDKPlatformTypeWechat;
    [self shareToPlamfortsWithPlathformType:temp];
}
/**
 微信朋友圈
 */
- (void)friendCircleAction {
    SSDKPlatformType temp = SSDKPlatformSubTypeWechatTimeline;
    [self shareToPlamfortsWithPlathformType:temp];
}

//MARK: 分享到各大平台
- (void)shareToPlamfortsWithPlathformType:(SSDKPlatformType)type{
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.shareContent
                                     images:@[self.shareImg]
                                        url:[NSURL URLWithString:self.shareUrl]
                                      title:self.shareTitle
                                       type:SSDKContentTypeAuto];

    //进行分享
    [ShareSDK share:type //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....
         switch (state) {
             case SSDKResponseStateSuccess:
             {
//                                   [UIWindow showTips:kLStr(@"share_suc")];
                 [KEY_WINDOW makeToast:kLStr(@"share_suc") duration:2.0 position:CSToastPositionCenter style:nil];
                 if (self.shareSuccessBlock) {
                     self.shareSuccessBlock();
                 }
             }
                 break;
             case SSDKResponseStateFail:
             {
//                                   [UIWindow showTips:kLStr(@"share_failed")];
                 [KEY_WINDOW makeToast:kLStr(@"share_failed") duration:2.0 position:CSToastPositionCenter style:nil];
                 if (self.shareFailBlock) {
                     self.shareFailBlock(error.description);
                 }
             }
                 break;
             default:
                 break;
         }
     }];
}


/* 保存截图到相册 */
- (void)savedPhotosAlbum:(UIImage *)snapShotImage{
    CGImageRef imageRef = snapShotImage.CGImage;
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRef];
    NSLog(@"sendImage==%@",sendImage);
    
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) { // 此应用程序没有被授权访问的照片数据。可能是家长控制权限。
        NSLog(@"因为系统原因, 无法访问相册");
    } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝访问相册
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kLStr(@"common_warming") message:kLStr(@"share_go_setting_privacy_photos_turn_on_access") delegate:self cancelButtonTitle:kLStr(@"common_alert_cancel") otherButtonTitles:kLStr(@"share_go_setting"), nil];
        [alertView show];
    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许访问相册
        // 放一些使用相册的代码
        //保存图片到照片库 （iOS10 以上记得在info.plist添加相册访问权限，否则可能崩溃）
        UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);
        [UIWindow showTips:kLStr(@"common_save_suc")];
        if (self.shareSuccessBlock) {
            self.shareSuccessBlock();
        }
    } else if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                // 放一些使用相册的代码
                //保存图片到照片库 （iOS10 以上记得在info.plist添加相册访问权限，否则可能崩溃）
                UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);
                if (self.shareSuccessBlock) {
                    self.shareSuccessBlock();
                }
                // 上面是异步回调
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIWindow showTips:kLStr(@"common_save_suc")];
                });
            }
        }];
    }
}

#pragma mark - Getters and Setters

- (NSMutableArray<ShareItemForTravel *> *)shareItemArr {
    if (!_shareItemArr) {
        _shareItemArr = [NSMutableArray array];
    }
    return _shareItemArr;
}

//- (void)setIsPriceContest:(BOOL)isPriceContest{
//    _isPriceContest = isPriceContest;
//    
//}

#pragma mark - Supperclass

#pragma mark - NSObject

@end



#pragma Item view

@implementation ShareItemForTravel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"iconHomeAllshareCopylink"];
        _icon.contentMode = UIViewContentModeCenter;
        _icon.userInteractionEnabled = YES;
        [self addSubview:_icon];
        
        _label = [[UILabel alloc] init];
        _label.text = @"TEXT";
        _label.textColor = HEXCOLOR(0x8F8F8F);
        _label.font = SmallFont;
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return self;
}

-(void)startAnimation:(NSTimeInterval)delayTime {
    CGRect originalFrame = self.frame;
    self.frame = CGRectMake(CGRectGetMinX(originalFrame), 35, originalFrame.size.width, originalFrame.size.height);
    [UIView animateWithDuration:0.9f
                          delay:delayTime
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = originalFrame;
                     }
                     completion:^(BOOL finished) {
                     }];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-30);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(20);
    }];
}

@end
