//
//  TMUIConfiguration.h
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/12.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupTVTool.h"

extern NSString * _Nonnull const h1;
extern NSString * _Nonnull const h2;
extern NSString * _Nonnull const h3;
extern NSString * _Nonnull const body;
extern NSString * _Nonnull const button;

NS_ASSUME_NONNULL_BEGIN

@interface TMUIExampleConfiguration : NSObject

SHARED_INSTANCE_FOR_HEADER

@property (nonatomic, strong, readonly) CUIStyle *h1;
@property (nonatomic, strong, readonly) CUIStyle *h2;
@property (nonatomic, strong, readonly) CUIStyle *h3;
@property (nonatomic, strong, readonly) CUIStyle *body;
@property (nonatomic, strong, readonly) CUIStyle *button;

@end

NS_ASSUME_NONNULL_END
