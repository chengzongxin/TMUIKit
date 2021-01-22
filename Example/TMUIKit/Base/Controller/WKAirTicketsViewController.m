//
//  WKAirTicketsViewController.m
//  silu
//
//  Created by sawyerzhang on 2017/10/24.
//  Copyright © 2017年 upintech. All rights reserved.
//

typedef NS_ENUM(NSUInteger, rightItemType) {
    rightItemTypeNone,
    rightItemTypeShareProgram,
    rightItemTypeShareScreen,
    rightItemTypeMap,
    rightItemTypeCustom,
    rightItemTypeHotelMap,
    rightItemTypeCinimaMap,
    rightItemTypeHelpService, /// 客服
};

#import "WKAirTicketsViewController.h"
#import "BaseDataModel.h"
#import <CommonCrypto/CommonDigest.h>
#import "WKWebViewJavascriptBridge.h"
#import "SafariViewController.h"
#import <MapKit/MapKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "FFToast.h"
#import "NSDictionary+Extension.h"
#import "MapViewController.h"
#import <MapKit/MKMapItem.h>
#import "WebTableController.h"
#import "ShareView.h"
#import "ShareUtils.h"
#import "CustomPopOverView.h"
#import <CoreLocation/CoreLocation.h>      //添加定位服务头文件（不可缺少）
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import "TYSnapshotScroll.h"
#import "WKWebView+LVShot.h"
#import "SharePopViewForWebView.h"
#import "UIImage+Circle.h"
#import "HotelListParaModel.h"
#import "TravelViewController.h"
#import "MovieMapViewController.h"
#import "MovieMapVCModel.h"
#import "BaseWebNoNetworkView.h"
#import "SpeechRecognizerHelper.h"
#import "SpeechSynthesizerHelper.h"
//#import "BaseWebNoNetworkView.h"
#import "TravelRequest.h"
// 图片全屏浏览
#import "MTFYPhotoBrowser.h"

// 医美首页图文+视频详情
#import "BeautyContentViewController.h"
// 医美首页图文+视频 Model
#import "BeautyPagesListContentModel.h"
// 分享相关
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <MessageUI/MessageUI.h>
#import <Photos/Photos.h>
#import "ShareUserHBView.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "ShareMenu.h"
#import "ShareKit.h"
#import "SpeechWebBoardView.h"
#import "UIImage+Circle.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AlertSheetNavigateView.h"
#import "CarMapViewController.h"
#import "AlertSheetNavigateView.h"
#import "TravelViewController.h"
#import "WKWebView+Cache.h"
#import "WebViewCacheManager.h"
#import "MainViewModel.h"
#import "OrderListBaseViewController.h"
#import "OrderBaseViewController.h"
// 医美视频
#import "BeautyVideoListViewController.h"
// 医美日记
#import "BeautyDiaryViewController.h"
#import "ProfileViewModel.h"

@interface WKAirTicketsViewController ()<WKUIDelegate, WKNavigationDelegate, UIGestureRecognizerDelegate, CustomPopOverViewDelegate, CLLocationManagerDelegate, BMKGeoCodeSearchDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    //    UILabel                     *_title_label;
    NSInteger                    _type;
    UIView                      *_naviView;
    UIButton                    *_backButton;   /// 没有导航栏按钮时显示的btn
    UIButton                    *_navBackButton;
    
    id                          _data;             // webview 传给 native 的值
    
    NSString                    *_HomePageUrl;  // 首页
    
    UIButton                     *_closeButton;   // 针对银联支付添加返回label
    
//    CLLocationManager *_locationManager;//定位服务管理类
    //    CLGeocoder * _geocoder;//初始化地理编码器
//    BMKGeoCodeSearch             *_geoCodeSearch;  // 反向地理编码
    BOOL    _haveShareCommunity;  //是否显示社区分享
}

@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;

/// 标题
@property (strong, nonatomic) UILabel   *title_label;
/// 进度条
@property (strong, nonatomic) UIProgressView *progressView;
/// 地图按钮
@property (strong, nonatomic) UIButton *rightItemMap;
/// 分享小程序按钮
@property (strong, nonatomic) UIButton *rightItemShareProgram;
/// 分享长截图按钮
@property (strong, nonatomic) UIButton *rightItemShareScreen;
/// 客服按钮
@property (strong, nonatomic) UIButton *rightItemHelpService;
/// 自定义按钮
@property (strong, nonatomic) UIButton *rightItemCustom;

//@property (nonatomic, strong) SharePopViewForWebView *sharePopView;
/// 分享链接
@property (nonatomic, copy) NSString *shareLinkStr;
/// 存储自定义右键的数组
@property (nonatomic, strong) NSArray<UIButton *> *customRightItemArray;
/// 分享活动类型
@property (nonatomic, assign) WebViewShareActivityType shareActivityType;

/// 用户当前定位信息
@property (nonatomic, strong) CLLocation *currentLocation;

// 分享json参数
@property (nonatomic,strong) ShareCommunityModel *communityModel;

@property (nonatomic,strong) NSDictionary *shareJson;


/// 发送请求的URL
@property (nonatomic, copy) NSString *navigationActionRequestUrl;
// 语音助手相关
@property (nonatomic, copy) WVJBResponseCallback speechRecognizerCallback;
@property (nonatomic, copy) WVJBResponseCallback speechSynthesizerCallback;
@property (nonatomic, strong) SpeechWebBoardView *speechBoardView;
/// 是否视频全屏
@property (nonatomic, assign) BOOL videoFullScreen;
@property (nonatomic,assign) BOOL isBackAction;
@end

@implementation WKAirTicketsViewController

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    /* 清除缓存
     NSURLCache * cache = [NSURLCache sharedURLCache];
     [cache removeAllCachedResponses];
     [cache setDiskCapacity:0];
     [cache setMemoryCapacity:0];
     */
    
    [self initWithNavigationBar];

    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:@"Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/222333", @"UserAgent", nil];

    NSString *userAgent = [dictionnary objectForKey:@"UserAgent"];
    userAgent = [NSString stringWithFormat:@"%@;;;from=matafyApp&version=%@", userAgent, VERSION];
    NSMutableDictionary *mDictionnary = [NSMutableDictionary dictionaryWithDictionary:dictionnary];
    [mDictionnary setValue:userAgent forKey:@"UserAgent"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:mDictionnary];

//    [self initializeLocationService];

    [self initWithWKWebView];

    [self addNotification];
    
    [self showProgress];

    _haveShareCommunity = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //隐藏返回按钮
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self addFullScreenNotification];

    
    // 修复wk iOS11 下移20px问题
    if (@available(iOS 11.0, *)) {
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isInteractivePopDisabled) {
        //禁用返回手势
//        self.zf_interactivePopDisabled = YES;
        [self interactivePopDisable:YES];
    }

    // 语音助手面板
    [self initSpeechBoardView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.speechBoardView removeFromSuperview];
    [self.speechBoardView setSpeechNil];
    [self cancelSpeech];
    [self removeFullScreenNotification];
    [SVProgressHUD dismiss];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.webView.scrollView setContentInset:UIEdgeInsetsZero];
}

#pragma mark init subView

- (void)initWithWKWebView {
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    
    config.preferences.javaScriptEnabled =YES;
    //通过JS与webView内容交互
    config.userContentController = [WKUserContentController new];
    
    if(IS_iPhoneX_Series){
        self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 88, KMainScreenWidth, self.view.height - 88) configuration:config];
    }else{
        self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, KMainScreenWidth, self.view.height - 64) configuration:config];
    }
    // 启用缓存开关
//    self.webView.cacheEnable = WebViewCacheManager.sharedInstance.cacheEnable;

    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    self.webView.scrollView.bounces = NO;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.backgroundColor  = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;

    NSURL *urlString = [NSURL URLWithString:self.url];
    _HomePageUrl = self.url;
    NSURLRequest *request = [NSURLRequest requestWithURL:urlString];
    [self.webView loadRequest:request];
    
    if (self.bridge) { return; }
    [WKWebViewJavascriptBridge enableLogging];
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    
    // JS调OC
    [self JS2OC];
}

- (void)initWithNavigationBar {
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 自定义导航栏
    _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kNavBarHeight)];
    //_naviView.backgroundColor = HEXCOLOR(0x00C3CE);
    _naviView.backgroundColor = UIColor.whiteColor;
//    _naviView.hidden = self.isShowDefaultNavi ? NO : YES;
    if([self.url containsString:@"touch.train.qunar.com"] || [self.url containsString:@"m.matafy.com/hotel"]){
        _naviView.hidden = NO;
    }
    
    [self.view addSubview:_naviView];
    
    UIButton *backButton = [[UIButton alloc]init];
    if (self.backButtonType == WebViewBackButtonType1) {
        [backButton setImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateNormal];
    } else {
        [backButton setImage:[UIImage imageNamed:@"投诉单 back"] forState:UIControlStateNormal];
    }
    _navBackButton = backButton;
    [backButton setSG_eventTimeInterval:3];
    [backButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [backButton addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_naviView addSubview:backButton];
    
    CGFloat naviStatusH = kStatusBarHeight;
    CGFloat backButtonH = 21;
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_naviView.mas_left).offset(15);
//        make.width.mas_equalTo(12);
        make.height.mas_equalTo(backButtonH);
        make.top.mas_equalTo(naviStatusH + (44 - backButtonH) * 0.5);
    }];
    
    // backLabel
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setTitle:kLStr(@"common_close") forState:UIControlStateNormal];
    @weakify(self);
    [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[_closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        if ([self.webView.URL.absoluteString containsString:@"95516"]) {
            [[self responder].navigationController popViewControllerAnimated:YES];
            return;
        }
    }];
    
    [_naviView addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_naviView.mas_left).offset(40);
        make.centerY.mas_equalTo(backButton.mas_centerY);
    }];
    _closeButton.hidden = YES;
    
    if([self.url containsString:@"recommend.html?id"]){
        [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
    
    _title_label = [UILabel new];
    _title_label.font = [UIFont fontWithName:@"Helvetica-Bold" size:kAspectRatio(16)];
    _title_label.numberOfLines = 1;
    _title_label.textAlignment = NSTextAlignmentCenter;
    //_title_label.textColor = [UIColor whiteColor];
    _title_label.textColor = [UIColor blackColor];
    [_naviView addSubview:_title_label];
    [_title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_naviView.mas_centerX);
        make.centerY.mas_equalTo(backButton.mas_centerY);
        make.width.mas_equalTo(kAspectRatio(250));
    }];
    
    // 默认情况下不显示导航栏的时候显示的返回按钮
    _backButton = [[UIButton alloc]initWithFrame:CGRectMake(15, kStatusBarHeight + (44 - 17) * 0.5, 11, 17)];
    [_backButton setImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateNormal];
    [_backButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [_backButton addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    [_backButton bringSubviewToFront:self.view];
    if (self.backButtonType != WebViewBackButtonTypeDefult) {
        _backButton.hidden = YES;
    }

    if([self.url containsString:@"recommend.html?id"]) {  // 图文隐藏ssni
        _backButton.hidden = YES;
    }
}

#pragma mark - 通知

/**
 监听通知
 */
- (void)addNotification {
    @weakify(self);
    [RACObserve(self.webView, title) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.title_label.text = self.webView.title;
    }];
    
    
    [RACObserve(self.webView, estimatedProgress) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        CGFloat progress = [x doubleValue];
//        NSLog(@"estimatedProgress:%lf", progress);
        self.progressView.hidden = NO;
        if (progress == 1) {
            [self.progressView setProgress:1 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            });
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:(float) progress animated:YES];
        }
    }];
    
    [RACObserve(self.webView, URL) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSURL *url = x;
        NSString *urlString = url.absoluteString;
        self.shareLinkStr = urlString;
        if ([urlString containsString:@"Choose"] ) {
            // 首页
            [self setRightItemButton:rightItemTypeShareProgram];
        } else if (
                   [urlString containsString:@"compareListOne"] //搜索列表页
                   || [urlString containsString:@"bookList"]     //机票详情页
                   || [urlString containsString:@"compareListTwo"] //机票第二程
                   || [urlString containsString:@"compareListThree"] //机票第三程
                   || [urlString containsString:@"hotelList"]    // 酒店列表
                   || [urlString containsString:@"hotelDetail"] // 酒店详情
                   || [urlString containsString:@"TrainList"]   // 火车票车次列表页
                   //                   || [urlString containsString:@"TrainDetails"] //火车票车次详情页
                   //                   || [urlString containsString:@"scenicList"]   // 门票项目景点列表页
                   //                   || [urlString containsString:@"scenicDetail"] //门票项目景点详情页
                   )
        {
            [self setRightItemButton:rightItemTypeShareScreen];
        } else {
            [self setRightItemButton:rightItemTypeNone];
        }
    }];
}


