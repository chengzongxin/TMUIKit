//
//  TMAppDelegate.h
//  TMUIKit
//
//  Created by chengzongxin on 01/19/2021.
//  Copyright (c) 2021 chengzongxin. All rights reserved.
//

@import UIKit;

extern NSString *const TDSelectedThemeIdentifier;
extern NSString *const TDThemeIdentifierDefault;
extern NSString *const TDThemeIdentifierGrapefruit;
extern NSString *const TDThemeIdentifierGrass;
extern NSString *const TDThemeIdentifierPinkRose;
extern NSString *const TDThemeIdentifierDark;

@interface TMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
