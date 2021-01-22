//
//  ShareCommunityView.m
//  Matafy
//
//  Created by Jason on 2018/12/17.
//  Copyright © 2018 com.upintech. All rights reserved.
//

#import "ShareCommunityView.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <MessageUI/MessageUI.h>

typedef void(^ShareSuccessBlock)(id);
typedef void(^ShareFailureBlock)(id);

@interface ShareCommunityView ()<MFMessageComposeViewControllerDelegate>

@property (copy, nonatomic) ShareSuccessBlock successBlock;

@property (copy, nonatomic) ShareFailureBlock failureBlock;

/**
 背景遮罩
 */
@property (strong, nonatomic) UIView *bgView;

@end

@implementation ShareCommunityView

+ (void)share:(NSString *)titleToShare text:(NSString *)textToShare image:(UIImage *)img url:(NSString *)urlToShare success:(void (^)(id))success fail:(void (^)(id))fail{
    [[self xibView] share:titleToShare text:textToShare image:img url:urlToShare success:success fail:fail];
}

+ (instancetype)xibView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (void)share:(NSString *)titleToShare text:(NSString *)textToShare image:(UIImage *)img url:(NSString *)urlToShare success:(void (^)(id))success fail:(void (^)(id))fail{
    self.shareTitle   = titleToShare;
    self.shareContent = textToShare;
    self.shareImg     = img;
    self.shareUrl     = urlToShare;
    self.successBlock = success;
    self.failureBlock = fail;
    
    UIWindow *mainWindow = [[UIApplication sharedApplication]keyWindow];
    
    for (UIView *view in mainWindow.subviews) {
        if ([view isKindOfClass:[self class]]) {
            NSLog(@"上一次的还没移除");
            return ;
        }
    }
    
    UIView *bgView = [UIView new];
    bgView.frame = mainWindow.frame;
    bgView.backgroundColor = JColorFromRGB(0x000000);
    bgView.alpha = 0.5;
    _bgView = bgView;
    
    self.frame = CGRectMake(0, KMainScreenHeight - self.frame.size.height, KMainScreenWidth, self.frame.size.height);
    
    [mainWindow addSubview:_bgView];
    [mainWindow addSubview:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(removeView:)];
    [_bgView addGestureRecognizer:tap];
}

// 取消操作
-(void)removeView:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
    [_bgView removeFromSuperview];
    self.failureBlock(@"");
}

- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
    [_bgView removeFromSuperview];
    self.failureBlock(@"");
}

///**
// 微博
// */
//- (IBAction)weiboAction:(UIButton *)sender {
//    SSDKPlatformType temp = SSDKPlatformTypeSinaWeibo;
//    [self shareToPlamfortsWithPlathformType:temp];
//}
/**
 微信
 */
- (IBAction)weixinAction:(UIButton *)sender {
    SSDKPlatformType temp = SSDKPlatformTypeWechat;
    [self shareToPlamfortsWithPlathformType:temp];
}
/**
 微信朋友圈
 */
- (IBAction)friendCircleAction:(UIButton *)sender {
    SSDKPlatformType temp = SSDKPlatformSubTypeWechatTimeline;
    [self shareToPlamfortsWithPlathformType:temp];
}
///**
// QQ空间
// */
//- (IBAction)QQZoneAction:(UIButton *)sender {
//    SSDKPlatformType temp = SSDKPlatformSubTypeQZone;
//    [self shareToPlamfortsWithPlathformType:temp];
//}
//
///**
// QQ
// */
//- (IBAction)QQAction:(UIButton *)sender {
//    SSDKPlatformType temp = SSDKPlatformTypeQQ;
//    [self shareToPlamfortsWithPlathformType:temp];
//}
//
///**
// SMS
// */
//- (IBAction)SMSAction:(id)sender {
//    NSLog(@"发短信");
//    
//    NSString *message = [NSString stringWithFormat:@"%@\n%@",self.shareContent,self.shareUrl];
//    
//    NSLog(@"message = %@",message);
//    
//    NSString *phone = @"";
//    NSLog(@"phone = %@",phone);
//    
//    //传入要发送到得电话号码，和短信界面预写入短信的内容，调用此方法即可跳到短信发送界面
//    [self showMessageView:@[phone] title:@"发送短信" body:message];
//}