/**
 监听视频播放全屏
 */
- (void)addFullScreenNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleVideoPlayEnterFullscreen) name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleVideoPlayExitFullscreen) name:UIWindowDidBecomeHiddenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

/**
 移除视频播放全屏通知
 */
- (void)removeFullScreenNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeHiddenNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

/// 进入全屏视频播放
- (void)handleVideoPlayEnterFullscreen {
    self.videoFullScreen = YES;
}

/// 退出全屏视频播放
- (void)handleVideoPlayExitFullscreen {
    self.videoFullScreen = NO;
    [WebViewViewModel endFullScreen];
}

/// 设备旋转
- (void)handleDeviceOrientationDidChange {
    if (!self.videoFullScreen) {
        return;
    }
    [WebViewViewModel handleDeviceOrientationDidChange];
}


#pragma mark 初始化定位服务
//- (void)initializeLocationService {
//    // 初始化定位管理器
//    _locationManager = [[CLLocationManager alloc] init];
//    [_locationManager requestWhenInUseAuthorization];
//    //[_locationManager requestAlwaysAuthorization];//iOS8必须，这两行必须有一行执行，否则无法获取位置信息，和定位
//    // 设置代理
//    _locationManager.delegate = self;
//    // 设置定位精确度到米
//    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
//    // 设置过滤器为无
//    _locationManager.distanceFilter = kCLDistanceFilterNone;
//    // 开始定位
//    [_locationManager startUpdatingLocation];//开始定位之后会不断的执行代理方法更新位置会比较费电所以建议获取完位置即时关闭更新位置服务
//    //初始化地理编码器
//    //    _geocoder = [[CLGeocoder alloc] init];
//    //初始化检索对象
//    _geoCodeSearch =[[BMKGeoCodeSearch alloc]init];
//    _geoCodeSearch.delegate = self;
//}


- (void)showProgress{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:kLStr(@"common_load_loading_data")];
    [SVProgressHUD dismissWithDelay:15];
}

/// 语音助手面板
- (void)initSpeechBoardView {
    if (self.speechBoardView && self.speechBoardView.superview) {
        return;
    }
    SpeechWebBoardView *speechBoardView = [SpeechWebBoardView showInView:KEY_WINDOW];
    self.speechBoardView = speechBoardView;
}

- (void)cancelSpeech {
    [self.speechBoardView setSpeechNil];
    [self.speechBoardView hide:nil];
}

#pragma mark - Public

#pragma mark - Event Respone
#pragma mark pop


- (void)backBtnAction:(UIButton *)btn {
    
    _isBackAction = YES;
    btn.enabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.enabled = YES;
    });
    
    
    if ([self.webView.URL.absoluteString containsString:@"Choose"]) {
        [[self responder].navigationController popViewControllerAnimated:YES];
        return;
    }
    
    @weakify(self);
    // 判断管理导航栏
    [self.bridge callHandler:@"naviAction" data:@"" responseCallback:^(NSString *responseData) {
        @strongify(self);
        _type =  [responseData integerValue];
        //type:1 按照历史记录返回 type:2 原生不做返回处理 type:3 关闭webView
        switch (_type) {
            case 1:
            {
                if ([self.webView canGoBack]) {
                    [self.webView goBack];
                }else{
                    [self goBack];
                }
            }
                break;
            case 2:
            {
                return ;
            }
                break;
            case 3:
            {
                [self goBack];
            }
                break;
                
            default:{
                
                if ([self.webView canGoBack]) {
                    [self.webView goBack];
                }else{
                    [self goBack];
                }
            }
                break;
            case 4:  // 关闭webView 并跳转到个人中心
            {
                [self goBack];
                self.tabBarController.selectedIndex = 3;
                self.tabBarController.tabBar.hidden = NO;
                
            }
                break;
            case 6:  // 关闭webView 并回到订单原生主页面
            {
//                [self goBack];
                [self backToOrder];
            }
                break;
        }
    }];
    
    _type = 0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(!_type){
            if([self.webView canGoBack]){
                [self.webView goBack];
            }else{
                [self goBack];
            }
        }else{
            return ;
        }
    });
}

/// 自定义右键点击
- (void)customRightItemClick:(UIButton *)sender {
    [self.bridge callHandler:@"rightNavItemClick" data:[NSNumber numberWithInteger:sender.tag] responseCallback:^(id responseData) {

    }];
}

- (void)goBack {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
  
    if(self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        // 出行优惠券走这里移除
        if(self.view.superview.tag == 999) {
            for (UIView *obj in self.view.superview.subviews) {
                [obj removeFromSuperview];
            }
            [self.view.superview removeFromSuperview];
          
        }
          [[self responder].navigationController popViewControllerAnimated:YES];
    }
}

- (void)showSharePopView {
    NSMutableArray *icons = [@[@"h5_微信",@"h5_朋友圈",@"h5_复制链接",@"h5_保存为图片",@"h5_社区"] mutableCopy];
    NSMutableArray *texts = [@[kLStr(@"share_wx_wx"), kLStr(@"share_wx_timeline") , kLStr(@"share_copy_link"), kLStr(@"share_save_image"), kLStr(@"share_community")] mutableCopy];

    if (NULLString(self.shareLinkStr)) {
        [icons removeObjectAtIndex:2];
        [texts removeObjectAtIndex:2];
    }

    if (!_haveShareCommunity) {
        [icons removeLastObject];
        [texts removeLastObject];
    }

    ShareMenu *share = [[ShareMenu alloc] initWithTopIcons:icons topTexts:texts];
    [share show];
    @weakify(self);
    share.tapItem = ^(NSIndexPath * _Nonnull indexPath) {
        @strongify(self);
        NSString *typeStr = texts[indexPath.item];
        if ([typeStr isEqualToString:kLStr(@"share_wx_wx")]) {
            [self selectWithShareType:ShareTypeWechat];
        }else if ([typeStr isEqualToString:kLStr(@"share_wx_timeline")]) {
            [self selectWithShareType:ShareTypeWechatFriend];
        }else if ([typeStr isEqualToString:kLStr(@"share_copy_link")]) {
            [self selectWithShareType:ShareTypeCopyLink];
        }else if ([typeStr isEqualToString:kLStr(@"share_save_image")]) {
            [self selectWithShareType:ShareTypeSaveLocal];
        }else if ([typeStr isEqualToString:kLStr(@"share_community")]) {
            [self selectWithShareType:ShareTypeCommunity];
        }
    };
}

#pragma mark 分享相关
- (void)selectWithShareType:(NSUInteger)shareType {
    if (shareType == ShareTypeCopyLink) {
        [self shareWithCopyLink:self.shareLinkStr];
        return;
    }
    else if(shareType  == ShareTypeCommunity)
    {
        [self sharePriceRatioToCommunity];
        return;
    }

    [ProgressHub showProgressWithStatus:kLStr(@"share_wait_image_create")];
    @weakify(self);
    [self.bridge callHandler:@"getWebSnapshot" data:nil responseCallback:^(id responseData) {
        @strongify(self);
        // 默认是当前网页的标题
        __block NSString *naviTitleStr = self.webView.title;
        NSString *qrImgUrlStr;
        NSString *webImgStr;
        //        NSString *base64ImgStr;

        __block UIImage *resultImg;
        //        __block UIImage *webImg;
        __block UIImage *qrImg;
        __block CGFloat captureHeight = 0.0;

        NSDictionary *responseDataDic;
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            responseDataDic = responseData;
            naviTitleStr = responseDataDic[@"title"];
            qrImgUrlStr = responseDataDic[@"url"];
            webImgStr = responseDataDic[@"img"];
            captureHeight = [responseDataDic[@"captureHeight"] floatValue];

        } else {
            webImgStr = responseData;
        }

        [self getWebImageFromResponseStr:webImgStr height:captureHeight success:^(UIImage *webShotImage) {
            @strongify(self);
            // 网页图片为空时则对当前截图
            if (!webShotImage) {
                webShotImage = [self screenShot];
                // 如果拿不到的返回的网页图片 标题就不用自己拼了
                naviTitleStr = nil;
            }

            UIImageView *qrImgView = [[UIImageView alloc]init];
            [qrImgView sd_setImageWithURL:[NSURL URLWithString:qrImgUrlStr] placeholderImage:[UIImage imageNamed:@"shareScreen2"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                @strongify(self);
                
                qrImg = qrImgView.image;

                // 二维码图片为空时则用默认图
                if (!qrImg) {
                    qrImg = [UIImage imageNamed:@"shareScreen2"];
                }

                // 拼接
                NSString *shareTipStr = [NSString stringWithFormat:@"%@\n%@", kLStr(@"share_wx_long_pressed_qcode"), kLStr(@"share_wx_open_mtfy_")];
                resultImg = [webShotImage combineLongWebImage:qrImg bottomText:shareTipStr title:naviTitleStr];

                [ProgressHub dismiss];

                [self shareWithType:shareType shareImage:resultImg];
            }];

            //完成截图通知前端
            [self.bridge callHandler:@"endSnapshot" data:nil responseCallback:^(id responseData) {
                NSLog(@"endSnapshot call data = %@",responseData);
            }];
        }];
    }];
}

