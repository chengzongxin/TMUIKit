//
//  Share.m
//  Matafy
//
//  Created by Cheng on 2018/1/25.
//  Copyright © 2018年 com.upintech. All rights reserved.
//

#import "ShareViewController.h"

@implementation ShareViewController

+ (instancetype)share:(NSString *)text image:(UIImage *)img url:(NSString *)url success:(void (^)(id))success fail:(void (^)(id))fail{
    //分享的图片
    UIImage *imageToShare = img?:[UIImage new];
    //分享的url
    NSURL *urlToShare = [NSURL URLWithString:url];
    //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
    NSArray *activityItems = @[text,imageToShare,urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            //分享 成功
            NSLog(@"completed");
            success(@"completed");
        } else  {
            //分享 取消
            NSLog(@"cancled");
            fail(@"cancled");
        }
    };
    return (ShareViewController *)activityVC;
}


@end
