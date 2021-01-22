//
//  AlertTool.m
//  silu
//
//  Created by liman on 15/7/15.
//  Copyright (c) 2015年 upintech. All rights reserved.
//

#import "AlertTool.h"

@implementation AlertTool

SHARED_INSTANCE_FOR_CLASS(AlertTool)

/**
 *  如果"服务器连接失败", 则弹出"重试"
 */
- (void)showMessage:(NSString *)message serverConnectionErrorBlock:(Block)serverConnectionErrorBlock
{
    // 当网络请求的参数为null时
    if ([message rangeOfString:@"NULL"].location != NSNotFound)
    {
        message = @"参数错误, NULL";
        
#ifdef DEBUG
        //do nothing...
#else
        return;
#endif
    }

    
    // 当leanCloud连接失败时
    if ([message rangeOfString:@"Socket is not connected"].location != NSNotFound)
    {
        message = @"连接远程聊天服务器失败";
        return;
    }
    if ([message rangeOfString:@"websocket not opened"].location != NSNotFound)
    {
        message = @"连接远程聊天服务器失败";
        return;
    }
    if ([message rangeOfString:@"SESSION_REQUIRED"].location != NSNotFound)
    {
        message = @"连接远程聊天服务器失败";
        return;
    }
    if ([message rangeOfString:@"未能完成该操作"].location != NSNotFound)
    {
        message = @"连接远程聊天服务器失败";
        return;
    }
    
    // 当ShareSDK取消第三方登录时
    if ([message isEqualToString:@"尚未授权"])
    {
        message = @"第三方登陆尚未授权";
        return;
    }
    
    // 检查网络是否连接
    if ([message isEqualToString:ERROR_MESSAGE_NO_NETWORK])
    {
        if ([USER_DEFAULT boolForKey:kIS_NETWORK_AVAILABLE_BAIDU] || [USER_DEFAULT boolForKey:kIS_NETWORK_AVAILABLE_GOOGLE])
        {
            message = @"网络连接失败";
        }
    }
    
    
    
    //-------------------------------- 判断是否为 "网络连接失败" ------------------------------
    
    if ([message isEqualToString:@"网络连接失败"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:ERROR_MESSAGE_NO_NETWORK delegate:self cancelButtonTitle:kLStr(@"common_alert_cancel") otherButtonTitles:@"重试", nil];
        [alert show];
        
        _block = serverConnectionErrorBlock; //注意:顺序不能颠倒,否则崩溃!
        return;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:kLStr(@"common_alert_sure") otherButtonTitles:nil];
        [alert show];
        
        return;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
         //点击了"重试"
        _block();
    }
}

@end