//发短信
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor blackColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        UIViewController *rootVC = [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController visibleViewController];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:kLStr(@"common_btn_back") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        [rootVC presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
        [[[[controller viewControllers] lastObject] navigationItem] setLeftBarButtonItem:leftItem];// back
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kLStr(@"common_alert_tip")
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:kLStr(@"common_alert_sure")
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

//发短信
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            NSLog(@"信息发送成功");
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            NSLog(@"信息传送失败");
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            NSLog(@"信息被用户取消传送");
            
            break;
        default:
            break;
    }
}

//MARK: 分享微信小程序
+ (void)shareMiniProgram:(TravalType)travalType{
    NSString *titleToShare;
    NSString *descripToShare;
    NSString *urlStrToShare;
    NSString *pathToShare;
    UIImage  *thumbImage;
    
    switch (travalType) {
        case TravalTypeNone:
        {
            titleToShare = @"我发现了一个很厉害的旅行预订小程序";
            descripToShare = @"123我发现了一个很厉害的旅行预订小程序";
            urlStrToShare = WX_MINI_PROGRAM_AIR;
            pathToShare = @"pages/home/home";
            thumbImage = [UIImage imageNamed:@"旅行分享图"];
        }
            break;
        case TravalTypeAir:
        {
            titleToShare = @"我发现了一个很厉害的机票预订小程序";
            descripToShare = @"123我发现了一个很厉害的机票预订小程序";
            urlStrToShare = WX_MINI_PROGRAM_AIR;
            pathToShare = @"pages/webview/webview";
            thumbImage = [UIImage imageNamed:@"机票分享图"];
        }
            break;
        case TravalTypeHotel:
        {
            titleToShare = @"我发现了一个很厉害的酒店预订小程序";
            descripToShare = @"123我发现了一个很厉害的酒店预订小程序";
            urlStrToShare = WX_MINI_PROGRAM_HOTEL;
            pathToShare = @"pages/webviewHotel/webviewHotel";
            thumbImage = [UIImage imageNamed:@"酒店分享图"];
        }
            break;
        case TravalTypeTrain:
        {
            titleToShare = @"我发现了一个很厉害的火车票预订小程序";
            descripToShare = @"123我发现了一个很厉害的火车票预订小程序";
            urlStrToShare = WX_MINI_PROGRAM_TRAIN;
            pathToShare = @"pages/webviewTrain/webviewTrain";
            thumbImage = [UIImage imageNamed:@"火车票分享图"];
        }
            break;
            
        default:
            break;
    }
    
    if (!NULLString([User sharedInstance].username)){
        [titleToShare stringByReplacingOccurrencesOfString:@"我" withString:[User sharedInstance].username];
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupWeChatMiniProgramShareParamsByTitle:titleToShare
                                                  description:descripToShare
                                                   webpageUrl:[NSURL URLWithString:urlStrToShare]
                                                         path:pathToShare
                                                   thumbImage:thumbImage
                                                     userName:@"gh_14b133c39d40"
                                              withShareTicket:YES
                                              miniProgramType:WX_MINI_PROGRAM_TYPE
                                           forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    //进行分享
    [ShareSDK share:SSDKPlatformSubTypeWechatSession //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kLStr(@"share_suc")
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:kLStr(@"common_alert_sure")
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateFail:
                 
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kLStr(@"share_failed")
                                                                 message:[NSString stringWithFormat:@"%@",error]
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
                 [alert show];
                 break;
             }
             default:
                 break;
         }
     }];
}