- (void)sharePriceRatioToCommunity
{
    if (![User sharedInstance].token) {
        [[LoginManager sharedInstance]login:^(NSInteger result) {

        }];
        return;
    }
    if(!self.communityModel)
    {
        return;
    }
    
    double maxPrice = 0;
    double minPrice;
    NSArray *plaArray = [NSArray array];
    if([self.shareJson[@"typeFrom"] isEqualToString:@"FLIGHT"])
    {
         NSDictionary *dic = self.shareJson[@"content"];
        plaArray = dic[@"contentList"];
    }
    else
    {
        NSDictionary *dic = self.shareJson[@"content"];
        plaArray = dic[@"contentList"];
    }
    
    if(self.communityModel.content.contentList.count > 1)
    {
        // 最大
      NSDictionary *maxPlat = plaArray.lastObject;
      maxPrice = [[maxPlat objectForKey:@"platformPrice"] doubleValue];
        // 最小
        NSDictionary *minPlat = plaArray.firstObject;
        minPrice = [[minPlat objectForKey:@"platformPrice"] doubleValue];
        
    }
    else {
         NSDictionary *minPlat = plaArray.firstObject;
             maxPrice = [[minPlat objectForKey:@"platformPrice"] doubleValue];
        minPrice = [[minPlat objectForKey:@"platformPrice"] doubleValue];
    }

    NSString *md5String = [NSString stringWithFormat:@"%@:%f:%f",[User sharedInstance].userId,maxPrice,minPrice];
    NSString *sign = [md5String md5].lowercaseString;
    
    NSDictionary *dic = @{
                          @"businessType":[self.shareJson objectForKey:@"typeFrom"],
                          @"content" : [self.shareJson objectForKey:@"content"],
                          @"imgUrl":[self.shareJson objectForKey:@"url"],
                          @"sign":sign
                          };
    [RequestManager sharePriceSpreadToCommunityWithParameter:dic
                                                     Success:^(id  _Nonnull data) {
                                                         [self.view makeToast:data duration:1 position:CSToastPositionCenter];
                                                     } fail:^(id  _Nonnull message) {
                                                         [self.view makeToast:message duration:5 position:CSToastPositionCenter];
                                                     }];
}

- (void)screenShotWebView{
    //再需要截图的地方调用此方法
    @weakify(self);
    [self.webView shotScreenContentScrollCapture:^(UIImage *screenShotImage) {
        @strongify(self);
        [self showSnapShotImage:screenShotImage];
    }];
}

// 显示长截图
- (void)showSnapShotImage:(UIImage *)img{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 100, kMTFYScreenW-100, kMTFYScreenH-150)];
    scroll.scrollEnabled = YES;
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [scroll addSubview:imgView];
    scroll.contentSize = imgView.size;
    [self.view addSubview:scroll];
    
    UIButton *btn = [UIButton button];
    btn.frame = CGRectMake(0, 0, 50, 50);
    btn.backgroundColor = UIColor.orangeColor;
    [btn setOkaTitle:@"delete"];
    [btn addTarget:self action:@selector(deleteSnapShot:)];
    [scroll addSubview:btn];
}

- (void)deleteSnapShot:(UIButton *)sender{
    [sender.superview removeFromSuperview];
}

/* 分享小程序 */
- (void)shareProgram:(id)sender {
    // 分享
    NSArray *menus = @[kLStr(@"share_wx_applet")];
    PopOverVieConfiguration *config = [PopOverVieConfiguration new];
    config.triAngelHeight = 5.0;
    config.triAngelWidth = 7.0;
    config.containerViewCornerRadius = 3.0;
    config.roundMargin = 2.0;
    config.showSpace = 0;
    config.defaultRowHeight = 44;
    config.tableBackgroundColor = [UIColor whiteColor];
    config.textColor = [UIColor blackColor];
    config.font = [UIFont systemFontOfSize:15];
    
    CustomPopOverView *pView = [[CustomPopOverView alloc]initWithBounds:CGRectMake(0, 0, KMainScreenWidth/2, config.defaultRowHeight*menus.count) titleMenus:menus config:config];
    pView.containerBackgroudColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    pView.delegate = self;
    [pView showFrom:sender alignStyle:CPAlignStyleRight];//这个黑体部分，注意你要传入sender
}

/* 跳酒店地图 */
- (void)pushToMapVC {
    @weakify(self);
    [self.bridge callHandler:@"sendListConditions" data:nil responseCallback:^(id responseData) {
        @strongify(self);
        if (!responseData) return;
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:responseData];
        if (!dict) return;
        HotelListParaModel *model = [HotelListParaModel mj_objectWithKeyValues:dict];
        // 地图
        //        [SVProgressHUD showInfoWithStatus:@"正在为您搜索..."];
        MapViewController *vc = [[UIStoryboard storyboardWithName:@"Map" bundle:nil] instantiateInitialViewController];
        vc.hotelListParaModel = model;
        [[self responder].navigationController pushViewController:vc animated:YES];
    }];
}

/* 跳电影票地图 */
- (void)pushToCinimaMapVC {
    @weakify(self);
    [self.bridge callHandler:@"sendListConditions" data:nil responseCallback:^(id responseData) {
        @strongify(self);
        if (!responseData) return;
        NSDictionary *dict = [NSDictionary dictionaryWithJsonString:responseData];
        if (!dict) return;
        MovieMapVCModel *model = [MovieMapVCModel mj_objectWithKeyValues:dict];
        MovieMapViewController *vc = [[MovieMapViewController alloc] init];
        
        vc.movie_id = model.movie_id;
        vc.movie_name = model.movie_name;
        vc.drupPath = model.drupPath;
        vc.cityLocation = CLLocationCoordinate2DMake(model.city_lat, model.city_lng);
        [[self responder].navigationController pushViewController:vc animated:YES];
    }];
}

/* 跳转到出行 */
- (void)toTripActivity {
    TravelViewController *vc = [TravelViewController storyboardInitialWithName:@"Travel"];
    [[self responder].navigationController pushViewController:vc animated:YES];
}

/* 返回订单界面 */
- (void)backToOrder {
    self.tabBarController.selectedIndex = 2;
    self.tabBarController.tabBar.hidden = NO;
    
    UINavigationController *nav = self.tabBarController.viewControllers[1];
    OrderBaseViewController *orderVC = nav.viewControllers.firstObject;
    if ([orderVC isKindOfClass:[OrderBaseViewController class]]) {
        [orderVC selectFirstTab];
    }
    [[self responder].navigationController popToRootViewControllerAnimated:NO];
}

/* 拉新抢红包分享弹窗 */
- (void)showSharePanel {
    /* 助力拉新红包 */
    /* 比码 */
    if (self.shareActivityType == WebViewShareActivityTypeUserRedPacket ||
        self.shareActivityType == WebViewShareActivityTypePriceContest) {
        @weakify(self);
        [WebViewViewModel getShareData:self.bridge type:self.shareActivityType success:^(WebViewShareActivityType type, NSDictionary * _Nonnull dict) {
            @strongify(self);
            [self showShareView:dict type:self.shareActivityType];
        }];
    }
}


/* 显示分享弹窗 */
- (void)showShareView:(NSDictionary *)dict type:(WebViewShareActivityType)type {
    NSString *title = dict[@"title"];
    NSString *content = dict[@"content"];
    NSString *url = dict[@"url"];
    NSString *imgUrl = dict[@"imgUrl"];
    NSString *pathUrl = dict[@"pathUrl"];
    if (type == WebViewShareActivityTypeUserRedPacket ||
        type == WebViewShareActivityTypePriceContest) {
        // 显示助力红包分享弹窗
        [[ShareUserHBView xibView] shareViewWithTitle:title content:content pathUrl:pathUrl image:imgUrl url:url clickHandle:^(NSInteger index) {
            // 分享点击埋点
            [WebViewViewModel setShareActionDataWithBridge:self.bridge type:type index:index responseCallback:^(id  _Nonnull responseData) {
                
            }];
            // 分享拉新红包分享埋点
            if (type == WebViewShareActivityTypeUserRedPacket) {
                NSDictionary *dict = [url mtfy_getURLParameters];
                NSString *activityId = dict[@"activityId"];
                if (!NULLString(activityId)) {
                    [MTFYBuriedPointActivity bp_redPkgShareActivity:activityId];
                }
            }
        } success:^{
            NSLog(@"分享成功------->");
        } fail:^{
            NSLog(@"分享失败------->");
        }];
    }
}


#pragma mark - Delegate
#pragma mark WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = NO;
    NSString *urlString = [webView.URL absoluteString];
    if([urlString containsString:@"tel:"]){
        [self callPhone:urlString];
    }
    
    if ([[webView.URL absoluteString] containsString:@"weixin://"]) {
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:webView.URL];
        //先判断是否能打开该url
        if (canOpen) {   //打开微信
            [[UIApplication sharedApplication] openURL:webView.URL];
        }
    }
}

/// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [SVProgressHUD dismiss];
    [self OC2JS];
    self.progressView.hidden = YES;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
}

/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [SVProgressHUD dismiss];
    self.progressView.hidden = YES;
}

/// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    [self OC2JS];
    //    [self JS2OC];
}

/// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

/// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    [self.progressView setProgress:0 animated:NO];
    self.progressView.hidden = YES;

    // 取消语音
    [self cancelSpeech];

    BOOL isIntercepted = [[AlipaySDK defaultService] payInterceptorWithUrl:navigationAction.request.URL.absoluteString fromScheme:@"endlessgo" callback:^(NSDictionary *result) {
        // 处理支付结果
        NSLog(@"支付结果%@  --跳转url : %@", result,result[@"returnUrl"]);
        // isProcessUrlPay 代表 支付宝已经处理该URL
        if ([result[@"isProcessUrlPay"] boolValue]) {
            // returnUrl 代表 第三方App需要跳转的成功页URL
            NSString* urlStr = result[@"returnUrl"];
            switch ([result [@"resultCode"]  integerValue]) {
                case 9000:   // 支付成功
                {
                    NSLog(@"支付成功");
                    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
                }
                    break;
                case 6001:   // 用户取消操作
                {
                    NSLog(@"用户取消操作");
              
                }
                    break;
                case 8000:   // 正在处理中
                {
                    NSLog(@"正在处理中");
                    
                }
                    break;
                case 4000:   // 订单支付失败
                {
                    NSLog(@"订单支付失败");
                    
                }
                    break;
                case 5000:   // 重复请求
                {
                    NSLog(@"重复请求");
                    if ([self.webView canGoBack]) {
                        [self.webView goBack];
                    }
                }
                    break;
                case 6002:   // 网络连接出错
                {
                    NSLog(@"网络连接出错");
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
    }];
    
    if (isIntercepted) {
        //    不允许跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        //允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    if ([webView.URL.absoluteString containsString:@"Choose"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameWebURL object:webView.URL.absoluteString];
    }
    
    if ([webView.URL.absoluteString containsString:@"95516"]) {
        _closeButton.hidden = NO;
    }else{
        _closeButton.hidden = YES;
    }
    
    [self OC2JS];
    
    WebViewJavascriptBridgeBase *base = [[WebViewJavascriptBridgeBase alloc] init];
    if ([base isWebViewJavascriptBridgeURL:navigationAction.request.URL]) {
        return;
    }
}

#pragma mark WKNavigationDelegate

// 4 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [self.webView reload];
}

#pragma mark WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    return [[WKWebView alloc]init];
}

#pragma mark WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kLStr(@"common_alert_tip") message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:kLStr(@"common_alert_confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kLStr(@"common_alert_tip") message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:kLStr(@"common_alert_cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:kLStr(@"common_alert_confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:kLStr(@"common_alert_finish") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark CustomPopOverViewDelegate
- (void)popOverView:(CustomPopOverView *)pView didClickMenuIndex:(NSInteger)index{
    [pView dismiss];
    if (self.webTitleName && [self.webTitleName isKindOfClass:[NSDictionary class]]) {
        int type = [self.webTitleName[@"type"] intValue];
        [ShareUtils shareMiniProgramWithType:type];
    }else{
        [ShareUtils shareMiniProgramWithType:TravelTypeNone];
    }
}

