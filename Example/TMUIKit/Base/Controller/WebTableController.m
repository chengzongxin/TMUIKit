//
//  WebTableController.m
//  Matafy
//
//  Created by Jason on 2018/5/31.
//  Copyright © 2018年 com.upintech. All rights reserved.
//

#import "WebTableController.h"
#import "WKAirTicketsViewController.h"
#import "ContentRecommendModel.h"
#import "RecommondCell.h"
#import "ADCell.h"
//#import "AdNativeManager.h"
//#import "AdNativeManagerDelegate.h"
#import "XWMagicMoveAnimator.h"
#import "UIViewController+XWTransition.h"
#import "UINavigationController+XWTransition.h"
#import "PlayerViewController.h"
#import "SafariViewController.h"
#import "MainRequest.h"
#import "UIScrollView+PeerRefresh.h"
#import <ReactiveObjC.h>
#import "TicketView.h"
#import <WebKit/WebKit.h>
#define kRecommondCellID @"kRecommondCellID"


// 广点通
#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"
#import "AppDelegate.h"

// POI
#import "PoiView.h"
#import "PoiHeaderView.h"
#import "POIDetailViewController.h"
#import "POIViewModel.h"
#import "PopularDestinationView.h"
#import "FFToast.h"
#import "ContentVideoViewController.h"
#import "InternetScenicSpotViewController.h"
#define kPoiHeaderHeight 56
#define kPoiViewHeight 320

/// 网红景点
#define kPoiHeaderHeight 56
#define kPoiViewHeight 320

static CGFloat const kHotHotelViewH = 185;
@interface WebTableController ()<UITableViewDelegate,UITableViewDataSource,TicketViewDelegate,GDTNativeExpressAdDelegete>{
    NSMutableArray  *_adArrM;            //广告数组
}

/* web */
@property (strong, nonatomic) WKAirTicketsViewController *webView;
/* table */
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray<ContentRecommendModel *>  *contentRecommends;

@property (assign, nonatomic) int sections;

@property (strong, nonatomic) TicketView *ticketView;



// 广点通
@property (nonatomic, strong) GDTNativeExpressAd *nativeExpressAd;

// 广告数组
@property (nonatomic, strong) NSArray *expressAdViews;

// 广告id数组
@property (strong , nonatomic) NSMutableArray *adIDArrM;

@property (assign ,nonatomic) NSInteger index;
// headerview = webView + collectionHeader + collectionView
@property (strong, nonatomic) UIView *headerView;
// collectionHeader
@property (strong, nonatomic) PoiHeaderView *poiHeaderView;
// collectionView
@property (strong, nonatomic) PoiView *poiView;

//@property (strong, nonatomic) NSArray *poiDatas;
@property (strong, nonatomic) POIList *poiList;

@property (nonatomic,assign) int webH;

@property (nonatomic,strong) NSDictionary *titleDictionary;

@property (nonatomic,strong) PoiHeaderView *scenicSpot_headerView;

@property (strong, nonatomic) PopularDestinationView *scenicSpot_poiView;

// 网红景点数据源
@property (strong, nonatomic) DynamicListModelData          *scenicSpotDynamicListModelData;

@end

@implementation WebTableController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.webView viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = YES;

    if (self.contentRecommends.count == 0) {
        [self loadNewData];

        // 广点通
        [self GDTNativeAD];
    }
    
}

