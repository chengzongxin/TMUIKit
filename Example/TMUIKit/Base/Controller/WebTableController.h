//
//  WebTableController.h
//  Matafy
//
//  Created by Jason on 2018/5/31.
//  Copyright © 2018年 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebTableController : UIViewController
/* webview的Url */
@property (copy, nonatomic) NSString *webUrl;
/* 机酒铁类型 */
@property (assign, nonatomic) int type;

@end
