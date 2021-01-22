//
//  WKAirTicketsViewController.h
//  silu
//
//  Created by sawyerzhang on 2017/10/24.
//  Copyright © 2017年 upintech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WebViewViewModel.h"


/**
 返回按钮样式
 */
typedef NS_ENUM(NSUInteger, WebViewBackButtonType) {
    WebViewBackButtonTypeDefult    = 0, ///<默认返回按钮样式(箭头)
    WebViewBackButtonType1         = 1, ///< 返回按钮样式"X"
};

typedef void(^WebViewBlock)(void);

@interface WKAirTicketsViewController : UIViewController

@property (copy , nonatomic) NSString *url;

@property (nonatomic,strong) UIImage *placeHolderImage;

// 1.机票 2.酒店 3. 火车票 4.门票 5.游轮
@property (nonatomic, assign) NSInteger webType;

@property (strong , nonatomic) WKWebView *webView;

//void setWebHeight(int height);//设置首页高度
@property (assign, nonatomic) int webHeight;

//void setWebFirst(boolean flag);//判断是否为首页，true为首页，false为非首页
@property (assign, nonatomic) BOOL webFirst;

//void setWebTitleName(int type, String firstAdds, String endAdds);//type：类型（0；机票，1：酒店， 2：火车票, 4.租车）， firstAdds：起始位置，endAdds：目的地（酒店传日期）
@property (strong, nonatomic) NSDictionary *webTitleName;

@property (nonatomic, assign) BOOL isShowDefaultNavi;
/// 禁用返回手势
@property (nonatomic, assign) BOOL isInteractivePopDisabled;
@property (nonatomic, copy) WebViewBlock dismissBlock;
@property (nonatomic, assign) WebViewBackButtonType backButtonType;

@property (nonatomic,copy) void (^getLinkManData)(NSDictionary *data);

@property (nonatomic, copy) NSString *selecCouponJsonStr;

@property (nonatomic, strong) RACSubject *selectCouponSubject;

@end
