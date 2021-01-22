//
//  AlertContentView.h
//  Matafy
//
//  Created by silkents on 2019/4/10.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertContentView : UIView
// 0 取消 1 确定
@property (nonatomic,copy) void (^btnClick)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