#pragma mark - Private
#pragma mark OC与JS交互

/**
 OC  调用  JS
 */
- (void)OC2JS {
    /*
     含义：OC调用JS
     @param callHandler 商定的事件名称,用来调用网页里面相应的事件实现
     @param data id类型,相当于我们函数中的参数,向网页传递函数执行需要的参数
     注意，这里callHandler分3种，根据需不需要传参数和需不需要后台返回执行结果来决定用哪个
     */
    NSString *token = [User sharedInstance].token;
    NSString *localToken = [[NSUserDefaults standardUserDefaults] objectForKey:kMatafyToken];
    @weakify(self);
    // 有token
    if (!NULLString(token)) {
        [self.bridge callHandler:@"sendToken" data:token responseCallback:^(id responseData) {
            NSLog(@"已经传了 token:%@",token);
        }];
    }
    // 已经登录, 等新token回来
    else if (!NULLString(localToken)) {
        [[[NSNotificationCenter.defaultCenter rac_addObserverForName:kNotificationNameTokenRefresh object:nil]
        takeUntil:[self rac_willDeallocSignal]]
        subscribeNext:^(id x) {
             @strongify(self);
            NSString *refreshToken = [User sharedInstance].token;
             [self.bridge callHandler:@"sendToken" data:refreshToken responseCallback:^(id responseData) {
     NSLog(@"已经传了 token:%@",token);
             }];
         }];
    }
    // 无token
    else {
        [self.bridge callHandler:@"sendToken" data:token responseCallback:^(id responseData) {

        }];
    }
    
    // 传城市给js
    NSString  *city = [[NSUserDefaults standardUserDefaults]objectForKey:@"city"];
    if ([city containsString:@"市"]) {
        NSRange range = [city rangeOfString:@"市"];//匹配得到的下标
        city = [city substringToIndex:range.location];//截取范围类的字符串
    }
    
    city = NULLString(city) == YES ? (User.sharedInstance.city?:@"") : city;
    // 传city
    [self.bridge callHandler:@"localCity" data:city responseCallback:^(id responseData) {
        
    }];
    
    // 传city lat lon new


    NSDictionary *newdata = @{
                              @"city":city?city:@"",
                              @"lat" : [NSString stringWithFormat:@"%f", [User sharedInstance].currentCoordinate.latitude],
                              @"lon" : [NSString stringWithFormat:@"%f", [User sharedInstance].currentCoordinate.longitude]
                              };
    
    [self.bridge callHandler:@"newlocalCity" data:newdata responseCallback:^(id responseData) {
        
    }];
    
    /**
     *  传版本号
     */
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [self.bridge callHandler:@"sendVersion" data:app_Version responseCallback:^(id responseData) {
        
    }];

    // 选择优惠券
    NSString *selectJson = !self.selecCouponJsonStr ? @"" : self.selecCouponJsonStr;
    [self.bridge callHandler:@"selectCoupon" data:selectJson  responseCallback:^(id responseData) {

    }];

    // 单次定位发送setGpsLocation
    [self requestSingleLocation];

    // 传递登录信息
    [self setUserName2JS];
}




#pragma mark JS2OC
/**
 *  JS 调用OC
 */
