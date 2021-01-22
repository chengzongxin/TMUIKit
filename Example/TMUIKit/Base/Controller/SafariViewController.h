//
//  SafariViewController.h
//  silu
//
//  Created by Cheng on 2017/12/18.
//  Copyright © 2017年 upintech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>

typedef void(^finish)(void);
typedef void(^escape)(void);

@interface SafariViewController : SFSafariViewController<SFSafariViewControllerDelegate>
// 加载完成
@property (nonatomic,copy) finish finishBlock;
// 退出
@property (nonatomic,copy) escape escapeBlock;

/*
 * urlString    加载使用的url
 * finishBlock  加载完成调用的block,使用self时先weakSelf一下
 */
- (instancetype)initWithURLString:(NSString *)urlString finish:(finish)finishBlock;

@end
