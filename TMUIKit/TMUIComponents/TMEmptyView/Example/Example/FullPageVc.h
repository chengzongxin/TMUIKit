//
//  FullPageVc.h
//  Example
//
//  Created by nigel.ning on 2020/8/14.
//  Copyright © 2020 t8t. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface FullPageVc : UIViewController

@property (nonatomic, strong)NSArray<NSArray<TestItem *> *> *dataSource;

@end

NS_ASSUME_NONNULL_END
