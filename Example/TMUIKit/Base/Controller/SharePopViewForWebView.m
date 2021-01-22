//
//  SharePopView.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "SharePopViewForWebView.h"
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
//#import <MessageUI/MessageUI.h>
#import "VideoTousuViewController.h"

#define shareAppLogan @"share_slogan"

@interface SharePopViewForWebView ()

@property (nonatomic, strong) NSMutableArray *itemArr;
@property (nonatomic,strong) UIScrollView *topScrollView;

@end


@implementation SharePopViewForWebView

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

- (instancetype)init {
    self = [super init];
    if (self) {
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
        
     
    }
    return self;
}


- (void)setValues
{
    if(self.itemArr.count > 0)
    {
        [self.itemArr removeAllObjects];
    }
    CGFloat wMultiple = 0.9;
    CGFloat scrollW = kMTFYScreenW * wMultiple;
    CGFloat itemWidth = (scrollW)/self.iconImageArray.count;
    
    _topScrollView = [[UIScrollView alloc]
                                   initWithFrame:CGRectMake(kMTFYScreenW * ((1 - wMultiple) * 0.5), 50, scrollW, 156)];
    _topScrollView.contentSize = CGSizeMake(itemWidth * self.iconImageArray.count, 80);
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 30);
    [_container addSubview:_topScrollView];
    
    for (NSInteger i = 0; i < self.titleArray.count; i++) {
        ShareItemForWebView *item = [[ShareItemForWebView alloc] initWithFrame:CGRectMake(itemWidth*i, 0, itemWidth, 156)];
        item.icon.image = [UIImage imageNamed:self.iconImageArray[i]];
        item.label.text = self.titleArray[i];
        item.tag = ShareTypeWechat + i;
        [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onShareItemTap:)]];
        [item startAnimation:i*0.03f];
        [_topScrollView addSubview:item];
        [self.itemArr addObject:item];
    }
}

#pragma mark - Public

- (void)show {


    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.container.frame;
                         frame.origin.y = frame.origin.y - frame.size.height;
                         self.container.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         [self setValues];
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
                         for (UIView *obj in _topScrollView.subviews) {
                             [obj removeFromSuperview];
                         }
                         [_topScrollView removeFromSuperview];
                         
                     }];
}

- (void)showCopyUrlItem {
    NSUInteger copyIndex = 2;
    ShareItemForWebView *copyItem = nil;
    if (copyIndex < self.itemArr.count) {
        copyItem = self.itemArr[copyIndex];
    }
    
    if (copyItem && !copyItem.hidden) {
        return;
    }
    
    NSUInteger realCount = self.itemArr.count;
    CGFloat wMultiple = 0.9;
    CGFloat scrollW = kMTFYScreenW * wMultiple;
    CGFloat itemWidth = (scrollW) / realCount;
    for (NSInteger i = 0; i < realCount; i++) {
        ShareItemForWebView *item = self.itemArr[i];
        item.hidden = NO;
        item.frame = CGRectMake(itemWidth*i, 0, itemWidth, 156);
    }
}



- (void)hideCopyUrlItem {
    NSUInteger copyIndex = 2;
    ShareItemForWebView *copyItem = nil;
    
    if (copyIndex < self.itemArr.count) {
        copyItem = self.itemArr[copyIndex];
    }
    
    if (copyItem) {
        copyItem.hidden = YES;
    }
    
    NSUInteger realCount = self.itemArr.count - 1;
    CGFloat wMultiple = 0.9;
    CGFloat scrollW = kMTFYScreenW * wMultiple;
    CGFloat itemWidth = (scrollW) / realCount;
    
    for (NSInteger i = 0; i < self.itemArr.count; i++) {
        if (i == copyIndex) {
            continue;
        }
        
        NSUInteger realIndex = i;
        if (i > copyIndex) {
            realIndex = i - 1;
        }
        ShareItemForWebView *item = self.itemArr[i];
        item.frame = CGRectMake(itemWidth*realIndex, 0, itemWidth, 156);
    }
}

#pragma mark - Event Respone

#pragma mark - Action

- (void)onShareItemTap:(UITapGestureRecognizer *)sender {
    [self dismiss];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.selectBlock) {
            self.selectBlock(sender.view.tag);
        }
    });  
}

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

#pragma mark - Delegate
#pragma mark - Private

#pragma mark - Getters and Setters

- (NSMutableArray *)itemArr {
    if (!_itemArr) {
        _itemArr = [NSMutableArray array];
    }
    return _itemArr;
}

#pragma mark - Supperclass
#pragma mark - NSObject


///**
// 微信
// */
//- (void)weixinAction {
//    SSDKPlatformType temp = SSDKPlatformTypeWechat;
//    [self shareToPlamfortsWithPlathformType:temp];
//}
///**
// 微信朋友圈
// */
//- (void)friendCircleAction {
//    SSDKPlatformType temp = SSDKPlatformSubTypeWechatTimeline;
//    [self shareToPlamfortsWithPlathformType:temp];
//}
//
////MARK: 分享到各大平台
//- (void)shareToPlamfortsWithPlathformType:(SSDKPlatformType)type{
//    //创建分享参数
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    [shareParams SSDKSetupShareParamsByText:self.shareContent
//                                     images:@[self.shareImg]
//                                        url:[NSURL URLWithString:self.shareUrl]
//                                      title:self.shareTitle
//                                       type:SSDKContentTypeAuto];
//
//    //进行分享
//    [ShareSDK share:type //传入分享的平台类型
//         parameters:shareParams
//     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....
//         switch (state) {
//             case SSDKResponseStateSuccess:
//             {
//                 //                  [UIWindow showTips:kLStr(@"share_suc")];
//             }
//             case SSDKResponseStateFail:
//             {
//                 //                  [UIWindow showTips:kLStr(@"share_failed")];
//             }
//             default:
//                 break;
//         }
//     }];
//}
//
//
///* 保存截图到相册 */
//- (void)savedPhotosAlbum:(UIImage *)snapShotImage{
//    CGImageRef imageRef = snapShotImage.CGImage;
//    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRef];
//    NSLog(@"sendImage==%@",sendImage);
//    //保存图片到照片库 （iOS10 以上记得在info.plist添加相册访问权限，否则可能崩溃）
//    UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);
//    [UIWindow showTips:@"保存成功"];
//}

@end



#pragma Item view

@implementation ShareItemForWebView
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
