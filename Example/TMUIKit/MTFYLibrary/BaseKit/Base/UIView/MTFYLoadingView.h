//
//  MTFYLoadingView.h
//  Matafy
//
//  Created by Tiaotiao on 2019/4/16.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaterialDesignSpinner.h"

NS_ASSUME_NONNULL_BEGIN

@interface MTFYLoadingView : UIView

@property (nonatomic, strong, readwrite) UIColor *lineColor;

- (void)show;

- (void)showWithStatus:(NSString *)status;

- (void)dismiss;


- (void)showWithNoRemove;
- (void)showWithStatusWithNoRemove:(NSString *)status;

- (void)dismissNoRemove;



@end

NS_ASSUME_NONNULL_END