- (void)JS2OC {
    
    
    @weakify(self);
    
    // 医美跳转
      [self.bridge registerHandler:@"openMedicalIntroduceView" handler:^(NSString *data, WVJBResponseCallback responseCallback) {
        @strongify(self);
          
          NSDictionary *json =  [data mj_JSONObject];
          BeautyPagesListContentModel *model = [BeautyPagesListContentModel mj_objectWithKeyValues:json];
          
          if(!model) {
              return;
          }
          // 视频
          if (model.is_video)
          {
              BeautyVideoListViewController *vc = [BeautyVideoListViewController new];
              vc.model = model;
              [vc dismissBlock:^{
                  [[RedPacketShareUserView shareInstance] show];
              }];
              [[self responder].navigationController pushViewController:vc animated:YES];
          } else {
              NSString *articleType = model.article_type;
              // 日记
              if ([articleType isEqualToString:BeautyArticleTypeDiary]) {
                  BeautyDiaryViewController *vc = [BeautyDiaryViewController new];
                  vc.model = model;
                  [vc dismissBlock:^{
                      [[RedPacketShareUserView shareInstance] show];
                  }];
                  [[self responder].navigationController pushViewController:vc animated:YES];
              }
              // 文章和问答
              else {
                  BeautyContentViewController *vc = [BeautyContentViewController new];
                  vc.model = model;
                  [vc dismissBlock:^{
                      [[RedPacketShareUserView shareInstance] show];
                  }];
                  [[self responder].navigationController pushViewController:vc animated:YES];
              }
          }
          [[RedPacketShareUserView shareInstance] hide];
      }];
    
    
    // 出行项目获取常用联系人数据
    [self.bridge registerHandler:@"carhailingPickeUserData" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSLog(@"data:%@",data);
        if(self.getLinkManData)
        {
            self.getLinkManData(data);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    // 自动关闭返回出行页面
    [self.bridge registerHandler:@"payCallbackToApp" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSLog(@"点击了查看订单");
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"payCallbackToAppNC" object:@(_isBackAction == YES?0:1)];
    }];
    
    // 调用分享页
    [self.bridge registerHandler:@"toIntentShareUI" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSLog(@"toIntentShareUI");
        [self showSharePopView];
    }];


    // 自动关闭返回出行页面
    [self.bridge registerHandler:@"openCarTaking" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        [self goBack];
        responseCallback(nil);
    }];
    

    [self.bridge registerHandler:@"shareCommunity" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
//        NSLog(@"shareCommunity:%zd",[[data objectForKey:@"isVisibility"] integerValue]);
        if([[data objectForKey:@"isVisibility"] integerValue] == 0)
        {
            _haveShareCommunity = NO;
            return ;
        }
        else
        {
            _haveShareCommunity = YES;
        }
        // 转 json
        NSString *jsonStr = [data objectForKey:@"content"];
        // 无数据时 return
        if (!jsonStr)
        {
            return;
        }
        NSData *json_data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];

        NSDictionary *tempDictQueryDiamond = [NSJSONSerialization JSONObjectWithData:json_data options:0 error:nil];
        // 不可变转可变
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:tempDictQueryDiamond];
        NSMutableArray *contentList = [NSMutableArray arrayWithCapacity:0];
        [contentList addObjectsFromArray:[tempDictQueryDiamond objectForKey:@"contentApiList"]];
        [contentList addObjectsFromArray:[tempDictQueryDiamond objectForKey:@"contentCrawlList"]];

        [params setObject:contentList forKey:@"contentList"];
        [params removeObjectForKey:@"contentApiList"];
        [params removeObjectForKey:@"contentCrawlList"];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:data];

        if([[data objectForKey:@"typeFrom"] isEqualToString:@"FLIGHT"])
        {
        NSArray *fligthList = [tempDictQueryDiamond objectForKey:@"flightList"];
        [params setObject:fligthList forKey:@"flightList"];
        }
        [dict setObject:params forKey:@"content"];
       NSArray *costOffArray =   [params objectForKey:@"contentList"];
        costOffArray = [self sortASCDictionaryArray:costOffArray withKey:@"platformPrice" ascending:YES];
        double costOff;
        if(costOffArray.count > 1)
        {
            NSDictionary *dict_1 =  costOffArray.lastObject;
            NSDictionary *dict_2 =  costOffArray.firstObject;
            costOff = [[dict_1 objectForKey:@"platformPrice"] doubleValue] -  [[dict_2 objectForKey:@"platformPrice"] doubleValue];
        }
        else
        {
            costOff = 0;
        }
        [params removeObjectForKey:@"contentList"];
        [params setObject:costOffArray forKey:@"contentList"];
        [params setObject:@(costOff) forKey:@"costOff"];
        if([[data objectForKey:@"typeFrom"] isEqualToString:@"HOTEL"])
        {
            if ([dict objectForKey:@"url"]) {
                NSArray *urls = [NSArray arrayWithObject:[dict objectForKey:@"url"]];
                [params setObject:urls forKey:@"urls"];
            }
        }
        
       ShareCommunityModel *model =  [ShareCommunityModel mj_objectWithKeyValues:dict];
        NSMutableArray *arrM = [PlatformContentList mj_objectArrayWithKeyValuesArray:model.content.contentList];
        model.content.contentList = arrM;
        self.communityModel = model;
        self.shareJson = dict;
        
    }];

    // 获取equipmentID
    [self.bridge registerHandler:@"getEquipmentID" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js方法获取equipmentID = %@",EID);
        responseCallback(EID);
    }];
    
    // 获取token
    [self.bridge registerHandler:@"getToken" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *token = [User sharedInstance].token;
        NSLog(@"js方法获取token = %@",token);
        responseCallback(token);
    }];
    
    // 获取版本号
    [self.bridge registerHandler:@"getAppVersionAndToken" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js方法获取版本号");
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString *token = [User sharedInstance].token;
        responseCallback(@{@"version":app_Version, @"token":token});
    }];
    
    // 获取当前语言
    [self.bridge registerHandler:@"getLanguage" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"获取当前语言");
         NSString *language = [kMTFYMultiLanguageModule modCurLanguageSourcePathName];
        if (!language) {
            language = [NSLocale preferredLanguages].firstObject;
        }
        responseCallback(@{@"language":language});
    }];


    // 跳转导航(传百度系坐标)
    [self.bridge registerHandler:@"navigationToMap" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        /**
         *  设置导航线路  参数lat lon city
         */
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([[data objectForKey:@"lat" ] floatValue], [[data objectForKey:@"lon" ] floatValue]);
        NSString *name = [data objectForKey:@"title"];
        [AlertSheetNavigateView showAndNavigateWithToCoordinate:loc toName:name actionHandle:^(BOOL success, NSString * _Nullable title) {
            if (responseCallback) {
                responseCallback(@{@"success":@(success)});
            }
        } cancelHandle:nil];
    }];


    // 跳转浏览器
    [self.bridge registerHandler:@"toExternalBrowsers" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSLog(@"js方法跳转浏览器");
        NSString *urlString = [data objectForKey:@"url"];
        if(![urlString containsString:@"#"]) {
            NSString *encodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            SafariViewController *vc = [[SafariViewController alloc] initWithURL:[NSURL URLWithString:encodedString]];
            [self.responder presentViewController:vc animated:YES completion:^{
                
            }];
        } else {
            NSRange range = [urlString rangeOfString:@"#"];//匹配得到的下标
            // 修复闪退
            if (range.location + 2 > urlString.length) {
                [UIWindow showTips:@"地址错误,请稍后再试"];
                return;
            }
            NSString *str1 = [urlString substringToIndex:range.location+2];
            NSString *str2 = [urlString substringFromIndex:range.location+2];//截取掉下标#之后的字符串
            NSString *encodedString = [str2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *string = [str1 stringByAppendingString:encodedString];
            SafariViewController *vc = [[SafariViewController alloc] initWithURL:[NSURL URLWithString:string]];
            
            [self.responder presentViewController:vc animated:YES completion:^{
                
            }];
        }
    }];
    
    // 登录
    [self.bridge registerHandler:@"loginAction" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSString *url = [data objectForKey:@"url"];
        if ([User sharedInstance].userId.length > 0) {
            NSString *token = [User sharedInstance].token;
            [self.bridge callHandler:@"sendToken" data:token responseCallback:^(id responseData) {
            }];
            responseCallback(token);
            return;
        } else {
            @weakify(self);
            [[LoginManager sharedInstance] login:^(NSInteger result) {
                @strongify(self);
                /**
                 *  登录成功后 传值token
                 */
                NSString *token = [User sharedInstance].token;
                [self.bridge callHandler:@"sendToken" data:token responseCallback:^(id responseData) {
                }];
                if (!NULLString(url)) {
                    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                }
            } escape:^{
                // 未登录
                [self loginCancel2JS];
            }];
        }
    }];
    
    //关闭webView
    [self.bridge registerHandler:@"closeWebView" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        [self goBack];
//        [[self responder].navigationController popViewControllerAnimated:YES];

    }];
    
    // 是否显示导航栏  方法名:iOSShowNavBar
    // 1 显示  0不显示
    [self.bridge registerHandler:@"iOSShowNavBar" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSInteger i = [[data objectForKey:@"show"] integerValue] ;
        NSLog(@"导航栏显示:%zd",i);
        [self showNavBarWithType:i];
    }];
    
    // 是否显示导航栏标题  方法名:iOSShowNaviTitle
    // 1 显示 0 不显示
    
    [self.bridge registerHandler:@"iOSShowNaviTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSInteger i = [[data objectForKey:@"show"] integerValue] ;
        switch (i) {
            case 0: {
                self.title_label.hidden = YES;
            }
                break;
            case 1: {
                self.title_label.hidden = NO;
            }
                break;
            default:
                break;
        }
    }];
    
    // 什么都不显示
    // show: 1 显示 0 不显示
    [self.bridge registerHandler:@"showEmpty" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSInteger i = [[data objectForKey:@"show"] integerValue];
        [self showEmptyWithType:i];
    }];
    
    // 导航栏颜色透明度 方法名:iOSNaviBarBGColorAndAlpha
    // 背景颜色: bgcolor(NSString) : 十六进制  透明度: alpha(float) : 0~1  1表示不透明  0 表示完全透明
    [self.bridge registerHandler:@"iOSNaviBarBGColorAndAlpha" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        [self configNaviBarBgColorAlpha:data];
    }];
    
    // 页面标题颜色、字重、字体大小 方法名:iOSNaviBarTitleAttributr
    // 标题颜色:titleColor(NSString ) : 十六进制  字重: titleStyle (NSString)  字体大小: titleFont (float)
    [self.bridge registerHandler:@"iOSNaviBarTitleAttribute" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        float font = [[data objectForKey:@"titleFont"] floatValue];
        NSInteger titleBold =  [[data objectForKey:@"isBold"] integerValue];
        
        if(titleBold){
            self.title_label.font = [UIFont boldSystemFontOfSize:font];
        } else {
            self.title_label.font =Font(font);
        }
        
        self.title_label.textColor = [UIColor colorWithHexString:[data objectForKey:@"titleColor"]]; // 字体颜色
    }];
    
    // 是否展示状态栏  方法名: iOSShowStatusBar
    // 1 展示状态栏  0 不展示状态栏
    [self.bridge registerHandler:@"iOSShowStatusBar" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSInteger i = [[data objectForKey:@"show"] integerValue] ;
        
        i = 0;
        NSLog(@"状态栏显示:%zd",i);
        switch (i) {
            case 0: {
                [[UIApplication sharedApplication] setStatusBarHidden:YES];
            }
                break;
            case 1: {
                [[UIApplication sharedApplication] setStatusBarHidden:NO];
            }
                break;
            default:
                break;
        }
    }];
    
    
    [self.bridge registerHandler:@"iOSShare" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dict = data;
        NSString *title = dict[@"title"];
        NSString *url = dict[@"url"];
        
        // 异步获取UIimage
        __block UIImage *image = [UIImage imageNamed:@"app_logo"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"image"]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                image = [UIImage imageWithData:imgData];
            });
        });
        
        // 等待2秒,没加载出来image就直接用app_logo
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ShareView share:title text:title image:image url:url success:^(id data) {
                
            } fail:^(id data) {
                
            }];
        });
    }];
    
    // 显示酒店地图按钮(老版本在用, 不推荐继续使用)
    [self.bridge registerHandler:@"SetHotelMap" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        [self configPushToHotelMap:data];
        responseCallback(@"push to map 方法调用");
    }];
    
    // 通用显示导航栏地图按钮(推荐使用)
    [self.bridge registerHandler:@"setSelectMapVisibility" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        BOOL isShow = [data[@"isVisibility"] boolValue];
        //fromType: 1 酒店地图, 2 电影票地图
        NSInteger fromType = [data[@"fromType"] integerValue];
        if (isShow) {
            if (fromType == 1) {
                [self setRightItemButton:rightItemTypeHotelMap];
            } else if (fromType == 2) {
                [self setRightItemButton:rightItemTypeCinimaMap];
            }
        }
        responseCallback(@"push to cinima map 方法调用");
    }];


    //    void setWebHeight(int height);//设置首页高度
    [self.bridge registerHandler:@"setWebHeight" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSLog(@"setWebHeight = %@",data);
        int webHeight = [data[@"height"] intValue];
        self.webHeight = webHeight;
    }];
    
    //    void setWebFirst(boolean flag);//判断是否为首页，true为首页，false为非首页
    [self.bridge registerHandler:@"setWebFirst" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSLog(@"是app首页");
        self.webFirst = [data boolValue];
    }];
    
    //    void setWebTitleName(int type, String firstAdds, String endAdds);//type：类型（0；机票，1：酒店， 2：火车票）， firstAdds：起始位置，endAdds：目的地（酒店传日期）
    [self.bridge registerHandler:@"setWebTitleName" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSLog(@"setWebTitleName = %@",data);
        self.webTitleName = data;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameWebTitles object:data];
    }];
    
    // 判断是否安装微信
    [self.bridge registerHandler:@"isInstallWeixin" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"isInstallWeixin call : %@", data);
        BOOL isWXAppInstalled = [WXApi isWXAppInstalled];
        responseCallback(@(isWXAppInstalled));
    }];
    
    // 跳转到首页
    [self.bridge registerHandler:@"toMainActivity" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSLog(@"toMainActivity call : %@", data);
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [self currentVC].tabBarController.selectedIndex = 0;
        }];

        [[self responder].navigationController popToRootViewControllerAnimated:YES];

        [CATransaction commit];
    }];
    
    
    // 分享小程序 shareMiniProgram
    [self.bridge registerHandler:@"shareMiniProgram" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"shareMiniProgram call : %@", data);
        if (![data isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        [ShareUtils shareMiniProgramWithType:[data[@"type"] intValue] title:data[@"title"] imageUrl:data[@"imageUrl"]];
    }];
    
    // H5分享小程序 shareMiniProgram
    [self.bridge registerHandler:@"shareWeiXinMiniProgram" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"shareMiniProgram call : %@", data);
        if (![data isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSString *title = data[@"title"];
        NSString *imageUrl = data[@"imageUrl"];
        NSString *pathUrl = data[@"pathUrl"];
        NSString *webPageUrl = data[@"webPageUrl"];
        [ShareUtils shareMiniProgramWithTitle:title imageUrl:imageUrl pathUrl:pathUrl webPageuUrl:webPageUrl];
    }];
    
    // 保存图片
    [self.bridge registerHandler:@"savePhoto" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        //        NSLog(@"savePhoto call : %@", data);
        [SVProgressHUD showInfoWithStatus:kLStr(@"common_saving_tip")];
        NSString *base64 = [data objectForKey:@"photo"];
        NSString *b64 = [[base64 componentsSeparatedByString:@","] lastObject];
//        [NSString ]
        UIImage *img;
        if (NULLString(b64) || NULLString(base64) ) {
            img = [self screenShot];
        }else{
            img = [WebViewViewModel decodeBase64ToImage:b64];
        }
        
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
    
    // 请求定位
    [self.bridge registerHandler:@"requestGpsLocation" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
//        [self configRequestGpsLocation:data callback:responseCallback];
        BOOL isEnable = [LocationManager sharedManager].isLocationServiceEnable;
        if (!isEnable) {
            NSDictionary *sendData = @{@"location":@"",@"isGpsEnable":@(isEnable)};

            [self.bridge callHandler:@"setGpsLocation" data:sendData responseCallback:^(id responseData) {
                NSLog(@"setGpsLocation call data = %@",responseData);
            }];

            responseCallback(sendData);
            return;
        }

        [self requestSingleLocation];
    }];
    
    // Gps是否可用（权限与GPS开关判断）,true=gps可用，false=gps不可用
    [self.bridge registerHandler:@"isGpsEnable" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSLog(@"isGpsEnable call : %@", data);
        BOOL isEnable = [self isLocationServiceEnable];
        responseCallback(@(isEnable));
    }];
    
    // 通用显示分享按钮方法
    [self.bridge registerHandler:@"setVisibleShareBtn" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        responseCallback(nil);
        NSDictionary *dataDic = data;
        if ([dataDic isKindOfClass:[NSDictionary class]]) {
            BOOL isShowShare = [dataDic[@"flag"] boolValue];
            NSString *shareUrlStr = dataDic[@"urlStr"];
            // 4.3.7版本后添加"type"参数
            WebViewShareActivityType shareType = [dataDic[@"type"] integerValue];
            self.shareActivityType = shareType;
//            self.sharePopView.shareUrl = shareUrlStr;
            self.shareLinkStr = shareUrlStr;
            if (!self.rightItemShareScreen && isShowShare) {
                [self setRightItemButton:rightItemTypeShareScreen];
            }
            [self hideShareScreenButton:!isShowShare];
        }
    }];
    
    // 传设备DeviceId
    [self.bridge registerHandler:@"setDeviceId" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(EID);
    }];
    
    // 保存数据到缓存
    [self.bridge registerHandler:@"saveShareprefData" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dataDic = data;
        if ([dataDic isKindOfClass:[NSDictionary class]]) {
            for (id key in [dataDic allKeys]) {
                NSUserDefaults *useDefaults = [NSUserDefaults standardUserDefaults];
                [useDefaults setObject:[dataDic objectForKey:key] forKey:key];
                [useDefaults synchronize];
            }
        }
    }];
    
    // 获取缓存的数据
    [self.bridge registerHandler:@"getShareprefData" handler:^(id data, WVJBResponseCallback responseCallback) {
        id key = data;
        if (key) {
            id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
            responseCallback(value);
        }
    }];
    
    // 跳转出行
    [self.bridge registerHandler:@"toTripActivity" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        [self toTripActivity];
    }];
    
    // 隐藏加载窗
    [self.bridge registerHandler:@"hintLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        [SVProgressHUD dismiss];
    }];
    
    // 开启关闭全屏退出手势
    [self.bridge registerHandler:@"interactivePopDisabled" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        if (data) {
//            [self responder].zf_interactivePopDisabled = [data boolValue];
            [[self responder] interactivePopDisable:[data boolValue]];
        }
    }];

    // 设置自定义导航栏右键
    [self.bridge registerHandler:@"setRightNavItem" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        if (data) {
            // 参数:type, image,iconSize,title,color,fontName,fontSize
            [self setRightItemWith:data];
        }
    }];

    // 设置自定义返回按钮
    [self.bridge registerHandler:@"setBackItem" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        if (data) {
            // 参数:show, image
            [self setBackItem:data];
        }
    }];

    // 触发分享, 调起分享弹窗
    [self.bridge registerHandler:@"getShareData" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        if (data) {
            // 参数:type, image, title, url, imageUrl
            NSDictionary *dict = [NSDictionary dictionaryWithJsonString:data];
            [self showShareView:dict type:[dict[@"type"] integerValue]];
        }
    }];

    // 打电话
    [self.bridge registerHandler:@"callPhone" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        if (data) {
            [self callPhone:data];
        }
    }];
