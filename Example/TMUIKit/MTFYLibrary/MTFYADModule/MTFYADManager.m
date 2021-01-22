//
//  MTFYADManager.m
//  Matafy
//
//  Created by Fussa on 2019/8/19.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYADManager.h"
//百度广告
#import "BaiduMobAdSDK/BaiduMobAdSplash.h"
#import "BaiduMobAdSDK/BaiduMobAdSetting.h"

//GDT
#import "GDTSDKConfig.h"
#import "GDTSplashAd.h"


static NSString* const kGDTPlacementId = @"3050338417787095";
static NSString* const kBDAdUnitTag = @"5827765";
static NSString* const kBDPublisherId = @"bb87aa4f";

@interface MTFYADManager()<BaiduMobAdSplashDelegate, GDTSplashAdDelegate>
@property (strong, nonatomic) GDTSplashAd *gdtSplash;
@property (strong, nonatomic) BaiduMobAdSplash *bdSplash;
@property (strong, nonatomic) UIView *bdCustomSplashView;
@property(nonatomic, copy) MTFYADManagerCompleteHandle completeHandleBlock;

@end

@implementation MTFYADManager

static MTFYADManager  *adManagerShareInstance = nil;
static dispatch_once_t MTFYADManager_onceToken;

+ (instancetype)shareInstance {
    dispatch_once(&MTFYADManager_onceToken, ^{
        adManagerShareInstance = [[MTFYADManager alloc] init];
    });
    return adManagerShareInstance;
}

- (void)loadSplashADInWindow:(UIWindow *)window completeHandle:(MTFYADManagerCompleteHandle)complteHandle {
    
    self.completeHandleBlock = complteHandle;
    
    [Global sharedInstance].adQueue.suspended = YES;
    // 随机产生[0,1)之间浮点数
    srand48(time(0));// reset
    double randomF = drand48();
    BOOL randomB = randomF > 0.5;
    randomB = NO;
    if (randomB) {
        // 设置广点通开屏广告
        [self setupGDTAD:window];
        [KEY_WINDOW makeToast:@"广点通"];
    }else{
        // 设置百度开屏广告
        [self setupBaiduAD:window];
        [KEY_WINDOW makeToast:@"百度"];
    }
}

#pragma mark  广点通广告
- (void)setupGDTAD:(UIWindow *)window {
    
    // iPhone下展示广告
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
        return;
    }
    
    [GDTSDKConfig setHttpsOn];
    
    GDTSplashAd *splash = [[GDTSplashAd alloc] initWithAppId:GDTID placementId:kGDTPlacementId];
    splash.delegate = self;
    
    UIImage *splashImage = [self p_splashBGImage];
    UIImage *backgroundImage = [UIImage mtfy_imageResize:splashImage andResizeTo:[UIScreen mainScreen].bounds.size];
    
    splash.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    splash.fetchDelay = 3;
    
    UIView *bottomView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMTFYScreenW, kWidth(115))];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIImageView  *bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Ad_bottom_logo"]];
    bottomImageView.contentMode = UIViewContentModeScaleAspectFit;
    bottomImageView.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:bottomImageView];
    [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomView.mas_centerX);
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        //            make.height.mas_equalTo(kAspectRatio(108));
        //            make.width.mas_equalTo(kAspectRatio(300));
    }];
    
    [splash loadAdAndShowInWindow:window withBottomView:bottomView];
    self.gdtSplash = splash;
}


#pragma mark  BAIDU AD
- (void)setupBaiduAD:(UIWindow *)window {
    [BaiduMobAdSetting sharedInstance].supportHttps = YES;
    BaiduMobAdSplash *splash = [[BaiduMobAdSplash alloc] init];
    splash.delegate = self;
    self.bdSplash = splash;
    
    //把在 mssp.baidu.com 上创建后获得的代码位 id 写到这里
    splash.AdUnitTag = kBDAdUnitTag;
    //   splash.AdUnitTag = @"6171562";
    
    splash.canSplashClick = YES;
    
    //可以在 customSplashView 上显示包含其他内容的自定义开屏
    self.bdCustomSplashView = [[UIView alloc] initWithFrame:window.frame];
    self.bdCustomSplashView.backgroundColor = [UIColor clearColor];
    [window addSubview:self.bdCustomSplashView];
    
    NSLog(@"frame----> %@", NSStringFromCGRect(window.frame));
    // background image
    UIImage *splashImage = [self p_splashBGImage];
    UIImage *backgroundImage = [UIImage mtfy_imageResize:splashImage andResizeTo:[UIScreen mainScreen].bounds.size];

    [self.bdCustomSplashView addSubview:[[UIImageView alloc] initWithImage:backgroundImage]];
    
    // bottom logo
    UIView *bottomView  = [[UIView alloc] initWithFrame:CGRectMake(0, kMTFYScreenH - kWidth(115), kMTFYScreenW, kWidth(115))];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.bdCustomSplashView addSubview:bottomView];
    UIImageView *bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Ad_bottom_logo"]];
    bottomImageView.contentMode = UIViewContentModeScaleAspectFit;
    bottomImageView.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:bottomImageView];
    [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomView.mas_centerX);
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        //        make.height.mas_equalTo(kAspectRatio(108));
        //        make.width.mas_equalTo(kAspectRatio(300));
    }];
    bottomView.hidden = YES;
    
    //在 baiduSplashContainer 用做上展现百度干告的容器，注意尺寸必须大于 200*200， 并且 baiduSplashContainer 需要全部在 window 内，同时开机画面不建议旋转
    UIView * baiduSplashContainer = [[UIView alloc] initWithFrame:(CGRect){CGPointZero,{kMTFYScreenW, kMTFYScreenH - kWidth(115)}}];
    
    [self.bdCustomSplashView addSubview:baiduSplashContainer];
    //在的 baiduSplashContainer 里展现百度干告
    [splash loadAndDisplayUsingContainerView:baiduSplashContainer];
    
    // 10 秒后移除
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeSplash];
    });
}

