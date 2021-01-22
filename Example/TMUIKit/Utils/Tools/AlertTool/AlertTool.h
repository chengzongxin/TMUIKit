//
//  AlertTool.h
//  silu
//
//  Created by liman on 15/7/15.
//  Copyright (c) 2015年 upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Block)(void);

@interface AlertTool : UIAlertController

SHARED_INSTANCE_FOR_HEADER(AlertTool)

@property (copy, nonatomic) Block block;

/**
 *  如果"服务器连接失败", 则弹出"重试"
 */
- (void)showMessage:(NSString *)message serverConnectionErrorBlock:(Block)serverConnectionErrorBlock;

@end