#pragma mark 语音识别相关
    // 开始录音
    [self.bridge registerHandler:@"startSpeechRecognizer" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSLog(@"收到录音请求");
        self.speechRecognizerCallback = responseCallback;
        [self.speechBoardView startListening:^(NSString * _Nullable result, NSString * _Nullable error) {
            NSDictionary *param = @{
                                    @"result": [NSString validStr:result],
                                    @"error": [NSString validStr:error]
                                    };
            if (responseCallback) {
                responseCallback(param);
            }
        }];
    }];

    // 开始识别
    [self.bridge registerHandler:@"startSpeechSynthesizer" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSLog(@"收到播放请求:%@", data);
        if (data) {
            self.speechSynthesizerCallback = responseCallback;
            NSString *title = @"";
            NSString *subtitle = @"";
            CGFloat bottomMargin = -1;

            if ([data isKindOfClass:[NSDictionary class]]) {
                    title = data[@"title"];
                    subtitle = data[@"subTitle"];

                    NSString *marginStr = data[@"margin"]; // 马踏飞面板距离屏幕的边距margin: 'null,null,50,null' (上, 右, 下, 左), 传null代表默认
                    if (!NULLString(marginStr) && [marginStr containsString:@","]) {
                        NSArray *margins = [marginStr componentsSeparatedByString:@","];
                        if (margins.count > 3) {
                            NSString *bottomMarginStr = margins[2];
                            if (!NULLString(bottomMarginStr) && ![bottomMarginStr isEqualToString:@"null"]) {
                                bottomMargin = [margins[2] floatValue];
                            }
                        }
                    }
            } else {
                title = [NSString stringWithFormat:@"%@", data];
            }

            [self.speechBoardView updateBottomMargin:bottomMargin];
            [self.speechBoardView startPlayingWithText:title subText:subtitle animate:YES synthesizer:YES complete:^(NSString * _Nullable result, NSString * _Nullable error) {
                NSDictionary *param = @{
                                        @"text": [NSString validStr:result],
                                        @"error": [NSString validStr:error]
                                        };
                if (responseCallback) {
                    responseCallback(param);
                }
            }];
        }
    }];

    // 关闭马踏飞
    [self.bridge registerHandler:@"HideSpeechBoard" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSLog(@"收到关闭马踏飞请求");
        [self.speechBoardView hide:^{
            if (responseCallback) {
                responseCallback(nil);
            }
        }];
    }];

    // 打开相机
    [self.bridge registerHandler:@"openCamera" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSLog(@"openPhotosAlbum");
        [self openCamera];
    }];

    // 打开相册
    [self.bridge registerHandler:@"openPhotosAlbum" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSLog(@"openPhotosAlbum");
        [self openPhotosAlbum];
    }];


    // 选择优惠券
    [self.bridge registerHandler:@"selectCoupon" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        [self.selectCouponSubject sendNext:data];
        [self.navigationController popViewControllerAnimated:YES];
    }];

    // 设备震动
    [self.bridge registerHandler:@"startVibrator" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"startVibrator");
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }];

    // 跳转租车地图
    [self.bridge registerHandler:@"openRentcarMap" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"openRentcarMap");
        @strongify(self);
        if (data) {
            NSDictionary *dict = [NSDictionary dictionaryWithJsonString:data[@"param"]];
            CarMapViewController *map = [[CarMapViewController alloc] init];
            map.param = dict;
            [self.navigationController pushViewController:map animated:YES];
        }
    }];

    // 传递用户信息
    [self.bridge registerHandler:@"getUserName" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        if ([User sharedInstance].token.length > 0) {
//            [self setUserName2JS];
            NSMutableDictionary *dict = [[User sharedInstance].user mj_keyValuesWithIgnoredKeys:@[@"currentCoordinate"]];
            responseCallback(dict);
            return;
        } else {
            @weakify(self);
            [[LoginManager sharedInstance] login:^(NSInteger result) {
                @strongify(self);
                // 登录成功
                [self setUserName2JS];
            } escape:^{
                // 未登录
                [self loginCancel2JS];
            }];
        }
    }];
    
    // 打开微信小程序
    [self.bridge registerHandler:@"openWXMiniProgram" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"打开微信小程序 path = %@",data);
        [MainViewModel pushToWxMiniWithPath:data completeHandle:^(BOOL success) {
            if (!success) {
                [UIWindow showTips:[NSString stringWithFormat:@"打开微信小程序失败 %@",data]];
            }
        }];
    }];
    
    // H5 通知app 刷新订单
    [self.bridge registerHandler:@"updateOrderStatus" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSLog(@"updateOrderStatus is call");
        self.progressView.hidden = YES;
        OrderBaseViewController *vc = (OrderBaseViewController *)self.navigationController.viewControllers.firstObject;
        if ([vc isKindOfClass:[OrderBaseViewController class]]) {
            // 设置标记fromWeb
            for (OrderListBaseViewController *childVC in vc.myChildViewControllers) {
                if ([childVC isViewLoaded]) {
                    childVC.fromWeb = NO;
                }
            }
        }
    }];

    // 打开全屏图片浏览
    [self.bridge registerHandler:@"openNativePicture" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        if (!data) { return; }
        NSArray *jsonStrArr = data[@"pictureList"];
        NSString *titleStr = data[@"titleStr"];
        NSInteger index = [data[@"position"] integerValue];
        if (![jsonStrArr isKindOfClass:[NSArray class]] || !jsonStrArr.count) { return;}
        if (index >= jsonStrArr.count) { index = jsonStrArr.count - 1; }
        if (index < 0) { index = 0; }
        [MTFYPhotoBrowser browserWithImages:jsonStrArr sourceView:nil currentIndex:index title:titleStr fromVC:self];
    }];
    
    // H5 通知app 刷新订单
    [self.bridge registerHandler:@"toNativeCar" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSLog(@"toNativeCar is call");
        
        NSString *mapType = data[@"mapType"];
        NSString *destLatitude = data[@"destLatitude"];
        NSString *destLongitude = data[@"destLongitude"];
        NSString *destName = data[@"destName"];
        NSString *destCity = data[@"destCity"];
        NSLog(@"%@,%@,%@,%@,%@",mapType,destLatitude,destLongitude,destName,destCity);
        // 出行 travel
        TravelViewController *vc = [TravelViewController storyboardInitialWithName:@"Travel"];
        vc.arrival = destName;
        vc.mapType = mapType;
        vc.arrivalCoor = CLLocationCoordinate2DMake(destLatitude.doubleValue, destLongitude.doubleValue);
        [[self responder].navigationController pushViewController:vc animated:YES];
    }];
    
    /// H5调用原生返回处理
    [self.bridge registerHandler:@"goBackToNative" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSNumber *type = (NSNumber *)data;
        switch (type.integerValue) {
            case 0: {
                if ([self.webView canGoBack]) {
                    [self.webView goBack];
                }else{
                    [self goBack];
                }
            }
                break;
                // 关闭webView 并回到订单原生主页面
            case 1: {
                [self backToOrder];
            }
                break;
            default:
                break;
        }
    }];
    
    /// 显示客服按钮
    [self.bridge registerHandler:@"setNativeHelpVisible" handler:^(id data, WVJBResponseCallback responseCallback) {
        BOOL isShow = [data[@"flag"] boolValue];
        if (isShow) {
            [self setRightItemButton:rightItemTypeHelpService];
        } else {
            if (_rightItemHelpService) {
                [_rightItemHelpService removeFromSuperview];
                _rightItemHelpService = nil;
            }
        }
        responseCallback(@"setNativeHelpVisible 方法调用");
    }];
    
    /// 邀请拉新
//    private Integer type;//0：微信，1：短信，2：QQ
//    private String content;//复制分享出去的内容
//    private boolean isCopy;// true:需要复制，false:不需要
    [self.bridge registerHandler:@"openActivityCopy" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"openActivityCopy = %@",data);
        // 微信
        int type = [data[@"type"] intValue];
        NSString *content = data[@"content"];
        BOOL isCopy = [data[@"isCopy"] boolValue];
        
        if (isCopy) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = content;
        }
        
        NSURL *url;
        if (type == 0) {
            url = [NSURL URLWithString:@"weixin://"];
        }else if (type == 1) {
            url = [NSURL URLWithString:@"sms://"];
        }else if (type == 2) {
            url = [NSURL URLWithString:@"mqqapi://"];
        }
        if ([UIApplication.sharedApplication canOpenURL:url]) {
            [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil];
        }else{
            Toast(@"您还未安装应用");
        }
        
        responseCallback(@"openActivityCopy 方法调用");
    }];
}

- (void)showNavBarWithType:(NSInteger)showType {
    switch (showType) {
        case 0: {
            _naviView.hidden = YES;
            _naviView.frame =  CGRectMake(0, 0, self.view.bounds.size.width, 0);
            _backButton.hidden = NO;
            [self.view bringSubviewToFront:_backButton];
            if(KIsiPhoneX){
                [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(-20);
                    make.left.right.bottom.mas_equalTo(self.view);
                }];
            }else{
                [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    //                    make.edges.equalTo(self.view);
                    make.left.right.bottom.mas_equalTo(self.view);
                    make.top.mas_equalTo(self.view.mas_top).offset(0);
                }];
            }
        }
            break;
        case 1: {
            _naviView.hidden = NO;
            _backButton.hidden = YES;
            if (IS_iPhoneX_Series) {
                CGFloat bottomInset = [self.url containsString:@"Choose"] ? 0 : 34;
                _naviView.frame =  CGRectMake(0, 0, self.view.bounds.size.width, 88);
                [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.view);
                    make.left.mas_equalTo(self.view);
                    make.bottom.mas_equalTo(-bottomInset);
                    make.top.mas_equalTo(_naviView.mas_bottom).offset(-1);
                }];
                
            } else {
                _naviView.frame =  CGRectMake(0, 0, self.view.bounds.size.width, 64);
                [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.view);
                    make.left.mas_equalTo(self.view);
                    make.bottom.mas_equalTo(self.view);
                    make.top.mas_equalTo(_naviView.mas_bottom).offset(-1);
                }];
            }
        }
            break;
        default:
            break;
    }
}

