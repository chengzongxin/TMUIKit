//
//  MTFYBaseNavigationController.h
//  Matafy
//
//  Created by Tiaotiao on 2019/4/19.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTFYBackButtonHandleDelegate <NSObject>

@optional

-(BOOL)navigationShouldPopOnBackButton;

@end

@interface MTFYBaseNavigationController : UINavigationController

- (void)updateNavigationBarForViewController:(UIViewController *)vc;
- (void)updateNavigationBarAlphaForViewController:(UIViewController *)vc;
- (void)updateNavigationBarColorOrImageForViewController:(UIViewController *)vc;
- (void)updateNavigationBarShadowImageIAlphaForViewController:(UIViewController *)vc;

@property (nonatomic, weak) id<MTFYBackButtonHandleDelegate> backDelegate;

// Push时是否隐藏掉Tabbar 默认YES
@property (nonatomic, assign) BOOL isHidesBottomBarWhenPushed;

@property (nonatomic, assign) BOOL isHideNavi;

@end

@interface UINavigationController(UINavigationBar) <UINavigationBarDelegate>

@end
