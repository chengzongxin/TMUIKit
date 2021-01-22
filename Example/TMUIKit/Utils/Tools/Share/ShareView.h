//
//  ShareView.h
//  Matafy
//
//  Created by Jason on 2018/6/14.
//  Copyright © 2018年 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TravalType){
    /**
     *  没有选择
     */
    TravalTypeNone  = 0,
    /**
     *  机票
     */
    TravalTypeAir   = 1,
    /**
     *  酒店
     */
    TravalTypeHotel = 2,
    /**
     *  火车
     */
    TravalTypeTrain = 3,
    /**
     *  出行
     */
    TravalTypeTravel = 4
};

@interface ShareView : UIView

@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property (weak, nonatomic) IBOutlet UIButton *friendCircleBtn;
@property (weak, nonatomic) IBOutlet UIButton *QQSpaceBtn;
@property (weak, nonatomic) IBOutlet UIButton *QQBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet UILabel *weixinLb;

@property (weak, nonatomic) IBOutlet UILabel *friendCircleLb;
@property (weak, nonatomic) IBOutlet UILabel *QQLb;
@property (weak, nonatomic) IBOutlet UILabel *QQSpaceLb;
@property (weak, nonatomic) IBOutlet UILabel *focusLb;

@property (nonatomic, copy) NSString *type;


@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, copy) UIImage  *shareImg;
@property (nonatomic, copy) NSString *shareUrl;


/**
 分享方法

 @param titleToShare 标题
 @param textToShare 文本
 @param img 图像
 @param urlToShare url
 @param success 成功回调
 @param fail 失败回调
 */
+ (void)share:(NSString *)titleToShare text:(NSString *)textToShare image:(UIImage *)img url:(NSString *)urlToShare success:(void (^)(id))success fail:(void (^)(id))fail;


/**
 初始化xib

 @return 返回share对象
 */
+ (instancetype)xibView;


/**
 分享方法
 
 @param titleToShare 标题
 @param textToShare 文本
 @param img 图像
 @param urlToShare url
 @param success 成功回调
 @param fail 失败回调
 */
- (void)share:(NSString *)titleToShare text:(NSString *)textToShare image:(UIImage *)img url:(NSString *)urlToShare success:(void (^)(id))success fail:(void (^)(id))fail;


/**
 分享微信小程序
 */
+ (void)shareMiniProgram:(TravalType)travalType;
+ (void)shareMiniProgram:(TravalType)travalType title:(NSString *)title imageUrl:(NSString *)imageUrl;
+ (void)shareMiniProgramWithTitle:(NSString *)title description:(NSString *)description webpageUrl:(NSString *)webpageUrl path:(NSString *)path imageUrl:(NSString *)imageUrl;
+ (void)shareMiniProgramWithTitle:(NSString *)title description:(NSString *)description webpageUrl:(NSString *)webpageUrl path:(NSString *)path imageUrl:(NSString *)imageUrl success:(void (^)(id))success fail:(void (^)(id))fail;


//MARK: H5分享微信小程序
+ (void)shareWeixinMiniProgram:(NSString *)title imageUrl:(NSString *)imageUrl pathUrl:(NSString *)pathUrl webPageuUrl:(NSString *)webPageUrl;

@end