#pragma mark - 广告代理方法
#pragma mark GDTSplashAdDelegate

/// 应用进入后台时回调 (点击下载有以后, 应用切换到后台)
-(void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd {
    NSLog(@"%s",__FUNCTION__);
}

/// 开屏广告成功展示
-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd {
    NSLog(@"%s",__FUNCTION__);
}

/// 开屏广告展示失败
-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error {
    NSLog(@"%s%@",__FUNCTION__,error);
    [self handleAdDismiss];
}

/// 开屏广告将要关闭回调
- (void)splashAdWillClosed:(GDTSplashAd *)splashAd {
    NSLog(@"%s",__FUNCTION__);
}

/// 开屏广告关闭回调
-(void)splashAdClosed:(GDTSplashAd *)splashAd {
    NSLog(@"%s",__FUNCTION__);
    self.gdtSplash = nil;
    [self handleAdDismiss];
}

/// 开屏广告点击以后即将弹出全屏广告页
- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd {
    NSLog(@"%s",__FUNCTION__);
}

/// 开屏广告点击以后弹出全屏广告页
- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd{
    NSLog(@"%s",__FUNCTION__);
}

/// 开屏广告点击回调
- (void)splashAdClicked:(GDTSplashAd *)splashAd {
    NSLog(@"%s",__FUNCTION__);
}

/// 点击以后全屏广告页将要关闭
- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd {
    NSLog(@"%s",__FUNCTION__);
}

/// 点击以后全屏广告页已经关闭
- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd {
    NSLog(@"%s",__FUNCTION__);
}


#pragma mark - BaiduMobAdSplashDelegate
/// 应用的APPID
- (NSString *)publisherId {
    return kBDPublisherId;
}

/// 广告展示成功
- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash{
    NSLog(@"splashSuccessPresentScreen");
    for (UIView *view in self.bdCustomSplashView.subviews) {
        view.hidden = NO;
    }
}

/// 广告展示失败
- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason)reason{
    //自定义开屏移除
    NSLog(@"splashlFailPresentScreen withError:%d",reason);
    [self removeSplash];
    [self handleAdDismiss];
}

/// 广告展示结束
- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash {
    NSLog(@"splashDidDismissScreen");
    //自定义开屏移除
    [self removeSplash];
    [self handleAdDismiss];
}

/// 广告被点击
- (void)splashDidClicked:(BaiduMobAdSplash *)splash {
    NSLog(@"splashDidClicked");
}

/// 广告详情页消失
- (void)splashDidDismissLp:(BaiduMobAdSplash *)splash {
    NSLog(@"splashDidDismissLp");
}

- (void)splashDidReady:(BaiduMobAdSplash *)splash AndAdType:(NSString *)adType VideoDuration:(NSInteger)videoDuration {
    NSLog(@"splashDidReady, adType: %@,  duration: %zd", adType, videoDuration);
}

#pragma mark - Private
/// 移除广告
- (void)removeSplash {
    if (self.bdSplash) {
        self.bdSplash.delegate = nil;
        self.bdSplash = nil;
        [self.bdCustomSplashView removeFromSuperview];
    }
}

/// 广告消失
- (void)handleAdDismiss {
    [Global sharedInstance].adQueue.suspended = NO;
    if (self.completeHandleBlock) {
        self.completeHandleBlock();
    }
}

/// 背景图片
- (UIImage *)p_splashBGImage{
    if (IS_iPhoneX_Series) {
         return [UIImage imageNamed:@"ad_bg_x"];
    } else{
        return [UIImage imageNamed:@"ad_bg"];
    }
}

#pragma mark - Setter && Getter
- (void)setBdSplash:(BaiduMobAdSplash *)bdSplash{
    objc_setAssociatedObject(self, @selector(bdSplash), bdSplash, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BaiduMobAdSplash *)bdSplash{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBdCustomSplashView:(UIView *)bdCustomSplashView{
    objc_setAssociatedObject(self, @selector(bdCustomSplashView), bdCustomSplashView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)bdCustomSplashView{
    return objc_getAssociatedObject(self, _cmd);
}


@end