//MARK: 分享微信小程序
+ (void)shareMiniProgram:(TravalType)travalType title:(NSString *)title imageUrl:(NSString *)imageUrl{
    NSString *titleToShare;
    NSString *descripToShare;
    NSString *urlStrToShare;
    NSString *pathToShare;
    NSString *thumbImage;
    
    switch (travalType) {
        case TravalTypeNone:
        {
            titleToShare = title;
            descripToShare = @"我发现了一个很厉害的旅行预订小程序";
            urlStrToShare = WX_MINI_PROGRAM_AIR;
            pathToShare = @"pages/home/home";
            thumbImage = imageUrl;
        }
            break;
        case TravalTypeAir:
        {
            titleToShare = title;
            descripToShare = @"我发现了一个很厉害的机票预订小程序";
            urlStrToShare = WX_MINI_PROGRAM_AIR;
            pathToShare = @"pages/webview/webview";
            thumbImage = imageUrl;
        }
            break;
        case TravalTypeHotel:
        {
            titleToShare = title;
            descripToShare = @"我发现了一个很厉害的酒店预订小程序";
            urlStrToShare = WX_MINI_PROGRAM_HOTEL;
            pathToShare = @"pages/webviewHotel/webviewHotel";
            thumbImage = imageUrl;
        }
            break;
        case TravalTypeTrain:
        {
            titleToShare = title;
            descripToShare = @"我发现了一个很厉害的火车票预订小程序";
            urlStrToShare = WX_MINI_PROGRAM_TRAIN;
            pathToShare = @"pages/webviewTrain/webviewTrain";
            thumbImage = imageUrl;
        }
            break;
            
        default:
            break;
    }
    
    if (!NULLString([User sharedInstance].username)){
        [titleToShare stringByReplacingOccurrencesOfString:@"我" withString:[User sharedInstance].username];
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupWeChatMiniProgramShareParamsByTitle:titleToShare
                                                  description:descripToShare
                                                   webpageUrl:[NSURL URLWithString:urlStrToShare]
                                                         path:pathToShare
                                                   thumbImage:thumbImage
                                                     userName:@"gh_14b133c39d40"
                                              withShareTicket:YES
                                              miniProgramType:WX_MINI_PROGRAM_TYPE
                                           forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    //进行分享
    [ShareSDK share:SSDKPlatformSubTypeWechatSession //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kLStr(@"share_suc")
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:kLStr(@"common_alert_sure")
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateFail:
                 
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kLStr(@"share_failed")
                                                                 message:[NSString stringWithFormat:@"%@",error]
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
                 [alert show];
                 break;
             }
             default:
                 break;
         }
     }];
}


//MARK: H5分享微信小程序
+ (void)shareWeixinMiniProgram:(NSString *)title imageUrl:(NSString *)imageUrl pathUrl:(NSString *)pathUrl webPageuUrl:(NSString *)webPageUrl{
    NSString *titleToShare;
    NSString *descripToShare;
    NSString *urlStrToShare;
    NSString *pathToShare;
    NSString *thumbImage;
    
    titleToShare = title;
    descripToShare = @"我发现了一个很厉害的旅行预订小程序";
    urlStrToShare = webPageUrl;
    pathToShare = pathUrl;
    thumbImage = imageUrl;
    
    if (!NULLString([User sharedInstance].username)){
        [titleToShare stringByReplacingOccurrencesOfString:@"我" withString:[User sharedInstance].username];
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupWeChatMiniProgramShareParamsByTitle:titleToShare
                                                  description:descripToShare
                                                   webpageUrl:[NSURL URLWithString:urlStrToShare]
                                                         path:pathToShare
                                                   thumbImage:thumbImage
                                                     userName:@"gh_14b133c39d40"
                                              withShareTicket:YES
                                              miniProgramType:WX_MINI_PROGRAM_TYPE
                                           forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    //进行分享
    [ShareSDK share:SSDKPlatformSubTypeWechatSession //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kLStr(@"share_suc")
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:kLStr(@"common_alert_sure")
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateFail:
                 
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kLStr(@"share_failed")
                                                                 message:[NSString stringWithFormat:@"%@",error]
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
                 [alert show];
                 break;
             }
             default:
                 break;
         }
     }];
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
                 [self removeView:nil];
//                 [UIWindow showTips:kLStr(@"share_suc")];
//                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kLStr(@"share_suc")
//                                                                     message:nil
//                                                                    delegate:nil
//                                                           cancelButtonTitle:kLStr(@"common_alert_sure")
//                                                           otherButtonTitles:nil];
//                 [alertView show];
//                 self.successBlock(kLStr(@"share_suc"));
//                 break;
             }
             case SSDKResponseStateFail:
             {
                 [self removeView:nil];
//                 [UIWindow showTips:kLStr(@"share_failed")];
//                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kLStr(@"share_failed")
//                                                                 message:[NSString stringWithFormat:@"%@",error]
//                                                                delegate:nil
//                                                       cancelButtonTitle:@"OK"
//                                                       otherButtonTitles:nil, nil];
//                 [alert show];
//                 self.failureBlock(kLStr(@"share_failed"));
//                 break;
             }
             default:
                 break;
         }
     }];
    [self removeView:nil];
}




- (void)back{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC dismissViewControllerAnimated:true completion:nil];
}


- (void)dealloc {
    NSLog(@"shareView 销毁");
}


@end
