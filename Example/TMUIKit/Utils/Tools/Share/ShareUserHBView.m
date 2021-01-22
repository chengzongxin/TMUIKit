//
//  ShareUserHBView.m
//  Matafy
//
//  Created by Fussa on 2019/5/30.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "ShareUserHBView.h"
#import "ShareKit.h"

static const NSTimeInterval kAnimationTimeInterval = 0.3;

@interface ShareUserHBView()
@property(nonatomic, copy) void (^clickBlock)(NSInteger index);
@property (nonatomic, copy) NSString *pathUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) id image;
@property (nonatomic, copy) NSString *url;

@property (strong, nonatomic) UIView *bgView;
@property (nonatomic, copy) ShareUserHBViewSuccessBlock successBlock;
@property (nonatomic, copy) ShareUserHBViewFailBlock failBlock;



@end

@implementation ShareUserHBView

#pragma mark - Public
+ (instancetype)xibView {
    return [ShareUserHBView gk_viewFromXib];
}

- (void)shareViewWithTitle:(NSString *)title
                   content:(NSString *)content
                     image:(id)image
                       url:(NSString *)url
               clickHandle:(ShareUserHBViewItemClickBlock)clickHandle
                   success:(ShareUserHBViewSuccessBlock)success
                      fail:(ShareUserHBViewFailBlock)fail{
    [self shareViewWithTitle:title content:content pathUrl:@"" image:image url:url clickHandle:clickHandle success:success fail:fail];
}

- (void)shareViewWithTitle:(NSString *)title
                   content:(NSString *)content
                   pathUrl:(NSString *)pathUrl
                     image:(id)image
                       url:(NSString *)url
               clickHandle:(ShareUserHBViewItemClickBlock)clickHandle
                   success:(ShareUserHBViewSuccessBlock)success
                      fail:(ShareUserHBViewFailBlock)fail {
    self.clickBlock = clickHandle;
    self.successBlock = success;
    self.failBlock = fail;
    self.title = title;
    self.content = content;
    self.pathUrl = pathUrl;
    self.image = image;
    self.url = url;
    
    for (UIView *view in KEY_WINDOW.subviews) {
        if ([view isKindOfClass:[self class]]) {
            return ;
        }
    }
    
    UIView *bgView = [UIView new];
    bgView.frame = KEY_WINDOW.frame;
    bgView.backgroundColor = JColorFromRGB(0x000000);
    bgView.alpha = 0.5;
    self.bgView = bgView;
    
    [KEY_WINDOW addSubview:self.bgView];
    self.frame = [self getHideFrame];
    [KEY_WINDOW addSubview:self];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(dismiss)];
    [self.bgView addGestureRecognizer:tap];
    
    [self show];
}

- (void)show {
    if (CGRectGetMaxY(self.frame) == KMainScreenHeight) return;
    [UIView animateWithDuration:kAnimationTimeInterval animations:^{
        self.frame = [self getDefaultFrame];
    } completion:^(BOOL finished) {
        if (self.clickBlock) {
            self.clickBlock(0);
        }
    }];
}

- (void)dismiss {
    if (CGRectGetMinY(self.frame) == KMainScreenHeight) return;
    [UIView animateWithDuration:kAnimationTimeInterval animations:^{
        self.frame = [self getHideFrame];
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - Action
- (IBAction)wxButtoonClick:(UIButton *)sender {
    [self handleBlockWithIndex:1];
}

- (IBAction)timelineButtoonClick:(UIButton *)sender {
    [self handleBlockWithIndex:2];
}

- (IBAction)qqButtoonClick:(UIButton *)sender {
    [self handleBlockWithIndex:3];
}

- (IBAction)weiboButtoonClick:(UIButton *)sender {
    [self handleBlockWithIndex:4];
}

- (IBAction)dingtalkButtoonClick:(UIButton *)sender {
    [self handleBlockWithIndex:5];
}
- (IBAction)cancelButtonClick:(UIButton *)sender {
    [self dismiss];
    if (self.clickBlock) {
        self.clickBlock(-1);
    }
}

- (void)handleBlockWithIndex:(NSInteger)index {
    if (self.clickBlock) {
        self.clickBlock(index);
    }
    
    SSDKPlatformType type = SSDKPlatformTypeWechat;
    switch (index) {
        case 1:
            type = SSDKPlatformTypeWechat;
            break;
        case 2:
            type = SSDKPlatformSubTypeWechatTimeline;
            break;
        case 3:
            type = SSDKPlatformTypeQQ;
            break;
        case 4:
            type = SSDKPlatformTypeSinaWeibo;
            break;
        case 5:
            type = SSDKPlatformTypeDingTalk;
            break;
        default:
            break;
    }
    [self shareToPlatform:type];
}

#pragma mark - Private
- (CGRect)getDefaultFrame {
    return CGRectMake(0, KMainScreenHeight - self.frame.size.height, KMainScreenWidth, self.frame.size.height);
}

- (CGRect)getHideFrame {
    return CGRectMake(0, KMainScreenHeight, KMainScreenWidth, self.frame.size.height);
}

#pragma mark - 分享相关

- (void)shareToPlatform: (SSDKPlatformType)platformType {
    
    if (platformType == SSDKPlatformTypeWechat && NULLString(self.pathUrl) == false) {
        // 有微信小程序path 分享微信小程序
        [ShareKit shareWeixinMiniProgram:self.title image:self.image pathUrl:self.pathUrl webPageuUrl:@"" success:^{
            if (self.successBlock) {
                self.successBlock();
            }
            [self dismiss];
        } fail:^{
            if (self.failBlock) {
                self.failBlock();
            }
            [self dismiss];
        }];
    }else{
        [ShareKit shareToPlatform:platformType content:self.content image:self.image url:self.url title:self.title success:^{
            if (self.successBlock) {
                self.successBlock();
            }
            [self dismiss];
        } fail:^{
            if (self.failBlock) {
                self.failBlock();
            }
            [self dismiss];
        }];
    }
    
    
}
@end