// 开启热点适配
- (void)viewWillLayoutSubviews {
    CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
    if (statusBarRect.size.height == kStatusBarHeight + 20) {
        self.view.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else{
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.webView viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.webView viewDidDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self.view addSubview:self.tableView];
    
    [self bindEvents];
    
    [self inital];
    
    
}

- (void)inital{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.contentRecommends = [NSMutableArray array];
    
    _adArrM  = [NSMutableArray arrayWithCapacity:0];
}

- (void)bindEvents{
    /// web高度

    @weakify(self);
    
    [[[NSNotificationCenter.defaultCenter
       rac_addObserverForName:kNotificationNameWebURL object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
//         滑动到一定距离后进入之后的页面出现偏差
        NSString *url = [x object];
        if ([url containsString:@"Choose"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.tableView.contentOffset = CGPointMake(0, -[UIApplication sharedApplication].statusBarFrame.size.height);
            });
        }
        
    }];
    
    // kvo监听webview的url状态,height
    [[RACSignal combineLatest:@[RACObserve(self.webView.webView, URL), RACObserve(self.webView, webHeight),RACObserve(self, contentRecommends), RACObserve(self, poiList)] reduce:^(NSURL *url, id webHeight,POIList *poiList){
        @strongify(self);
        NSString *urlString = [url absoluteString];
        int height = [webHeight intValue];
//        NSLog(@"urlString = [%@],webHeight = [%d],recommendArr.count = [%@]",urlString,height,poiList);
        if ([urlString containsString:@"Choose"] ) {
            // 首页
            self.sections = (int)self.contentRecommends.count;
            self.tableView.mj_footer.hidden = NO;
            self.tableView.scrollEnabled = YES;
            self.scenicSpot_poiView.hidden = NO;
        }else{
            self.sections = 0;
            self.tableView.mj_footer.hidden = YES;
            self.tableView.scrollEnabled = NO;
            self.scenicSpot_poiView.hidden = YES;
            // 移动到最顶部,非主页,全屏显示机酒铁业务
            if (self.tableView.contentOffset.y > -kStatusHeight) {
                [self.tableView setContentOffset:CGPointMake(0,-kStatusHeight) animated:YES];
//                [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
            }
        }
        [self.tableView reloadData];
        
        if ([urlString containsString:@"Choose"] && height != 0) {
            if (self.poiList.pois.count) {
                return @(height+kPoiViewHeight+kPoiHeaderHeight);
            }else{
                return @(height);
            }
        }else{
            return @([UIScreen mainScreen].bounds.size.height);
        }
    }] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        _webH = [x intValue];
//        NSLog(@"subscribeNext webHeight = [%d],current webHeight = [%f]",_webH,self.tableView.tableHeaderView.height);
        
        
        if (self.tableView.tableHeaderView.height == _webH && [UIScreen mainScreen].bounds.size.height != _webH) {
                return ;
       }else if ([UIScreen mainScreen].bounds.size.height == _webH){
//           NSLog(@"111111111111111111111");
            self.headerView.height = _webH;
            self.webView.view.height = _webH;
            self.webView.webView.height = _webH -(44 + [UIApplication sharedApplication].statusBarFrame.size.height); // webview - 导航栏高度
            self.poiHeaderView.height = 0;
            self.poiView.height = 0;
           self.scenicSpot_poiView.height = 0;
           self.scenicSpot_headerView.height= 0;
        }else{
            // 添加横幅POI
            _webH = _webH - 34; // 纠偏,之前的webview底部有34偏移
            if (self.poiList.pois) {
                // 有poi数据 height+kPoiViewHeight+kPoiHeaderHeight
                if(self.titleDictionary &&[[self.titleDictionary objectForKey:@"type"]isEqual:@3])
                {
//                     NSLog(@"222222222222222222222222222222");
                    self.headerView.height = _webH+88+44+20+kHotHotelViewH+kPoiHeaderHeight;
                    self.webView.view.frame = CGRectMake(0, 0, KMainScreenWidth, _webH-kPoiHeaderHeight-kPoiViewHeight+88+44);
                   
                    self.scenicSpot_headerView.frame = CGRectMake(0, _webH-kPoiHeaderHeight-kPoiViewHeight+88+44, KMainScreenWidth, kPoiHeaderHeight);
                    self.scenicSpot_poiView.frame = CGRectMake(0, _webH-kPoiHeaderHeight-kPoiViewHeight+88+kPoiHeaderHeight+44, KMainScreenWidth, kHotHotelViewH);
                    
                    self.poiHeaderView.frame = CGRectMake(0, _webH-kPoiHeaderHeight-kPoiViewHeight+88+44+kHotHotelViewH+kPoiHeaderHeight, KMainScreenWidth, kPoiHeaderHeight);
                    self.poiView.frame = CGRectMake(0, _webH-kPoiHeaderHeight-kPoiViewHeight+88+kPoiHeaderHeight+44+kHotHotelViewH+kPoiHeaderHeight, KMainScreenWidth, kPoiViewHeight);
                    self.scenicSpot_headerView.hidden = NO;
                    self.scenicSpot_poiView.hidden = NO;
                }
                else
                {
//
                self.headerView.height = _webH+88+44+20;
//                    self.headerView.height = _webH;
                self.webView.view.frame = CGRectMake(0, 0, KMainScreenWidth, _webH-kPoiHeaderHeight-kPoiViewHeight+88+44);
                self.poiHeaderView.frame = CGRectMake(0, _webH-kPoiHeaderHeight-kPoiViewHeight+88+44, KMainScreenWidth, kPoiHeaderHeight);
                self.poiView.frame = CGRectMake(0, _webH-kPoiHeaderHeight-kPoiViewHeight+88+kPoiHeaderHeight+44, KMainScreenWidth, kPoiViewHeight);
                    
                    self.scenicSpot_headerView.frame = CGRectMake(0, _webH-kPoiHeaderHeight-kPoiViewHeight+88+44, KMainScreenWidth, 0.001);
                    self.scenicSpot_poiView.frame = CGRectMake(0, _webH-kPoiHeaderHeight-kPoiViewHeight+88+kPoiHeaderHeight+44, KMainScreenWidth, 0.001);        self.scenicSpot_headerView.hidden = YES;
                    self.scenicSpot_poiView.hidden = YES;
                }
               
            }else{
                // 没有poi数据 height
                self.headerView.height = _webH+88+44+20;
                self.webView.view.frame = CGRectMake(0, 0, KMainScreenWidth, _webH+88+44);
            }
            
        }
        
    }];

    // 监听web标题内容
    [RACObserve(self.webView, webTitleName) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSLog(@"webTitleName = %@",x);
        self.titleDictionary = x;
        self.ticketView.titles = x;
        [self loadDataWithTitles:x];
    }];
    
    // 弹出虚拟键盘后位置偏移
    [[[NSNotificationCenter.defaultCenter
      rac_addObserverForName:UIKeyboardDidHideNotification object:nil]
     takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        self.webView.webView.scrollView.contentOffset = CGPointMake(self.webView.webView.scrollView.contentOffset.x, 0);
    }];
}