- (void)showEmptyWithType:(NSInteger)showType {
    switch (showType) {
        case 0:{
            _naviView.hidden = YES;
            _backButton.hidden = YES;
            [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
        }
            break;
        case 1: {
            _naviView.hidden = NO;
            _backButton.hidden = NO;
            [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(self.view);
                make.top.mas_equalTo(self.view).offset(63);
            }];
        }
            break;
        default:
            break;
    }
}

- (void)configNaviBarBgColorAlpha:(NSDictionary *)data {
    id bgcolor = [data objectForKey:@"bgcolor"];
    if (!bgcolor || [bgcolor isEqualToString:@"#ffffff"]) {
        [_backButton setImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateNormal];
        _backButton.hidden = NO;

        if (_rightItemMap) {
            [_rightItemMap setImage:[UIImage imageNamed:@"map_btn"] forState:UIControlStateNormal];
        }
        
        if (_rightItemShareScreen) {
            [_rightItemShareScreen setImage:[UIImage imageNamed:@"share_h5_black"] forState:UIControlStateNormal];
        }
        
        if (_rightItemHelpService) {
            [_rightItemHelpService setImage:[UIImage imageNamed:@"common_help_black"] forState:UIControlStateNormal];
        }
        
    } else {
        if (_rightItemMap) {
            [_rightItemMap setImage:[UIImage imageNamed:@"ic_map_white"] forState:UIControlStateNormal];
        }

        if (_rightItemShareProgram) {
            [_rightItemShareProgram setImage:[UIImage imageNamed:@"机酒铁分享图标_白"] forState:UIControlStateNormal];
        }
        
        if (_rightItemShareScreen) {
            [_rightItemShareScreen setImage:[UIImage imageNamed:@"share_h5_white"] forState:UIControlStateNormal];
        }
        
        if (_rightItemHelpService) {
            [_rightItemHelpService setImage:[UIImage imageNamed:@"common_help_white"] forState:UIControlStateNormal];
        }
    }
    
    // 设置导航栏颜色
    _naviView.backgroundColor = [UIColor colorWithHexString:[data objectForKey:@"bgcolor"]];
    
    // 设置导航栏透明度
    _naviView.alpha = [[data objectForKey:@"alpha"] floatValue];
}

- (void)configPushToHotelMap:(id)data {
    BOOL isShow = [data[@"show"] boolValue];
    if (isShow) {
        [self setRightItemButton:rightItemTypeHotelMap];
    }
}


#pragma mark 图片保存相关

// 图片保存
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        //NSLog(@"保存成功");
        [ProgressHub showDismissableSuccessWithStatus:kLStr(@"common_save_suc")];
    }else {
        //NSLog(@"保存失败");
        [ProgressHub showDismissableErrorWithStatus:kLStr(@"common_save_failed")];
    }
    [SVProgressHUD dismissWithDelay:2];
}

- (UIImage *)screenShot {
//    UIGraphicsBeginImageContext(self.view.bounds.size);
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);//原图
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark 截图相关
/* 长截图 */
- (void)saveScreenshot{
    //再需要截图的地方调用此方法
    @weakify(self);
    [self.webView shotScreenContentScrollCapture:^(UIImage *screenShotImage) {
        @strongify(self);
        [self showSnapShot:screenShotImage];
    }];
}

/* 显示截图 */
- (void)showSnapShot:(UIImage *)snapShotImage{
    UIScrollView *  storeScrollView = [UIScrollView new];
    storeScrollView.contentSize = CGSizeMake(kMTFYScreenW/2, kMTFYScreenH/2*3);
    storeScrollView.frame =CGRectMake(0, 0, kMTFYScreenW/2, kMTFYScreenH/2);
    storeScrollView.center = self.view.center;
    storeScrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:storeScrollView];
    
    UIImageView *storeImage = [UIImageView new];
    storeImage.image = snapShotImage;
    [storeScrollView addSubview:storeImage];
    storeImage.frame = CGRectMake(0, 0, kMTFYScreenW/2, kMTFYScreenH/2*3);
    
    UIButton *delete = [UIButton button];
    delete.frame = CGRectMake(kMTFYScreenW/2-40, 0, 40, 40);
    [delete setOkaTitle:@"delete"];
    [delete addTarget:self action:@selector(deleteScrollView:)];
    [storeScrollView addSubview:delete];
}

- (void)deleteScrollView:(UIButton *)button{
    UIView *scroll = button.superview;
    [scroll removeFromSuperview];
    scroll = nil;
}

- (void)getWebImageFromResponseStr:(NSString *)webImgStr height:(CGFloat)height success:(void (^)(UIImage *webShotImage))success {
    
    if (height <= 0 || height > 5000) {
        height = 5000;
    }
    
    NSString *base64ImgStr;
    __block UIImage *webImg;
    
    if (webImgStr) {
        base64ImgStr = [[webImgStr componentsSeparatedByString:@","] lastObject];
    }
    
    if (base64ImgStr) {
        webImg = [WebViewViewModel decodeBase64ToImage:base64ImgStr];
    }
    
    if (webImg) {
        // 先缩小些再去看高度是否超过限制
        webImg = [webImg compressImage:webImg toTargetWidth:kScreenWidth];
        // 按最大高度截取
        webImg = [webImg cutImage:height];
        if (success) {
            success(webImg);
            return;
        }
    }
    // 网页图片为空时则对当前截图
    else {
        // 前端没有传, 则原生截两屏高度
        [self.webView shotScreenContentScrollCaptureWithIndex:0 MaxIndex:1 completion:^(UIImage *screenShotImage) {
            if (success) {
                success(screenShotImage);
            }
        }];
    }
}

- (void)shareWithType:(NSUInteger)shareType shareImage:shareImg {
    UIImage *resultImg = shareImg;
    // iPhone X 头部留一部分高度
    if (IS_iPhoneX_Series) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, resultImg.size.width, 44)];
        backView.backgroundColor = HEXCOLOR(0x00C3CE);
        UIImage *backImg = [UIImage imageFromView:backView rect:backView.frame];
        resultImg = [UIImage combineImageUpImage:backImg DownImage:shareImg];
    }
    NSInteger sharePlatformType = 0;
    switch (shareType) {
        case ShareTypeWechat:
            sharePlatformType = SSDKPlatformTypeWechat;
            break;
        case ShareTypeWechatFriend:
            sharePlatformType = SSDKPlatformSubTypeWechatTimeline;
            break;
        case ShareTypeSaveLocal: {
            [ShareKit savedPhotoAlbum:resultImg];
            return;
        }
            break;
        case ShareTypeCommunity: {
            NSLog(@"分享到社区");

            return;
        }
            break;
        default:
            break;
    }
    
    [self shareToPlamfortsWithPlathformType:sharePlatformType shareImage:resultImg];
}


- (void)shareWithCopyLink:(NSString *)link {
    if (NULLString(link)) return;

    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = link;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIWindow showTips:kLStr(@"share_copy_link_already")];
    });
}

// 分享到各大平台
- (void)shareToPlamfortsWithPlathformType:(SSDKPlatformType)type shareImage:(UIImage *)shareImage {
    if (!shareImage) return;
    
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSString *shareContentStr = nil;
    [shareParams SSDKSetupShareParamsByText:shareContentStr
                                     images:@[shareImage]
                                        url:nil
                                      title:nil
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:type //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....
         switch (state) {
             case SSDKResponseStateSuccess: {
                 //                  [UIWindow showTips:kLStr(@"share_suc")];
             }
                 break;
             case SSDKResponseStateFail:{
                 //                  [UIWindow showTips:kLStr(@"share_failed")];
             }
                 break;
             default:
                 break;
         }
     }];
}

- (void)openCamera{
    // 调用系统相机的类
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];

    // 设置选取的照片是否可编辑
    pickerController.allowsEditing = YES;
    // 设置相册呈现的样式
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
    pickerController.delegate = self;

    // 使用模态呈现相册
    [[self currentVC] presentViewController:pickerController animated:YES completion:nil];
}

- (void)openPhotosAlbum{
        // 调用系统相册的类
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];

    // 设置选取的照片是否可编辑
    pickerController.allowsEditing = YES;
    // 设置相册呈现的样式
    pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    // 选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
    pickerController.delegate = self;

    // 使用模态呈现相册
    [[self currentVC] presentViewController:pickerController animated:YES completion:nil];
}


#pragma mark 拍完照或者相册选择照片后的方法
// 选择照片完成之后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // info是所选择照片的信息
    //  UIImagePickerControllerEditedImage//编辑过的图片
    //  UIImagePickerControllerOriginalImage//原图
    NSLog(@"info---%@",info);
    // 刚才已经看了info中的键值对，可以从info中取出一个UIImage对象，将取出的对象压缩上传到服务器
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    // 压缩一下图片再上传
    NSData *imgData = UIImageJPEGRepresentation(resultImage, 0.001);

    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
//    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *encodedImageStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    [self removeSpaceAndNewline:encodedImageStr];
    //使用模态返回到软件界面
    [[self currentVC] dismissViewControllerAnimated:YES completion:nil];
    // 这里传值给h5界面
    NSString *imageString = [self removeSpaceAndNewline:encodedImageStr];

    [self.bridge callHandler:@"getPhotosAlbum" data:imageString];
//    NSString *jsFunctStr = [NSString stringWithFormat:@"rtnCamera('%@')",imageString];
//    [context evaluateScript:jsFunctStr];
}

- (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}
////单个文件的大小
//- (long long) fileSizeAtPath:(NSString*) filePath{
//    NSFileManager* manager = [NSFileManager defaultManager];
//    if ([manager fileExistsAtPath:filePath]){
//        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize] / 1024.0;
//    }
//    return 0;
//}
//点击取消按钮所执行的方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //这是捕获点击右上角cancel按钮所触发的事件，如果我们需要在点击cancel按钮的时候做一些其他逻辑操作。就需要实现该代理方法，如果不做任何逻辑操作，就可以不实现
    [[self currentVC] dismissViewControllerAnimated:YES completion:nil];

}
// 压缩图片的方法
- (NSData *)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}


#pragma mark isLocationServiceEnable

