//
//  TMUIMultiDatePickerViewController.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/4/15.
//

#import <UIKit/UIKit.h>
#import "TMUIPickerView.h"
#import "TMUIPickerViewConfig.h"
NS_ASSUME_NONNULL_BEGIN

@interface TMUIMultiDatePickerViewController : UIViewController

+ (void)showFromViewController:(UIViewController *)fromVC
                   configBlock:(TMUIPickerConfigBlock)configBlock
                 callbackBlock:(TMUIPickerMultiDateSelectDateBlock)callback;

@end

NS_ASSUME_NONNULL_END