- (void)loadDataWithTitles:(NSDictionary *)titles{
    if (titles.allKeys.count < 3) {
        NSLog(@"titles = %@",titles);
        return;
    }
    NSString *firstAdds = titles[@"firstAdds"];
    NSString *endAdds = titles[@"endAdds"];
    int type = [titles[@"type"] intValue];
    self.ticketView.type = type;
    NSString *city;
    switch (type) {
        case 0:
            city = endAdds;
            break;
        case 1:
            city = firstAdds;
            break;
        case 2:
            city = endAdds;
            break;
        case 3:
            city = firstAdds;
            break;
        case 4:
            city = firstAdds;
            break;
        default:
            break;
    }
    
    [self loadPOI:city type:type];
}


#pragma mark - 上下拉刷新
- (void)insertNewData{

    [ProgressHub show];
    [SVProgressHUD dismissWithDelay:15];
    [MainRequest recommendType:2 success:^(NSArray *data) {
        [ProgressHub dismiss];
        NSMutableArray *tempArr = self.contentRecommends;
        self.contentRecommends = [NSMutableArray array];
        [[self mutableArrayValueForKey:@"contentRecommends"] addObjectsFromArray:data];
        [[self mutableArrayValueForKey:@"contentRecommends"] addObjectsFromArray:tempArr];
        //        [_contentRecommends addObjectsFromArray:_adArrM];
        if (_adArrM.count != 0) {
            [[self mutableArrayValueForKey:@"contentRecommends"] addObject:_adArrM.firstObject];
            [_adArrM removeObjectAtIndex:0];
//            NSLog(@"广告数量:%zd",_adArrM.count);
            
            if (_adArrM.count == 2) {  // 只剩两条广告时请求
                [self GDTNativeAD];
                NSLog(@"剩下两条,请求广告");
            }
        }
//        NSLog(@"contentRecommends = %@",self.contentRecommends);
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    //    CGFloat offsetY = self.tableView.contentOffset.y;
//        [self.tableView setContentOffset:CGPointMake(0, offsetY) animated:NO];
        
        // 顶部toast
        if (data.count) {
            [self topToast:data.count];
            [self.tableView layoutIfNeeded];
            if (KIsiPhoneX) {
                [self.tableView setContentOffset:CGPointMake(0, self.tableView.tableHeaderView.height - 88 * 2 + 20) animated:NO];
            }else{
                [self.tableView setContentOffset:CGPointMake(0, self.tableView.tableHeaderView.height - 100) animated:NO];
            }
        }
        
    } fail:^(id message) {
        [ProgressHub dismiss];
    }];
}

