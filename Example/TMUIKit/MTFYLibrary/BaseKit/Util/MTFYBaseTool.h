//
//  MTFYBaseTool.h
//  Matafy
//
//  Created by Tiaotiao on 2019/4/3.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTFYBaseTool : NSObject

+ (BOOL)mtfy_checkIsAppStore;

+ (UIViewController *)mtfy_fetchCurrentVC;

+ (void)mtfy_makeCallTelephone:(NSString *)phoneNum;

/**
 * 获取状态栏statusBar
 */
+ (UIView *)statusBar;

@end

NS_ASSUME_NONNULL_END
