//
//  MTFYPhotoBrowser.m
//  Matafy
//
// Created by Fussa on 2019/12/2.
// Copyright (c) 2019 com.upintech. All rights reserved.
//
#import "MTFYPhotoBrowser.h"
#import "GKPhotoBrowser.h"

NSTimeInterval lastScaleTime = 0;

@implementation MTFYPhotoBrowser

+ (void)browserWithImages:(NSArray *)images sourceView:(UIView *)sourceView currentIndex:(NSInteger)index{
    [self browserWithImages:images sourceView:sourceView currentIndex:index title:nil fromVC:nil];
}

+ (void)browserWithImages:(NSArray *)images currentIndex:(NSInteger)index title:(NSString *)title fromVC:(UIViewController *)viewController {
    [self browserWithImages:images sourceView:nil currentIndex:index title:title fromVC:viewController];
}

+ (void)browserWithImages:(NSArray *)images sourceView:(UIView *)sourceView currentIndex:(NSInteger)index title:(NSString *)title fromVC:(UIViewController *)viewController {

    if (!images.count) {
        return;
    }
    
    if (!viewController) {
        viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }

    BOOL isSourceViewImage = [sourceView isKindOfClass:[UIImageView class]];
    CGRect defaultFrame = CGRectMake(KScreenW * 0.5, KScreenH * 0.5, 1, 1);

    NSArray *photoArr = [images mtfy_map:^id(id element, NSUInteger index) {
        GKPhoto *photo = [GKPhoto new];
        if ([element isKindOfClass:[NSString class]]) {
            photo.url = [NSURL URLWithString:element];
        };
        if ([element isKindOfClass:[UIImage class]]) {
            photo.image = element;
        }
        if ([element isKindOfClass:[NSURL class]]) {
            photo.url = element;
        }
        if (isSourceViewImage){
            photo.sourceImageView = (UIImageView *) sourceView;
        }
        photo.sourceFrame = sourceView ? [sourceView convertRect:sourceView.bounds toView:KEY_WINDOW] : defaultFrame;
        return photo;
    }];

    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photoArr currentIndex:index];
    browser.showStyle = GKPhotoBrowserShowStyleZoom;
    browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
    browser.failureText = kLStr(@"common_image_loading_fail");
    browser.isLowGifMemory = YES;
    browser.mtfy_automaticallySetModalPresentationStyle = NO;

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusHeight, kScreenWidth, kNavBarHeight - kStatusHeight)];

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, headerView.height, headerView.height)];
    backButton.imageView.contentMode = UIViewContentModeCenter;
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setImage:[UIImage imageNamed:@"content_image_back"] forState:UIControlStateNormal];
    [backButton mtfy_clickWithBlock:^{
        [browser dismiss];
    }];
    [headerView addSubview:backButton];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerView.height, 0, headerView.bounds.size.width - headerView.height * 2, headerView.bounds.size.height)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 2;
    titleLabel.text = title;
    [headerView addSubview:titleLabel];

    UILabel *pageLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 50) / 2, kScreenHeight - 50 - 0, 50, 24)];
    pageLabel.backgroundColor = [UIColor blackColor];
    pageLabel.textColor = [UIColor whiteColor];
    pageLabel.font = [UIFont systemFontOfSize:12];
    pageLabel.textAlignment = NSTextAlignmentCenter;
    pageLabel.layer.cornerRadius = 24.0 / 2.0;
    pageLabel.layer.masksToBounds = YES;
    
    
    UILabel *scaleLabel = [[UILabel alloc] init];
    scaleLabel.backgroundColor = [UIColor colorWithRed:42/255.0 green:50/255.0 blue:63/255.0 alpha:1.0];
    scaleLabel.frame = CGRectMake((kScreenWidth - 121) / 2, kScreenHeight - 50, 121, 33);
    scaleLabel.font = [UIFont systemFontOfSize:12];
    scaleLabel.textColor = UIColor.whiteColor;
    scaleLabel.alpha = 0.6;
    scaleLabel.layer.cornerRadius = 33 / 2.0;
    scaleLabel.layer.masksToBounds = YES;
    scaleLabel.hidden = YES;
    scaleLabel.textAlignment = NSTextAlignmentCenter;
    
    if (images.count <= 1) {
        pageLabel.hidden = YES;
    }

    [browser setupCoverViews:@[headerView, pageLabel,scaleLabel] layoutBlock:^(GKPhotoBrowser *_Nonnull photoBrowser, CGRect superFrame) {
        pageLabel.text = [NSString stringWithFormat:@"%@/%@", @(photoBrowser.currentIndex + 1).stringValue, @(images.count).stringValue];
    }];
    
    // 选择, 更新页码
    browser.didSelectAtIndexBlock = ^(NSInteger index) {
        pageLabel.text = [NSString stringWithFormat:@"%@/%@", @(index + 1).stringValue, @(images.count).stringValue];
    };
    
    __weak __typeof (&*browser)weakBrowser = browser;
    // 长按, 提示保存
    browser.longPressWithIndexBlock = ^(NSInteger index) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:kLStr(@"common_alert_tip") message:kLStr(@"common_alert_save_photo") preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLStr(@"common_alert_cancel") style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:kLStr(@"common_alert_sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            GKPhotoView *view = [weakBrowser curPhotoView];
            UIImageWriteToSavedPhotosAlbum(view.imageView.image, nil, nil, nil);
            [UIWindow showTips:kLStr(@"common_save_suc")];
        }];
        [alert addAction:cancelAction];
        [alert addAction:confirmAction];
        [weakBrowser presentViewController:alert animated:YES completion:nil];
    };
    
    BOOL isHide = [[RedPacketShareUserView shareInstance] checkIsHide];
    [[RedPacketShareUserView shareInstance] hide];
    browser.dismissBlock = ^{
        if (!isHide) {
            [[RedPacketShareUserView shareInstance] show];
        }
    };
    
    [browser showFromVC:viewController];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        browser.curPhotoView.zoomEnded = ^(GKPhotoView * _Nonnull photoView, CGFloat scale) {
            NSLog(@"%@,%f",photoView,scale);
            NSString *scaleStr = [NSString stringWithFormat:@"缩放比例: %0.0f%%",(scale-1)*100];
            scaleLabel.text = scaleStr;
            scaleLabel.hidden = NO;
            lastScaleTime = [[NSDate date] timeIntervalSince1970];
            // 用户操作2秒后消失
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:lastScaleTime];
                NSTimeInterval interval = [NSDate.date timeIntervalSinceDate:lastDate];
                NSLog(@"interval = %f",interval);
                if (interval > 2) {
                    scaleLabel.hidden = YES;
                }
            });
        };
    });
}

@end