- (void)loadNewData{
    [MainRequest recommendType:2 success:^(NSArray *data) {
//        [self.contentRecommends addObjectsFromArray:data];
        [[self mutableArrayValueForKey:@"contentRecommends"] addObjectsFromArray:data];
        //        [_contentRecommends addObjectsFromArray:_adArrM];
        if (_adArrM.count != 0) {
            
            if(data.count > 2){
            
            [[self mutableArrayValueForKey:@"contentRecommends"] addObject:_adArrM.firstObject];
            [_adArrM removeObjectAtIndex:0];
            NSLog(@"广告数量:%zd",_adArrM.count);
            
            if (_adArrM.count == 2) {  // 只剩两条广告时请求
                [self GDTNativeAD];
                NSLog(@"剩下两条,请求广告");
            }
            }
        }
            
        
        
        
//        NSLog(@"contentRecommends = %@",self.contentRecommends);
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } fail:^(id message) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
//        Toast(message);
    }];
}

#pragma mark - tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 33;
    }else{
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIView *title_view = [UIView new];
        title_view.frame = CGRectMake(0, 0, KMainScreenWidth, 33);
        title_view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [UILabel new];
        label.text = kLStr(@"home_index_wonderfulShortVideo");
        [label sizeToFit];
        label.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:kAspectRatio(17)];
        label.textColor = [UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1/1.0];
        [title_view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.bottom.mas_equalTo(title_view.mas_bottom).offset(-8);
        }];
        
        UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        refreshBtn.tintColor = [UIColor colorWithHexString:@"0x00C3CE"];
        refreshBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        [refreshBtn setTitleColor:[UIColor colorWithHexString:@"0x00C3CE"] forState:UIControlStateNormal];
        [refreshBtn setTitle:[NSString stringWithFormat:@"%@ ", kLStr(@"home_index_changeBatches")] forState:UIControlStateNormal];
        [refreshBtn setImage:[UIImage imageNamed:@"poi_refresh"] forState:UIControlStateNormal];
        refreshBtn.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        [refreshBtn addTarget:self action:@selector(insertNewData) forControlEvents:UIControlEventTouchUpInside];
        [title_view addSubview:refreshBtn];
        [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-18);
            make.centerY.equalTo(label.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(66, 20));
        }];
        
        
        return title_view;
    }else{
        return nil;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( [self.contentRecommends[indexPath.section] isMemberOfClass:[ContentRecommendModel class]]){
        RecommondCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecommondCellID];
        cell.model          = self.contentRecommends[indexPath.section];
        return cell;
    }else{
        ADCell  *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"adcell-%zd",indexPath.section]];
        if (!cell) {
            cell = [[ADCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"adcell-%zd",indexPath.section]];
        }
        UIView *view =(UIView *) [self.contentRecommends objectAtIndex:indexPath.section];
        view.layer.cornerRadius = 10.0f;
        view.layer.masksToBounds = YES;
        [cell.bgView addSubview:view];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithHexString:@"#F7F7FB"];
        
        return cell;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.contentRecommends[indexPath.section] isMemberOfClass:[ContentRecommendModel class]]){
        return UITableViewAutomaticDimension;
    }else{

        return  kAspectRatio(200);
    }

        
        
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(![self.contentRecommends[indexPath.section] isMemberOfClass:[ContentRecommendModel class]]){
//        AdViewNativeAdInfo *adDic =  (AdViewNativeAdInfo*)  [self.contentRecommends objectAtIndex:indexPath.section];
//        [adDic clickNativeAdWithClickPoint:CGPointMake(100, 100)];
    }else{
        
        // 获取点击的model和cell对象
        ContentRecommendModel *model   = self.contentRecommends[indexPath.section];
        RecommondCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (model.ftype == 1) {
            // 图文
            WKAirTicketsViewController *vc = [WKAirTicketsViewController new];
            vc.url = model.h5Url;
            [self.navigationController pushViewController:vc animated:true];
        } else if (model.ftype == 2){
            // 视频
            UIStoryboard *story            = [UIStoryboard storyboardWithName:@"Player" bundle:nil];
            PlayerViewController *playerVC = [story instantiateInitialViewController];
            playerVC.tag                   = cell.content.text;
            playerVC.model = model;
            
            // 转场
            UIImageView  *imgView = cell.imgView;
            [self xw_addMagicMoveStartViewGroup:@[imgView]];
            XWMagicMoveAnimator *animator = [XWMagicMoveAnimator new];
            animator.dampingEnable = YES;
            animator.imageMode = YES;
            animator.toDuration = 1.0f;
            animator.backDuration = 1.0f;
            playerVC.placeholderImageView = imgView;
            [self xw_presentViewController:playerVC withAnimator:animator];
        } else if (model.ftype == 3) {
            // 机酒铁
            SafariViewController *vc = [[SafariViewController alloc] initWithURLString:model.h5Url finish:^{
                
            }];
            [self.navigationController pushViewController:vc animated:true];
        }
    }
}