- (BOOL)isLocationServiceEnable {
    BOOL isGpsEnable = false;
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {

        //定位功能可用
        isGpsEnable = true;
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {

        //定位不能用
        isGpsEnable = false;
    }
    NSLog(@"isGpsEnable = %d",isGpsEnable);
    return isGpsEnable;
}

#pragma mark 获取单次定位信息回调给H5
- (void)requestSingleLocation {
    BOOL isEnable = [LocationManager sharedManager].isLocationServiceEnable;
    @weakify(self);
    [[LocationManager sharedManager] requestLocationWithCompletionBlock:^(BMKLocation *location, NSError *error) {
        @strongify(self);
        self.currentLocation = location.location;
        [[LocationManager sharedManager] reverseGeoCodeOptionWith:location.location.coordinate callBack:^(CLLocationCoordinate2D coordinate, BMKReverseGeoCodeSearchResult * _Nullable result, BOOL success) {
            [User sharedInstance].locationResult = result;
            BMKAddressComponent *addressComponent = result.addressDetail;
            BMKPoiInfo *poi = result.poiList.firstObject;
            NSDictionary *locationPara = @{@"adcode":addressComponent.adCode?:@"",
                                           @"address":result.address?:@"",
                                           @"city":addressComponent.city?:@"",
                                           @"cityCode":result.cityCode?:@"",
                                           @"country":addressComponent.country?:@"",
                                           @"countryCode":addressComponent.countryCode?:@"",
                                           @"district":addressComponent.district?:@"",
                                           @"province":addressComponent.province?:@"",
                                           @"street": addressComponent.streetName?:@"",
                                           @"streetNumber": addressComponent.streetNumber?:@"",
                                           @"baiDuPoiId": poi.UID?:@"",
                                           @"baiDuPoiName":poi.name?:@"",
                                           @"latitude":[NSString stringWithFormat:@"%f", result.location.latitude]?:@"",
                                           @"longitude":[NSString stringWithFormat:@"%f", result.location.longitude]?:@"",
                                           };
            NSDictionary *sendData = @{@"location":locationPara,@"isGpsEnable":@(isEnable)};
//            NSLog(@"%@",locationPara);
            [self.bridge callHandler:@"setGpsLocation" data:sendData responseCallback:^(id responseData) {
                NSLog(@"setGpsLocation call data = %@",responseData);
            }];
        }];
    }];
}

// 发送用户信息给h5
- (void)setUserName2JS{
    NSMutableDictionary *dict = [[User sharedInstance].user mj_keyValuesWithIgnoredKeys:@[@"currentCoordinate"]];
//    [dict setObject:@"0" forKey:@"currentCoordinate"];
    [self.bridge callHandler:@"setUserName" data:dict responseCallback:^(id responseData) {
        NSLog(@"setUserName call data = %@",responseData);
    }];
}

#pragma mark - Getters and Setters

// 取消登录后回调给h5
- (void)loginCancel2JS{
    [self.bridge callHandler:@"loginCancel" data:@"login cancel from ios" responseCallback:^(id responseData) {
        
    }];
}

// 进度条
- (UIProgressView *)progressView {
    if(!_progressView) {
        CGFloat y = kNavBarHeight;
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, y, self.view.width, 0)];
        _progressView.backgroundColor = [UIColor clearColor];
        _progressView.tintColor = [UIColor orangeColor];
        _progressView.trackTintColor = [UIColor whiteColor];
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

// MARK: 拼接时间戳
- (void)setUrl:(NSString *)url {
    _url = [url appendTimestampMatafy];
    
    NSArray *subView = self.view.subviews;
    if (![subView containsObject:self.webView]) {
        [self.view addSubview:self.webView];
        [self.view insertSubview:self.webView belowSubview:self.progressView];
    }
}

- (UIViewController *)responder {
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        return self;
    }
    
    if (self.navigationController) {
        return self;
    }
    
    UIViewController *vc = self;
    int times = 0;
    while (![vc isKindOfClass:[WebTableController class]]) {
        vc = (UIViewController *)vc.nextResponder;
        times++;
        if (times > 5) {
            return nil;
        }
    }
    return vc;
}

#pragma mark RightItem Actions Set 右上角按钮
- (void)setRightItemButton:(rightItemType)type {
    
    BOOL isLightColor = CGColorEqualToColor(_naviView.backgroundColor.CGColor, [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor) || CGColorEqualToColor(_naviView.backgroundColor.CGColor, ColorWhite.CGColor);

    switch (type) {
        case rightItemTypeNone:
        {
            if (_rightItemShareProgram) {
                [_rightItemShareProgram removeFromSuperview];
                _rightItemShareProgram = nil;
            }
            
            if (_rightItemShareScreen) {
                [_rightItemShareScreen removeFromSuperview];
                _rightItemShareScreen = nil;
            }
            
            if (_rightItemMap) {
                [_rightItemMap removeFromSuperview];
                _rightItemMap = nil;
            }
            
            if (_rightItemHelpService) {
                [_rightItemHelpService removeFromSuperview];
                _rightItemHelpService = nil;
            }
        }
            break;
        case rightItemTypeShareProgram:
        {
            if (_rightItemShareScreen) {
                [_rightItemShareScreen removeFromSuperview];
                _rightItemShareScreen = nil;
            }
            if (_rightItemMap) {
                [_rightItemMap removeFromSuperview];
                _rightItemMap = nil;
            }
            if (!_rightItemShareProgram) {
                UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                if (isLightColor) {
                    [shareBtn setImage:[UIImage imageNamed:@"机酒铁分享图标"] forState:UIControlStateNormal];
                } else {
                    [shareBtn setImage:[UIImage imageNamed:@"机酒铁分享图标_白"] forState:UIControlStateNormal];
                }
                [shareBtn addTarget:self action:@selector(shareProgram:) forControlEvents:UIControlEventTouchUpInside];
                [_naviView addSubview:shareBtn];
                [shareBtn setEnlargeEdgeWithTop:10 right:20 bottom:10 left:20];
                [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(_backButton.mas_centerY).offset(0);
                    make.right.offset(-15);
                }];
                _rightItemShareProgram = shareBtn;
            }
        }
            break;
        case rightItemTypeShareScreen:
        {
            if (_rightItemShareProgram) {
                [_rightItemShareProgram removeFromSuperview];
                _rightItemShareProgram = nil;
            }
            if (_rightItemMap) {
                [_rightItemMap removeFromSuperview];
                _rightItemMap = nil;
            }
            if (!_rightItemShareScreen) {
                UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_naviView addSubview:shareBtn];
                [shareBtn setEnlargeEdgeWithTop:10 right:20 bottom:10 left:20];
                [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(_backButton.mas_centerY).offset(0);
                    make.right.offset(-15);
                }];
                _rightItemShareScreen = shareBtn;

                if (self.shareActivityType == WebViewShareActivityTypeUserRedPacket) {
                    [shareBtn setImage:[UIImage imageNamed:@"ic_mian_share"] forState:UIControlStateNormal];
                    [shareBtn addTarget:self action:@selector(showSharePanel) forControlEvents:UIControlEventTouchUpInside];
                } else if (self.shareActivityType == WebViewShareActivityTypePriceContest){
                    [shareBtn setImage:[UIImage imageNamed:@"ic_mian_share"] forState:UIControlStateNormal];
                    [shareBtn addTarget:self action:@selector(showSharePanel) forControlEvents:UIControlEventTouchUpInside];
                }else {
                    if (isLightColor) {
                         [shareBtn setImage:[UIImage imageNamed:@"share_h5_black"] forState:UIControlStateNormal];
                    } else {
                        [shareBtn setImage:[UIImage imageNamed:@"share_h5_white"] forState:UIControlStateNormal];
                    }
                    [shareBtn addTarget:self action:@selector(showSharePopView) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
            break;
        default:
            break;
    }
    
    if (type == rightItemTypeHotelMap || type ==  rightItemTypeCinimaMap) {
        if (!_rightItemMap) {
            UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_naviView addSubview:mapBtn];
            [mapBtn setEnlargeEdgeWithTop:10 right:20 bottom:10 left:20];
            [mapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_backButton.mas_centerY);
                if (_rightItemShareScreen && !_rightItemShareScreen.hidden) {
                    make.right.offset(-15).equalTo(_rightItemShareScreen.mas_left);
                } else if (_rightItemShareProgram && !_rightItemShareProgram.hidden) {
                    make.right.offset(-15).equalTo(_rightItemShareProgram.mas_left);
                } else {
                    make.right.offset(-15);
                }
            }];

            [mapBtn sizeToFit];
            _rightItemMap = mapBtn;
            if (isLightColor) {
                [mapBtn setImage:[UIImage imageNamed:@"map_btn"] forState:UIControlStateNormal];
            } else {
                [mapBtn setImage:[UIImage imageNamed:@"ic_map_white"] forState:UIControlStateNormal];
            }


            if (type == rightItemTypeHotelMap) {
                [mapBtn addTarget:self action:@selector(pushToMapVC) forControlEvents:UIControlEventTouchUpInside];
            } else if (type == rightItemTypeCinimaMap) {
                [mapBtn addTarget:self action:@selector(pushToCinimaMapVC) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    
    /// 客服
    if (type == rightItemTypeHelpService) {
        if (!_rightItemHelpService) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_naviView addSubview:btn];
            [btn setEnlargeEdgeWithTop:10 right:20 bottom:10 left:20];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_backButton.mas_centerY);
                if (_rightItemShareScreen && !_rightItemShareScreen.hidden) {
                    make.right.offset(-15).equalTo(_rightItemShareScreen.mas_left);
                } else if (_rightItemShareProgram && !_rightItemShareProgram.hidden) {
                    make.right.offset(-15).equalTo(_rightItemShareProgram.mas_left);
                } else if (_rightItemMap && !_rightItemMap.hidden) {
                    make.right.offset(-15).equalTo(_rightItemMap.mas_left);
                } else {
                    make.right.offset(-15);
                }
            }];

            [btn sizeToFit];
            _rightItemHelpService = btn;
            if (isLightColor) {
                [btn setImage:[UIImage imageNamed:@"common_help_black"] forState:UIControlStateNormal];
            } else {
                [btn setImage:[UIImage imageNamed:@"common_help_white"] forState:UIControlStateNormal];
            }
            [btn addTarget:self action:@selector(pushTohelpService) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)pushTohelpService {
    [ProfileViewModel pushToMeiqiaWithVC:self];
}

// 设置自定义导航栏右边按钮
- (void)setRightItemWith:(id)data {
    NSArray<UIButton *> *buttonArray = [WebViewViewModel createRightItemButtonFrom:data superView:_naviView referenceCenterY:_backButton.mas_centerY];
    for (UIButton *button in self.customRightItemArray) {
        [button removeFromSuperview];
    }
    self.customRightItemArray = buttonArray;
    @weakify(self);
    [buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [obj addTarget:self action:@selector(customRightItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [_naviView addSubview:obj];
    }];
}

/// 设置自定义返回按钮
- (void)setBackItem:(id)data {
    BOOL show = [data[@"show"] boolValue];
    NSString *imageURL = data[@"image"];
    NSURL *url = [NSURL URLWithString:imageURL];
    if (self.isShowDefaultNavi) {
        [_navBackButton sd_setImageWithURL:url forState:UIControlStateNormal];
        _navBackButton.hidden = !show;
        _backButton.hidden = YES;
    } else {
        [_backButton sd_setImageWithURL:url forState:UIControlStateNormal];
        _backButton.hidden = !show;
    }
}

- (void)hideShareScreenButton:(BOOL)hidden {
    if (!_rightItemShareScreen) {
        return;
    }
    _rightItemShareScreen.hidden = hidden;
    if (_rightItemMap && _rightItemShareScreen) {
        [_rightItemMap mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backButton.mas_centerY);
            if (hidden) {
                make.right.offset(-15);
            } else {
                make.right.offset(-15).equalTo(_rightItemShareScreen.mas_left);
            }
        }];
    }
}

#pragma mark - Setter && Getter
//- (SharePopViewForWebView *)sharePopView {
//
//    if (!_sharePopView) {
//        _sharePopView = [[SharePopViewForWebView alloc] init];
//        @weakify(self);
//        _sharePopView.selectBlock = ^(NSUInteger type) {
//            @strongify(self);
//            [self selectWithShareType:type];
//        };
//    }
//    return _sharePopView;
//}

#pragma mark - Supperclass

@end
