//
//  MTFYHeader.h
//  Matafy
//
//  Created by Tiaotiao on 2019/4/3.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#ifndef MTFYHeader_h
#define MTFYHeader_h

#define kScreenPortraitWidth (!UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? kScreenWidth : kScreenHeight)
#define kScreenPortraitHeight (!UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? kScreenHeight : kScreenWidth)

#define isIp5 ((kScreenPortraitHeight) <= 568.0f)
#define isIp6 (kScreenPortraitWidth <= 375.0f)
#define adapterH(a, b) (isIp5 ? a : b)


// const
#import "MTFYConstants.h"
#import "MTFYPayConstants.h"
#import "MTFYPlaceholderConstants.h"

// Protocol
#import "MTFYSectionProtocol.h"

// category
#import "TTLabel.h"
#import "UIColor+MTFYBaseColor.h"
#import "UIFont+MTFYBaseFont.h"
#import "NSString+MTFYBaseNSString.h"
#import "NSArray+Json.h"
#import "UILabel+SBLocalizable.h"
#import "UIButton+SBLocalizable.h"
#import "UITextField+SBLocalizable.h"
#import "NSDate+Utils.h"
#import "NSDate+Interval.h"
#import "NSCalendar+Init.h"
#import "NSArray+FP.h"
#import "UITextField+MTFY.h"
#import "UISearchBar+MTFY.h"
#import "UIViewController+ChangeDefaultPresentStyle.h"
#import "NSObject+SwizzleMethod.h"
#import "NSMutableArray+MTFY.h"
#import "NSArray+MTFY.h"
#import "NSUserDefaults+MTFY.h"
#import "UIView+MTFY.h"
#import "UIImage+Extension.h"
#import "UILabel+MTFY.h"
#import "UIButton+MTFY.h"
#import "UILabel+TapAction.h"
#import "UIView+Border.h"

// Tool
#import "MTFYBaseTool.h"
#import "MTFYPriceFormatTool.h"
#import "MTFYFormatTool.h"
#import "MTFYUnitTool.h"
#import "MTFYLoadingView.h"
#import "MTFYBaseNavigationController.h"
#import "HBDNavigationBar.h"
#import "UIViewController+HBD.h"
#import "MTFYUserTool.h"
#import "MTFYBaseIGListCollectionCell.h"
#import "MTFYBaseIGListSectionController.h"

// system
#import "MTFYAuthorization.h"

// header
#import "TravelHeader.h"

// util
#import "MTFYTimer.h"
#import "MTFYPhotoBrowser.h"
#import "MTFYUtil.h"

// 模块
#import "MTFYNetworkCenter.h"
#import "MTFYThirdPayModule.h"
#import "MTFYShareModule.h"
#import "MTFYNetworkURL.h"

#import "MTFYBuriedPointTravel.h"
#import "MTFYBuriedPointActivity.h"
#import "MTFYResponseModel.h"
#import "MTFYEmptySectionController.h"

#endif /* MTFYHeader_h */