#pragma mark - TicketView Delegate
- (void)backAction{
    NSLog(@"%s",__FUNCTION__);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchAction{
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - Actions
// 修正setContentOffset顶部空白
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self.tableView setContentOffset:CGPointMake(0, -[UIApplication sharedApplication].statusBarFrame.size.height) animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y > self.tableView.tableHeaderView.height - kStatusHeight - self.poiView.height) {
        self.ticketView.hidden = NO;
    }else{
        self.ticketView.hidden = YES;
    }
}

#pragma mark - Getter & Setter
- (WKAirTicketsViewController *)webView{
    if (!_webView) {
        _webView = [[WKAirTicketsViewController alloc] init];
        _webView.isShowDefaultNavi = YES;
        [self addChildViewController:_webView];
    }
    return _webView;
}

- (void)setWebUrl:(NSString *)webUrl{
    _webUrl = webUrl;
    self.webView.url = webUrl;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.frame = CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight+kPoiHeaderHeight+kPoiViewHeight);

        @weakify(self);
        /*************网红景点**************/
        PoiHeaderView *scenicSpot_headerView = [PoiHeaderView xibView];
        scenicSpot_headerView.backgroundColor = [UIColor whiteColor];
        scenicSpot_headerView.titleLabel.text = kLStr(@"home_index_internetCelebrityAttractions");
        scenicSpot_headerView.frame = CGRectMake(0, KMainScreenHeight, KMainScreenWidth, 200);
        [scenicSpot_headerView clickMore:^{
            @strongify(self);
            // 网红景点
            InternetScenicSpotViewController *vc = [InternetScenicSpotViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
      
        _scenicSpot_headerView = scenicSpot_headerView;
        
        
        /* hothotel view */
        PopularDestinationView *scenicSpotView = [PopularDestinationView xibView];
        scenicSpotView.didSelectItemBlock = ^(NSInteger index) {
            @strongify(self);
//            @strongify(self);
            DynamicListModelDataList *list = self.scenicSpotDynamicListModelData.list[index];
            ContentVideoViewController *vc = [ContentVideoViewController storyboardWithName:@"Community"];
            vc.dynamicId =list.id;
            vc.dynamicListModelDataList = list;
            [self.navigationController pushViewController:vc animated:YES];
        };
        _scenicSpot_poiView = scenicSpotView;
        
        // POI header
        PoiHeaderView *poiHeaderView = [PoiHeaderView xibView];
        poiHeaderView.backgroundColor = [UIColor whiteColor];
        poiHeaderView.frame = CGRectMake(0, KMainScreenHeight, KMainScreenWidth, kPoiHeaderHeight);
        
        [poiHeaderView clickMore:^{
            @strongify(self);
            [self tapMoreAction];
            
        }];
  
        [_headerView addSubview:poiHeaderView];
        _poiHeaderView = poiHeaderView;

        
        // POI
        PoiView *poiView = [PoiView xibView];
        poiView.frame = CGRectMake(0, KMainScreenHeight+kPoiHeaderHeight, KMainScreenWidth, kPoiViewHeight);
        [poiView setDataSources:nil tapAction:^(NSInteger index, POIListModel *model) {
            NSLog(@"poiview tap %ld,model = %@",(long)index,model);
            @strongify(self);
            if (self.poiList.pois.count == index) {  // 最后一个poi
                [self tapMoreAction];
                
            }else{
                
                POIDetailViewController *vc = [POIDetailViewController storyboardWithName:@"POI"];
//                vc.hidesBottomBarWhenPushed = YES;
                [vc setPoiID:model.id andType:[model.type intValue]];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        [_headerView addSubview:poiView];
         [_headerView addSubview:scenicSpotView];
        [_headerView addSubview:scenicSpot_headerView];
        [_headerView addSubview:self.webView.view];
        self.poiView = poiView;
    }
    return _headerView;
}

- (void)tapMoreAction{
    UIViewController *vc = [UIViewController storyboardInitialWithName:@"POI"];
//    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        CGFloat statusH = [UIApplication sharedApplication].statusBarFrame.size.height;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -statusH, self.view.frame.size.width, self.view.frame.size.height+statusH) style:UITableViewStyleGrouped];
        _tableView .backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight  = 264;
        _tableView.sectionFooterHeight = 0.0f;
        _tableView.contentInset = UIEdgeInsetsZero;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RecommondCell class]) bundle:nil] forCellReuseIdentifier:kRecommondCellID];
        [_tableView registerClass:[ADCell class] forCellReuseIdentifier:@"adCellId"];
        // set header
//        self.webView.view.height = self.view.height * 0.9;
        _tableView.tableHeaderView = self.headerView;
        WS(weakSelf)
        [_tableView setRefreshWithFooterBlock:^{
            [weakSelf loadNewData];
        }];
        
        
        /// 请求网红景点数据
        [self loadScenicData];
        
    }
    return _tableView;
}

