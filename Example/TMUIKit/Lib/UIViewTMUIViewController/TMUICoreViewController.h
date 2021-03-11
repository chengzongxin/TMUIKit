//
//  TMUICoreViewController.h
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/10.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMUICoreViewController : UIViewController

TMAssociatedPropertyStrongType(NSString, method1);

@property (nonatomic, strong) NSString *method2;

@property (nonatomic, nullable, weak) NSString *method3;

@end

NS_ASSUME_NONNULL_END
