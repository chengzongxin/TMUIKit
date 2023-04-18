//
//  TMUINavigationBarDefineType.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/5/23.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TMUINavigationBarStyle_Light,           ///<  白色背景，黑色内容
    TMUINavigationBarStyle_Dark,            ///<  黑色背景，白色内容
} TMUINavigationBarStyle;

typedef enum : NSUInteger {
    TMUINavigationBarLeftViewType_None,     ///<  没有按钮
    TMUINavigationBarLeftViewType_Back,     ///<  返回 --  默认
} TMUINavigationBarLeftViewType;

typedef enum : NSUInteger {
    TMUINavigationBarRightViewType_None,    ///<  没有按钮 -- 默认
    TMUINavigationBarRightViewType_Share,   ///<  分享
    TMUINavigationBarRightViewType_Search,  ///<  搜索
} TMUINavigationBarRightViewType;

/// 操作左右按钮回调
@protocol TMUINavigationBarProtocol <NSObject>

/// 兼容项目
- (void)navBackAction:(UIButton *)btn;

- (void)tmui_navBackAction:(UIButton *)btn;

- (void)navRightAction:(UIButton *)btn;

@end