- (TicketView *)ticketView{
    if (!_ticketView) {
        _ticketView = [TicketView xibView];
        _ticketView.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height + 52);
        _ticketView.type = _type;
        _ticketView.delegate = self;
        [self.view addSubview:_ticketView];
        [self.view bringSubviewToFront:_ticketView];
        _ticketView.hidden = YES;
    }
    return _ticketView;
}

// 广点通原生广告位id
//机票广告位: 1020931478185433  6040039448382432   9020132418082239  9030737428783525   9050134458785506
//酒店广告位: 3020933438988507  3050836418088538  3080439418886559  8040731468189620  1040634488987681
//火车票广告位:  1030837448883602  9080838448681673  1050532448584644   3030433408787675  7000536408784696
- (void)setType:(int)type{
    _type = type;
    switch (type) {
        case 0:
            self.adIDArrM = [NSMutableArray arrayWithObjects:@"1020931478185433",@"6040039448382432",@"9020132418082239",@"9030737428783525",@"9050134458785506", nil];
            break;
        case 1:
            self.adIDArrM = [NSMutableArray arrayWithObjects:@"3020933438988507",@"3050836418088538",@"3080439418886559",@"8040731468189620",@"1040634488987681", nil];
            break;
        case 2:
            self.adIDArrM = [NSMutableArray arrayWithObjects:@"1030837448883602",@"9080838448681673",@"1050532448584644",@"3030433408787675",@"7000536408784696", nil];
            break;
        case 3:
            self.adIDArrM = [NSMutableArray arrayWithObjects:@"3020933438988507",@"3050836418088538",@"3080439418886559",@"8040731468189620",@"1040634488987681", nil];
            break;
        default:
            self.adIDArrM = [NSMutableArray arrayWithObjects:@"3020933438988507",@"3050836418088538",@"3080439418886559",@"8040731468189620",@"1040634488987681", nil];
            break;
    }
    self.ticketView.type = type;
    [self loadPOI:nil type:1];
}

- (void)loadPOI:(NSString *)city type:(int)type{
    // 获取POI数据
    if (NULLString(city)) {
        // 缓存
        city = UserDefaultObjectForKey(@"city") ?: @"深圳";
    }
    
    NSString *businessLine;
    switch (type) {
        case 0:
            businessLine = @"AIR";
            break;
        case 1:
            businessLine = @"HOTEL";
            break;
        case 2:
            businessLine = @"TRAIN";
            break;
        case 3:
            businessLine = @"HOTEL";
            break;
            
            
        default:
            businessLine = @"HOTEL";
            break;
    }
    
    city = [self filterString:city];
    
    UserDefaultSetObjectForKey(city, @"poicity")
    UserDefaultSetObjectForKey(businessLine, @"poibusinessLine")
    
    [POIViewModel getNewPOIFromCity:city types:@[@"景点",@"美食",@"酒店"] businessLine:businessLine searchQuery:nil size:2 pagenum:1 success:^(id data) {
        POIList *poiList = data;
        if (!poiList.pois.count) {
            // 搜索小城市时,没有返回数据,搜索定位城市,如果没有定位城市,搜索深圳
            
            if (self.poiView.tag > 3) {
                self.poiList = nil;
                return ;
            }
            
            NSString *localCity = UserDefaultObjectForKey(@"city") ?: @"深圳";
            
            if ([city containsString:localCity] || [city containsString:@"深圳"]) {
                self.poiView.tag++;
            }else{
                self.poiView.tag = 0;
            }
            
            [self loadPOI:nil type:type];
        }else{
            _poiView.poiList = data;
            self.poiList = data;
        }
        
    } fail:^(id message) {
        NSLog(@"poi = %@",message);
    }];
}

- (NSString *)filterString:(NSString *)city{
    if (NULLString(city)) {
        return city;
    }
    
    // 芭堤雅
    if ([city containsString:@"芭提雅"]) {
        city = [city stringByReplacingOccurrencesOfString:@"提" withString:@"堤"];
    }
    
    // 删除有括弧的
    if ([city containsString:@"("]) {
        NSRange range = [city rangeOfString:@"("];
        city = [city substringToIndex:range.location];
    }
    
    return city;
}

- (void)setPoiList:(POIList *)poiList{
    _poiList = poiList;
    if (_poiList.pois.count == 0) {
        _poiList = nil;
    }
    
    if (!_poiList.pois.count) {
        _poiView.hidden = YES;
        _poiHeaderView.hidden = YES;
        [self.tableView reloadData];
    }
    
    _poiHeaderView.titleLabel.text =  [NSString stringWithFormat:@"%@ %@",kLStr(@"poi_hot_spot_in"), _poiList.city];
}

#pragma mark - 广告相关
- (void)GDTNativeAD{
    
    if (self.index < [self.adIDArrM count]) {
        NSString *adId = self.adIDArrM[self.index];
        NSLog(@"广告id:%@",adId);
        self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppId:GDTID
                                                             placementId:adId
                                                                  adSize:CGSizeMake((kMTFYScreenW - 30), kAspectRatio(200))];
        
        self.nativeExpressAd.delegate = self;
        [self.nativeExpressAd loadAd:10];
        
        self.index++;
        
    }else{  // 重新拉取
        
        self.index = 0;
    }
    
    
}
#pragma mark - GDTNativeExpressAdDelegete
/**
 * 拉取广告成功的回调
 */
- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views
{
    self.expressAdViews = [NSArray arrayWithArray:views];
    [_adArrM addObjectsFromArray:self.expressAdViews];
    if (self.expressAdViews.count) {
        @weakify(self);
        [self.expressAdViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            GDTNativeExpressAdView *expressView = (GDTNativeExpressAdView *)obj;
            
            expressView.controller = self;
            [expressView render];
        }];
    }
}

/**
 * 拉取广告失败的回调
 */
- (void)nativeExpressAdRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView
{
}

/**
 * 拉取原生模板广告失败
 */
- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error
{
    NSLog(@"Express Ad Load Fail : %@",error);
}

- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView
{
    
}

- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"nativeExpressAdViewClicked");
}

- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"--------%s-------",__FUNCTION__);
}

- (void)dealloc{
    NSLog(@"%@ is dealloc",[self class]);
}

- (void)topToast:(NSInteger )counts{
    FFToast *toast =  [[FFToast alloc] initToastWithTitle:nil message:[NSString stringWithFormat:kLStr(@"home_index_refresh_success_content"), counts] iconImage:nil];
    toast.gradientStartColor = @"0383FF";
    toast.gradientEndColor = @"ABDCFF";
    toast.duration = 2;
    [toast show];
}

- (void)loadScenicData
{
    // 网红景点
    [RequestManager requestInternetScenicSpotWithRecommendSuccess:^(id  _Nonnull data) {
        DynamicListModelData *model =[DynamicListModelData new];
        model.list = data;
        _scenicSpotDynamicListModelData = model;
        _scenicSpot_poiView.modelData = model;
         [self.tableView reloadData];
        
    } fail:^(id  _Nonnull message) {
        
    }];
    
}

@end
